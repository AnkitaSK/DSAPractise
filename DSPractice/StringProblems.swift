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
        backtrack(&digits, &result, index + 1, k: k)
    }
}

