//
//  StackProblems.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 09.03.24.
//

import Foundation

class Stack<T> {
    fileprivate var data: [T] = []
    func push(_ value: T) {
        data.append(value)
    }
    
    func pop() -> T {
        data.removeLast()
    }
    
    func topElement() -> T? {
        data.last
    }
    
    var isEmpty: Bool {
        data.isEmpty
    }
}

class StackProblems {
    // nearest greater to right
    func nextGreaterElement(_ nums: [Int]) -> [Int] {
        var results = [Int]()
        let stack = Stack<Int>()
        
//        for i in (0..<nums.count).reversed() { or below
        for i in stride(from: nums.count - 1, through: 0, by: -1) {
            if stack.isEmpty {
                results.append(-1)
            } else if !stack.isEmpty, nums[i] < stack.topElement()! {
                results.append(stack.topElement()!)
            } else if !stack.isEmpty, nums[i] > stack.topElement()! {
                // pop until nums[i] < top
                while !stack.isEmpty, nums[i] > stack.topElement()! {
                    stack.pop()
                }
                
                if stack.isEmpty {
                    results.append(-1)
                } else {
                    results.append(stack.topElement()!)
                }
            }
            stack.push(nums[i])
        }
        
        return results.reversed()
    }
    
    // variations -> nearest greater to left, nearest smaller to left, nearest smaller to right
    
    func span(_ nums: [Int]) -> [Int] {
        var finalResults = nextGreaterElementToLeftIndices(nums)
        for (index, _) in finalResults.enumerated() {
            finalResults[index] = index - finalResults[index]
        }
                
        
        func nextGreaterElementToLeftIndices(_ nums: [Int]) -> [Int] {
            var results = [Int]()
            let stack = Stack<(index: Int, value: Int)>() //  better to use tuple (index, value)
            
            for i in stride(from: 0, through: nums.count - 1, by: 1) {
                if stack.isEmpty {
                    results.append(-1)
                } else if !stack.isEmpty, nums[i] < stack.topElement()!.value {
                    results.append(stack.topElement()!.index)
                } else if !stack.isEmpty, nums[i] >= stack.topElement()!.value {
                    while !stack.isEmpty, nums[i] >= stack.topElement()!.value {
                        stack.pop()
                    }
                    
                    if stack.isEmpty {
                        results.append(-1)
                    } else {
                        results.append(stack.topElement()!.index)
                    }
                }
                stack.push((i, nums[i]))
            }
            
            return results
        }
        
        return finalResults
        
    }
    
    func largestRectangleArea(_ heights: [Int]) -> Int {
        var result: Int = 0
        
        let nearestSmallestToRightIndicesArray = nearestSmallestToRightIndices(heights)
        let nearestSmallestToLeftIndicesArray = nearestSmallestToLeftIndices(heights)
        
        var widthsArray = Array(repeating: 0, count: heights.count)
        for i in 0..<heights.count {
            widthsArray[i] = nearestSmallestToRightIndicesArray[i] - nearestSmallestToLeftIndicesArray[i] - 1
        }
        
        var results = Array(repeating: 0, count: heights.count)
        for i in 0..<heights.count {
            results[i] = widthsArray[i] * heights[i]
        }
        
        result = results.max() ?? 0
        
        func nearestSmallestToRightIndices(_ heights: [Int]) -> [Int] {
            var result = [Int]()
            let stack = Stack<(index: Int, value: Int)>()
            for i in stride(from: heights.count - 1, through: 0, by: -1) {
                if stack.isEmpty {
                    result.append(heights.count)
                } else if !stack.isEmpty, heights[i] > stack.topElement()!.value {
                    result.append(stack.topElement()!.index)
                } else if !stack.isEmpty, heights[i] <= stack.topElement()!.value {
                    while !stack.isEmpty, heights[i] <= stack.topElement()!.value {
                        stack.pop()
                    }
                    
                    if stack.isEmpty {
                        result.append(heights.count)
                    } else {
                        result.append(stack.topElement()!.index)
                    }
                }
                
                stack.push((i, heights[i]))
            }
            return result.reversed()
        }
        
        func nearestSmallestToLeftIndices(_ heights: [Int]) -> [Int] {
            var result = [Int]()
            let stack = Stack<(index: Int, value: Int)>()
            for i in stride(from: 0, through: heights.count - 1, by: 1) {
                if stack.isEmpty {
                    result.append(-1)
                } else if !stack.isEmpty, heights[i] > stack.topElement()!.value {
                    result.append(stack.topElement()!.index)
                } else if !stack.isEmpty, heights[i] <= stack.topElement()!.value {
                    while !stack.isEmpty, heights[i] <= stack.topElement()!.value {
                        stack.pop()
                    }
                    
                    if stack.isEmpty {
                        result.append(-1)
                    } else {
                        result.append(stack.topElement()!.index)
                    }
                }
                
                stack.push((i, heights[i]))
            }
            return result
        }
        
        return result
    }
    
