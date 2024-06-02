//
//  Bitwise.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 29/05/24.
//

import Foundation

class Bitwise {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var result = 0
        for n in nums {
            result = result ^ n
        }
        return false
    }
    
//    func getSum(_ a: Int, _ b: Int) -> Int {
//        return a & b 
//    }
    
    func getSum(_ a: Int, _ b: Int) -> Int {
            var a = a
            var b = b
            while (b != 0) {
                let carry = (a & b) << 1
                a = a ^ b
                b = carry
            }
            return a
        }
    
}
