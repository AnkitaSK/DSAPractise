//
//  Backtracking.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 20.02.24.
//

import Foundation

class Backtracking {
    
    func permute(_ nums: [Int]) -> [[Int]] {
        var results = [[Int]]()
        var numsValue = nums
        solvePermute(&results, &numsValue, 0)
        return results
    }
    
    func solvePermute(_ results: inout [[Int]], _ nums: inout [Int], _ start: Int) {
        if start == nums.count - 1 {
            results.append(nums)
            return
        }
        
        for i in start..<nums.count {
            nums.swapAt(start, i)
            solvePermute(&results, &nums, start + 1)
            nums.swapAt(start, i)
            
        }
    }
    
    func subsets(_ nums: [Int]) -> [[Int]] {
        var results = [[Int]]()
        let output = [Int]()
        var input = nums
        solveSubset(&input, output, &results)
        return results
    }
    
    func solveSubset(_ input: inout [Int], _ output: [Int], _ results: inout [[Int]]) {
        if input.count == 0 {
            results.append(output)
            return
        }
        
        let output1 = output
        var output2 = output
        
        output2.append(input.first!)
        let temp = input.first!
        input.remove(at: 0)
        
        solveSubset(&input, output1, &results)
        solveSubset(&input, output2, &results)
        input.insert(temp, at: 0)
    }
    
    //    var set = Set<Int>()
    func subsets2(_ nums: [Int]) -> [[Int]] {
        var results = Set<[Int]>()
        var output = [Int]()
        var input = nums
        solveSubset2(&input, &output, &results)
        return Array(results)
    }
    
    func solveSubset2(_ input: inout [Int], _ output: inout [Int], _ results: inout Set<[Int]>) {
        if input.count == 0 {
            output.sort()
            results.insert(output)
            return
        }
        
        let value = input.last!
        var output1 = output
        var output2 = output
        
        output2.append(value)
        let temp = value
        input.removeLast()
        
        solveSubset2(&input, &output1, &results)
        solveSubset2(&input, &output2, &results)
        input.append(temp)
    }
    
    // 200.
    // as you move through the grid, you change land (1) to sea (0)
    // base case = when you encounter sea, you return
    // simply keep count of the islands in count var
    func numIslands(_ grid: [[Character]]) -> Int {
        
        var count = 0
        
        if grid.count == 0 {
            return count
        }
        var grid = grid
        for i in 0..<grid.count {
            for j in 0..<grid[0].count {
                if grid[i][j] == "1" {
                    dfs(&grid, i, j)
                    count += 1
                }
            }
        }
        
        return count
        
    }
    
    let choices = [
        Choice(direction: "U", dx: -1, dy: 0),
        Choice(direction: "L", dx: 1, dy: 0),
        Choice(direction: "L", dx: 0, dy: -1),
        Choice(direction: "R", dx: 0, dy: 1)
    ]
    
    func dfs(_ grid: inout[[Character]], _ x: Int, _ y: Int) {
        
        // basic validation check
        if !isValidGrid(x, y, grid){
            return
        }
        
        // base condition
        if grid[x][y] == "0" {
            return
        }
        
        for choice in choices {
            grid[x][y] = "0"
            
            dfs(&grid, x + choice.dx, y + choice.dy)
        }
    }
    
