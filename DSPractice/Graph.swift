import Foundation

struct Vertex<T> {
    let value: T
}

extension Vertex: Hashable where T: Hashable {}
extension Vertex: Equatable where T: Equatable {}

extension Vertex: CustomStringConvertible {
    var description: String {
        "\(value)"
    }
}

struct Edge<T> {
    let source: Vertex<T>
    let destination: Vertex<T>
    let weight: Double?
}

public enum EdgeType {
    case directed
    case undirected
}

protocol Graph {
    associatedtype Element
    
    func createVertex(data: Element) -> Vertex<Element>
    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func addUndirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double?
    func add(_ edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
}


/*
 Graph can be represented using AdjacencyList or Adjacency matrix, we will learn AdjacencyList
 */

// using AdjacencyList

class AdjacencyList<T: Hashable>: Graph {
    init() {}
    var adjacencies: [Vertex<T>: [Edge<T>]] = [:]
    
    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(value: data)
        adjacencies[vertex] = []
        return vertex
    }
    
    func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencies[source]?.append(edge)
    }
    
    func addUndirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
    
    func edges(from source: Vertex<T>) -> [Edge<T>] {
        adjacencies[source] ?? []
    }
    
    func weight(from source: Vertex<T>, to destination: Vertex<T>) -> Double? {
        edges(from: source).first { destination == $0.destination }?.weight
    }
    
    func add(_ edge: EdgeType, from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(from: source, to: destination, weight: weight)
        }
    }
}

extension AdjacencyList: CustomStringConvertible {
    var description: String {
        var result = ""
        for (vertex, edges) in adjacencies {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ]\n")
        }
        
        return result
    }
}


/* BFS traversal (traversing or searching graph)
 - explores all the current vertex's neighbours before traversing the next level of vertices.
 - shortest path for undirected graph
 - using queue DS - FIFO
 - Applications - finding shortest path between 2 vertices, finding potential paths between vertices,
   generating min spanning tree
 */

extension Graph where Element: Hashable {
    // this function will traverse all the vertices from source
    func breadthFirstSearch(from source: Vertex<Element>, to: Vertex<Element>) -> [Vertex<Element>] {
        var result: [Vertex<Element>] = []
        var queue: [Vertex<Element>] = [] // using Array DS
        var visited: [Vertex<Element>] = []
        
        queue.append(source)
        visited.append(source)
        
        var pathFound = false
        
        while !queue.isEmpty {
            let dequeued = queue.removeFirst()
            result.append(dequeued)
            if dequeued == to {
                pathFound = true
                break
            }
            let neighbours = edges(from: dequeued)
            neighbours.forEach { edge in
                if !visited.contains(edge.destination) {
                    queue.append(edge.destination)
                    visited.append(edge.destination)
                }
            }
        }
        
        return pathFound == true ? result: []
    }
}

/* DFS traversal (or searching)
 - use stack DS to implement as you start with a given source and attempt to explore deeper and deeper
   until you reach the end. At this point, you need to BACKTRACK and explore next available branch until
   you reach the dead end or find what you are looking for.
 */

extension Graph where Element: Hashable {
    func depthFirstSearch(source: Vertex<Element>) -> [Vertex<Element>] {
        var results = [Vertex<Element>]()
        var visited = [Vertex<Element>]()
        
        
        solve(source, &results, &visited)
        
        return visited // use only one array visited or results
    }
    
    func solve(_ start: Vertex<Element>, _ results: inout [Vertex<Element>], _ visited: inout [Vertex<Element>]) {
        
        if visited.contains(start) {
            return
        }
        visited.append(start)
        results.append(start)
        
        let edges = edges(from: start)
        edges.forEach { edge in
            let neighbour = edge.destination
            
            solve(neighbour, &results, &visited)
            
        }
    }
}

class GraphProblems {
    // 210
    func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
        // create adjacency list
        
        var adjacencyList: [Int: [Int]] = [:]
        for pre in prerequisites {
            let a = pre.last!
            let b = pre.first!
            adjacencyList[a, default: []].append(b)
        }
        
        var results = [Int]()
        var visited = [Int]()
        
        for i in 0..<numCourses {
            if isCycle(i) == true {
                results = []
            }
        }
        
        func isCycle(_ start: Int) -> Bool {
            if visited.contains(start) {
                return true
            }
            
            visited.append(start)
            let neighbours = adjacencyList[start]
            for value in neighbours ?? [] {
                if !visited.contains(value) {
                    return isCycle(value)
                }
                
                
                // backtrack
                visited.removeLast()
                results.append(start)
            }
            return false
        }
        
