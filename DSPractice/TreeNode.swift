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
}