    func isValidGrid(_ x: Int, _ y: Int, _ grid: [[Character]]) -> Bool {
        if x >= 0, x < grid.count, y >= 0, y < grid[0].count {
            return true
        }
        return false
    }
    
    
    func shortestPathBinaryMatrix(_ grid: [[Int]]) -> Int {
        var grid = grid
        var count = 0
        let choices = [
            Choice(direction: "u", dx: -1, dy: 0),
            Choice(direction: "d", dx: 1, dy: 0),
            Choice(direction: "l", dx: 0, dy: -1),
            Choice(direction: "r", dx: 0, dy: 1),
            
            Choice(direction: "Dur", dx: -1, dy: 1),
            Choice(direction: "Ddr", dx: 1, dy: 1),
            Choice(direction: "Ddl", dx: 1, dy: -1),
            Choice(direction: "Dul", dx: -1, dy: -1)
        ]
        
        var path = ""
        var result = [Int]()
        var pathResult = [String]()
        
        if grid[0][0] == 0 {
            count += 1
            shortestPathBinaryMatrix(&grid, 0, 0, &count, n: grid.count, choices: choices, path: &path, result: &result, pathResult: &pathResult)
            return result.sorted(by: <).first ?? 0
        } else {
            return -1
        }
    }
    
    private func shortestPathBinaryMatrix(_ grid: inout [[Int]], _ x: Int, _ y: Int, _ pathCount: inout Int, n: Int, choices: [Choice], path: inout String, result: inout [Int], pathResult: inout [String]) {
        
        if x == n - 1, y == n - 1 {
            result.append(pathCount)
            pathResult.append(path)
            return
        }
        
        for choice in choices {
            let dx = x + choice.dx
            let dy = y + choice.dy
            
            if isValidChoice(dx, dy, grid, n) {
                grid[dx][dy] = 1
                pathCount += 1
                path.append(choice.direction)
                
                shortestPathBinaryMatrix(&grid, dx, dy, &pathCount, n: n, choices: choices, path: &path, result: &result, pathResult: &pathResult)
                grid[dx][dy] = 0
                pathCount -= 1
                path.removeLast()
            }
        }
    }
    
    private func isValidChoice(_ x: Int, _ y: Int, _ grid: [[Int]], _ n: Int) -> Bool {
        return x >= 0 && x < n && y >= 0 && y < n && grid[x][y] != 1
    }
    
    func checkMove(_ board: [[Character]], _ rMove: Int, _ cMove: Int, _ color: Character) -> Bool {
        
        var count = 0
        let choices = [
            Choice(direction: "u", dx: -1, dy: 0),
            Choice(direction: "d", dx: 1, dy: 0),
            Choice(direction: "l", dx: 0, dy: -1),
            Choice(direction: "r", dx: 0, dy: 1),
            
            Choice(direction: "Dur", dx: -1, dy: 1),
            Choice(direction: "Ddr", dx: 1, dy: 1),
            Choice(direction: "Ddl", dx: 1, dy: -1),
            Choice(direction: "Dul", dx: -1, dy: -1)
        ]
        
        if board[rMove][cMove] == "." {
            checkMove(board, rMove, cMove, color, count: &count, choices: choices, savedChoice: nil)
            return count > 0 ? true: false
        } else {
            return false
        }
        
    }
    
    private func checkMove(_ board: [[Character]],  _ rMove: Int, _ cMove: Int, _ color: Character, count: inout Int, choices: [Choice], savedChoice: Choice? = nil) {
        
        if rMove == board.count - 1 || cMove == board.count - 1 {
            count = 0 // as the points are wrong
            return
        }
        
        if board[rMove][cMove] == color {
            return
        }
        
        for choice in choices {
            var dx: Int = 0
            var dy: Int = 0
            if let savedChoice = savedChoice {
                dx = rMove + savedChoice.dx
                dy = cMove + savedChoice.dy
            } else {
                dx = rMove + choice.dx
                dy = cMove + choice.dy
            }
            if isValicMove(board, dx, dy, board.count) {
                count += 1
                checkMove(board, dx, dy, color, count: &count, choices: choices, savedChoice: choice)
            }
        }
    }
    
