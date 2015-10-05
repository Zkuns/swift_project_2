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
    @IBOutlet weak var result: UITextField!
    @IBOutlet weak var express: UILabel!
    var stack = Array<Double>()
    var is_middle_type = false
    var result_value: Double? {
        set{
            if let digit = newValue{
                result.text = "\(digit)"
            } else {
                result.text = " "
            }
        }
        get{
            return NSNumberFormatter().numberFromString(result.text!)!.doubleValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.variableValues["π"] = M_PI
    }

    @IBAction func click_operator(sender: UIButton) {
        let m_operator = sender.currentTitle!
        brain.pushOperation(m_operator)
    }
    
    @IBAction func click_constant(sender: UIButton) {
        let constant = sender.currentTitle!
        brain.pushOperand(constant)
    }
    
    @IBAction func ser_m(sender: AnyObject) {
        brain.variableValues["M"] = result_value
    }
    
    @IBAction func enter() {
        is_middle_type = false
        if let digit = result_value{
            brain.pushOperand(digit)
        }
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
    
    @IBAction func do_it(sender: AnyObject) {
        express.text! = brain.describe
        if let result = brain.evaluate(){
            result_value = result
        }
    }
    
    @IBAction func clear() {
        is_middle_type = false
        result.text! = "0"
        brain.reset()
        brain.variableValues["M"] = nil
    }

}

