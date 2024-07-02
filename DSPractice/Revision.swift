//
//  Revision.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 06.04.24.
//

import Foundation

class GraphRevision {
    // for Directed graphs
    func isCycleForDirected(_ num: Int, _ prerequisites: [[Int]]) -> Bool {
        // create adj list
        var adjList = [Int : [Int]]()
        for n in 0..<num {
            adjList[n] = []
        }

        for pre in prerequisites {
            adjList[pre[1]]?.append(pre[0])
        }
        
        var result = false
        var visited = Array(repeating: false, count: num)
        var visitedFromDFS = Array(repeating: false, count: num)
        
        findCycle()
        
        func findCycle() {
            for a in adjList { // for disconnected graphs
                if !visited[a.key] {
                     result  = isCycleDetected(a.key)
                }
            }
        }

        func isCycleDetected(_ vertex: Int) -> Bool {
            visited[vertex] = true
            visitedFromDFS[vertex] = true
            for neighbour in adjList[vertex] ?? [] {
                if !visited[neighbour] {
                    return isCycleDetected(neighbour)
                } else if visitedFromDFS[vertex] {
                    return true
                }
            }
            visitedFromDFS[vertex] = false
            return false
        }

        return result
    }
    
    // for undirected graphs - keeping track of parent node
    func isCycleForUndirected(_ num: Int, _ prerequisites: [[Int]]) -> Bool {
        // create adj list for undirected graphs
        var adjList = [Int : [Int]]()
        for n in 0..<num {
            adjList[n] = []
        }

        for pre in prerequisites {
            adjList[pre[1]]?.append(pre[0])
            adjList[pre[0]]?.append(pre[1])
        }
        
        var result = false
        var visited = Array(repeating: false, count: num)
        findCycle()
        
        
        func findCycle() {
            for v in adjList {
                if !visited[v.key] {
                    result = isCycleDetectedDFS(v.key, -1)
                }
            }
        }
        
        func isCycleDetectedDFS(_ vertex: Int, _ parent: Int) -> Bool {
            visited[vertex] = true
            
            // go through the neighbours
            for neighbour in adjList[vertex] ?? [] {
                if !visited[neighbour] {
                    return isCycleDetectedDFS(neighbour, vertex)
                } else if parent != neighbour {
                    return true
                }
            }
            return false
        }
        
        return result
    }
    
    // topological sort eg: 210. Course Schedule II
    // non-dependent element appears in the end
    // application - OS's - for prioritation
    // for directed graph
    func topologicalSort(_ num: Int, _ prerequisites: [[Int]]) -> [Int] {
        var adjList = [Int : [Int]]()
        for n in 0..<num {
            adjList[n] = []
        }
        
        for pre in prerequisites { // for directed graphs
            adjList[pre[1]]?.append(pre[0])
        }
        var result = [Int]()
        var stack = [Int]() // stack using array
        var visited = Array(repeating: false, count: num)
        for adj in adjList {
            if !visited[adj.key] {
                dfs(adj.key)
            }
        }
        
        func dfs(_ vertex: Int) {
            visited[vertex] = true
            
            for neighbour in adjList[vertex] ?? [] {
                if !visited[neighbour] {
                    dfs(neighbour)
                }
            }
            stack.append(vertex)
        }
        
        for s in stack.reversed() { // or since you used an array simply reverse it to get a result
            result.append(s)
        }
        
        return result
    }
    
    // 417. // not working
    func pacificAtlantic(_ heights: [[Int]]) -> [[Int]] {
        
        let rows = heights.count
        let cols = heights[0].count
        
        var pacificVisited = Set<[Int]>()
        var atlanticVisited = Set<[Int]>()
        var result = [[Int]]()
        let choices = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        
//        for i in 0..<rows {
//            for j in 0..<cols {
//                if i == 0 {
//                    // 1st row
//                    dfs(0, j, &pacificVisited, previousHeight: heights[0][j])
//                }
//                
//                if j == 0 {
//                    // 1st col
//                    dfs(i, 0, &pacificVisited, previousHeight: heights[i][0])
//                }
//                
//                if i == cols - 1 {
//                    // last row
//                    dfs(cols - 1, j, &atlanticVisited, previousHeight: heights[cols - 1][j])
//                }
//                
//                if j == rows - 1 {
//                    // last cols
//                    dfs(i, rows - 1, &atlanticVisited, previousHeight: heights[i][rows - 1])
//                }
//            }
//        }
        
        for c in 0..<cols {
            dfs(0, c, &pacificVisited, previousHeight: heights[0][c])
            dfs(rows - 1, c, &atlanticVisited, previousHeight: heights[rows - 1][c])
        }
        
        for r in 0..<rows {
            dfs(r, 0, &pacificVisited, previousHeight: heights[r][0])
            dfs(r, cols - 1, &atlanticVisited, previousHeight: heights[r][cols - 1])
        }
        
        func dfs(_ x: Int, _ y: Int, _ visited: inout Set<[Int]>, previousHeight: Int) {
            if !isValid(x, y, previousHeight) {
                return
            }
            
            if visited.contains([x, y]) {
                return
            }
            
            let temp = [x, y]
            visited.insert([x, y])
            
            for choice in choices {
//                if !visited.contains([x + choice.0, y + choice.1]) {
                    dfs(x + choice.0, y + choice.1, &visited, previousHeight: heights[x][y])
//                }
            }
//            visited.remove(temp)
        }
        
        func isValid(_ x: Int, _ y: Int, _ previousHeight: Int) -> Bool {
            if x >= 0 && x < rows, y >= 0 && y < cols, heights[x][y] >= previousHeight {
                return true
            }
            return false
        }
        
        for i in 0..<rows {
            for j in 0..<cols {
                if pacificVisited.contains([i, j]) && atlanticVisited.contains([i, j]) {
                    result.append([i ,j])
                }
            }
        }
        
        return result
        
    }
    
