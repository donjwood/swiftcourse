//
//  ViewController.swift
//  Psychologist
//
//  Created by Donald Wood on 4/9/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {
    
    
    @IBAction func nothing(sender: UIButton) {
    
        //Even though this is done in code, it still calls prepare.
        performSegueWithIdentifier("nothing", sender: nil)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        //Best to do this in prepare if there is the possibility the view will end up in UINavigationController
        if let navCon = destination as? UINavigationController
        {
            //Returns top view on the stack
            destination = navCon.visibleViewController
        }
        if let hvc = destination as? HappinessViewController{
            if let identifier = segue.identifier {
                switch identifier {
                    case "sad": hvc.happiness = 0
                    case "happy": hvc.happiness = 100
                    case "nothing": hvc.happiness = 25
                    default: hvc.happiness = 50
                }
            }
        }
    }

}

