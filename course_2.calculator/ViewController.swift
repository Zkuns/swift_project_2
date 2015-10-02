//
//  ViewController.swift
//  course_2.calculator
//
//  Created by 朱坤 on 10/1/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        switch m_operator{
            case "+": two_calculate(+)
            case "−": two_calculate(-)
            case "×": two_calculate(*)
            case "÷": two_calculate(/)
            case "√": one_calculate {sqrt($0)}
            case "sin": one_calculate {sin($0)}
            case "cos": one_calculate {cos($0)}
            case "π":
                stack.append(M_PI)
                is_middle_type = false
                print("\(stack)")
            default: break
        }
    }
    
    @IBAction func click_remember(sender: UIButton) {
        let m_operator = sender.currentTitle!
        remember.text! = m_operator
    }
    @IBAction func enter() {
        is_middle_type = false
        stack.append(result_value)
        print("\(stack)")
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
    
    func two_calculate(fun: (Double, Double)->Double){
        if (stack.count >= 2){
            result_value = fun(stack.removeLast(), stack.removeLast())
            enter()
        }
    }
    
    func one_calculate(fun: Double-> Double){
        if (stack.count >= 1){
            result_value = fun(stack.removeLast())
            enter()
        }
    }
    
    @IBAction func clear() {
        is_middle_type = false
        result.text! = "0"
        stack.removeAll()
        remember.text = "nil"
    }
}