    // 684 // not working
    func findRedundantConnection(_ edges: [[Int]]) -> [Int] {
        
        let result = [Int]()
        var parents = [Node]()
        for _ in 0..<(edges.count + 1) {
            let parent = Node(parent: -1, rank: 0)
            parents.append(parent)
        }
        
        // find if from and to have a common absolute parent
        for edge in edges {
            let absParent0 = find(edge[0])
            let absParent1 = find(edge[1])
            
            if absParent0 == absParent1 {
                return edge
            }
            
            union(edge[0], edge[1])
        }
        
        // find absolut parent of a node
        func find(_ vertex: Int) -> Int {
            if parents[vertex].parent == -1 {
                return vertex
            }
            parents[vertex].parent = find(parents[vertex].parent)
            return parents[vertex].parent
        }
        
        func union(_ vertex1: Int, _ vertex2: Int) {
            // if rank 1 > rank 2 then node 1 becomes a parent
            // also when not equal, don't update the ranks
            if parents[vertex1].parent > parents[vertex2].parent {
                parents[vertex2].parent = vertex1
            } else if parents[vertex1].parent < parents[vertex2].parent {
                parents[vertex1].parent = vertex2
            } else {
                // if equal pick anyone to become a parent
                parents[vertex1].parent = vertex2
                // increment the rank
                parents[vertex2].rank += 1
            }
        }
        
        return result
        
        struct Node {
            var parent: Int
            var rank: Int
        }
    }
    
    //994
    func orangesRotting(_ grid: [[Int]]) -> Int {
        var grid = grid
        let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        let rows = grid.count
        let cols = grid[0].count
        var queue = [(Int, [Int])]() // [(0, [1, 2]), [3, 4]] time, coordinates of grid
        var freshOranges = 0
        var time = 0
        
        for r in 0..<rows {
            for c in 0..<cols {
                if grid[r][c] == 1 {
                    freshOranges += 1
                }
                if grid[r][c] == 2 {
                    queue.append((0,[r,c])) // enqueue
                }
            }
        }
        
        while !queue.isEmpty {
            let dequeued = queue.removeFirst() // dequeue
            // visit neighbours using directions
            for direction in directions {
                let time = dequeued.0
                let dx = dequeued.1[0] + direction.0
                let dy = dequeued.1[1] + direction.1
                
                if isValid(dx, dy) {
                    grid[dx][dy] = 2
                    let newTime = time + 1
                    queue.append((newTime, [dx, dy]))
                    freshOranges -= 1
                }
            }
            time = dequeued.0
        }
        
        func isValid(_ x: Int, _ y: Int) -> Bool {
            if x >= 0 && x < rows, y >= 0 && y < cols, grid[x][y] == 1 {
                return true
            }
            return false
        }
        
        if freshOranges > 0 {
            return -1
        }
        return time
    }
    
    // 2101
    func maximumDetonation(_ bombs: [[Int]]) -> Int {
        let n = bombs.count
        var adjList = [Int: [Int]]()
        
        for i in 0..<n {
            adjList[i] = []
        }
        
        for i in 0..<n {
            for j in 0..<n {
                if i != j {
                    let x1 = bombs[i][0]
                    let y1 = bombs[i][1]
                    let r1 = bombs[i][2]
                    
                    let x2 = bombs[j][0]
                    let y2 = bombs[j][1]
                    let r2 = bombs[j][2]
                    
                    let x = (x2 - x1) * (x2 - x1)
                    let y = (y2 - y1) * (y2 - y1)
                    let distance = sqrt(Double(x + y))
                    // range will be
                    if Double(r1) >= distance {
                        adjList[i]?.append(j)
                    }
                }
            }
        }
        
        // go through the each node of graph to find the chain detonation reaction count (max)
        var result = Int.min
        var visited = Set<Int>()
        for vertex in adjList {
            dfs(vertex.key, &visited)
            result = max(result, visited.count)
            visited.removeAll() // backtrack
        }
        
        return result
        
        func dfs(_ vertex: Int, _ visited: inout Set<Int>) {
            visited.insert(vertex)
            
            // navigate to its neighbours
            for neighbour in adjList[vertex] ?? [] {
                if !visited.contains(neighbour) {
                    dfs(neighbour, &visited)
                }
            }
        }
    }
}


