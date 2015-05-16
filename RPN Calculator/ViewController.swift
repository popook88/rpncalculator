//
//  ViewController.swift
//  RPN Calculator
//
//  Created by Kevin Kane on 3/19/15.
//  Copyright (c) 2015 KevinKane. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var clearDigit = true
    
    var brain = CalculatorBrain()
    
    @IBOutlet weak var display: UILabel!
    
    var displayValue: Double {
        get {
            var ball = NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            return ball
        }
        set {
            display.text = "\(newValue)"
        }
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if clearDigit{
            display.text! = digit
            clearDigit = false
        }
        else{
            display.text! += digit
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if let result = brain.performOperation(sender.currentTitle!){
            displayValue = result
        }
        else{
            displayValue = 0
        }
        clearDigit = true
    }
    
    @IBAction func enter() {
        clearDigit = true
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }
        else{
            //error message in the future
            displayValue = 0
        }
    }
    
    @IBAction func clearAll() {
        clearDigit = true
        displayValue = 0
        brain.clearMemory()
    }
    
}

