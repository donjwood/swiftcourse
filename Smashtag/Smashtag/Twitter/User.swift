//
//  User.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

// container to hold data about a Twitter user

public struct User: CustomStringConvertible
{
    //DJW: Changed from lets to vars to work around swift 1.2 errors
    public var screenName: String
    public var name: String
    public var profileImageURL: NSURL?
    public var verified: Bool
    public var id: String!
    
    public var description: String { var v = verified ? " ✅" : ""; return "@\(screenName) (\(name))\(v)" }

    // MARK: - Private Implementation

    init?(data: NSDictionary?) {
        let name = data?.valueForKeyPath(TwitterKey.Name) as? String
        let screenName = data?.valueForKeyPath(TwitterKey.ScreenName) as? String
        
        //DJW: Added default values to work around swift 1.2 errors
        self.screenName = "Unknown"
        self.name = "Unknown"
        self.profileImageURL = nil
        self.verified = false
        self.id = ""
        
        if name != nil && screenName != nil {
            self.name = name!
            self.screenName = screenName!
            self.id = data?.valueForKeyPath(TwitterKey.ID) as? String
            if let verified = data?.valueForKeyPath(TwitterKey.Verified)?.boolValue {
                self.verified = verified
            }
            if let urlString = data?.valueForKeyPath(TwitterKey.ProfileImageURL) as? String {
                self.profileImageURL = NSURL(string: urlString)
            }
        } else {
            return nil
        }
    }
    
    var asPropertyList: AnyObject {
        var dictionary = Dictionary<String,String>()
        dictionary[TwitterKey.Name] = self.name
        dictionary[TwitterKey.ScreenName] = self.screenName
        dictionary[TwitterKey.ID] = self.id
        dictionary[TwitterKey.Verified] = verified ? "YES" : "NO"
        dictionary[TwitterKey.ProfileImageURL] = profileImageURL?.absoluteString
        return dictionary
    }

    
    init() {
        screenName = "Unknown"
        name = "Unknown"
        
        //Added by DJW to get around swift 1.2 errors
        profileImageURL = nil
        verified = false
        id = ""

    }
    
    struct TwitterKey {
        static let Name = "name"
        static let ScreenName = "screen_name"
        static let ID = "id_str"
        static let Verified = "verified"
        static let ProfileImageURL = "profile_image_url"
    }
}
