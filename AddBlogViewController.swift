//
//  AddBlogViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import MobileCoreServices
import AVFoundation
import Parse
import iAd
class AddBlogViewController: UITableViewController {
    
    // MARK: - Properties
    
    var thumbnail: UIImage?
    var video: PFFile?
    var videoOfUrl: NSURL?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView ()
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.canDisplayBannerAds = true
       
    }
    
    // MARK: - Action
    
    @IBAction func recordButtonTapped(sender: UIButton) {
        self.startCameraRecord(self, withDelegate: self)
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.view.addSubview(self.activityIndicator)
        
        if let videoOfUrl = self.videoOfUrl {
            
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            guard let data = NSData(contentsOfURL: videoOfUrl) else {return}
            let file = PFFile(name: "video.mov", data: data)
            
            file?.saveInBackgroundWithBlock({ (success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if success {
                    guard let currentUser = UserController.shareController.current else {return}
                    BlogController.createBlog(file!, user: currentUser, caption: self.captionTextField.text, completion: { (blog, success) -> Void in
                        if blog != nil {
                            self.presentAlert("Yo! Upload Completed", message: "")

                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    guard let thumbnail = self.thumbnail else {return}
                                    ImageController.createThumbnails(thumbnail, blog: blog!, completion: { (success, error) -> Void in
                                            if success {
//                                                self.presentAlert("Yo! Upload Completed", message: "")
                                                print("successfully save")
                                            } else {
                                                print(error?.localizedDescription)
                                            }
                                        })
                                })
                            self.cleanWall()
                            self.recordButton.setBackgroundImage(UIImage(named: "cameraButton"), forState: .Normal)
                            self.tableView.reloadData()

                        } else {
                            let failedAlert = UIAlertController(title: "Failed!", message: "Image failed to post. Please try again.", preferredStyle: .Alert)
                            failedAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                            self.presentViewController(failedAlert, animated: true, completion: nil)
                        }
                    })
                    
                } else {
                    print(error?.localizedDescription)
                }
                }, progressBlock: { percent in
                    print("Upload: \(percent)%")
            })
            self.view.window?.endEditing(true)
        } else {
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presentAlert("No video Added", message: "Record your video and share")
            })
        }
    }
    
    
    
    func cleanWall() {
        for viewToRemove in videoView.subviews {
            
            videoOfUrl = nil
            viewToRemove.removeFromSuperview()
        }
    }
    
    // MARK: Video Record
    
    func startCameraRecord(view: UIViewController, withDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) == false {
            return false
        }
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .Camera
        cameraController.mediaTypes = [kUTTypeMovie as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        cameraController.videoMaximumDuration = 30
        
        presentViewController(cameraController, animated: true, completion: nil)
        return true
    }
    
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        
        
        //        var title = "Success"
        //        var message = "Video was saved to library"
        if let _ = error {
            print("successfully saved to library")
            //            title = "Error"
            //            message = "Video failed to save"
        }
        //        self.presentAlert(title, message: message)
    }
    
    //MARK: - Present Alert
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - AVPlayerViewController
    
    var avPlayer = AVPlayer()
    
    func playBackgroundMovie(url: NSURL){
        
        self.recordButton.setBackgroundImage(nil, forState: .Normal)
        
        
        avPlayer = AVPlayer(URL: url)
        
        let moviePlayer = AVPlayerViewController()
        self.addChildViewController(moviePlayer)
        
        moviePlayer.player = avPlayer
        moviePlayer.view.bounds = self.videoView.bounds
        moviePlayer.view.center = self.videoView.center
        moviePlayer.view.frame = CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height)
        moviePlayer.view.sizeToFit()
        moviePlayer.videoGravity = AVLayerVideoGravityResizeAspect
        moviePlayer.showsPlaybackControls = true
        
        avPlayer.play()
        videoView.addSubview(moviePlayer.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "playerReachedEnd",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: nil)
        self.tableView.reloadData()
    }
    
    func playerReachedEnd() {
        avPlayer.seekToTime(CMTimeMakeWithSeconds(0, 1))
        avPlayer.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension AddBlogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == kUTTypeMovie {
            if let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path {
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                    
                    
                    // Save to Library
                    UISaveVideoAtPathToSavedPhotosAlbum(path, self, "video:didFinishSavingWithError:contextInfo:", nil)
                    
                    if let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL {

                        self.videoOfUrl = urlOfVideo
                        
                        // Play Video
                        self.playBackgroundMovie(urlOfVideo)
                        let thumbnails: UIImage =  VideoController.takeSnapshot(urlOfVideo)
                       
                        self.thumbnail = thumbnails
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension AddBlogViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
