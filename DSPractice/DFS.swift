import Foundation

// DFS is same as backtracking
// you convert problem into a tree and apply DFS
// DFS = stack == recurssion + backtracking

// rat in a maze problem

extension Backtracking {
    func ratInMaze(maze: [[Int]]) -> [String] {
        
        let choices = [("U", -1, 0), ("D", 1, 0), ("L", 0, -1), ("R", 0, 1)]
        var results = [String]()
        var mazeValue = maze
        var path = ""
        let n = maze.count
        let m = maze[0].count
        
        if maze[0][0] == 1 {
            findPaths(maze: &mazeValue, x: 0, y: 0, path: &path)
        }
        
        func findPaths(maze: inout [[Int]], x: Int, y: Int, path: inout String) {
            // base condition
            if x == n - 1 && y == m - 1 {
                results.append(path)
                return
            }
            
            for choice in choices {
                let dx = x + choice.1
                let dy = y + choice.2
                
                if isValid(maze: maze, dx: dx, dy: dy) {
                    maze[dx][dy] = 0
                    path.append(choice.0)
                    findPaths(maze: &maze, x: dx, y: dy, path: &path)
                    
                    maze[dx][dy] = 1
                    path.removeLast()
                }
            }
            
        }
        
        func isValid(maze: [[Int]], dx: Int, dy: Int) -> Bool {
            return dx >= 0 && dx < n && dy >= 0 && dy < m && maze[dx][dy] == 1
        }
        
        return results
    }
}