        return results
    }
    
    func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
        var adjacencyList = [Int: [Int]]()
        for num in  0..<numCourses { // numCourses is nodes
            adjacencyList[num] = []
        }
        //adj list
        for prerequisite in prerequisites {
            adjacencyList[prerequisite[0]]?.append(prerequisite[1])
        }
        
        var visited = Set<Int>() // to detect cycle, already visited check
        var results = [Bool]()
        
        for vertex in adjacencyList {
            dfsSolve(vertex.key, &visited, adjacencyList, &results)
        }
        
        return !results.contains(false)
    }
    
    private func dfsSolve(_ current: Int, _ visited: inout Set<Int>, _ adjacencyList: [Int: [Int]], _ results: inout [Bool]) {
        if let values = adjacencyList[current], values.isEmpty {
            results.append(true)
            return
        }
        
        if visited.contains(current) {
            results.append(false)
            return
        }
        
        visited.insert(current)
        for pre in adjacencyList[current] ?? [] {
            dfsSolve(pre, &visited, adjacencyList, &results)
//            visited.remove(current)
        }
    }
    
    func numberOfConnectedComponents(_ n: Int, _ prerequisites: [[Int]]) -> Int {
        var results = Set<Int>()
        var adjacencyList = [Int: [Int]]()
        for i in 0..<n {
            adjacencyList[i] = []
        }
        for pre in prerequisites {
            adjacencyList[pre[0]]?.append(pre[1])
        }
        
        var visited = Set<Int>()
        for adj in adjacencyList {
            dfsNumberOfConnectedComponents(adj.key, adjacencyList, &visited, &results)
        }
        
        return results.count
    }
    
    private func dfsNumberOfConnectedComponents(_ currentVertex: Int, _ adjacencyList: [Int: [Int]], _ visited: inout Set<Int>, _ results: inout Set<Int>) {
        if let value = adjacencyList[currentVertex], value.isEmpty {
            // store result
            results.insert(currentVertex)
            return
        }
        
        if visited.contains(currentVertex) {
            return
        }
        
        visited.insert(currentVertex)
        for edge in adjacencyList[currentVertex] ?? [] {
            dfsNumberOfConnectedComponents(edge, adjacencyList, &visited, &results)
        }
    }
    
    // does cycle exist?
    func isUndirectedGraphsCyclic(_ n: Int, _ prerequisites: [[Int]]) -> Bool {
        var parents = Array(repeating: -1, count: n)
        // n = 3 [-1, -1, -1]
        
        func find(v: Int) -> Int { // O(N)
            if parents[v] == -1 {
                return v
            }
            return find(v: parents[v])
        }
        
        func union(x: Int, y: Int) {
            // join at absolute parents
            let x = find(v: x) // find absolute parent
            let y = find(v: y) // find absolute parent
            parents[x] = y
        }
        
        
        func isCyclic(prerequisites: [[Int]]) -> Bool {
            for p in prerequisites {
                let fromP = find(v: p[0])
                let toP = find(v: p[1])
                
                if fromP == toP { // if both has single absolute root then the path exists
                    return true
                }
                // else union
                union(x: fromP, y: toP)
            }
            return false
        }
            
        if isCyclic(prerequisites: prerequisites) {
            return true
        } else {
            return false
        }
    }
    
    struct Node {
        var parent: Int
        var rank: Int
    }
    
    // with O(log n) for find and union
    func isUndirectedGraphsCyclic2(_ n: Int, _ prerequisites: [[Int]]) -> Bool {
        var parents = [Node]()
        for i in 0..<n {
            let node = Node(parent: -1, rank: 0)
            parents.append(node)
        }
        
        func find(v: Int) -> Int { // O(N)
            if parents[v].parent == -1 {
                return v
            }
            parents[v].parent = find(v: parents[v].parent) // path compression
            return parents[v].parent
        }
        
        func union(from: Int, to: Int) {
            // join at absolute parents
//            let x = find(v: x) // find absolute parent
//            let y = find(v: y) // find absolute parent
            // based on rank
            if parents[from].rank > parents[to].rank {
                parents[to].parent = from
            } else if parents[from].rank < parents[to].rank {
                parents[from].parent = to
            } else {
                // anyone can be the parent
                parents[from].parent = to
                parents[to].rank += 1
            }
        }
        
        
        func isCyclic(prerequisites: [[Int]]) -> Bool {
            for p in prerequisites {
                let fromP = find(v: p[0])
                let toP = find(v: p[1])
                
                if fromP == toP { // if both has single absolute root then the path exists
                    return true
                }
                // else union
                union(from: fromP, to: toP)
            }
            return false
        }
            
        if isCyclic(prerequisites: prerequisites) {
            return true
        } else {
            return false
        }
    }
    
    func countComponents(_ n: Int, _ prerequisites: [[Int]]) -> Int {
        var result = n
        var parents = Array(repeating: -1, count: n)
        // n = 3 [-1, -1, -1]
        
        func find(v: Int) -> Int { // O(N)
            if parents[v] == -1 {
                return v
            }
            return find(v: parents[v])
        }
        
        func union(x: Int, y: Int) {
            // join at absolute parents
            let x = find(v: x) // find absolute parent
            let y = find(v: y) // find absolute parent
            parents[x] = y
        }
        
        @discardableResult
        func isCyclic(prerequisites: [[Int]]) -> Bool {
            for p in prerequisites {
                let fromP = find(v: p[0])
                let toP = find(v: p[1])
                
                if fromP == toP { // if both has single absolute root then the path exists
                    return true
                }
                // else union
                union(x: fromP, y: toP)
                result -= 1
            }
            return false
        }
            
        isCyclic(prerequisites: prerequisites)
        
        return result
    }
    
    func closedIsland(_ grid: [[Int]]) -> Int {
        // 0 - land, 1 - water, island = land surrounded by water
        
        let row = grid.count
        let col = grid[0].count
        
        var grid = grid
        var result = 0
        
        if row <= 1 || col <= 1 {
            return result
        }
        
        for i in 1..<row - 1 {
            for j in 1..<col - 1 {
                if grid[i][j] == 0 {
                    closedIsland(&grid, i, j, row, col)
                    result += 1
                }
            }
        }
        
        return result
    }
    
    private func isOnParimeter(_ x: Int, _ y: Int, _ row: Int, _ col: Int) -> Bool {
        if x == 0 || x == row - 1 || y == 0 || y == col - 1 {
            return true
        }
        return false
    }
    
    private func closedIsland(_ grid: inout [[Int]], _ x: Int, _ y: Int, _ row: Int, _ col: Int) {
        
        if isOnParimeter(x, y, row, col) {
            return
        }
        
        if grid[x][y] == 1 || grid[x][y] == -1 {
            return
        }
        
        for choice in choices {
            grid[x][y] = -1
            closedIsland(&grid, x + choice.dx, y + choice.dy, row, col)
        }
    }
    
    
    
    func numIslands(_ grid: [[Character]]) -> Int {
        // 1 - land, 0 - water, island = land surrounded by water
        let row = grid.count
        let col = grid[0].count
        
        if row == 0 || col == 0 {
            return 0
        }
        
        var result = 0
        var grid = grid
        for i in 0..<row {
            for j in 0..<col {
                if grid[i][j] == "1" {
                    isIsland(&grid, i, j, row, col)
                    result += 1
                }
            }
        }
        
        return result
    }
    
    let choices = [
            Choice(direction: "u", dx: -1, dy: 0),
            Choice(direction: "d", dx: 1, dy: 0),
            Choice(direction: "l", dx: 0, dy: -1),
            Choice(direction: "r", dx: 0, dy: 1)
    ]
    
    private func isIsland(_ grid: inout [[Character]], _ x: Int, _ y: Int, _ row: Int, _ col: Int) {
        
        if !isValidnumIslands(x, y, row, col) {
            return
        }
        
        if grid[x][y] == "0" {
            return
        }
        
        for choice in choices {
            grid[x][y] = "0"
            isIsland(&grid, x + choice.dx, y + choice.dy, row, col)
        }
        
    }
    
    private func isValidnumIslands(_ x: Int, _ y: Int, _ row: Int, _ col: Int) -> Bool {
        if x >= 0, x < row, y >= 0, y < col {
            return true
        }
        return false
    }
    
