//
//  PrefixSumProblems.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 06/07/24.
//

import Foundation

struct PrefixSumProblems {
    // 523. Continuous Subarray Sum
    // take the prefixsum
    // calculate remender and save these remender for index in the dict.
    // logic - if this remender occures again in the dict, find the length of window. If the length >= 2 then return true
    // similarly, if the remender is 0 and i >= 1 that means the length of a window is > 1. Therefore return true
    func checkSubarraySum(_ nums: [Int], _ k: Int) -> Bool {
            // using prefix sum
            var prefixSum = 0
            var dict = [Int: Int]()
            for i in 0..<nums.count {
                prefixSum += nums[i]
                // to check the multiple of k, use modulo k and store remender
                let remender = prefixSum % k
                if remender == 0 && i >= 1 {
                    return true
                }
                if dict[remender] == nil {
                    dict[remender] = i
                } else {
                    if let index = dict[remender] {
                        if i - index >= 2 { // because according to the given rule
                            return true
                        }
                    }
                }
            }
            return false
        }
    
    // 560. Subarray Sum Equals K
    // return total number of subarrays whose sum is equal to k
    // O(n2)
    func subarraySum(_ nums: [Int], _ k: Int) -> Int {
        var count = 0
        // find the sum for each subarray
        for i in 0..<nums.count {
            var sum = 0
            for j in i..<nums.count {
                sum += nums[j]
                if sum == k {
                    count += 1
                }
            }
        }
        return count
    }
}
