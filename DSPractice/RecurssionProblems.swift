//
//  RecurssionProblems.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 02/07/24.
//

import Foundation

struct RecurssionProblems {
    
    // using IBH method
    // simple problems
    // print 1 to n
    func printValues(_ n: Int) {
        
        // BC
        if n == 1 {
            print(n)
            return
        }
        
        // hypothesis
        printValues(n - 1)
        
        // induction
        print(n)
        
    }
    
    // print n to 1
    func printValuesReverse(_ n: Int) {
        
        // BC
        if n == 1 {
            print(n)
            return
        }
        
        // induction
        print(n)
        
        // hypothesis
        printValuesReverse(n - 1)
    }
    
    // using IBH method
    // height of BT
    func heightOfTree(node: TreeNode?) -> Int {
        if node == nil {
            return 0
        }
        
        // hypo
        let leftHeight = heightOfTree(node: node?.left)
        let rightHeight = heightOfTree(node: node?.right)
        
        // induction
        return max(leftHeight, rightHeight) + 1
    }
    
    // sort array
    // using IBH method
    func sortArray(arr: inout [Int]) {
        // bc valid i/p
        if arr.count == 1 {
            return
        }
        
        // hypothesis
        let temp = arr.removeLast()
        sortArray(arr: &arr)
        
        // induction - logic to merge
        mergeInArray(arr: &arr, value: temp)
        
    }
    
    private func mergeInArray(arr: inout [Int], value: Int) {
        if arr.isEmpty || arr.last! <= value {
            arr.append(value)
            return
        }
        
        let temp = arr.removeLast()
        mergeInArray(arr: &arr, value: value)
        arr.append(temp)
    }
    
    // delete middle element in an array
    // IBH method
    func deleteMiddle(arr: inout [Int]) {
        if arr.isEmpty {
            return
        }
        let k = (arr.count / 2) + 1 // middle element index
        deleteMiddleElement(arr: &arr, k: k)
    }
    
    private func deleteMiddleElement(arr: inout [Int], k: Int) {
        if k == 1 {
            arr.removeLast()
            return
        }
        
        let temp = arr.removeFirst()
        deleteMiddleElement(arr: &arr, k: k - 1)
        arr.insert(temp, at: 0)
    }
    
    // reverse stack
    // IBH method
    func reverse(_ stack: inout [Int]) {
        if stack.isEmpty {
            return
        }
        
        solve(&stack)
        
        func solve(_ stack: inout [Int]) {
            if stack.count == 1 {
                return
            }
            
            // hypo
            let temp = stack.last // top()
            stack.removeLast() // pop()
            solve(&stack)
            
            // induction
            insert(&stack, temp!)
        }
        
        func insert(_ stack: inout [Int], _ element: Int) {
            if stack.isEmpty {
                stack.append(element) // push(element)
                return
            }
            
            let temp = stack.last // top()
            stack.removeLast() // pop()
            insert(&stack, element)
            stack.append(temp!) // push(temp)
        }
    }
    
    // using i/p - o/p method
    // print subsets
    // you reduce the input
    func printSubsets(_ text: String) {
        solve(text, "")
        func solve(_ input: String, _ output: String) {
            if input.isEmpty {
                print(output)
                return
            }
            
            let output1 = output
            var output2 = output
            
            var newInput = input // if using reference type then apply backtracking
//            output2.append(newInput.removeLast()) // append last and remove and removeLast() does it in one go
            output2.append(newInput.last!)
            newInput.removeLast()
            
            solve(newInput, output1)
            solve(newInput, output2)
        }
    }
    
    // print permutations with spaces
    // choice and decision therefore ip-op method
    func printPermutations(_ text: String) {
        if text.isEmpty {
            return
        }
        
        var output = ""
        output.append(text[0])
        var input = text
        input.removeFirst()
        
        solve(input, output)
        
        func solve(_ input: String, _ output: String) {
            if input.isEmpty {
                print(output)
                return
            }
            
            var output1 = output
            var output2 = output
            
            output1.append("_\(input[0])")
            output2.append("\(input[0])")
            
            var newInput = input
            newInput.removeFirst()
            
            solve(newInput, output1)
            solve(newInput, output2)
        }
    }
    
    // permutations with case change
    // choice + decision = ip-op method
    func printPermutationsWithCaseChange(_ text: String) {
        
        solve(text, "")
        
        func solve(_ input: String, _ output: String) {
            if input.isEmpty {
                print(output)
                return
            }
            
            var output1 = output
            var output2 = output
            
            output1.append(input[0].lowercased())
            output2.append(input[0])
            
            var newInput = input
            newInput.removeFirst()
            
            solve(newInput, output1)
            solve(newInput, output2)
        }
    }
    
    // letter case permutation with numbers in between
    func printPermutationsForCases(_ text: String) {
        
        solve(text, "")
        
        func solve(_ input: String, _ output: String) {
            if input.isEmpty {
                print(output)
                return
            }
            
            var output1 = output
            var output2 = output
            
            let temp = Character(input[0])
            if temp.isLetter {
                output1.append(temp.lowercased())
                output2.append(temp.uppercased())
                
                var newInput = input
                newInput.removeFirst()
                
                solve(newInput, output1)
                solve(newInput, output2)
            } else {
                // no choice
                output1.append(temp)
                var newInput = input
                newInput.removeFirst()
                
                solve(newInput, output1)
            }
        }
    }
    
    // Generate all Balanced Parentheses
    // revise 
    func generateBalancedParanthesis(n: Int) -> [String] {
        
        var results = [String]()
        solve(n, n, "")
        func solve(_ openCount: Int, _ closeCount: Int, _ output: String) {
            if openCount == 0 && closeCount == 0 {
                results.append(output)
                return
            }
            
            if openCount != 0 {
                var output1 = output
                // and open parenthesis is always added
                output1.append("(")
                solve(openCount - 1, closeCount, output1)
            }
            
            
            // check condition to add close parenthesis
            if closeCount > openCount {
                var output2 = output
                output2.append(")")
                solve(openCount, closeCount - 1, output2)
            }
            
        }
        
        return results
    }
    
//    Print N-bit binary numbers having more 1’s than 0’s for any prefix
    func prefixOne(n: Int) {
        
        solve("", 0, 0, n)
        // “ “  1= 0, 0 = 0, n = 3
        func solve(_ output: String, _ ones: Int, _ zeros: Int, _ n: Int) {
            if n == 0 {
                print(output)
                return
            }
            
            var output1 = output
            output1.append("1")
            solve(output1, ones + 1, zeros, n - 1)
            
            if ones > zeros {
                var output2 = output
                output2.append("0")
                solve(output2, ones, zeros + 1, n - 1)
            }
        }
    }
    
}