//    func allPathsSourceTarget(_ graph: [[Int]]) -> [[Int]] {
//        // source = 0, dest = graph.count - 1
//        // [[1,2],[3],[3],[]]
//        
//        // create adj list
//        var adjList = [Int: [Int]]()
//        for (index, value) in graph.enumerated() {
//            adjList[index] = value
//        }
//        
//        var results = [[Int]]()
//        
//        // using BFS - Queue DS
//        var queue = [[Int]]() // using array
//        var visited = Set<[Int]>() // due to O(1) complexity
//        
//        queue.append(adjList[0]!) // source vertex
//        visited.insert(adjList[0]!)
//        
//        let goalNode = graph.count - 1
//        
//        while !queue.isEmpty {
//            // deque
//            let first = queue.removeFirst()
////            result.append(first)
//            // check for the neighbours
//            let neighbours = adjList[first]
//            for n in neighbours ?? [] {
//                if !visited.contains(n) {
//                    queue.append(n)
//                    visited.insert(n)
//                }
//            }
//        }
//        
//        return results
//        
//    }
    
    func allPathsSourceTarget2(_ graph: [[Int]]) -> [[Int]] {
        // [[1,2],[3],[3],[]]
        let target = graph.count - 1
        var results = [[Int]]()
        var queue = [(node: Int, path: [Int])]() // array of tuple
        
        // init
        queue.append((0, [0]))
        
        while !queue.isEmpty {
            let (node, path) = queue.removeFirst()
            if node == target {
                results.append(path)
            } else {
                for neighbor in graph[node] { // [1, 2]
                    queue.append((neighbor, path + [neighbor]))
                }
            }
        }
        return results
    }
    
    // detect cycle in directed graph
    // https://www.youtube.com/watch?v=GLxfoaZlRqs
    func isCyclic(_ n: Int, _ prerequisit: [[Int]]) -> Bool {
        // create adj list
        var adjList = [Int: [Int]]()
        for i in 0..<n {
            adjList[i] = []
        }
        for pre in prerequisit {
            adjList[pre[1]]?.append(pre[0])
        }
        
        // check cycle
        var visited = Array(repeating: false, count: n)
        var visitedFromDfs = Array(repeating: false, count: n)
        
        for v in adjList {
            if !visited[v.key] {
                if isCyclicDFS(adjList, v.key, &visited, &visitedFromDfs) {
                    return true
                }
            }
        }
        return false
    }
    
    private func isCyclicDFS(_ adjList: [Int: [Int]], _ v: Int, _ visited: inout[Bool], _ visitedFromDfs: inout[Bool]) -> Bool {
        visited[v] = true
        visitedFromDfs[v] = true
        
        for n in adjList[v] ?? [] {
            if !visited[n] {
                if isCyclicDFS(adjList, n, &visited, &visitedFromDfs) {
                    return true
                }
            } else if visitedFromDfs[n] {
                return true
            }
        }
        visitedFromDfs[v] = false
        return false
    }
    
    func findOrder2(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
        
        if isCyclic(numCourses, prerequisites) {
            return []
        }
        
        var adjList = [Int: [Int]]()
        for n in 0..<numCourses {
            adjList[n] = []
        }
        for prerequisite in prerequisites {
            adjList[prerequisite[1]]?.append(prerequisite[0])
        }
        
        var temp = [Int]() // can use result array
        var visited = Array(repeating: false, count: numCourses)
        
        // using topological sort algo
        for v in adjList {
            if !visited[v.key] {
                findOrder2Dfs(adjList, &visited, &temp, v.key)
            }
        }
        
        return temp.reversed()
        
    }
    
    private func findOrder2Dfs(_ adjList: [Int: [Int]], _ visited: inout [Bool], _ temp: inout [Int], _ v: Int) {
        
        visited[v] = true
        
        for n in adjList[v] ?? [] {
            if !visited[n] {
                findOrder2Dfs(adjList, &visited, &temp, n)
            }
        }
        temp.append(v) // backtrack and store
    }
    
    // 1443. Min time to collect all apples in a tree
    func minTime(_ n: Int, _ edges: [[Int]], _ hasApple: [Bool]) -> Int {
        var adjList = [Int: [Int]]()// [0: [1, 2], 1: [0, 4, 5], ....]
        for edge in edges {
            if adjList[edge[0]] == nil {
                adjList[edge[0]] = [edge[1]]
            } else {
                adjList[edge[0]]?.append(edge[1])
            }
            
            if adjList[edge[1]] == nil {
                adjList[edge[1]] = [edge[0]]
            } else {
                adjList[edge[1]]?.append(edge[0])
            }
        }
        
        
        func dfs(_ current: Int, _ parent: Int) -> Int {
            var time = 0
            for neighbour in adjList[current] ?? [] {
                if neighbour != parent {
                    let childTime = dfs(neighbour, current)
                    // calculate childTime
                    if hasApple[neighbour] || childTime > 0 {
                        time += 2 + childTime
                    }
                }
                
            }
            return time
        }
        
        return dfs(0, -1)
        
    }
    
}

extension GraphProblems {
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
