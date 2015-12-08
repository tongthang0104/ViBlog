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

class AddBlogViewController: UIViewController {

    var caption: String?
    var video: NSURL?
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var recordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recordButtonTapped(sender: UIButton) {
        self.startCameraRecord(self, withDelegate: self)
    }
    
    func startCameraRecord(view: UIViewController, withDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) == false {
            return false
        }
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .Camera
        cameraController.mediaTypes = [kUTTypeMovie as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        presentViewController(cameraController, animated: true, completion: nil)
        return true
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        self.view.window?.endEditing(true)
        if let video = video {
            BlogController.createBlog(video, caption: caption, completion: { (blog, success) -> Void in
                if blog != nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let failedAlert = UIAlertController(title: "Failed!", message: "Image failed to post. Please try again.", preferredStyle: .Alert)
                    failedAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(failedAlert, animated: true, completion: nil)
                }
            })
        }
    }

    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
extension AddBlogViewController: UIImagePickerControllerDelegate {
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == kUTTypeMovie {
            if let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path {
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                    UISaveVideoAtPathToSavedPhotosAlbum(path, self, "video:didFinishSavingWithError:contextInfo:", nil)
                    
                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                    let asset: AVAsset = AVAsset(URL: urlOfVideo!)
                    
                    let duration: CMTime = asset.duration
                    let snapshot = CMTimeMake(duration.value / 2, duration.timescale)
                    
                    let generator = AVAssetImageGenerator(asset: asset)
                    let imageRef: CGImageRef = try! generator.copyCGImageAtTime(snapshot, actualTime: nil)
                    
                    let thumbnail: UIImage = UIImage(CGImage: imageRef)
                    let data = UIImagePNGRepresentation(thumbnail)
                    let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                    data?.writeToFile(directory, atomically: true)
                    
                    self.recordButton.setBackgroundImage(thumbnail, forState: .Normal)
                    self.recordButton.setTitle("", forState: .Normal)
                    
                    //self.presentViewController(moviePlayers, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    
    
    
}

extension AddBlogViewController: UINavigationControllerDelegate {
    
}
