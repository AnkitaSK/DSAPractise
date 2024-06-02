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
    
}
