//
//  MathProblems.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 19/06/24.
//

import Foundation

extension Solution {
    // 50. pow(x, n)
    // time complexity = O(log n)
    func myPow(_ x: Double, _ n: Int) -> Double {
        // x= 2, n = 8 = 256
        var x = x
        var n = n
        var result = 1.0
        
        // when n is -ve number
        if n < 0 {
            n = abs(n)
            x = 1/x
        }
        
        while n != 0 {
            if (n & 1) == 1 { // if odd power i.e eg: n = 9
                result *= x
            }
            x *= x  // not straight fowards using bitwise
            n = n >> 1 // right shift ~ making value half
        }
        
        return result
    }
}