    func nearestSmallestToRightIndices(_ heights: [Int]) -> [Int] {
        var result = [Int]()
        let stack = Stack<Int>()
        for i in stride(from: heights.count - 1, through: 0, by: -1) {
            if stack.isEmpty {
                result.append(-1)
            } else if !stack.isEmpty, heights[i] > stack.topElement()! {
                result.append(stack.topElement()!)
            } else if !stack.isEmpty, heights[i] <= stack.topElement()! {
                while !stack.isEmpty, heights[i] <= stack.topElement()! {
                    stack.pop()
                }
                
                if stack.isEmpty {
                    result.append(-1)
                } else {
                    result.append(stack.topElement()!)
                }
            }
            
            stack.push(heights[i])
        }
        return result.reversed()
    }
    
    
    // basic calculator
    // 227. Basic Calculator II
    // using editorial solution
    // if + or - then calculate later therefore store currentNumber in stack
    // revise
    func calculate(_ s: String) -> Int {
        // "33+2*2" = 33 + 4 = 37
        let sArray = Array(s)
        var result = 0
        var currentNumber = 0
        var operation = "+"
        var stack = [Int]()
        
        var i = 0
        
        for s in sArray {
            // if s is digit
            if s.isWholeNumber {
                currentNumber = ((currentNumber * 10) + s.wholeNumberValue!)
            } 
            if !s.isWholeNumber && !s.isWhitespace || i == sArray.count - 1 { // only for the end, even for the whole number the pointer has to enter this condition
                if operation == "-" {
                    stack.append(currentNumber * -1)
                } else if operation == "+" {
                    stack.append(currentNumber) // * +1
                } else if operation == "*" {
                    // pop from stack * current
                    let calculatedValue = stack.removeLast() * currentNumber
                    stack.append(calculatedValue)
                } else if operation == "/" {
                    let calculatedValue = stack.removeLast() / currentNumber
                    stack.append(calculatedValue)
                }
                
                operation = !s.isWholeNumber ? String(s) : "+"
                currentNumber = 0
            }
            i += 1
        }
        
//        while !stack.isEmpty {
//            result += stack.removeLast()
//        }
        
        result = stack.reduce(0, +)
        
        return result
    }
    
    // 224. Basic Calculator
    // with brackets -- no multiplication and division
    // when you encounter ( store result into stack
    // "(1+(4+5+2)-3)+(6+8)"
    // revise
    func calculate2(_ s: String) -> Int {
        var stack = [Int]()
        var result = 0
        var number = 0 // keep track of current number
        var operation = 1 // default +
        
        let sArray = Array(s)
        
        for s in sArray {
            if s.isWholeNumber {
                number = (number * 10) + s.wholeNumberValue!
            }
            
            if !s.isWholeNumber && !s.isWhitespace {
                if s == "-" {
                    result += operation * number
                    operation = -1
                } else if s == "+" {
                    result += operation * number
                    operation = 1
                } else if s == "(" {
                    
                    stack.append(result)
                    stack.append(operation)
                    
                    result = 0
                    operation = 1
                } else if s == ")" {
                    result += operation * number
                    
                    result *= stack.removeLast()
                    result += stack.removeLast()
                }
                
                number = 0
            }
        }
        
        result += (number * operation) // add last number in the result
        return result
    }
    
    
    // 1249. Minimum Remove to Make Valid Parentheses
    // revise
    func minRemoveToMakeValid(_ s: String) -> String {
        var stack = [Int]() // storing the index into stack
        var sArray = Array(s)
        var i = 0
        
        for s in sArray {
            if s == "(" {
                stack.append(i)
            } else if s == ")" {
                if !stack.isEmpty {
                    stack.removeLast()
                } else {
                    sArray[i] = "$"
                }
            }
            i += 1
        }
        
        // when stack has only ( brackets eg: ))((
        while !stack.isEmpty {
            let j = stack.removeLast()
            sArray[j] = "$"
        }
        
        return String(sArray).replacingOccurrences(of: "$", with: "")
    }
    
    // 71. Simplify Path
    // ignore for .
    // pop for ..
    // put each text like abc, bc, into a stack
    // in the end join the stack seperated by /
    // "/home/"
    // revise
    func simplifyPath(_ path: String) -> String {
        var stack = [String]()
        // make a func call to split the path into this way
        var pathArray = splitPath(path: path)
//        pathArray.append("/")// need as part of logic
        var current = ""
        
        for p in pathArray {
            if p == "/" {
                if current == ".." {
                    if !stack.isEmpty {
                        stack.removeLast()
                    }
                } else if current != "" && current != "." {
                    stack.append(current)
                }
                current = ""
            } else { // if p != "/" like . or .. or // or text
                current += String(p)
            }
        }
        
        // when end of pathArray is not /
        
        let result = "/" + stack.joined(by: Character("/")) // in stack you need to pop everything in the array and join array
        return String(result)
    }
    
    private func splitPath(path: String) -> [String] {
        
        var components = [String]()
        var current = ""
        
        for p in path {
            if p == "/" {
                if !current.isEmpty {
                    components.append(current)
                    current = ""
                }
                components.append("/")
                
            } else {
                current += String(p)
            }
        }
        
        // when there is no / in the end
        if !current.isEmpty {
            components.append(current)
        }
        
        return components
        
    }
    
    // 1614. Maximum Nesting Depth of the Parentheses
    func maxDepth(_ s: String) -> Int {
        let sArray = Array(s)
        var stack = [Int]()
        var result = Int.min
        
        var count = 0
        for i in 0..<sArray.count {
            
            if sArray[i] == "(" {
                // push to stack
                stack.append(i)
                count += 1
            } else if sArray[i] == ")" {
                // pop from stack
                stack.removeLast()
                count -= 1
            }
            result = max(result, count)
        }
        return result
    }
    
    func isValid(_ s: String) -> Bool {
        
        var stack = [Int]()
        var canPop = true
        
        let dict = ["(" : 1,
                    ")" : 1,
                    "[" : 2,
                    "]" : 2,
                    "{" : 3,
                    "}" : 3
        ]
        
        for c in s {
            if c == "(" || c == "[" || c == "{" {
                stack.append(dict[String(c)]!)
            } else if let last = stack.last, last == dict[String(c)] {
                stack.removeLast()
            } else {
                canPop = false
            }
        }
        
        return stack.isEmpty && canPop
    }
}

