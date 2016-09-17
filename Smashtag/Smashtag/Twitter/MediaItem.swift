//
//  MediaItem.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

// holds the network url and aspectRatio of an image attached to a Tweet
// created automatically when a Tweet object is created

public struct MediaItem
{
    
    //DJW: Changed from lets to vars by to work around swift 1.2 errors
    public var url: NSURL!
    public var aspectRatio: Double
    
    public var description: String { return (url.absoluteString ?? "no url") + " (aspect ratio = \(aspectRatio))" }
    
    // MARK: - Private Implementation

    init?(data: NSDictionary?) {
        
        //DJW: Added default values to work around Swift 1.2 errors
        var valid = false
        self.url = nil
        aspectRatio = 0
        if let urlString = data?.valueForKeyPath(TwitterKey.MediaURL) as? NSString {
            if let url = NSURL(string: urlString as String) {
                self.url = url
                let h = data?.valueForKeyPath(TwitterKey.Height) as? NSNumber
                let w = data?.valueForKeyPath(TwitterKey.Width) as? NSNumber
                if h != nil && w != nil && h?.doubleValue != 0 {
                    aspectRatio = w!.doubleValue / h!.doubleValue
                    valid = true
                }
            }
        }
        if !valid {
            return nil
        }
        
    }
    
    struct TwitterKey {
        static let MediaURL = "media_url_https"
        static let Width = "sizes.small.w"
        static let Height = "sizes.small.h"
    }
}
