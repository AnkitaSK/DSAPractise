//
//  Trie.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 26/05/24.
//

import Foundation

class TrieNode<T: Hashable> {
  var value: T?
  var children: [T: TrieNode] = [:]
  var isTerminating = false
  
  init(value: T? = nil) {
    self.value = value
  }
  
  func add(child: T) {
    guard children[child] == nil else { return }
    children[child] = TrieNode(value: child)
  }
}

class Trie {
  typealias Node = TrieNode<Character>
  fileprivate let root: Node
  
  init() {
    root = Node()
  }
}

extension Trie {
  func insert(word: String) {
    guard !word.isEmpty else { return }
    
    var currentNode = root
    
    let characters = Array(word.lowercased())
    var currentIndex = 0
  
    while currentIndex < characters.count {
      let character = characters[currentIndex]
      
      if let child = currentNode.children[character] {
        currentNode = child
      } else {
        currentNode.add(child: character)
        currentNode = currentNode.children[character]!
      }
      
      currentIndex += 1
      
      
      if currentIndex == characters.count {
        currentNode.isTerminating = true
      }
    }
  }
  
  func contains(word: String) -> Bool {
    guard !word.isEmpty else { return false }
    
    var currentNode = root
    
    let characters = Array(word.lowercased())
    var currentIndex = 0
    
    while currentIndex < characters.count, let child = currentNode.children[characters[currentIndex]] {
      currentIndex += 1
      currentNode = child
    }
    
    if currentIndex == characters.count && currentNode.isTerminating {
      return true
    } else {
      return false
    }
  }
}


extension Trie {
    
    private func getNode(_ word: String) -> TrieNode<Character>? {
        guard !word.isEmpty else { return nil }
        var current = root
        let characters = Array(word.lowercased())
        var count = characters.count
        for char in characters {
            if let child = current.children[char] {
                count -= 1
                current = child
            }
        }
        
        if count == 0 {
            return current
        }
        return nil
    }
    
    func search(_ word: String) -> Bool {
        if let node = getNode(word), node.isTerminating {
            return true
        }
        return false
    }
    
    func startsWith(_ prefix: String) -> Bool {
        if getNode(prefix) != nil {
            return true
        }
        return false
    }
}

// 211. Design Add and Search Words Data Structure
class WordDictionary {
    let root: TrieNode<Character>
    
    init() {
        root = TrieNode()
    }
    
    func addWord(_ word: String) {
        var current = root
        let characters = Array(word.lowercased())
        var count = characters.count
        for char in characters.reversed() {
            if let child = current.children[char] {
                current = child
            } else {
                current.children[char] = TrieNode(value: char)
                current = current.children[char]!
            }
            count -= 1
        }
        if count == 0 {
            current.isTerminating = true
        }
    }
    
    private func getNode(_ word: String) -> TrieNode<Character>? {
        guard !word.isEmpty else { return nil }
        var current = root
        let characters = Array(word.lowercased())
        var count = characters.count
        for char in characters.reversed() {
            if let child = current.children[char] {
                count -= 1
                current = child
            }
        }
        
        if count == 0 {
            return current
        }
        return nil
    }
    
    func search(_ word: String) -> Bool {
        let characters = Array(word.lowercased())
        if characters.first == "." {
            // simple search
            let editedWord = word.replacingOccurrences(of: ".", with: "")
            if let node = getNode(editedWord) {
                return true
            }
        } else {
            // prefix check
            let editedWord = String(word.replacingOccurrences(of: ".", with: "").reversed())
            if getNode(editedWord) != nil {
                return true
            }
        }
        return false
    }
}
