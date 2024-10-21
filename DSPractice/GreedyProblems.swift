import Foundation

struct GreedyProblems {
    
    func candy(_ ratings: [Int]) -> Int {
        // initialize results by 1 (Each child must have at least one candy.)
        var results = Array(repeating: 1, count: ratings.count)
        
        // traverse from left to right
        for i in 1..<ratings.count {
            if ratings[i - 1] < ratings[i] {
                results[i] = results[i - 1] + 1
            }
        }
        
        // traverse from right to left and recalculate the candy count
        for i in stride(from: ratings.count - 2, through: 0, by: -1) {
            if ratings[i] > ratings[i + 1] {
                results[i] = max(results[i], results[i + 1] + 1)
            }
        }
        
        return results.reduce(0, +)
    }
}
