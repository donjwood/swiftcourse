//
//  RecentSearchHistory.swift
//  Smashtag
//
//  Created by Donald Wood on 6/29/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import Foundation

class RecentSearchHistory {
    
    //MARK: - Propeties
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private struct Constants {
        static let MaxRetentionCount = 100
        static let DefaultsRecentSearchesKey = "SmashTagRecentSearches.History"
    }
    
    var history: [String] {
            return defaults.objectForKey(Constants.DefaultsRecentSearchesKey) as? [String] ?? []
    }
    
    //MARK: - Methods
    internal func addToHistory(searchTerm: String) {
        
        var historyValues = defaults.objectForKey(Constants.DefaultsRecentSearchesKey) as? [String] ?? []
        
        if let searchTermIndex = historyValues.indexOf(searchTerm) {
            historyValues.removeAtIndex(searchTermIndex)
        }
        
        historyValues.insert(searchTerm, atIndex: 0)
        
        if historyValues.count > Constants.MaxRetentionCount {
            historyValues.removeAtIndex(Constants.MaxRetentionCount)
        }
        
        defaults.setObject(historyValues, forKey: Constants.DefaultsRecentSearchesKey)

    }
}