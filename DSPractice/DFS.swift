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
    
    // 79. word search
    // we will have to iterate through each row and col because
    // the word can start from any place.
    // bc - count == word.cout because
    // there can be more letters in the board than the word given. Therefore check for the count => 4
    func isTheWordPresent(_ board: [[Character]], _ word: String) -> Bool {
        
        var result = false
        var changingBoard = board
        let choices = [("U", -1, 0), ("D", 1, 0), ("L", 0, -1), ("R", 0, 1)]
        let n = board.count
        let m = board[0].count
        var path = ""
        for i in 0..<n {
            for j in 0..<m {
                dfs(board: &changingBoard, x: i, y: j, count: 0, path: &path)
            }
        }
        
        
        func dfs(board: inout[[Character]], x: Int, y: Int, count: Int, path: inout String) {
            
            if count == word.count {
                result = path == word
                return
            }
            
            if !isValid(board: board, x: x, y: y, count: count) {
                return
            }
            
            
            for choice in choices {
                path.append(board[x][y])
                let temp = board[x][y]
                board[x][y] = Character("-")
                
                dfs(board: &board, x: x + choice.1, y: y + choice.2, count: count + 1, path: &path)
                
                // backtrack
                board[x][y] = temp
                path.removeLast()
            }
            
        }
        
        func isValid(board: [[Character]], x: Int, y: Int, count: Int) -> Bool {
            if count < word.count && x >= 0 && x < n && y >= 0 && y < m && board[x][y] == Character(word[count]) && board[x][y] != Character("-") {
                return true
            }
            return false
        }
        return result
    }
    
    // 212. Word search 2
    // using DFS + trie
    // map the given words to be searched into the trie
    // in dfs compare for letter in the trie
    func findWords(_ board: [[Character]], _ words: [String]) -> [String] {
        let trie = Trie()
        for word in words {
            trie.addWord(word: word)
        }
        
        var result = Set<String>()
        let choices = [("u", -1, 0), ("d", 1, 0), ("l", 0, -1), ("r", 0, 1)]
        let n = board.count
        let m = board[0].count
        
        var boardValue = board
        var path = ""
        
        for i in 0..<n {
            for j in 0..<m {
                dfs(board: &boardValue, x: i, y: j, node: trie.root, path: &path)
            }
        }
        
        func dfs(board: inout [[Character]], x: Int, y: Int, node: TrieNode<Character>, path: inout String) {
            
            // base case
            if node.isTerminating {
                result.insert(path)
                return
            }
            
            if !isValid(board: board, x: x, y: y, trieNode: node) {
                return
            }
            
            for choice in choices {
                let nextNode = node.children[board[x][y]]!
                
                path.append(board[x][y])
                let temp = board[x][y]
                board[x][y] = Character("$")
                
                dfs(board: &board, x: x + choice.1, y: y + choice.2, node: nextNode, path: &path)
                // backtrack
                path.removeLast()
                board[x][y] = temp
            }
        }
        
        func isValid(board: [[Character]], x: Int, y: Int, trieNode: TrieNode<Character>) -> Bool {
            if x >= 0 && x < n && y >= 0 && y < m && board[x][y] != Character("$"), let node = trieNode.children[board[x][y]], node.value == board[x][y] {
                return true
            }
            return false
        }
        
        return result.sorted() // converting into set because of multiple entries
    }
}

extension Trie {
    func addWord(word: String) {
        guard !word.isEmpty else { return }
        var currentNode = root
        let characters = Array(word.lowercased())
        var charIndex = 0
        for char in characters {
            if let child = currentNode.children[char] {
                currentNode = child
            } else {
                currentNode.children[char] = TrieNode(value: char)
                currentNode = currentNode.children[char]!
            }
            charIndex += 1
        }
        
        if charIndex == word.count {
            currentNode.isTerminating = true
        }
    }
}
