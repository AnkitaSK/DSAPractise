//
//  TwoPointers.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 22.03.24.
//

import Foundation


class TwoPointers {
    func sortedSquares(_ nums: [Int]) -> [Int] {
        var results = Array(repeating: -1, count: nums.count)
        
        var i = 0
        var j = nums.count - 1
        var index = j
        
        while i <= j { // index >= 0
            if abs(nums[i]) < abs(nums[j]) {
                results[index] = nums[j] * nums[j]
                j -= 1
            } else {
                results[index] = nums[i] * nums[i]
                i += 1
            }
            index -= 1
        }
        
        return results
    }
    
    func moveZeroes(_ nums: inout [Int]) {
        
        var i = 0
        var j = 0
        
        while i < nums.count {
            
            if nums[i] == 0 {
                i += 1
            } else if nums[i] != 0, nums[j] == 0 {
                nums.swapAt(i, j)
                j += 1
                i += 1
            }
        }
        
    }
    
    func isSubsequence(_ s: String, _ t: String) -> Bool {
        var i = 0
        var j = 0
        var count = 0
        
        while i < s.count, j < t.count {
            if s[i] == t[j] {
                i += 1
                j += 1
                
                count += 1
            } else {
                j += 1
            }
        }
        
        if count == s.count {
            return true
        }
        return false
    }
}
