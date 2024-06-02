//
//  DP.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 17.03.24.
//

import Foundation

class DP {
    func knapsackTopDown(nArray:[Int], w: Int) -> Int {
        let n = nArray.count
        var dp = Matrix(rows: n + 1, columns: w + 1, value: -1)
        
        // initialization
        for i in 0..<(n + 1) {
            for j in 0..<(w + 1) {
                if i == 0 || j == 0 {
                    dp[i, j] = 0
                }
            }
        }
        
        if dp[n, w] != -1 {
            return dp[n, w]
        }
        
        for i in 1..<(n + 1) {
            for j in 1..<(w + 1) {
                if nArray[i - 1] <= j {
                    dp[i, j] = max(nArray[i - 1] + dp[i - 1, j - nArray[i - 1]], dp[i - 1, j])
                } else {
                    dp[i, j] = dp[i - 1, j]
                }
            }
        }
        
        return dp[n, w]
    }
    
    // using recurssion and memoization
    func subsetSum(arr: [Int], sum: Int) -> Bool {
        var dp = Matrix(rows: arr.count + 1, columns: sum + 1, value: false)
        let test = subsetSumSolve(arr, n: arr.count, w: sum, dp: &dp)
        return test
    }
    
    private func subsetSumSolve(_ arr: [Int], n: Int, w: Int, dp: inout Matrix<Bool>) -> Bool {
        if n == 0 {
            dp[n, w] = false
            return dp[n, w]
        }
        
        if w == 0 {
            dp[n, w] = true
            return dp[n, w]
        }
        
        if dp[n, w] != false {
            return dp[n, w]
        }
        
        if arr[n - 1] <= w {
            dp[n, w] = subsetSumSolve(arr, n: n - 1, w: w - arr[n - 1], dp: &dp) || subsetSumSolve(arr, n: n - 1, w: w, dp: &dp)
        } else {
            dp[n, w] = subsetSumSolve(arr, n: n - 1, w: w, dp: &dp)
        }
        return dp[n, w]
    }
    
    // equal sum partition, variation of subsetSum
    func equalSumPartition(arr: [Int]) -> Bool {
        let sum = arr.reduce(0) { $0 + $1 }
        if sum % 2 == 1 { // odd
            return false
        } else {
            return subsetSum(arr: arr, sum: sum / 2)
        }
    }
    
    // using recurssion + memoization
//    func countSubsetSumWithGivenSum(arr: [Int], sum: Int) -> Int {
//        var dp = Matrix(rows: arr.count + 1, columns: sum + 1, value: -1)
//        let test = countSubsetSumWithGivenSumSolve(arr: arr, n: arr.count, w: sum, dp: &dp)
//        return test
//    }
//    
//    private func countSubsetSumWithGivenSumSolve(arr: [Int], n: Int, w: Int, dp: inout Matrix<Int>) -> Int {
//        if n == 0 {
//            dp[n, w] = 0
//            return dp[n, w]
//        }
//        
//        if w == 0 {
//            dp[n, w] = 1
//            return dp[n, w]
//        }
//        
//        if dp[n, w] != -1 {
//            return dp[n, w]
//        }
//        
//        if arr[n - 1] <= w {
//            dp[n, w] = countSubsetSumWithGivenSumSolve(arr: arr, n: n - 1, w: w - arr[n - 1], dp: &dp) + countSubsetSumWithGivenSumSolve(arr: arr, n: n - 1, w: w, dp: &dp)
//        } else {
//            dp[n, w] = countSubsetSumWithGivenSumSolve(arr: arr, n: n - 1, w: w, dp: &dp)
//        }
//        
//        return dp[n, w]
//    }
    
    // using topdown
    func countSubsetSumWithGivenSumTopDown(arr: [Int], sum: Int) -> Int {
        var dp = Matrix(rows: arr.count + 1, columns: sum + 1, value: -1)
        let test = countSubsetSumWithGivenSumSolveTopDown(arr: arr, n: arr.count, w: sum, dp: &dp)
        return test
    }
    
    private func countSubsetSumWithGivenSumSolveTopDown(arr: [Int], n: Int, w: Int, dp: inout Matrix<Int>) -> Int {
        
        for i in 0..<n + 1 {
            for j in 0..<w + 1 {
                if i == 0 {
                    dp[i, j] = 0
                }
                
                if j == 0 {
                    dp[i, j] = 1
                }
            }
        }
        if dp[n, w] != -1 {
            return dp[n, w]
        }
        
        for i in 1..<n + 1 {
            for j in 1..<w + 1 {
                if arr[i - 1] <= j {
                    dp[i, j] = countSubsetSumWithGivenSumSolveTopDown(arr: arr, n: i - 1, w: j - arr[i - 1], dp: &dp) + countSubsetSumWithGivenSumSolveTopDown(arr: arr, n: i - 1, w: j, dp: &dp)
                } else {
                    dp[i, j] = countSubsetSumWithGivenSumSolveTopDown(arr: arr, n: i - 1, w: j, dp: &dp)
                }
            }
        }
        
        return dp[n, w]
    }
    
