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
}

