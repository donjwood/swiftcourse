//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by Donald Wood on 4/10/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

class DiagnosedHappinessViewController : HappinessViewController, UIPopoverPresentationControllerDelegate {
 
    override var happiness: Int {
        didSet {
            //Does not override Didset in superclass.
            diagnosticHistory += [happiness]
        }
    }
    
    //Use defaults sincew a new view is created each time and loses the array info.
    private let defaults = NSUserDefaults.standardUserDefaults()
    var diagnosticHistory: [Int] {
        get { return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? [] } //If there is no array of strings, returns empty array.
        set { defaults.setObject(newValue, forKey: History.DefaultsKey) }
    }
    
    private struct History {
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultsKey = "DiagnosedHappinessViewController.History"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default: break
            }
        }
    }
    
    //Added to adapt to iPhone so we have a popover instead of a modal.
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
}
