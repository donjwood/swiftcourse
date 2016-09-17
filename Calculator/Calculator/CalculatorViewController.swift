//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Donald Wood on 3/1/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

   
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var hasTypedDecimalPoint = false
    
    var brain = CalculatorBrain()

    @IBAction func clear(sender: UIButton) {
        
        displayValue = nil
        historyDisplayValue = nil
        brain.clearOps()
        brain.clearVariables()
        
    }
    
    @IBAction func clearEntry(sender: UIButton) {
        
        if !userIsInTheMiddleOfTypingANumber {
            displayValue = brain.undoLastEntry()
            historyDisplayValue = "\(brain)"
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func backspace(sender: UIButton) {
        if !userIsInTheMiddleOfTypingANumber {
            displayValue = brain.undoLastEntry()
            historyDisplayValue = "\(brain)"
        } else {
        
            if let lastChar = (display.text!).characters.last {
            
                if lastChar == "." {
                    hasTypedDecimalPoint = false
                }
                
                let newDisplayText = String((display.text!).characters.dropLast())
                if newDisplayText.characters.count > 0
                {
                    display.text = newDisplayText
                } else {
                    display.text = "0"
                    userIsInTheMiddleOfTypingANumber = false
                }
                
            }
        }
    }
    
    @IBAction func negate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber
        {
            if let firstDigit = (display.text!).characters.first{
                if firstDigit == "-" {
                    display.text = String((display.text!).characters.dropFirst())
                } else {
                    display.text = "-" + display.text!
                }
            }
        } else {
            operate(sender)
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if digit == "." {
            if !hasTypedDecimalPoint {
            hasTypedDecimalPoint = true
            } else {
                return
            }
        }
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)        }
        historyDisplayValue = "\(brain)"
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false;
        displayValue = brain.pushOperand(displayValue!)
        historyDisplayValue = "\(brain)"
    }

    
    @IBAction func setMVariable(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        brain.variableValues["M"] = displayValue
        displayValue = brain.evaluate()
        historyDisplayValue = "\(brain)"
    }
    
    @IBAction func pushMVariable(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        displayValue = brain.pushOperand("M")
        historyDisplayValue = "\(brain)"
    }
    
    var displayValue: Double?{
        get{
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set{
            if newValue != nil {
                display.text = String(format: "%g", newValue!)
            } else {
                display.text = "0"
            }
            
            userIsInTheMiddleOfTypingANumber = false
            hasTypedDecimalPoint = false
        }
    }
    
    var historyDisplayValue: String? {
        get{
            return historyDisplay.text
        }
        set{
            if newValue != nil && newValue != "" {
                historyDisplay.text = "\(newValue!)="
            } else {
                historyDisplay.text = " "
            }
        }
    }
    
    //MARK: Prepare for Segue
    
    //prepare for segue method
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        var destination = segue.destinationViewController as? UIViewController
        //Best to do this in prepare if there is the possibility the view will end up in UINavigationController
        if let navCon = destination as? UINavigationController
        {
            //Returns top view on the stack
            destination = navCon.visibleViewController
        }
        
        if let gvc = destination as? GraphViewController{
            gvc.calcBrain.program = brain.program
        }
        
    }
}

