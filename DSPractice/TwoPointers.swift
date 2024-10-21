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
    
    // VALID WORD ABBREVIATION | LEETCODE # 408
    func validWordAbbriviation(word: String, abbr: String) -> Bool {
        // word = substitution,  abbr = s10n => true
        // apple, a2e => false , l is not present
        // using 2 pointers
        var wordPtr = 0
        var abbrPtr = 0
        
        let wordArray = Array(word)
        let abbrArray = Array(abbr)
        
        while wordPtr < wordArray.count && abbrPtr < abbrArray.count {
            if abbrArray[abbrPtr].isWholeNumber {
                if abbrArray[abbrPtr] == "0" {
                    return false
                }
                // parse if there is a digit in abbr
                var currentNumber = 0
                while abbrPtr < abbrArray.count && abbrArray[abbrPtr].isWholeNumber {
                    currentNumber = (currentNumber * 10) + abbrArray[abbrPtr].wholeNumberValue!
                    abbrPtr += 1
                }
                wordPtr += currentNumber
            } else {
                if wordArray[wordPtr] != abbrArray[abbrPtr] {
                    return false
                }
                wordPtr += 1
                abbrPtr += 1
            }
            
        }
        
        return wordPtr == wordArray.count && abbrPtr == abbrArray.count
    }
    
    // 5. Longest Palindromic Substring
    func longestPalindrome(_ s: String) -> String {
        
        var result = ""
        var resultLength = 0
        
        for i in 0..<s.count {
            
            // another loop for pointers traversal
            // for odd palindrome
            var left = i
            var right = i
            while left >= 0 && right < s.count && s[left] == s[right] {
                if right - left + 1 > resultLength {
                    let startIndex = s.index(s.startIndex, offsetBy: left)
                    let endIndex = s.index(s.startIndex, offsetBy: right)
                    result = String(s[startIndex...endIndex])
                    resultLength = right - left + 1
                }
                
                left -= 1
                right += 1
            }
            
            // another loop for pointers traversal
            // for even palindrome
            var l = i
            var r = i + 1
            while l >= 0 && r < s.count && s[l] == s[r] {
                if r - l + 1 > resultLength {
                    let startIndex = s.index(s.startIndex, offsetBy: l)
                    let endIndex = s.index(s.startIndex, offsetBy: r)
                    result = String(s[startIndex...endIndex])
                    resultLength = r - l + 1
                }
                
                l -= 1
                r += 1
            }
            
        }
        
        return result
    }
}
