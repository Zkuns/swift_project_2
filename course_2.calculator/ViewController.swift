//
//  ViewController.swift
//  course_2.calculator
//
//  Created by 朱坤 on 10/1/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let brain = CalculatorBrain()
    @IBOutlet weak var remember: UILabel!
    @IBOutlet weak var result: UITextField!
    var stack = Array<Double>()
    var is_middle_type = false
    var result_value: Double {
        set{
            result.text = "\(newValue)"
        }
        get{
            return NSNumberFormatter().numberFromString(result.text!)!.doubleValue
        }
    }

    @IBAction func click_operator(sender: UIButton) {
        let m_operator = sender.currentTitle!
        brain.pushOperation(m_operator)
        if let result = brain.evaluate(){
            result_value = result
        }
    }
    
    @IBAction func click_remember(sender: UIButton) {
        let m_operator = sender.currentTitle!
        remember.text! = m_operator
    }
    @IBAction func enter() {
        is_middle_type = false
        brain.pushOperand(result_value)
    }
    
    @IBAction func click_number(sender: UIButton) {
        let digit = sender.currentTitle!
        if (digit == "." && result.text!.rangeOfString(".") != nil) { return }
        if is_middle_type {
            result.text! = result.text! + digit
        } else {
            if (digit == "." && result.text!.characters.count == 1) { return }
            result.text! = digit
            is_middle_type = true
        }
    }
    
    @IBAction func clear() {
        is_middle_type = false
        result.text! = "0"
        brain.reset()
        remember.text = "nil"
    }
}