    // unbounded knapsack
    // number of ways
    func coinChange2(_ coins: [Int], _ amount: Int) -> Int {
        var dp = Matrix(rows: coins.count + 1, columns: amount + 1, value: -1)
        return coinChangeSolveTopDown(coins, coins.count, amount, dp: &dp)
    }
    
    func coinChangeSolveTopDown(_ coins: [Int], _ n: Int, _ w: Int, dp: inout Matrix<Int>) -> Int {
        
        for i in 0..<n + 1 {
            for j in 0..<w + 1 {
                if i == 0 {
                    dp[i, j] = 0
                }
                
                if j == 0 {
                    dp[i, j] = 1
                }
            }
        }
        
//        if dp[n, w] != -1 {
//            return dp[n, w]
//        }
        
        for i in 1..<n + 1 {
            for j in 1..<w + 1 {
                if coins[i - 1] <= j {
                    dp[i, j] = dp[i - 1, j - coins[i - 1]] + dp[i - 1, j]
                } else {
                    dp[i, j] = dp[i - 1, j]
                }
            }
        }
        
        return dp[n, w]
    }
    
    // 518. Coin Change II
    // Return the number of combinations
    // knapsack - unbounded
    func coinChange2(_ amount: Int, _ coins: [Int]) -> Int {
        // amount = 5, coins = [1,2,5]
        let rows = coins.count
        let cols = amount
        var dp = Matrix(rows: rows + 1, columns: cols + 1, value: -1)
        
        // initialise
        for i in 0..<(rows + 1) {
            for j in 0..<(cols + 1) {
                if i == 0 {
                    dp[i, j] = 0
                }
                
                if j == 0 {
                    dp[i, j] = 1
                }
            }
        }
        
        // memoization
//        if dp[rows, cols] != -1 {
//            return dp[rows, cols]
//        }
        
        // main
        for i in 1..<(rows + 1) {
            for j in 1..<(cols + 1) {
                if coins[i - 1] <= j {
                    // include, exclude
                    dp[i, j] = dp[i, j - coins[i - 1]] + dp[i - 1, j]
                } else {
                    // exclude
                    dp[i, j] = dp[i - 1, j]
                }
            }
        }
        
        return dp[rows, cols]
    }
    
    // 322. Coin Change
    // return fewest number of coins that you need to make up that amount.
    func    coinChange1(_ coins: [Int], _ amount: Int) -> Int {
        let row = coins.count
        let col = amount
        var dp = Matrix(rows: coins.count + 1, columns: amount + 1, value: -1)
        
        // init
        for i in 0..<(row + 1) {
            for j in 0..<(col + 1) {
                if i == 0 {
                    dp[i, j] = Int.max - 1
                }
                
                if j == 0 {
                    dp[i, j] = 0
                }
            }
        }
        
        //actual
        for i in 1..<(row + 1) {
            for j in 1..<(col + 1) {
                if coins[i - 1] <= j {
                    dp[i, j] = min(1 + dp[i, j - coins[i - 1]], dp[i - 1, j])
                } else {
                    dp[i, j] = dp[i - 1, j]
                }
            }
        }
        
        return dp[row, col] == Int.max - 1 ? -1 : dp[row, col]
    }
    
    func lengthOfLIS(_ nums: [Int]) -> Int {
        var dp = Matrix(rows: nums.count, columns: nums.count + 1, value: -1)
        return solve(nums, nums.count, 0, -1, &dp)
    }

    private func solve(_ nums: [Int], _ n: Int, _ curr: Int, _ prev: Int, _ dp: inout Matrix<Int>) -> Int {
        if curr == n {
            return 0
        }
        
        if dp[curr, prev + 1] != -1 {
            return dp[curr, prev + 1]
        }

        if prev == -1 || nums[curr] > nums[prev] {
            dp[curr, prev + 1] = max(1 + solve(nums, n, curr + 1, curr, &dp), solve(nums, n, curr + 1, prev, &dp))
        } else {
            dp[curr, prev + 1] = solve(nums, n, curr + 1, prev, &dp)
        }

        return dp[curr, prev + 1]

    }
}


