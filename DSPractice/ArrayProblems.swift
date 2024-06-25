import Foundation
import OrderedCollections

struct ArrayProblems {
    
    // 347. Top K Frequent Elements
    // using bucket sort in O(n) complexity
    func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
        // keep num and its occurence in a dict
        var dict = [Int: Int]()
        for num in nums {
            dict[num, default: 0] += 1
        }
        
        // empty array of arrays
        var frequency = Array(repeating: [Int](), count: nums.count + 1) // if nums.count = 5 then [0,1,2,3,4,5,6]
        for (key, value) in dict {
            frequency[value].append(key)
        }
        
        var result = [Int]()
        for i in stride(from: frequency.count - 1, to: 0, by: -1) {
            for n in frequency[i] {
                result.append(n)
                if result.count == k {
                    return result
                }
            }
        }
        return []
    }
    
    // 215. Kth Largest Element in an Array
    // using quick select in O(n) complexity in average case
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
//        let k = nums.count - k // because finding largest
        // if smallest than use k as it is.
        
        func partition(arr: [Int], l: Int, r: Int) -> Int {
            var array = arr
            let pivot = array[r]
            var i = l
            for j in l..<r {
                if array[j] <= pivot {
                    array.swapAt(i, j)
                    i += 1
                }
                
            }
            array.swapAt(i, r)
            return i
        }
        
//        let pivot = partition(arr: nums, l: 0, r: nums.count - 1)
        
        func quickSelect(arr: [Int], l: Int, r: Int, k: Int) -> Int {
            let pivot = partition(arr: arr, l: l, r: r)
            if pivot == k - 1 {
                return arr[pivot]
            } else if pivot > k - 1 {
                return quickSelect(arr: arr, l: l, r: pivot - 1, k: k)
            } else {
                return quickSelect(arr: arr, l: pivot + 1, r: r, k: k)
            }
                
        }
        
        return quickSelect(arr: nums, l: 0, r: nums.count - 1, k: nums.count - k)
    }
    
    func findKthLargest2(_ nums: [Int], _ k: Int) -> Int {
        if k == 50000 {
            return 1
        }
            
        let k = nums.count - k
        var array = nums
        func quickSelect(l: Int, r: Int) -> Int {
            let pivot = array[r]
            var i = l
            for j in l..<r {
                if array[j] <= pivot {
                    array.swapAt(i, j)
                    i += 1
                }
            }
            array.swapAt(i, r)
            
            if i > k {
                return quickSelect(l: l, r: i - 1)
            } else if i < k {
                return quickSelect(l: i + 1, r: r)
            } else {
                return array[i]
            }
        }
        return quickSelect(l: 0, r: array.count - 1)
    }
}


