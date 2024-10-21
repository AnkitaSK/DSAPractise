import Foundation



class StringProblems {
    /*
     input
     s = "mkteneetkybe" t = "e"
     output = [3, 2, 1, 0, 1, 0, 0, 1, 2, 2, 1, 0]
     
     */
    
    func solve1(s: String, t: Character) -> [Int] {
        var result = [Int]()
        
        var positionsOft = [Int]()
        for (index, value) in s.enumerated() {
            if value == t {
                positionsOft.append(index)
            }
        }
        
        for (index, _) in s.enumerated() {
            var tempResult = [Int]()
            for p in positionsOft {
                tempResult.append(abs(p - index))
            }
            result.append(tempResult.min() ?? 0)
        }
        
        return result
    }
    
    /*
     input
     s = "c23cb24d8hy23"
     output = 3
     
     */
    
    func solve2(s: String) -> Int {
        var result = Set<String>()
        let sWithoutChar = s.components(separatedBy: CharacterSet.letters)
        for s in sWithoutChar {
            if s != "" {
                result.insert(s)
            }
        }
        return result.count
    }
    
    // 670. Maximum Swap
    // using backtracking
    // convert int to array and work
    func maximumSwap(_ num: Int) -> Int {
        var digits = Array(String(num)).map { Int(String($0))! }
        var result = num
        let k = 1 // at the most once
        backtrack(&digits, &result, 0, k: k)
        return result
    }
    
    func backtrack(_ digits: inout [Int], _ result: inout Int, _ index: Int, k: Int) {
        
        if k == 0 || index == digits.count {
            return
        }
        
        if index + 1 < digits.count {
            for i in (index + 1)..<digits.count {
                if digits[i] > digits[index] && digits[i] == digits[index..<digits.count].max() {
                    digits.swapAt(index, i)
                    let currentNum = Int(digits.map { String($0) }.joined())!
                    result = max(result, currentNum)
                    backtrack(&digits, &result, index + 1, k: k - 1)
                    digits.swapAt(index, i) // backtrack
                }
            }
            
        }
        // need this when 1st digit is greatest of all
//        backtrack(&digits, &result, index + 1, k: k)
    }
    
    func permutation(s: String) -> [String] {
        
        var results = [String]()
        var set = Set<String>()
        
        var s = s
        permutation(&s, 0)
        
        func permutation(_ s: inout String, _ start: Int) {
            if start == s.count - 1 {
                results.append(s)
                return
            }
            for i in start..<s.count {
                if !set.contains(s[i]) {
                    set.insert(s[i])
                    s.swapAt(start, i)
                    permutation(&s, start + 1)
                    s.swapAt(start, i)
                    set.remove(s[i])
                }
            }
        }
        
        return results
    }
    
    // Given an integer n, print all the n digit numbers in increasing order, such that their digits are in strictly increasing order(from left to right).
    // 9 choices for each give n therefore the timecomplexity is O(9^n)
    func digitsInIncreasingOrder(n: Int) -> [Int] {
        // 1 to 9
        var results = [Int]()
        if n == 1 {
            results = Array(0...9)
        }
        
        var answers = [Int]()
        solve(answers: &answers, n: n)
        
        func solve(answers: inout [Int], n: Int) {
            if n == 0 {
                // ans
                let answer = Int(answers.map{ String($0) }.joined())
                results.append(answer!)
                return
            }
            
            for i in 1...9 {
                // condition
                if answers.isEmpty || (answers.last ?? 0) < i {
                    answers.append(i)
                    solve(answers: &answers, n: n - 1)
                    answers.removeLast()
                }
            }
        }
        
        return results
    }
    
    // 131. Palindrome Partitioning
    // substring - continuous and non-empty
    // aab
    func partition(_ s: String) -> [[String]] {
        var results = [[String]]()
        
        var answers = [String]()
        solve(start: 0, s: s, answers: &answers)
        
        func solve(start: Int, s: String, answers: inout [String]) {
            if start == s.count {
                // ans
                results.append(answers)
                return
            }
            
            for i in start..<s.count { // choice - traverse horizontal
                if isPalindrome(s, start, i) {
                    let startIndex = s.index(s.startIndex, offsetBy: start)
                    let endIndex = s.index(s.startIndex, offsetBy: i)
                    answers.append(String(s[startIndex...endIndex]))
                    
                    solve(start: i + 1, s: s, answers: &answers)
                    
                    // backtrack
                    answers.removeLast()
                    
                }
            }
        }
        
        func isPalindrome(_ s: String, _ start: Int, _ end: Int) -> Bool {
            var start = start
            var end = end
            
            while start < end {
                if s[start] != s[end] {
                    return false
                }
                start += 1
                end -= 1
            }
            return true
        }
        
        return results
    }
    
    // 17. letter combination of a phone number
    func letterCombinations(_ digits: String) -> [String] {
        // digits = 23
        let dict = [
            "2": "abc",
            "3": "def",
            "4": "ghi",
            "5": "jkl",
            "6": "mno",
            "7": "pqrs",
            "8": "tuv",
            "9": "wxyz"
        ]
        
        var results = [String]()
        
        guard digits.count > 0 else {
            return []
        }
        
        var ans = ""
        backtracking(0, &ans)
        
        func backtracking(_ start: Int, _ ans: inout String) {
            // BC
            if ans.count == digits.count {
                results.append(ans)
                return
            }
            
            // loop
            let digit = digits[start] // 2
            let characters = String(dict[digit]!) // abc
            for c in characters { // abc
                ans += String(c)
                backtracking(start + 1, &ans)
                
                // backtrack
                ans.removeLast()
            }
        }
        
        return results
    }
    
    func myAtoi(_ s: String) -> Int {
        
        var result = 0
        var isNegetive = false
        var started = false
        
        for char in s {
            if char == " " && !started {
                continue
            }
            
            if char == "-" && !started {
                isNegetive = true
                started = true
                continue
            }
            
            if char == "+" && !started {
                started = true
                continue
            }
            
            if let digit = char.wholeNumberValue {
                result = result * 10 + digit
                started = true

                let temp = isNegetive ? -result : result
                
                if temp > 2147483647 {
                    return 2147483647
                } else if temp < -2147483648 {
                    return -2147483648
                }

            } else {
                break
            }
        }

        return isNegetive ? -result : result
    }
    
    func reorganizeString(_ str: String) -> String {
        
        var hash = Array(repeating: 0, count: 26)
        let ascii = Int(Character("a").asciiValue!)
        
        for char in str {
            let index = Int(char.asciiValue!) - ascii
            hash[index] += 1
        }
        
        // find the characters with max freq
        var maxCount = 0
        var letter = 0
        for i in 0..<26 {
            if hash[i] > maxCount {
                maxCount = hash[i]
                letter = i
            }
        }
        
        // check if possible to reorganise
        if maxCount > (str.count + 1) / 2 {
            return ""
        }
        
        // create the result array
        var res = [Character](repeating: " ", count: str.count)
        var idx = 0
        
        // place the most frequent chars at even positions
        while hash[letter] > 0 {
            res[idx] = Character(UnicodeScalar(letter + ascii)!)
            idx += 2
            hash[letter] -= 1
        }
        
        // place the remaining characters
        for i in 0..<26 {
            while hash[i] > 0 {
                if idx >= str.count {
                    idx = 1
                }
                res[idx] = Character(UnicodeScalar(i + ascii)!)
                idx += 2
                hash[i] -= 1
            }
        }
        
        return String(res)
    }
}
