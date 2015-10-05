//
//  calculator_brain.swift
//  course_2.calculator
//
//  Created by 朱坤 on 10/2/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import Foundation

class CalculatorBrain{
    private enum Op: CustomStringConvertible{
        case Constant(String);
        case Operand(Double);
        case UnaryOperation(String, Double ->Double);
        case BinaryOperation(String, (Double, Double)-> Double);
        var description: String{
            get{
                switch self{
                case .Constant(let str):
                    return str
                case .Operand(let number):
                    return "\(number)"
                case .UnaryOperation(let name, _):
                    return name
                case .BinaryOperation(let name, _):
                    return name
                }
            }
        }
    }
    
    private func learn_ops(op: Op){
        knowops[op.description] = op
    }
    
    init(){
        learn_ops(Op.BinaryOperation("+", +))
        learn_ops(Op.BinaryOperation("−", -))
        learn_ops(Op.BinaryOperation("×", *))
        learn_ops(Op.BinaryOperation("÷", /))
        learn_ops(Op.UnaryOperation("sin", { sin($0) }))
        learn_ops(Op.UnaryOperation("cos", { cos($0) }))
//        learn_ops(Op.Operand(M_PI))
    }
    
    private var knowops = [String: Op]()
    
    private var stack = [Op]()
    
    var variableValues = Dictionary<String, Double>()
    
    func pushOperand(str: String) {
        stack.insert(Op.Constant(str), atIndex: 0)
    }
    
    func pushOperand(digit: Double) {
        stack.insert(Op.Operand(digit), atIndex: 0)
    }
    
    func pushOperation(name: String) {
        if let op = knowops[name] {
            stack.append(op)
        }
    }
    
    private func evaluate(var stack: [Op]) -> (num: Double?, remain: [Op]){
        if (stack.count>0){
            let opera = stack.removeLast()
            switch opera {
                case .Constant(let str):
                    if let digit = variableValues[str]{
                        return (digit, stack)
                    }
                case .Operand(let digit):
                    return (digit, stack)
                case .UnaryOperation(_, let fun):
                    let result = evaluate(stack)
                    if let num = result.num{
                        return (fun(num), result.remain)
                    }
                case .BinaryOperation(_, let fun):
                    let result = evaluate(stack)
                    if let num1 = result.num {
                        let result2 = evaluate(result.remain)
                        if let num2 = result2.num{
                            return (fun(num1, num2), result2.remain)
                        }
                    }
            }
        }
        return (nil, stack)
    }
    
    private func describe(var stack: [Op]) -> (num: String?, remain: [Op]){
        if (stack.count > 0) {
            let opera = stack.removeLast()
            switch opera {
                case .Constant(let str):
                    return (str, stack)
                case .Operand(let digit):
                    return ("\(digit)", stack)
                case .UnaryOperation(let str, _):
                    let result = describe(stack)
                    return ("\(str)(\(result.num!))", stack)
                case .BinaryOperation(let str, _):
                    let result = describe(stack)
                    if let num = result.num {
                        let result1 = describe(result.remain)
                        if let num1 = result1.num {
                            switch str{
                                case "−", "÷":
                                    return ("(\(num) \(str) \(num1))", result1.remain)
                                case "+", "×":
                                    return ("(\(num1) \(str) \(num))", result1.remain)
                                default: break
                            }
                        }
                    }
            }
        }
        return ("?", stack)
    }
    var describe: String {
        get{
            return describe(stack).num!
        }
    }
    
    func evaluate()-> Double?{
        let result = evaluate(stack)
        print("\(stack)")
        print("\(describe)")
        return result.num
    }
    
    func reset(){
        stack.removeAll()
    }
}