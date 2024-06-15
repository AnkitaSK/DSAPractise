import OrderedCollections

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

class Trees {
    // Level order traversal or the BFS traversal where the nodes are printed by their level
    // using queue -> time complexity O(n), space - O(n)
    func bfsTrees(root: TreeNode) {
        var queue = [TreeNode]() // using array
        queue.append(root)
        
        while !queue.isEmpty {
            let dequeued = queue.removeFirst()
            print(dequeued.val)
            if let leftNode = dequeued.left {
                queue.append(leftNode)
            }
            
            if let rightNode = dequeued.right {
                queue.append(rightNode)
            }
        }
    }
    
    // preorder traversal from left to right => NLR
    func leftViewTree(root: TreeNode?) -> [Int] {
        var dict: OrderedDictionary<Int, TreeNode> = [:]
        
        leftViewTreeUtil(root: root, level: 0)
        
        func leftViewTreeUtil(root: TreeNode?, level: Int) {
            if root == nil {
                return
            }
            
            if dict[level] == nil {
                dict[level] = root
            }
            
            leftViewTreeUtil(root: root?.left, level: level + 1)
            leftViewTreeUtil(root: root?.right, level: level + 1)
        }
        
        return dict.values.map{ $0.val }
    }
    
    // preorder traversal from right to left => NRL
    func rightViewTree(root: TreeNode?) -> [Int] {
        var dict: OrderedDictionary<Int, TreeNode> = [:]
        
        leftViewTreeUtil(root: root, level: 0)
        
        func leftViewTreeUtil(root: TreeNode?, level: Int) {
            if root == nil {
                return
            }
            
            if dict[level] == nil {
                dict[level] = root
            }
            
            leftViewTreeUtil(root: root?.right, level: level + 1)
            leftViewTreeUtil(root: root?.left, level: level + 1)
        }
        
        return dict.values.map{ $0.val }
    }
    
    // top order
    // level order traversal is needed
    func topViewTree(root: TreeNode) -> [Int] {
        var queue = [(Int,TreeNode)]()
        var dict: OrderedDictionary<Int, Int> = [:]
        
        queue.append((0, root))
        
        while !queue.isEmpty {
            let dequeue = queue.removeFirst()
            if dict[dequeue.0] == nil {
                dict[dequeue.0] = dequeue.1.val
            }
            
            if let leftNode = dequeue.1.left {
                queue.append((dequeue.0 - 1, leftNode))
            }
            if let rightNode = dequeue.1.right {
                queue.append((dequeue.0 + 1, rightNode))
            }
        }
        
        // 1st sort the dict by key order (ascending) and then print its value
        // this will print from left to right
        return dict.sorted(by: { $0.key < $1.key }).map{ $0.value }
    }
    
    func bottomView(root: TreeNode) -> [Int] {
        // stores horizontal distance and a treenode
        var queue = [(Int, TreeNode)]()
        var dict: Dictionary<Int, Int> = [:]
        
        queue.append((0, root))
        
        while !queue.isEmpty {
            let dequeue = queue.removeFirst()
            
            // logic for bottomview
            dict[dequeue.0] = dequeue.1.val
            
            // normal logic of level traversal
            if let leftNode = dequeue.1.left {
                queue.append((dequeue.0 - 1, leftNode))
            }
            
            if let rightNode = dequeue.1.right {
                queue.append((dequeue.0 + 1, rightNode))
            }
        }
        
        return dict.sorted(by: { $0.key < $1.key }).map{ $0.value }
    }
    
    // flatten BT or convert to the Doubly Linked List
    // inorder traversal
    // leftTree = left pointer, rightTree = next pointer
    
    func flattenTree(root: TreeNode?) -> TreeNode? {
        var head: TreeNode? = nil
        var prev: TreeNode? = nil
        
        flattenTree(root: root)
        
        func flattenTree(root: TreeNode?) {
            if root == nil {
                return
            }
            //LNR
            flattenTree(root: root?.left)
            
            if prev == nil {
                head = root
            } else {
                prev?.right = root
                root?.left = prev
            }
            prev = root
            
            flattenTree(root: root?.right)
        }
        
        return head
    }
    
    // diameter of BT
    // using DP on tree
    // 3 steps: base case, hypothesis, induction
    func diameterOfTree(root: TreeNode) -> Int {
        var result = Int.min
        
        diameter(root: root, result: &result)
        func diameter(root: TreeNode?, result: inout Int) -> Int {
            // bc
            if root == nil {
                return 0
            }
            
            // hypothesis (remains same)
            let left = diameter(root: root?.left, result: &result)
            let right = diameter(root: root?.right, result: &result)
            
            // induction
            // pass the value further, including the self count
            let temp = max(left, right) + 1
            // new possible result
            let ans = max(temp, left + right + 1)
            result = max(ans, result)
            
            return temp
        }
        return result
    }
    
}
