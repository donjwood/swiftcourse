//
//  TextViewController.swift
//  Psychologist
//
//  Created by Donald Wood on 4/10/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = text
        }

    }
    
    var text: String = "" {
        didSet {
            textView?.text = text
        }
    }
    
    //Set to autosize popover based on content
    override var preferredContentSize: CGSize {
        get {
            if textView != nil && presentingViewController != nil {
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
              return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue}
    }
}
