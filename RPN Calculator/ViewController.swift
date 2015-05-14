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
    
    @IBAction func binaryOperator(sender: UIButton) {
        if displayValue != 0 {
            operandStack.append(displayValue)
        }
        if(operandStack.count >= 2){
            let op = sender.currentTitle!
            var left = operandStack.removeLast()
            var right = operandStack.removeLast()
            var result = 0.0
            if op == "+" {
                result = left + right
            }
            else if op == "−" {
                result = left - right
            }
            else if op == "×" {
                result = left * right
            }
            else if op == "÷" {
                if right != 0 {
                    result = left / right
                }
            }
        
        operandStack.append(result)
        display.text! = "\(result)"
        clearDigit = true
        }
    }
    
    
    var operandStack = Array<Double>()
    @IBAction func enter() {
        operandStack.append(displayValue)
        display.text! = "0"
        clearDigit = true

    }
    
    @IBAction func clearAll() {
        clearDigit = true
        display.text! = "0"
        operandStack.removeAll(keepCapacity: false)
        
    }
    
}

