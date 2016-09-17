//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Donald Wood on 6/25/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {

    //MARK: - Enumerations
    enum MentionType:CustomStringConvertible {
        case Media(MediaItem)
        case Hashtag(Tweet.IndexedKeyword)
        case User(Tweet.IndexedKeyword)
        case Url(Tweet.IndexedKeyword)
        
        var description: String {
            get{
                switch self {
                case .Media(let aMediaItem):
                    return aMediaItem.description
                case .Hashtag(let aHashtag):
                    return aHashtag.keyword
                case .User(let aUser):
                    return aUser.keyword
                case .Url(let aUrl):
                    return aUrl.keyword
                }
            }
        }
    }
    
    //MARK: - Properties
    var tweet: Tweet? {
        didSet {
            //When a tweet is set, init the data source
            if tweet != nil {
                setMentionDataWithTweet(tweet!)
            }
            
        }
    }
    
    private var mentionData = [[MentionType]]()
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = tweet?.user.name ?? ""
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentionData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionData[section].count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch mentionData[section][0]{
        case .Media(_):
            return "Images"
        case .Hashtag(_):
            return "Hashtags"
        case .User(_):
            return "Users"
        case .Url(_):
            return "Urls"
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mentionItem = mentionData[indexPath.section][indexPath.row]
        
        switch mentionItem {
            
        case .Media(let media):
            return tableView.bounds.size.width / CGFloat(media.aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mentionItem = mentionData[indexPath.section][indexPath.row]
        
        switch mentionItem {
        
        case .Media(let media):
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Image", forIndexPath: indexPath) as! MentionImageTableViewCell
            
            // Configure the cell...
            cell.media = media
            
            return cell

        default:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Mention", forIndexPath: indexPath) 
        
            // Configure the cell...
            cell.textLabel!.text! = "\(mentionItem)"
        
            return cell
            
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mentionItem = mentionData[indexPath.section][indexPath.row]
        
        switch mentionItem {
        case .Media(let anImage):
            self.performSegueWithIdentifier("ShowImage", sender: self)
        case .Hashtag(let aTweet):
            self.performSegueWithIdentifier("SearchForMention", sender: self)
        case .User(let aUser):
            self.performSegueWithIdentifier("SearchForMention", sender: self)
        case .Url(let aUrl):
            UIApplication.sharedApplication().openURL(NSURL(string:aUrl.keyword)!)
        }

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Segues

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "SearchForMention" {
            if let tweetTVC = segue.destinationViewController as? TweetTableViewController,
                indexPath = self.tableView.indexPathForSelectedRow {
                let mentionItem = mentionData[indexPath.section][indexPath.row]
                switch mentionItem {
                case .Hashtag(let aHashtag):
                    tweetTVC.searchText = aHashtag.keyword
                case .User(let aUser):
                    tweetTVC.searchText = aUser.keyword
                default:
                    break
                }
                
            }
        } else if segue.identifier == "ShowImage" {
            if let ivc = segue.destinationViewController as? ImageViewController,
                indexPath = self.tableView.indexPathForSelectedRow {
                let mentionItem = mentionData[indexPath.section][indexPath.row]
                    switch mentionItem {
                    case .Media(let anImage):
                        ivc.imageURL = anImage.url
                    default:
                        break
                    }
            }
        }
    }
    
    //MARK: - Helper Methods
    private func setMentionDataWithTweet(tweet: Tweet){
        mentionData.removeAll()
        
        if tweet.media.count > 0 {
            mentionData.append(tweet.media.map({MentionType.Media($0)}))
        }
        
        if tweet.hashtags.count > 0 {
            mentionData.append(tweet.hashtags.map({MentionType.Hashtag($0)}))

        }

        if tweet.userMentions.count > 0 {
            mentionData.append(tweet.userMentions.map({MentionType.User($0)}))
        }
        
        if tweet.urls.count > 0{
            mentionData.append(tweet.urls.map({MentionType.Url($0)}))
        }
    }
    
}
