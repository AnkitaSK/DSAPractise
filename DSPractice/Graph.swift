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
    
}
