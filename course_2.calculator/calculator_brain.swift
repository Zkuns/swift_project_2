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
        case Operand(Double);
        case UnaryOperation(String, Double ->Double);
        case BinaryOperation(String, (Double, Double)-> Double);
        var description: String{
            get{
                switch self{
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
        learn_ops(Op.BinaryOperation("−", { $1 - $0 }))
        learn_ops(Op.BinaryOperation("×", *))
        learn_ops(Op.BinaryOperation("÷", { $1 / $0 }))
        learn_ops(Op.UnaryOperation("sin", { sin($0) }))
        learn_ops(Op.UnaryOperation("cos", { cos($0) }))
        learn_ops(Op.Operand(M_PI))
    }
    
    private var knowops = [String: Op]()
    
    private var stack = [Op]()
    
    func pushOperand(digit: Double) {
        stack.append(Op.Operand(digit))
    }
    
    func pushOperation(name: String) {
        if let op = knowops[name] {
            stack.append(op)
        }
    }
    
    private func evaluate(var stack: [Op]) -> (num: Double?, remain: [Op]){
        let opera = stack.removeLast()
        switch opera {
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
        return (nil, stack)
    }
    
    func evaluate()-> Double?{
        let result = evaluate(stack)
        print("\(stack)")
        return result.num
    }
    
    func reset(){
        stack.removeAll()
    }
}