    private func isValicMove(_ board: [[Character]],  _ x: Int, _ y: Int, _ n: Int) -> Bool {
        return x >= 0 && x < n && y >= 0 && y < n && board[x][y] != "."
    }
    
    
    func numberOfPaths(_ grid: [[Int]], _ k: Int) -> Int {
        
        let choices = [
            Choice(direction: "D", dx: 1, dy: 0),
            Choice(direction: "R", dx: 0, dy: 1)
        ]
        
        var result = 0
        var grid = grid
        let row = grid.count
        let col = grid[0].count
        
        var sum = grid[0][0] // init sum with value at [0][0]
        
        numberOfPathsSolve(&grid, 0, 0, row, col, &result, &sum, k, choices)
        return result
    }
    
    private func numberOfPathsSolve(_ grid: inout [[Int]], _ x: Int, _ y: Int, _ row: Int, _ col: Int, _ result: inout Int, _ sum: inout Int, _ k: Int, _ choices: [Choice]) {
        
        if x == row - 1, y == col - 1 {
            if sum % k == 0 {
                result += 1
            }
            return
        }
        
        for choice in choices {
            let dx = x + choice.dx
            let dy = y + choice.dy
            
            if isValidChoice(dx, dy, grid, row, col) {
                let value = grid[dx][dy] // save value in-order to backtrack
                sum += value
                grid[dx][dy] = -11 // mark as visited
                numberOfPathsSolve(&grid, dx, dy, row, col, &result, &sum, k, choices)
                
                sum -= value
                grid[dx][dy] = value
            }
        }
    }
    
    private func isValidChoice(_ x: Int, _ y: Int, _ grid: [[Int]], _ row: Int, _ col: Int) -> Bool {
        if x >= 0 && x < row && y >= 0 && y < col && grid[x][y] != -11 {
            return true
        }
        return false
    }
    
    func getMaximumGold(_ grid: [[Int]]) -> Int {
        var result = 0
        var grid = grid
        let choices = [
            Choice(direction: "u", dx: -1, dy: 0),
            Choice(direction: "d", dx: 1, dy: 0),
            Choice(direction: "l", dx: 0, dy: -1),
            Choice(direction: "r", dx: 0, dy: 1)
        ]
        let row = grid.count
        let col = grid[0].count
        var sum = 0
        for i in 0..<row {
            for j in 0..<col {
                if grid[i][j] > 0 {
                    getMaximumGoldSolve(&grid, i, j, row, col, &result, &sum, choices: choices)
                }
            }
        }
        return result
    }
    
    private func getMaximumGoldSolve(_ grid: inout [[Int]], _ x: Int, _ y: Int, _ row: Int, _ col: Int, _ result: inout Int, _ sum: inout Int, choices: [Choice]) {
        
        if !isValidMaximumGold(grid, x, y, row, col) {
            result = max(result, sum)
            return
        }
        
//        if x == row - 1, y == col - 1 {
//            return
//        }
        
        for choice in choices {
            let value = grid[x][y]
            sum += value
            // set visited
            grid[x][y] = 0
            getMaximumGoldSolve(&grid, x + choice.dx, y + choice.dy, row, col, &result, &sum, choices: choices)
            
            // backtracking
            sum -= value
            grid[x][y] = value
        }
    }
    
    private func isValidMaximumGold(_ grid: [[Int]], _ x: Int, _ y: Int, _ row: Int, _ col: Int) -> Bool {
        if x >= 0 && x < row && y >= 0 && y < col, grid[x][y] > 0 {
            return true
        }
        return false
    }
    
    func maxAreaOfIsland(_ grid: [[Int]]) -> Int {
        var grid = grid
        var result = 0
        let row = grid.count
        let col = grid[0].count
        
        for i in 0..<row {
            for j in 0..<col {
                maxAreaOfIslandSolve(&grid, i, j, row, col, result: &result, 0)
            }
        }
        return result
    }
    
