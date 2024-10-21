//
//  BinarySearch.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 24.03.24.
//

import Foundation

class BinarySearch {
    func peakIndexInMountainArray(_ arr: [Int]) -> Int {
        var start = 0
        var end = arr.count - 1
        
        while start < end {
            let mid = (start + end) / 2
            
            if arr[mid] > arr[mid - 1] && arr[mid] > arr[mid + 1] {
                return mid
            } else if arr[mid] > arr[mid - 1] {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return -1
    }
    
    func findMin(_ nums: [Int]) -> Int {
        // [3,4,5,0,2]
        /* This question can be asked in different ways
         - find the index of min element
         - how many times its been rotated (# times its been rotated = index of min element)
         index of min element gives you number of times the array has been rotated.
         - find the min element
         */
        guard nums.count > 1 else { return nums[0] }
        
        var start = 0
        var end = nums.count - 1
        let n = nums.count
        
        while start <= end {
            let mid = (start + end) / 2
            let next = (mid + 1) % n
            let prev = (mid + n - 1) % n
            
            if nums[mid] <= nums[next] && nums[mid] <= nums[prev] {
                return nums[mid]
            } else if nums[mid] <= nums[end] {
                end = mid - 1
            } else if nums[start] <= nums[mid] {
                start = mid + 1
            }
        }
        
        return -1
    }
    
    func search(_ nums: [Int], _ target: Int) -> Int {
        /* this is search given element in the rotated sorted array
         - find the index of min element
         - this index becomes the point where you get 2 subarray sorted in both the direction
         - use this sorted array to find the target
        */
        
        var start = 0
        var end = nums.count - 1
        let n = nums.count
        var minIndex = -1
        
        while start <= end {
            let mid = (start + end) / 2
            // for rotated array
            let next = (mid + 1) % n
            let prev = (mid + n - 1) % n
            
            
            if nums[mid] <= nums[prev] && nums[mid] <= nums[next] {
                minIndex = mid
                break
            } else if nums[mid] <= nums[end] {
                end = mid - 1
            } else if nums[start] <= nums[mid] {
                start = mid + 1
            }
            
            /*
             if nums[mid] <= nums[next] && nums[mid] <= nums[prev] {
                 minIndex = mid
                 break
             } else if nums[mid] <= nums[end] {
                 end = mid - 1
             } else if nums[start] <= nums[mid] {
                 start = mid + 1
             }
             */
        }
        
        start = 0
        end = nums.count - 1
        
        let leftSearch = binarySearch(arr: nums, start: 0, end: minIndex, element: target)
        let rightSearch = binarySearch(arr: nums, start: minIndex, end: end, element: target)
        
        if leftSearch != -1 {
            return leftSearch
        } else if rightSearch != -1 {
            return rightSearch
        } else {
            return -1
        }
    }
    
    // to return index
    func binarySearch(arr: [Int], start: Int, end: Int, element: Int) -> Int {
        
        var start = start
        var end = end
        
        while start <= end {
            let mid = (start + end) / 2
            
            if arr[mid] == element {
                return mid
            } else if element > arr[mid] {
                start = mid + 1
            } else {
                end = mid - 1
            }
        }
        
        return -1
    }
    
    func findPeakElement(_ nums: [Int]) -> Int {
        
        guard nums.count > 1 else {
            return 0
        }
        
        var start = 0
        var end = nums.count - 1

        while start <= end {
            let mid = start + (end - start) / 2

            if mid > 0 && mid < nums.count - 1 {
                if nums[mid] > nums[mid - 1] && nums[mid] > nums[mid + 1] {
                    return mid
                 } else if nums[mid + 1] > nums[mid] {
                    // go to right - in the direction of highest
                    start = mid + 1
                 } else if nums[mid - 1] > nums[mid] {
                    // go to left - in the direction of highest
                    end = mid - 1
                 }
            } else {
                // edge cases
                if mid == 0 {
                    if nums[0] > nums[1] {
                        return 0
                    } else {
                        return 1
                     }
                }

                if mid == nums.count - 1 {
                    if nums[nums.count - 1] > nums[nums.count - 2] {
                        return nums.count - 1
                    } else {
                        return nums.count - 2
                    }
                }

            }
            
        }
        return -1
    }
    
    func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
            let m = matrix[0].count
            let n = matrix.count
            var i = 0
            var j = m - 1

            while i >= 0 && i < n, j >= 0 && j < m {
                if matrix[i][j] == target {
                    return true
                } else if matrix[i][j] > target {
                    j -= 1
                } else if matrix[i][j] < target {
                    i -= 1
                }
            }

            return false
        }
    
    // 875. Koko Eating Bananas
    func minEatingSpeed(_ piles: [Int], _ h: Int) -> Int {
        if h < piles.count {
            return -1
        }
        var start = piles.min()!
        var end = piles.max()!
        var result = Int.max
        
        while start <= end {
            let mid = (start + end) / 2
            if minEatingSpeedIsValid(piles, h, mid) {
                result = mid
                end = mid - 1
            } else {
                start = mid + 1
            }
        }
        
        return result
    }
    
    private func minEatingSpeedIsValid(_ piles: [Int], _ h: Int, _ max: Int) -> Bool {

        var hours = 0
        for pile in piles {
            hours += Int(ceil(Double(pile) / Double(max)))
        }
        
        if hours <= h {
            // can get a possible solution  eg: 6 < 8 (h) -> search for a smaller value, go to left
            return true
        } else {
            return false
        }
    }
    
    // 410. Split Array Largest Sum
    func splitArray(_ nums: [Int], _ k: Int) -> Int {
        if k > nums.count {
            return -1
        }
        var result = 0
        var start = nums.max()!
        var end = nums.reduce(0, +)
        
        while start <= end { // n
            let mid = (start + end) / 2
            if isValidSplitArray(nums, k, mid) {
                result = mid
                end = mid - 1
            } else { // log n
                start = mid + 1
            }
        }
        
        return result
    }
    
    private func isValidSplitArray(_ nums: [Int], _ k: Int, _ max: Int) -> Bool {
        var numberOfSplit = 1
        var sum = 0
        
        for num in nums { // n
            sum += num
            if sum > max {
                numberOfSplit += 1
                sum = num
            }
            
            if numberOfSplit > k {
                return false
            }
        }
        return true
    }
    
    // 1011. Capacity To Ship Packages Within D Days
    func shipWithinDays(_ weights: [Int], _ days: Int) -> Int {
        if days > weights.count {
            return -1
        }
        
        var start = weights.max()!
        var end = weights.reduce(0, +)
        var result = 0
        
        while start <= end {
            let mid = (start + end) / 2
            if shipWithinDaysIsValid(weights, days, mid) {
                // move to smaller check
                result = mid
                end = mid - 1
            } else {
                start = mid + 1
            }
        }
        
        return result
    }
    
    private func shipWithinDaysIsValid(_ weights: [Int], _ days: Int, _ max: Int) -> Bool {
        var newDays = 1
        var sum = 0
        for weight in weights {
            sum += weight
            if sum > max {
                newDays += 1
                sum = weight
            }
            
            if newDays > days { // if number of days greater than given days
                return false
            }
        }
        return true
    }
    
    // 1283. Find the Smallest Divisor Given a Threshold
    func smallestDivisor(_ nums: [Int], _ threshold: Int) -> Int {
        
        var result = 0
        
        var start = 1
        var end = nums.max()!
        
        while start <= end {
            let mid = (start + end) / 2
            if smallestDivisorIsValid(nums, threshold, mid) {
                result = mid
                end = mid - 1
            } else {
                start = mid + 1
            }
        }
        
        return result
    }
    
    private func smallestDivisorIsValid(_ nums: [Int], _ threshold: Int, _ divisor: Int) -> Bool {
        
        var sum = 0
        for num in nums {
            sum += Int(ceil(Double(num) / Double(divisor)))
        }
        
        if sum <= threshold {
            return true
        }
        
        return false
    }
    
    // 1482. Minimum Number of Days to Make m Bouquets
    func minDays(_ bloomDay: [Int], _ m: Int, _ k: Int) -> Int {
        if bloomDay.count < (m * k) {
            return -1
        }
        var result = 0
        var start = bloomDay.min()!
        var end = bloomDay.max()!
        while start <= end {
            let mid = (start + end) / 2
            if minDayIsValid(bloomDay, m, k, mid) {
                // move to left to find better ans
                result = mid
                end = mid - 1
            } else {
                // move right
                start = mid + 1
            }
        }
        return result
        
    }
    
    private func minDayIsValid(_ bloomDay: [Int], _ m: Int, _ k: Int, _ max: Int) -> Bool {
        var flowers = 0
        var bouquets = 0
        for day in bloomDay {
            if day <= max {
                flowers += 1
            } else {
                flowers = 0
            }
            
            if flowers == k {
                bouquets += 1
                flowers = 0
            }
            
            if bouquets >= m {
                return true
            }
        }
        
        return false
    }
    
    // first occurance
    func firstOccurance(_ array: [Int], k: Int) -> Int {
        var start = 0
        var end = array.count - 1
        var result = -1
        
        while start <= end {
            let mid = start + (end - start) / 2
            if array[mid] == k {
                result = mid
                end = mid - 1
            } else if array[mid] < k {
                start = mid + 1
            } else {
                end = mid - 1
            }
        }
        
        return result
    }
    
    // last occurance
    func lastOccurance(_ array: [Int], k: Int) -> Int {
        var start = 0
        var end = array.count - 1
        var result = -1
        
        while start <= end {
            let mid = start + (end - start) / 2
            if array[mid] == k {
                result = mid
                start = mid + 1
            } else if array[mid] < k {
                start = mid + 1
            } else {
                end = mid - 1
            }
        }
        
        return result
    }
    
    // count element in sorted array
    func countElement(_ array: [Int], k: Int) -> Int {
        let firstOccurance = firstOccurance(array, k: k)
        let lastOccurence = lastOccurance(array, k: k)
        
        return lastOccurence - firstOccurance
    }
    
    // number of times sorted array is rotated
    func numberOfTimesRotated(_ array: [Int]) -> Int {
        // index of the smallest element
        // always discard sorted side
        var start = 0
        var end = array.count - 1
        let n = array.count
        
        while start <= end {
            let mid = start + (end - start) / 2
            let next = (mid + 1) % n
            let prev = (mid + n - 1) % n
            if array[mid] <= array[next] && array[mid] <= array[prev] {
                return mid
            } else if array[mid] <= array[end] {
                end = mid - 1
            } else {
                start = mid + 1
            }
        }
        
        return -1
    }
    
    // 4. Median of Two Sorted Arrays
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        if nums1.count > nums2.count {
            return findMedianSortedArrays(nums2, nums1)
        }
        
        let smaller = nums1
        let larger = nums2
        
        var start = 0
        var end = smaller.count // smaller.count - 1
         
        while start <= end {
            var partitionSmaller = (start + end) / 2
            var partitionLarger = (smaller.count + larger.count + 1) / 2 - partitionSmaller
            
            let maxLeftForSmaller = partitionSmaller == 0 ? Int.min : smaller[partitionSmaller - 1]
            let minRightForSmaller = partitionSmaller == smaller.count ? Int.max : smaller[partitionSmaller]
            
            let maxLeftForLarger = partitionLarger == 0 ? Int.min : larger[partitionLarger - 1]
            let minRightForLarger = partitionLarger == larger.count ? Int.max : larger[partitionLarger]
            
            if maxLeftForSmaller <= minRightForLarger && maxLeftForLarger <= minRightForSmaller {
                // find answers
                // check for even or odd count for the combination of arrays
                if (smaller.count + larger.count) % 2 == 0 {
                    // even
                    return Double(max(maxLeftForSmaller, maxLeftForLarger) + min(minRightForSmaller, minRightForLarger)) / 2
                } else {
                    // odd
                    return Double(max(maxLeftForSmaller, maxLeftForLarger))
                }
            } else if maxLeftForLarger > minRightForSmaller {
                // move towards left
                start = partitionSmaller + 1
            } else {
                end = partitionSmaller - 1
            }
            
        }
        
        return 0
    }
}

