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
    
}