    private func maxAreaOfIslandSolve(_ grid: inout [[Int]], _ x: Int, _ y: Int, _ row: Int, _ col: Int, result: inout Int, _ path: Int) {
        
        if x == row - 1 && y == col - 1 {
            result = max(result, path)
            return
        }
        
        for choice in choices {
            let dx = x + choice.dx
            let dy = y + choice.dy
            if isValidArea(grid, dx, dy, row, col) && grid[dx][dy] == 1 {
                grid[dx][dy] = 0
                let test = path + 1
                maxAreaOfIslandSolve(&grid, dx, dy, row, col, result: &result, test)
            } else if isValidArea(grid, dx, dy, row, col) {
                result = max(result, path)
            }
        }
    }
    
    private func isValidArea(_ grid: [[Int]], _ x: Int, _ y: Int, _ row: Int, _ col: Int) -> Bool {
        if x >= 0 && y >= 0 && x < row && y < col {
            return true
        }
        return false
    }
    
    // not solved
    func largestIsland(_ grid: [[Int]]) -> Int {
        var grid = grid
        var result = 0
        let row = grid.count
        let col = grid[0].count
        
        for i in 0..<row {
            for j in 0..<col {
                let x = i
                let y = j
                let val = grid[x][y]
                if grid[i][j] == 0 {
                    grid[i][j] = 1
                }
                var path = [Int]()
//                if grid[i][j] == 1 {
//                    path.append(grid[i][j])
//                }
                largestIslandSolve(&grid, i, j, row, col, result: &result, &path)
                // revert
                grid[x][y] = val
//                path.removeLast()
            }
        }
        
        
        return result
    }
    
    private func largestIslandSolve(_ grid: inout [[Int]], _ x: Int, _ y: Int, _ row: Int, _ col: Int, result: inout Int, _ path: inout [Int]) {
        if !isValidArea(grid, x, y, row, col) {
            result = max(result, path.count)
            return
        }
        
        for choice in choices {
            // set visited
            var val = -1
            if grid[x][y] == 1 {
                val = grid[x][y]
                path.append(grid[x][y])
                grid[x][y] = 0
            }
            
            
            largestIslandSolve(&grid, x + choice.dx, y + choice.dy, row, col, result: &result, &path)
            
            if val != -1 {
                path.removeLast()
                grid[x][y] = 1
            }
            
        }
    }
    
    // worked
    func surroundedRegionFlip(_ board: inout [[Character]]) {
        print("i/p \n",board)
        let row = board.count
        let col = board[0].count
        
//        var board = board
        for i in 0..<row {
            // col fixed
            surroundedRegionFlipSolve(&board, i, 0, row, col)
            surroundedRegionFlipSolve(&board, i, col - 1, row, col)
        }
        
        for j in 0..<col {
            // row fixed
            surroundedRegionFlipSolve(&board, 0, j, row, col)
            surroundedRegionFlipSolve(&board, row - 1, j, row, col)
        }
        
        // flip
        flipBoard(&board, row, col)
        
        print("o/p \n",board)
    }
    
    private func flipBoard(_ board: inout [[Character]],_ row: Int, _ col: Int) {
        for i in 0..<row {
            for j in 0..<col {
                if board[i][j] == "M" {
                    board[i][j] = "O"
                } else if board[i][j] == "O" {
                    board[i][j] = "X"
                }
            }
        }
    }
    
    private func surroundedRegionFlipSolve(_ board: inout [[Character]], _ x: Int, _ y: Int, _ row: Int, _ col: Int) {
        if !isValidSurroundedRegionFlip(board, x, y, row, col) {
            return
        }
        
        for choice in choices {
            board[x][y] = "M"
            surroundedRegionFlipSolve(&board, x + choice.dx, y + choice.dy, row, col)
//            board[x][y] = "O"
        }
    }
    
    private func isValidSurroundedRegionFlip(_ board: [[Character]], _ x: Int, _ y: Int, _ row: Int, _ col: Int) -> Bool {
        if x >= 0 && y >= 0 && x < row && y < col, board[x][y] == "O" {
            return true
        }
        return false
    }
}

struct Choice {
    let direction: String
    let dx: Int
    let dy: Int
}
