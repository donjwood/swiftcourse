//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Donald Wood on 3/12/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import Foundation

class CalculatorBrain: CustomStringConvertible
{
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case ConstantOperand(String, Double)
        case VariableOperand(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, Int, Bool, (Double, Double) -> Double)
        
        var description: String
        {
            get{
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .ConstantOperand(let symbol, _):
                    return symbol
                case .VariableOperand(let symbol):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _, _, _):
                    return symbol
                default:
                    return ""
                }
            }
        }
        
        var precedence: Int {
            switch self {
            case .BinaryOperation(_, let precedenceValue, _, _):
                return precedenceValue
            default:
                return Int.max
            }
        }
        
        var isCommutative: Bool {
            get{
                switch self {
                case .BinaryOperation(_, _, let commutativeValue,  _):
                    return commutativeValue
                default:
                    return true;
                }
            }
        }
    }

    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    var variableValues = Dictionary<String,Double>()
    
    var description: String {
        get {
            return expressionsToString(opStack)
        }
    }
    
    var evaluatedExpression: String {
        get {
            let (output, _, _, remainingOps) = opsToString(opStack)
            return output ?? ""
        }
    }
    
    init(){
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.ConstantOperand("π", M_PI))
        learnOp(Op.BinaryOperation("×", 2, true, *))   //* and + considered functions
        learnOp(Op.BinaryOperation("÷", 2, false) { $1 / $0 })
        learnOp(Op.BinaryOperation("+", 1, true, +))
        learnOp(Op.BinaryOperation("−", 1, false) { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("+/-") {$0 * -1})
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList{ //guaranteed to be a PropertyList
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    } else {
                        newOpStack.append(.VariableOperand(opSymbol))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    func clearOps() {
        opStack.removeAll()
        print("Operations Cleared")
    }
    
    func clearVariables() {
        variableValues.removeAll()
        print("Variables Cleared")
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.VariableOperand(symbol))
        return evaluate()
    }
    
    func undoLastEntry() -> Double? {
        if !opStack.isEmpty {
            opStack.removeLast()
        }
        return evaluate()
    }
    
    func sinDeg(degreeValue: Double) -> Double {
        return sin(degreesToRadians(degreeValue))
    }
    
    func cosDeg(degreeValue: Double) -> Double {
        return cos(degreesToRadians(degreeValue))
    }
    
    func degreesToRadians(degreeValue: Double) -> Double {
        return degreeValue * (M_PI / 180)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .ConstantOperand(_, let constantValue):
                return (constantValue, remainingOps)
            case .VariableOperand(let symbol):
                return (variableValues[symbol], remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, _, _, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
            
        }
        
        return (nil, ops)
    }
    
    //Given an array of ops, this method returns them as a string of expressions
    private func expressionsToString(ops: [Op]) -> String {
    
        let (output, _, _, remainingOps) = opsToString(ops)
        
        let expressionString = output ?? ""
        
        if remainingOps.isEmpty {
            return expressionString
        } else {
            return "\(expressionsToString(remainingOps)),\(expressionString)"
        }
        
    }
    
    //Given an array of ops, this function returns the first complete expression as a string and the remaining ops on the stack.
    private func opsToString(ops: [Op]) -> (stringValue: String?, opPrecedence: Int, isOpCommutative: Bool, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op{
            case .Operand(let operand):
                return (String(format: "%g",operand), op.precedence, op.isCommutative, remainingOps)
            case .ConstantOperand(let symbol, _):
                return (symbol, op.precedence, op.isCommutative, remainingOps)
            case .VariableOperand(let symbol):
                return (symbol, op.precedence, op.isCommutative, remainingOps)
            case .UnaryOperation(let symbol, _):
                let opsStr = opsToString(remainingOps)
                let opStrValue = opsStr.stringValue ?? "?"
                return ("\(symbol)(\(opStrValue))", op.precedence, op.isCommutative, opsStr.remainingOps)
            case .BinaryOperation(let symbol, let precedence, let isCommutative, _):
                let opsStr1 = opsToString(remainingOps)
                var opsStrValue1 = opsStr1.stringValue ?? "?"
                if (opsStr1.opPrecedence == precedence && !(op.isCommutative && opsStr1.isOpCommutative)) ||
                    opsStr1.opPrecedence < precedence {
                    opsStrValue1 = "(\(opsStrValue1))"
                }
                
                let opsStr2 = opsToString(opsStr1.remainingOps)
                var opsStrValue2 = opsStr2.stringValue ?? "?"
                if opsStr2.opPrecedence < precedence {
                    opsStrValue2 = "(\(opsStrValue2))"
                }
                
                return ("\(opsStrValue2)\(symbol)\(opsStrValue1)", op.precedence, op.isCommutative, opsStr2.remainingOps)
            }
        }
        
        return (nil, Int.max, true, ops)
        
    }
    
}
