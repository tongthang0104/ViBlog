//
//  VideoPlayerViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 12/9/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
import AVFoundation


    /* Asset keys */
    let kTracksKey: String = "tracks"
    
    let kPlayableKey: String = "playable"
    
    /* PlayerItem keys */
    let kStatusKey: String = "status"
    
    let kCurrentItemKey: String = "currentItem"
    
    var AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext: Void
    
    var AVPlayerDemoPlaybackViewControllerStatusObservationContext: Void
    
class VideoPlayerViewController: UIViewController {
        
        var URL: NSURL
        var playerItem: AVPlayerItem
        var player: AVPlayer
        override func loadView() {
            var playerView: VideoPlayerView = VideoPlayerView()
            self.view = playerView
            self.playerView = playerView
            playerView
        }
        
       init () {
            self.player.removeObserver(self, forKeyPath: kCurrentItemKey)
            self.player.currentItem!.removeObserver(self, forKeyPath: kStatusKey)
            self.player.pause()
            self.URL = nil
            self.player = nil
            self.playerItem = nil
            self.playerView = nil
            super.dealloc()
        }
        
        func prepareToPlayAsset(asset: AVURLAsset, withKeys requestedKeys: [AnyObject]) {
            for thisKey: String in requestedKeys {
                var error: NSErrorPointer? = nil
                var keyStatus: AVKeyValueStatus = asset.statusOfValueForKey(thisKey, error: error)
                if keyStatus == .Failed {
                    return
                }
            }
            if !asset.playable {
                return
            }
            if self.playerItem {
                self.playerItem.removeObserver(self, forKeyPath: kStatusKey)
                NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerItem)
            }
            self.playerItem = AVPlayerItem(asset: asset)
            self.playerItem!.addObserver(self, forKeyPath: kStatusKey, options: .Initial | .New, context: AVPlayerDemoPlaybackViewControllerStatusObservationContext)
            // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
            if !self.player() {
                self.player = AVPlayer.playerWithPlayerItem(self.playerItem)
                self.player.addObserver(self, forKeyPath: kCurrentItemKey, options: .Initial | .New, context: AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
            }
            if self.player.currentItem != self.playerItem {
                self.player().replaceCurrentItemWithPlayerItem(self.playerItem)
            }
        }
        
        func observeValueForKeyPath(path: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: ) {
            if context == AVPlayerDemoPlaybackViewControllerStatusObservationContext {
                var status: AVPlayerStatus = change[.NewKey].integerValue
                if status == .ReadyToPlay {
                    self.player.play()
                }
            }
            else {
                if context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext {
                    var newPlayerItem: AVPlayerItem = change[.NewKey]
                    if newPlayerItem {
                        self.playerView.player = self.player
                        self.playerView.videoFillMode = .ResizeAspect
                    }
                }
                else {
                    super.observeValueForKeyPath(path, ofObject: object, change: change, context: context)
                }
            }
        }
        
        func setURL(URL: NSURL) {
            URL
            self.URL = URL.copy()
            var asset: AVURLAsset = AVURLAsset.URLAssetWithURL(URL, options: nil)
            var requestedKeys: [AnyObject] = [AnyObject].arrayWithObjects(kTracksKey, kPlayableKey, nil)
            asset.loadValuesAsynchronouslyForKeys(requestedKeys, completionHandler: {() -> Void in
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    self.prepareToPlayAsset(asset, withKeys: requestedKeys)
                })
            })
        }
        
        func URL() -> NSURL {
            return URL
        }
        
        func itemDidFinishPlaying() {
            NSLog("finish playing")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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


