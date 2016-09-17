//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Donald Wood on 5/18/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    var hashtagHighlightColor = UIColor.redColor()
    var urlHighlightColor = UIColor.blueColor()
    var userMentionHighlightColor = UIColor.orangeColor()
    
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            
            var tweetText = tweet.text
            
            for _ in tweet.media {
                tweetText += " 📷"
            }
            
            var attrTweetText = NSMutableAttributedString(string: tweetText, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleBody)])
            
            //Highlight hashtags
            for hashtag in tweet.hashtags {
                attrTweetText.addAttribute(NSForegroundColorAttributeName, value: hashtagHighlightColor, range: hashtag.nsrange)
            }
            
            //Highlight urls
            for url in tweet.urls {
                attrTweetText.addAttribute(NSForegroundColorAttributeName, value: urlHighlightColor, range: url.nsrange)
            }
            
            //Highlight user mentions
            for userMention in tweet.userMentions {
                attrTweetText.addAttribute(NSForegroundColorAttributeName, value: userMentionHighlightColor, range: userMention.nsrange)
            }

            tweetTextLabel?.attributedText = attrTweetText
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                //User initiated thread to fetch image.
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    }
}
