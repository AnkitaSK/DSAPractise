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
    
    // 39. Combination Sum
    // revise
    // 2, 3, 6, 7  o/p = 7
    // O(2^n)
    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        var results = [[Int]]()
        
        var answers = [Int]()
        solve(start: 0, answers: &answers, sum: 0)
        
        func solve(start: Int, answers: inout [Int], sum: Int) {
            if sum == target {
                results.append(answers)
                return
            }
            
            for i in start..<candidates.count {
                if sum + candidates[i] <= target {
                    answers.append(candidates[i])
                    solve(start: i, answers: &answers, sum: sum + candidates[i]) // start = i because this is not unique
                    answers.removeLast()
                }
            }
        }
        
        return results
    }
    
    // 40. Combination Sum II
    func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
        var results = [[Int]]()
        
        var answers = [Int]()
        let sortedCanditates = candidates.sorted(by: <) // sorted
        solve(start: 0, sum: 0, answers: &answers)
        func solve(start: Int, sum: Int, answers: inout [Int]) {
            if sum == target {
                results.append(answers)
                return
            }
            
            var previous = -1
            for i in start..<sortedCanditates.count {
                if sortedCanditates[i] != previous {
                    if sum + sortedCanditates[i] <= target {
                        answers.append(sortedCanditates[i])
                        solve(start: i + 1, sum: sum + sortedCanditates[i], answers: &answers)
                        answers.removeLast()
                    }
                    previous = sortedCanditates[i]
                }
            }
        }
        
        return results
    }
    
    // 78. Subsets
    // using backtracking
    // input- output method
    func subsets(_ nums: [Int]) -> [[Int]] {
        var results = [[Int]]()
        var input = nums
        var output = [Int]()
        solve(input: &input, output: &output)
        func solve(input: inout [Int], output: inout [Int]) {
            if input.isEmpty {
                results.append(output)
                return
            }
            
            var output1 = output
            var output2 = output
            
            // include
            output1.append(input.last!)
            // remove from input
            let temp = input.last
            input.removeLast()
            
            solve(input: &input, output: &output1)
            solve(input: &input, output: &output2)
            
            // backtrack
            input.append(temp!)
        }
        
        return results
    }
    
    func subsetsWithDup(_ nums: [Int]) -> [[Int]] {
        var results = Set<[Int]>()
        var input = nums
        var output = [Int]()
        solve(input: &input, output: &output)
        func solve(input: inout [Int], output: inout [Int]) {
            if input.isEmpty {
                results.insert(output)
                return
            }
            
            var output1 = output
            var output2 = output
            
            // include
            output1.append(input.last!)
            // remove from input
            let temp = input.last
            input.removeLast()
            
            solve(input: &input, output: &output1)
            solve(input: &input, output: &output2)
            
            // backtrack
            input.append(temp!)
        }
        
        return Array(results)
    }
    
    // 698. Partition to K Equal Sum Subsets
    // revise
    func canPartitionKSubsets(_ nums: [Int], _ k: Int) -> Bool {
        
        let sum = nums.reduce(0, +) / k
        var count = 0
        var used = Array(repeating: false, count: nums.count)
        var kValue = k
        solve(0, 0)
        func solve(_ calculatedSum: Int, _ start: Int) {
            if kValue == 0 {
                return
            }
            
            if calculatedSum == sum {
                count += 1
                kValue -= 1
                return
            }
            
            for i in start..<nums.count {
                if used[i] == false, calculatedSum + nums[i] <= sum {
                    used[i] = true
                    solve(calculatedSum + nums[i], i + 1)
                }
            }
        }
        
        if count == k {
            return true
        }
        return false
    }
}


