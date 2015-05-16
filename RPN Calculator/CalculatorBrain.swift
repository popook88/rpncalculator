//
//  CalculatorBrain.swift
//  RPN Calculator
//
//  Created by Kevin Kane on 5/16/15.
//  Copyright (c) 2015 KevinKane. All rights reserved.
//

import Foundation
import Darwin

class CalculatorBrain{

    private enum Op: Printable {
        case Operand(Double)
        case UniaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self{
                case .Operand(let value):
                    return "\(value)"
                case .UniaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    //dictionary
    private var knownOps = [String: Op]()
    
    init() {
        func learnOp (op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") {$1 / $0})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1 - $0})
        learnOp(Op.UniaryOperation("√", sqrt))
    }

    
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        //whenever you look up something in a dictionary, it always returns an optional. Because it could be nil if it doesn't exist
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    

    //classes can have inheritance
    //classes are passed by reference
    //structs are passed by value
    //doubles, ints, dictionaries and arrays are structs
    //it's implied that let is before these copied values, you need var
    //or create local variable
    private func evaluate(ops: [Op]) -> (result: Double?, remainingStack: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UniaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingStack)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                let op2Evaluation = evaluate(remainingOps)

                if  let operand1 = op1Evaluation.result,
                    let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingStack)
                }
                
//                let op1Evaluation = evaluate(remainingOps)
//                if let operand1 = op1Evaluation.result {
//                    let op2Evaluation = evaluate(remainingOps)
//                    if let operand2 = op2Evaluation.result {
//                        return (operation(operand1, operand2), op2Evaluation.remainingStack)
//                    }
//                }
            }
        }
        return (nil, ops)
    }
    func evaluate() -> Double?{
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with the remainder \(remainder) left over")
        return result
        
    }
    
    func clearMemory(){
        while !opStack.isEmpty{
            opStack.removeLast()
        }
    }

}