class LCS {
    func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
        var dp = Matrix(rows: text1.count + 1, columns: text2.count + 1, value: -1)
//        return lcsRecurssion(text1, text2, text1.count, text2.count, dp: &dp)
        return lcsTopDown(text1, text2, text1.count, text2.count, dp: &dp)
    }
    
    private func lcsRecurssion(_ x: String, _ y: String, _ n: Int, _ m: Int, dp: inout Matrix<Int>) -> Int {
        
        if n == 0 || m == 0 {
            dp[n, m] = 0
            return dp[n, m]
        }
        
        if dp[n, m] != -1 {
            return dp[n, m]
        }
        
        if x[n - 1] == y[m - 1] {
            dp[n, m] = 1 + lcsRecurssion(x, y, n - 1, m - 1, dp: &dp)
        } else {
            dp[n, m] = max(lcsRecurssion(x, y, n, m - 1, dp: &dp), lcsRecurssion(x, y, n - 1, m, dp: &dp))
        }
        
        return dp[n, m]
    }
    
    private func lcsTopDown(_ x: String, _ y: String, _ n: Int, _ m: Int, dp: inout Matrix<Int>) -> Int {
        
        for i in 0..<(n + 1) {
            for j in 0..<(m + 1) {
                if i == 0 || j == 0 {
                    dp[i, j] = 0
                }
            }
        }
        
        for i in 1..<(n + 1) {
            for j in 1..<(m + 1) {
                if x[i - 1] == y[j - 1] {
                    dp[i, j] = 1 + dp[i - 1, j - 1]
                } else {
                    dp[i, j] = max(dp[i, j - 1], dp[i - 1, j])
                }
            }
        }
        
        return dp[n, m]
    }
    
    // longest common substring using top-down
    func longestCommonSubstring(_ text1: String, _ text2: String) -> Int {
        var dp = Matrix(rows: text1.count + 1, columns: text2.count + 1, value: -1)
        return lcsubstringTopDown(text1, text2, text1.count, text2.count, dp: &dp)
    }
    
    private func lcsubstringTopDown(_ x: String, _ y: String, _ n: Int, _ m: Int, dp: inout Matrix<Int>) -> Int {
        var result = 0
        
        for i in 0..<n + 1 {
            for j in 0..<m + 1 {
                if i == 0 {
                    dp[i, j] = 0
                }
                
                if j == 0 {
                    dp[i, j] = 0
                }
            }
        }
        
        for i in 1..<n + 1 {
            for j in 1..<m + 1 {
                if x[i - 1] == y[j - 1] {
                    dp[i, j] = 1 + dp[i - 1, j - 1]
                    result = max(result, dp[i, j]) // this is must
                } else {
                    dp[i, j] = 0
                }
            }
        }
        
        return result
    }
    
    // 115. Distinct Subsequences of s
    func numDistinct(_ s: String, _ t: String) -> Int {
        var dp = Matrix(rows: s.count + 1, columns: t.count + 1, value: -1)
        return numDistinctTopdown(s, t, n: s.count, m: t.count, dp: &dp)
    }
    
    func numDistinctTopdown(_ x: String, _ y: String, n: Int, m: Int, dp: inout Matrix<Int>) -> Int {
        for i in 0..<n + 1 {
            for j in 0..<m + 1 {
                if i == 0 {
                    dp[i, j] = 0
                }
                
                if j == 0 {
                    dp[i, j] = 1 // 1 ask the interviewer s: "r" t: "" if o/p is r then return 1
                }
            }
        }
        
        if dp[n, m] != -1 {
            return dp[n, m]
        }
        
        for i in 1..<n + 1 {
            for j in 1..<m + 1 {
                if x[i - 1] == y[j - 1] {
                    dp[i, j] = dp[i - 1, j - 1] + dp[i - 1, j] // 2 choices to take or not to take
                } else {
                    dp[i, j] =  dp[i - 1, j]
                }
            }
        }
        
        return dp[n, m]
    }
    
    
    // Shortest Common Supersequence
    func shortestCommonSupersequence(_ str1: String, _ str2: String) -> String {
        var dp = Matrix(rows: str1.count + 1, columns: str2.count + 1, value: -1)
        lcsRecurssion(str1, str2, str1.count, str2.count, dp: &dp)
        
        
        // print in string
        var i = str1.count
        var j = str2.count
        var result = ""
        while i > 0 && j > 0 {
            if str1[i - 1] == str2[j - 1] {
                result.append(str1[i - 1])
                i -= 1
                j -= 1
            } else if dp[i - 1, j] > dp[i, j - 1] {
                result.append(str1[i - 1])
                i -= 1
            } else {
                result.append(str2[j - 1])
                j -= 1
            }
        }
        
        while i > 0 {
            result.append(str1[i - 1])
            i -= 1
        }
        
        while j > 0 {
            result.append(str2[j - 1])
            j -= 1
        }
        
        return result
    }
    
    
    func isSubsequence(_ s: String, _ t: String) -> Bool {
        let lcs = longestCommonSubsequence(s, t)
        if lcs == s.count {
            return true
        } else {
            return false
        }
    }
    
}
