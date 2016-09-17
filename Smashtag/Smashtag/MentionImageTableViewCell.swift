//
//  MentionImageTableViewCell.swift
//  Smashtag
//
//  Created by Donald Wood on 6/28/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

class MentionImageTableViewCell: UITableViewCell {

    var media: MediaItem? {
        didSet {
            updateUI()
        }
    }
    

    @IBOutlet weak var tweetedImageView: UIImageView!
    
    func updateUI() {
        if let media = self.media {
            if let imageURL = media.url {
                tweetedImageView.contentMode = UIViewContentMode.ScaleAspectFill
                tweetedImageView.frame = CGRectMake(tweetedImageView.frame.origin.x, tweetedImageView.frame.origin.y, tweetedImageView.frame.width, tweetedImageView.frame.width * CGFloat(media.aspectRatio))
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, self.frame.height / CGFloat(media.aspectRatio))
                    dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    if let imageData = NSData(contentsOfURL: imageURL) { // blocks main thread!
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tweetedImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
                
            }
        }
    }
}
