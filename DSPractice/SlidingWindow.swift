//
//  SlidingWindow.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 20.03.24.
//

import Foundation

class SlidingWindow {
    
    func findOccurenceOfAnagrams(_ s: String, _ p: String) -> Int {
        var result = 0
        var i = 0; var j = 0
        var dict = [String: Int]()
        let k = p.count
        for s in p {
            dict[String(s), default: 0] += 1
        }
        var count = dict.count
        
        while j < s.count {
            // calculations
            if dict[s[j]] != nil {
                dict[s[j]]! -= 1
                if dict[s[j]]! == 0 {
                    count -= 1
                }
            }
            
            if j - i + 1 < k {
                j += 1
            } else if j - i + 1 == k {
                // result
                if count == 0 {
                    result += 1
                }
                
                // move forward
                if dict[s[i]] != nil {
                    dict[s[i]]! += 1
                    if dict[s[i]]! == 1 {
                        count += 1
                    }
                }
                i += 1
                j += 1
            }
        }
        
        return result
    }
    
    // maximum of all subarrays of size k
    func maxOfAllSubarrays(array: [Int], k: Int) -> [Int] {
        var results = [Int]()
        var i = 0; var j = 0
        var tempResults = [Int]()
        while j < array.count {
            // calculations
            tempResults.removeAll { $0 < array[j] }
            tempResults.append(array[j])
            
            if j - i + 1 < k {
                j += 1
            } else if j - i + 1 == k {
                // result
                if tempResults.count > 0 {
                    results.append(tempResults.first!)
                    
                    // remove calculations of i, before shifting
                    if array[i] == tempResults.first! {
                        tempResults.removeFirst()
                    }
                }
                
                // shift the window
                i += 1
                j += 1
            }
        }
        return results
    }
    
    // variable size window
    //largest subarray of sum k
    func largestSubArray(array: [Int], k: Int) -> Int {
        var result = 0
        var j = 0; var i = 0
        var sum = 0
        while j < array.count {
            // calculation
            sum += array[j]
            
            if sum < k {
                j += 1
            } else if sum == k {
                result = max(result, j - i + 1)
                j += 1
            } else if sum > k {
                while sum > k {
                    sum -= array[i]
                    i += 1
                }
                j += 1
            }
        }
        return result
    }
    
    // longest substring with k unique characters // aabacbebec, k = 3
    func longestSubstring(s: String, k: Int) -> Int {
        var result = 0
        var i = 0; var j = 0
        var dict = [String: Int]()
        
        while j < s.count {
            // calculation
            dict[s[j], default: 0] += 1
            
            if dict.count < k {
                j += 1
            } else if dict.count == k {
                // possible answer
                result = max(result, j - i + 1)
                j += 1
            } else if dict.count > k {
                while dict.count > k {
                    if dict[s[i]] != nil {
                        dict[s[i]]! -= 1
                        if dict[s[i]]! == 0 {
                            dict.removeValue(forKey: s[i])
                        }
                    }
                    i += 1
                }
                j += 1
            }
        }
        
        return result
    }
    
    // max sum of array of size k
    // fixed size k
    func maxSum(array: [Int], k: Int) -> Int {
        var result = Int.min
        // i and j - j moving ahead
        var i = 0
        var j = 0
        var sum = 0
        while j < array.count {
            sum += array[j]
            if j - i + 1 < k {
                j += 1
            } else if j - i + 1 == k {
                // possible answer
                result = max(result, sum)
                // shift the widow
                sum -= array[i]
                i += 1
                j += 1
            }
        }
        return result
    }
    
    // First Negative Number in every Window of Size K
    // fixed size sliding window
    // 12 -1 -7 8 -15 30 16 28 k = 3
    func negativeNumbers(array: [Int], k: Int) -> [Int] {
        var result = [Int]()
        var i = 0
        var j = 0
        var queue = [Int]()
        while j < array.count {
            // calculate the possible ans as you move the j
            if array[j] < 0 {
                queue.append(array[j]) // enqueue
                // -1 -7
            }
            if j - i + 1 < k {
                j += 1
            } else if j - i + 1 == k {
                // possible answer
                if queue.isEmpty {
                    result.append(0)
                } else {
                    result.append(queue.first!)
                }
                // remove the calculation for i and move the window
                if !queue.isEmpty, array[i] == queue.first! {
                    queue.removeFirst() // dequeue
                }
                i += 1
                j += 1
            }
        }
        return result
    }

    // [1,1,1,0,0,0,1,1,1,1,0]
    // i = 0 j = 5 k = -1
    // i = 4 j = 6 k = 1
    func longestOnes(_ nums: [Int], _ k: Int) -> Int {
        var i = 0
        var j = 0
        var result = 0 // Int.min
        var count = k
        while j < nums.count {
            // calculation
            if nums[j] == 0 {
                count -= 1
            }
            
            if count > 0 {
                result = max(result, j - i + 1) // checking here because of the rule - atmost
                j += 1
            } else if count == 0 {
                result = max(result, j - i + 1)
                j += 1
            } else if count < 0 {
                while count < 0 {
                    // removing calculation
                    if nums[i] == 0 {
                        count += 1
                    }
                    // shifting i
                    i += 1
                }
                j += 1
            }
        }
        return result
        
    }
}


