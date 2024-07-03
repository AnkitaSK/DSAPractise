import Foundation

class Solution {
    func isAnagram(_ s: String, _ t: String) -> Bool {
        var dict = [Character: Int]()
        for char in s {
            dict[char, default: .zero] += 1
        }

        for char in t {
            if let availChar = dict[char] {
                dict[char] = availChar - 1
            } else {
                return false
            }
        }

        return dict.values.allSatisfy{ $0 == .zero}
    }
    
    func groupCommonValuesByIndices(_ arr: [Int]) -> [[Int]] {
        var dict = [Int: [Int]]()
        
        for (index, value) in arr.enumerated() {
            if let _ = dict[value] {
                dict[value]?.append(index)
            } else {
                dict[value] = [index]
            }
        }
        
        var results = [[Int]]()
        for values in dict.values {
            results.append(values)
        }
        return results
    }
    
    
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        var dict = [UInt8: [String]]()
        
        for str in strs {
            
            let value = str.utf8.reduce(0) { partialResult, v in
                v - "a".utf8.first!
            }
            
            if let _ = dict[value] {
                dict[value]?.append(str)
            } else {
                dict[value] = [str]
            }
        }
        
        var results = [[String]]()
        for value in dict.values {
            results.append(value)
        }
        
        return results
    }
    
    func productExceptSelf(_ nums: [Int]) -> [Int] {
        var result = Array(repeating: 0, count: nums.count)
        var prefix = Array(repeating: 1, count: nums.count + 1)
        var postfix = Array(repeating: 1, count: nums.count + 1)
        
        for i in 0..<nums.count {
            if i == 0 {
                prefix[i] = 1 * nums[i]
            } else {
                prefix[i] = prefix[i - 1] * nums[i]
            }
        }
        
        for j in (0..<nums.count).reversed() {
            if j == nums.count - 1 {
                postfix[j] = 1 * nums[j]
            } else {
                postfix[j] = postfix[j + 1] * nums[j]
            }
        }
        
        for k in 0..<nums.count {
            if k == 0 {
                result[k] = 1 * postfix[k + 1]
            } else {
                result[k] = prefix[k - 1] * postfix[k + 1]
            }
        }
        
        return result
        
    }
    
    func isPalindrome(_ s: String) -> Bool {
        
        guard !s.isEmpty else {
            return true
        }
        
        let value = s.lowercased().filter{ $0.isLetter || $0.isNumber }
        
        var i = value.startIndex
        var j = value.index(before: value.endIndex)
        
        while i <= j {
            if value[i] == value[j] {
                i = value.index(after: i)
                j = value.index(before: j)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func threeSum(_ nums: [Int]) -> [[Int]] {
        let target = 0
        let numbers = nums.sorted()
        var start = 0
        var end = numbers.count - 1
        var results = [[Int]]()
        
        while start < numbers.count {
            var center = start + 1
            while center < end {
                let sum = numbers[start] + numbers[center] + numbers[end]
                if sum < target {
                    center += 1
                } else if sum > target {
                    end -= 1
                } else {
                    results.append([numbers[start], numbers[center], numbers[end]])
                    center += 1
                    end -= 1
                }
            }
            start += 1
        }

        return results
    }
    
    func maxArea(_ height: [Int]) -> Int {
        var result = Int.min
//        for l in 0..<height.count {
//            for r in (l + 1)..<height.count {
//                let area = min(height[l], height[r]) * (r - l)
//                result = max(result, area)
//            }
//        }
        
        var l = 0
        var r = height.count - 1
        
        while l < r {
            let area = min(height[l], height[r]) * (r - l)
            result = max(result, area)
            
            if height[l] < height[r] {
                l += 1
            } else {
                r -= 1
            }
        }
        
        return result
    }
    
    func trap(_ height: [Int]) -> Int {
        // algo -> min(maxL, maxR) - height[i]
        
        var maxL = Array(repeating: 0, count: height.count)
        for i in 0..<height.count {
            if i == 0 {
                maxL[i] = 0
            } else {
                maxL[i] = max(height[i - 1], maxL[i - 1])
            }
        }
        
        var maxR = Array(repeating: 0, count: height.count)
        for j in (0..<height.count).reversed() {
            if j == height.count - 1 {
                maxR[j] = 0
            } else {
                maxR[j] = max(height[j + 1], maxR[j + 1])
            }
        }
        
        //        var results = Array(repeating: 0, count: height.count)
        //        for k in 0..<height.count {
        //            let value = min(maxL[k], maxR[k]) - height[k]
        //            if value > 0 {
        //                results[k] = value
        //            } else {
        //                results[k] = 0
        //            }
        //        }
        
        var result = 0
        for k in 0..<height.count {
            result += max((min(maxL[k], maxR[k]) - height[k]), 0)
        }
        return result
        //        return results.reduce(0){ $0 + $1 }
    }
    
    func evalRPN(_ tokens: [String]) -> Int {
        var stack = [Int]()
        
        
        for token in tokens {
            switch(token) {
            case "+":
                stack.append(stack.removeLast() + stack.removeLast())
            case "-":
                var first = stack.removeLast()
                var second = stack.removeLast()
                var temp = -1
                
                if first < second {
                    temp = first
                    first = second
                    second = temp
                }
                stack.append(first - second)
            case "*":
                stack.append(stack.removeLast() * stack.removeLast())
            case "/":
                var first = stack.removeLast()
                var second = stack.removeLast()
                var temp = -1
                
                if first < second {
                    temp = first
                    first = second
                    second = temp
                }
                
                if second == 0 {
                    stack.append(0)
                } else {
                    stack.append(first / second)
                }
            default:
                stack.append(Int(token)!)
            }
        }
        
        return stack.last ?? -1
    }
    
    func generateParenthesis(_ n: Int) -> [String] {
        // if openCount == closeCount == n.count => result
        // if openCount < n => append "("
        // if openCount > closeCount => append ")"

        var stack = [String]()
        var results = [String]()

        func backTracking(_ openCount: Int, _ closeCount: Int) {
            if (openCount, closeCount) == (openCount, n) {
                results.append(stack.joined())
                return
            }
            
            if openCount < n {
                stack.append("(")
                backTracking(openCount + 1, closeCount)
                stack.removeLast()
            }

            if openCount > closeCount {
                stack.append(")")
                backTracking(openCount, closeCount + 1)
                stack.removeLast()
            }
        }

        backTracking(0, 0)
        return results
    }
    
    func dailyTemperatures(_ temperatures: [Int]) -> [Int] {
        var stack = [(Int, Int)]()
        var results = Array(repeating: 0, count: temperatures.count)
        
        for (i, temp) in temperatures.enumerated() {
            while !stack.isEmpty, temp > stack.last!.0 {
                let (_, index) = stack.removeLast()
                results[index] = i - index
            }
            stack.append((temp, i))
        }
        
        return results
    }
    
    func carFleet(_ target: Int, _ position: [Int], _ speed: [Int]) -> Int {
        var stack = [Int]()
        
        return stack.count
    }
    
    
    func search(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count
        
        while left < right {
            let mid = (left + right) / 2
            
            if nums[mid] == target {
                return mid
            } else if target > nums[mid] {
                left = mid
            } else {
                right = mid
            }
        }
        return -1
    }
    
    func minEatingSpeed(_ piles: [Int], _ h: Int) -> Int {
        guard piles.count > 0 else { return 0 }
        let maxValue = piles.max()
        var result = maxValue!
        var left = 1
        var right = maxValue!
        
        while left <= right {
            let mid = (left + right) / 2
            var hours = 0
            for p in piles {
                hours += Int(ceil(Double(p) / Double(mid)))
            }
            
            if hours <= h {
                result = min(result, mid)
                right = mid - 1
            } else {
                left = mid + 1
            }
        }
        
        return result
    }
    
    func findMin(_ nums: [Int]) -> Int {
        guard nums.count > 0 else { return 0 }
        var left = 0
        var right = nums.count - 1
        
        var result = Int.max
        
        while left <= right {
            
            if nums[left] <= nums[right] {
                result = min(result, nums[left])
                break
            } else {
                let mid = (left + right) / 2
                
                result = min(result, nums[mid])
                if nums[left] <= nums[mid] {
                    left = mid + 1
                } else {
                    right = mid - 1
                }
            }
        }
        
        return result
        
    }
    
    func searchTarget(_ nums: [Int], _ target: Int) -> Int {
        
        var left = 0
        var right = nums.count - 1
        
        while left <= right {
            let mid = (left + right) / 2
            if nums[mid] == target {
                return mid
            }
            
            // left part
            if nums[left] <= nums[mid] {
                if target < nums[left] {
                    left = mid + 1
                } else if target > nums[mid] {
                    left = mid + 1
                } else {
                    right = mid - 1
                }
            } else { // right part
                if target > nums[right] {
                    right = mid - 1
                } else if target < nums[mid] {
                    right = mid - 1
                } else {
                    left = mid + 1
                }
            }
        }
        
        return -1
    }
    
    func maxProfit(_ prices: [Int]) -> Int {
        var maxProfit = 0
        var left = 0
        var right = 1
        
        while right < prices.count {
            if prices[left] < prices[right] {
                maxProfit = max(maxProfit, prices[right] - prices[left])
            } else {
                left = right
            }
            right += 1
        }
        
        return maxProfit
    }
    
    func lengthOfLongestSubstring(_ s: String) -> Int {
        // sliding window problem
        // unique characters and longest, therefore right - left + 1 == dict (check for the presence of the unique characters)
        // if (while) dict.count < (right - left + 1), delete from dict
        
        var maxLength = 0
        var left = s.startIndex
        var right = s.startIndex
        var dict = [Character: Int]()
        
        while right < s.endIndex {
            dict[s[right], default: 0] += 1
            let window = s.distance(from: left, to: right) + 1
            
            if window == dict.count {
                // found a possible answer
                maxLength = max(maxLength, window)
            } else if dict.count < window {
                // shift the left pointer, before shifting remove the char associated from the left pointer from dict
                while dict.count < (s.distance(from: left, to: right) + 1), left < s.endIndex {
                    dict[s[left]]! -= 1
                    if dict[s[left]]! == 0 {
                        dict.removeValue(forKey: s[left])
                    }
                    left = s.index(after: left)
                }
            }
            right = s.index(after: right)
        }
        
        return maxLength
    }
    
    func characterReplacement(_ s: String, _ k: Int) -> Int {
        var result = 0
        var left = s.startIndex
        var right = s.startIndex
        var dict = [Character: Int]()
        
        func longestCharacter() -> Int {
            return dict.values.sorted(by: >).first ?? 0
        }
        
        while right < s.endIndex {
            dict[s[right], default: 0] += 1
            let window = s.distance(from: left, to: right) + 1
            let longestCharacterCount = longestCharacter() // TODO:
            
            if window - longestCharacterCount <= k {
                result = max(result, window)
                right = s.index(after: right)
            } else {
                while((s.distance(from: left, to: right) + 1) - longestCharacterCount > k) {
                    dict[s[left]]! -= 1
                    if dict[s[left]]! == 0 {
                        dict.removeValue(forKey: s[left])
                    }
                    left = s.index(after: left)
                }
                right = s.index(after: right)
            }
        }
        
        return result
    }
    
    func checkInclusion(_ s1: String, _ s2: String) -> Bool {
        
        guard s2.count >= s1.count else { return false }
        
        var s1Dict = [Character: Int]()
        var s2Dict = [Character: Int]()
        
        var left = s1.startIndex
        var right = s2.startIndex
        
        while right < s1.endIndex {
            s1Dict[s1[right], default: 0] += 1
            s2Dict[s2[right], default: 0] += 1
            right = s1.index(after: right)
        }
        
        right = s1.index(before: right)
        while right < s2.endIndex {
            if s1Dict == s2Dict {
                return true
            }
            right = s2.index(after: right)
            
            if right != s2.endIndex {
                s2Dict[s2[right], default: 0] += 1
                s2Dict[s2[left], default: 0] -= 1
                if s2Dict[s2[left]] == 0 {
                    s2Dict.removeValue(forKey: s2[left])
                }
                left = s2.index(after: left)
            }
        }
        
        return false
    }
    
    func invertTree(_ root: TreeNode?) -> TreeNode? {
        // recurssion
        if root == nil {
            return nil
        }
        
        let left = invertTree(root?.left)
        let right = invertTree(root?.right)
        
        root?.left = right
        root?.right = left
        
        return root
    }
    
}

let test = Solution()
//print(test.isAnagram("aabbbb", "aaaabb"))
//print(test.groupCommonValuesByIndices([1,1,2,3,1]))
//print(test.groupAnagrams(["cab","tin","pew","duh","may","ill","buy","bar","max","doc"]))
//print(test.productExceptSelf([1,2,3,4]))
//print(test.isPalindrome(""))
//print(test.threeSum([-1,0,1,2,-1,-4]))
// [-4 -1 -1 0 1 2]
//print(test.maxArea([1,8,6,2,5,4,8,3,7]))
//print(test.trap([0,1,0,2,1,0,1,3,2,1,2,1]))
//print(test.evalRPN(["3","11","5","+","-"]))
//print(test.generateParenthesis(3))
//print(test.dailyTemperatures([73,74,75,71,69,72,76,73]))
//print(test.carFleet(12, [10,8,0,5,3], [2,4,1,1,3]))
//print(test.search([-1,0,3,5,9,12], 9))
//print(test.minEatingSpeed([3,6,7,11], 8))
//print(test.findMin([3,1,2]))
//print(test.searchTarget([4,5,6,7,0,1,2], 0))
//print(test.maxProfit([7,1,5,3,6,4]))
//print(test.lengthOfLongestSubstring("pwwkew"))
//print(test.characterReplacement("AABABBA", 1))
//print(test.checkInclusion("ab", "ab"))
//let root = TreeNode(2, TreeNode(1), TreeNode(3))
let root2 = TreeNode(2, TreeNode(1, TreeNode(5), TreeNode(6)), TreeNode(3, TreeNode(7), TreeNode(8)))
//let testValue = test.invertTree(root)
//print("\(testValue?.val), \(testValue?.left?.val), \(testValue?.right?.val)")

let computation = Computation()
//print(computation.maxDepth(root2))

/// using level order traversal
let depth = computation.maxDepth(root2)
//for i in 1...depth {
//    var level = i
//    computation.printLeafNodes(root2, &level)
//}


let root3 = TreeNode(1, TreeNode(2, TreeNode(4), TreeNode(5)), TreeNode(3))
////print(computation.maxDepth(root3))
//print(computation.diameterOfTree(root3))

let root4 = TreeNode(1, TreeNode(2), nil)
//print(computation.maxDepth(root4))
//print(computation.diameterOfTree(root4))


//let root = TreeNode(1)
//root.left = TreeNode( 2)
//root.right = TreeNode(3)
//root.left?.left = TreeNode(4)
//root.left?.right = TreeNode(5)

let root = TreeNode(1)
root.left = TreeNode( 2)
root.right = TreeNode(2)
root.left?.left = TreeNode(3)
root.right?.right = TreeNode(3)
root.left?.left?.left = TreeNode(4)
root.right?.right?.right = TreeNode(4)

//print(computation.isBalanced(root))

let tree1 = TreeNode(1, TreeNode(2), nil)
let tree2 = TreeNode(1, nil, TreeNode(2))
//print(computation.isSameTree(tree1, tree2))

let tree3 = TreeNode(3, TreeNode(4, TreeNode(1), TreeNode(2)), TreeNode(5))
let subTree = TreeNode(4, TreeNode(1), TreeNode(2))
//print(computation.isSubtree(tree3, subTree))


class Computation {
    
    func printLeafNodes(_ root: TreeNode?, _ level: inout Int) {
        // need a BFS traversal
          // need height of the tree
        if root == nil {
            return
        }
        
        if level == 1 {
            print("\(String(describing: root?.val))")
        } else if level > 1 {
            var tempLevel = level - 1
            printLeafNodes(root?.left, &tempLevel)
            printLeafNodes(root?.right, &tempLevel)
        }
        
    }


    func maxDepth(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        }
        
        let leftDepth = maxDepth(root?.left)
        let rightDepth = maxDepth(root?.right)
        
        return max(leftDepth, rightDepth) + 1
    }
    
    // longest length of a tree
    var diameter = 0
    func diameterOfTree(_ root: TreeNode?) -> Int {
        // use dfs
        dfs(root)
        
        return diameter
    }
    
    private func dfs(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        }
        
        let leftTree = dfs(root?.left)
        let rightTree = dfs(root?.right)
        
        // update diameter if path through current node is longest
        diameter = max(diameter, leftTree + rightTree)
        
        // return height of the subtree rooted at the current node
        return max(leftTree, rightTree) + 1
    }
    
    
    func isBalanced(_ root: TreeNode?) -> Bool {
        
        guard root != nil else { return true }
        
        let leftTreeHeight = height(root?.left)
        let righTreeHeight = height(root?.right)
        
        if abs(leftTreeHeight - righTreeHeight) <= 1 && isBalanced(root?.left) && isBalanced(root?.right) {
            return true
        }
        
        return false
    }
    
    private func height(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        }
        
        let leftTreeHeight = height(root?.left)
        let rightTreeHeight = height(root?.right)
        
        return max(leftTreeHeight, rightTreeHeight) + 1
    }
    
    func isSubtree(_ root: TreeNode?, _ subRoot: TreeNode?) -> Bool {
        
        // base condition
        if root == nil && subRoot == nil { return true }
        if root == nil || subRoot == nil { return false }
        
        // if not same tree then check left subtree with subroot
        if isSameTree(root, subRoot) == false {
            let leftSubTreeCheck = isSubtree(root?.left, subRoot)
            let rightSubTreeCheck = isSubtree(root?.right, subRoot)
            
            return leftSubTreeCheck || rightSubTreeCheck
        } else {
            return true
        }
        
    }
    
    func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        
        if p == nil && q == nil { return true }
        if p == nil || q == nil { return false }
        
        if p?.val == q?.val {
            let isLeftTreeSame = isSameTree(p?.left, q?.left)
            let isRightTreeSame = isSameTree(p?.right, q?.right)
            
            return isLeftTreeSame && isRightTreeSame
        } else {
            return false
        }
    }
    
    
    var result = [[Int]]()
    var tempResult = [Int]()
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard root != nil else { return [] }
        let height = maxDepth(root)
        for i in 1...height {
            bfs(root, i)
            result.append(tempResult)
            tempResult.removeAll()
        }
        return result
    }
    
    private func bfs(_ root: TreeNode?, _ level: Int) {
        if root == nil { return }
        
        if level > 1 {
            let tempLevel = level - 1
            bfs(root?.left, tempLevel)
            bfs(root?.right, tempLevel)
        } else if level == 1 {
            tempResult.append(root!.val)
        }
    }
    
    var results2 = [Int]()
    func rightSideView(_ root: TreeNode?) -> [Int] {
        if root == nil { return [] }
        
        traverse(root, 0)
        return results2
    }
    
    private func traverse(_ root: TreeNode?, _ level: Int) {
        if root == nil { return }
        
        if results2.count == level {
            results2.append(root!.val)
        }
        traverse(root?.right, level + 1)
        traverse(root?.left, level + 1)
    }
    
    var goodNodeCount = 0
    func goodNodes(_ root: TreeNode?) -> Int {
        if root == nil { return 0 }
        traverse2(root, Int.min)
        return goodNodeCount
    }
    
    private func traverse2(_ root: TreeNode?, _ maxValueInPath: Int) {
        
        if root == nil {
            return
        }
        
        if root!.val >= maxValueInPath {
            goodNodeCount += 1
        }
        
        let tempHigh = max(maxValueInPath, root!.val)
        traverse2(root?.left, tempHigh)
        traverse2(root?.right, tempHigh)
    }
    
    
    func isValidBST(_ root: TreeNode?) -> Bool {
        return traverseForBSTCheck(root, max: nil, min: nil)
    }
    
    func traverseForBSTCheck(_ root: TreeNode?, max: Int?, min: Int?) -> Bool {
        if root == nil {
            return true
        }
        
        if let maxVal = max, root!.val >= maxVal {
            return false
        }
        
        if let minVal = min, root!.val <= minVal {
            return false
        }
        
        return traverseForBSTCheck(root?.left, max: root?.val, min: min) && traverseForBSTCheck(root?.right, max: max, min: root?.val)
    }
    
    
    func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
        var count = 0
        return kthSmallestTraverse(root, count: &count, k) ?? 0
    }
    
    // in order traversal because in BST this traversal visits in ascending order
    func kthSmallestTraverse(_ root: TreeNode?, count: inout Int, _ k: Int) -> Int? {
        if root == nil {
            return nil
        }
        
        
        if let left = kthSmallestTraverse(root?.left, count: &count, k) {
            return left
        }
        
        count += 1
        if count == k {
            return root!.val //count // or
        }
        
        return kthSmallestTraverse(root?.right, count: &count, k)
    }
    
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        if root == nil {
            return nil
        }
        
        let rootValue = root!.val
        let pValue = p!.val
        let qValue = q!.val
        
        if pValue < rootValue && qValue < rootValue {
            return lowestCommonAncestor(root?.left, p, q)
        }
        
        if pValue > rootValue && qValue > rootValue {
            return lowestCommonAncestor(root?.right, p, q)
        }
        
        return root
    }
}

let root5 = TreeNode(2, TreeNode(1, TreeNode(5), TreeNode(6)), TreeNode(3, TreeNode(7), TreeNode(8)))
let temp = Computation()
//print(computation.levelOrder(root5))

let root6 = TreeNode(1, TreeNode(2), nil)
//print(computation.rightSideView(root5))

let root7 = TreeNode(5, TreeNode(4), TreeNode(6, TreeNode(3), TreeNode(7)))
//let root8 = TreeNode(2, TreeNode(1), TreeNode(3))
//print(computation.isValidBST(root7))


//let root7 = TreeNode(2, nil, TreeNode(4, TreeNode(10), TreeNode(8, TreeNode(4), nil)))
//print(computation.goodNodes(root7))

let root9 = TreeNode(5, TreeNode(3, TreeNode(2, TreeNode(1), nil), TreeNode(4)), TreeNode(6))
//print(computation.kthSmallest(root9, 3))

let root10 = TreeNode(6, TreeNode(2, TreeNode(0), TreeNode(4, TreeNode(3), TreeNode(5))), TreeNode(8, TreeNode(7), TreeNode(9)))

//let root11 = TreeNode(6)
//root11.left = TreeNode(2)
//root11.right = TreeNode(value: 8)
//root11.left?.left = TreeNode(value: 0)
//root11.left?.right = TreeNode(value: 4)
//root11.right?.left = TreeNode(value: 7)
//root11.right?.right = TreeNode(value: 9)
//root11.left?.right?.left = TreeNode(value: 3)
//root11.left?.right?.right = TreeNode(value: 5)

let p = root10.left!.left! // Node with value 0
let q = root10.left!.right!.right! // Node with value 5

//print(computation.lowestCommonAncestor(root10, p, q)?.val)


let backTracking = Backtracking()
//print(backTracking.permute([1, 2, 3]))

//print(backTracking.subsets([1, 2, 3]))

//print(backTracking.subsets2([4,4,4,1,4]))
//print(backTracking.numberOfPaths([[5,2,4],[3,0,5],[0,7,2]], 3))
//print(backTracking.getMaximumGold([[0,6,0],[5,8,7],[0,9,0]]))
//print(backTracking.maxAreaOfIsland([[0,0,1,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,1,1,1,0,0,0],[0,1,1,0,1,0,0,0,0,0,0,0,0],[0,1,0,0,1,1,0,0,1,0,1,0,0],[0,1,0,0,1,1,0,0,1,1,1,0,0],[0,0,0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,1,1,1,0,0,0],[0,0,0,0,0,0,0,1,1,0,0,0,0]]))

//print(backTracking.largestIsland([[1,0],[0,1]]))
//var test14: [[Character]] = [["X","X","X","X"],["X","O","O","X"],["X","X","O","X"],["X","O","X","X"]]
//print(backTracking.surroundedRegionFlip(&test14))


let stringProblems = StringProblems()
//print(stringProblems.solve1(s: "mkteneetkybe", t: "e"))
//print(stringProblems.solve2(s: "c23cb24d8hy23"))
//print(stringProblems.maximumSwap(98368))
//print(stringProblems.permutation(s: "abc"))
//print(stringProblems.digitsInIncreasingOrder(n: 3))
//print(stringProblems.partition("aab"))
//print(stringProblems.combinationSum([2,3,6,7], 7))
//print(stringProblems.subsets([1,2,3]))
//print(stringProblems.subsetsWithDup([1,2,2]))


let stackProblems = StackProblems()
//print(stackProblems.nextGreaterElement([1,2,1]))
//print(stackProblems.nextGreaterElementToLeftIndices([1,2,1]))
//print(stackProblems.span([100,80,60,70,60,75,85]))
//print(stackProblems.nearestSmallestToRightIndices([1,2,1]))
//print(stackProblems.largestRectangleArea([2, 3]))



let graph = AdjacencyList<String>()

let singapore = graph.createVertex(data: "Singapore")
let tokyo = graph.createVertex(data: "Tokyo")
let hongKong = graph.createVertex(data: "Hong Kong")
let detroit = graph.createVertex(data: "Detroit")
let sanFrancisco = graph.createVertex(data: "San Francisco")
let washingtonDC = graph.createVertex(data: "Washington DC")
let austinTexas = graph.createVertex(data: "Austin Texas")
let seattle = graph.createVertex(data: "Seattle")

let testCity = graph.createVertex(data: "testCity")

graph.add(.undirected, from: singapore, to: hongKong, weight: 300)
graph.add(.undirected, from: singapore, to: tokyo, weight: 500)
graph.add(.undirected, from: hongKong, to: tokyo, weight: 250)
graph.add(.undirected, from: tokyo, to: detroit, weight: 450)
graph.add(.undirected, from: tokyo, to: washingtonDC, weight: 300)
graph.add(.undirected, from: hongKong, to: sanFrancisco, weight: 600)
graph.add(.undirected, from: detroit, to: austinTexas, weight: 50)
graph.add(.undirected, from: austinTexas, to: washingtonDC, weight: 292)
graph.add(.undirected, from: sanFrancisco, to: washingtonDC, weight: 337)
graph.add(.undirected, from: washingtonDC, to: seattle, weight: 277)
graph.add(.undirected, from: sanFrancisco, to: seattle, weight: 218)
graph.add(.undirected, from: austinTexas, to: sanFrancisco, weight: 297)

graph.add(.undirected, from: testCity, to: sanFrancisco, weight: 297)

//print(graph)

//let vertices = graph.breadthFirstSearch(from: testCity, to: detroit)
//vertices.forEach { vertex in
//  print(vertex)
//}


//let graph2 = AdjacencyList<String>()
//let one = graph2.createVertex(data: "1")
//let two = graph2.createVertex(data: "2")
//let three = graph2.createVertex(data: "3")
//let four = graph2.createVertex(data: "4")
//let five = graph2.createVertex(data: "5")
//
//graph2.add(.undirected, from: one, to: two, weight: 1)
//graph2.add(.undirected, from: one, to: five, weight: 1)
//
//graph2.add(.undirected, from: two, to: three, weight: 1)
//graph2.add(.undirected, from: two, to: four, weight: 1)
//
//graph2.add(.undirected, from: three, to: four, weight: 1)
//graph2.add(.undirected, from: four, to: five, weight: 1)
//
//let vertices2 = graph2.depthFirstSearch(source: one)
//vertices2.forEach { vertex in
//    print(vertex)
//}


//print(backTracking.numIslands([
//    ["1","1","1","1","0"],
//    ["1","1","0","1","0"],
//    ["1","1","0","0","0"],
//    ["0","0","0","0","0"]
//  ]))

//print(backTracking.shortestPathBinaryMatrix([[0,0,1,1,0,0],[0,0,0,0,1,1],[1,0,1,1,0,0],[0,0,1,1,0,0],[0,0,0,0,0,0],[0,0,1,0,0,0]]))

let graphProblems = GraphProblems()
//print(graphProblems.canFinish(2, [[1, 0], [0, 1]]))
//print(graphProblems.numberOfConnectedComponents(5, [[0,1],[1,2],[3,4]]))
//graphProblems.findOrder(4, [[1,0],[2,0],[3,1],[3,2]])
//print(graphProblems.isUndirectedGraphsCyclic(5, [[0,1],[1,2], [3,4]]))
//print(graphProblems.isUndirectedGraphsCyclic2(5, [[0,1],[1,2], [3,4]]))
//print(graphProblems.countComponents(3, [[0,1],[1,2],[0,2]]))
//print(graphProblems.numIslands([
//    ["1","1","0","0","0"],
//    ["1","1","0","0","0"],
//    ["0","0","1","0","0"],
//    ["0","0","0","1","1"]
//  ]))
//print(graphProblems.closedIsland([[0,0,1,1,0,1,0,0,1,0],[1,1,0,1,1,0,1,1,1,0],[1,0,1,1,1,0,0,1,1,0],[0,1,1,0,0,0,0,1,0,1],[0,0,0,0,0,0,1,1,1,0],[0,1,0,1,0,1,0,1,1,1],[1,0,1,0,1,1,0,0,0,1],[1,1,1,1,1,1,0,0,0,0],[1,1,1,0,0,1,0,1,0,1],[1,1,1,0,1,1,0,1,1,0]]))
//print(graphProblems.allPathsSourceTarget2([[1,2],[3],[3],[]]))
//print(graphProblems.isCyclic(2, [[1,0],[0,1]]))
//print(graphProblems.findOrder2(4, [[1,0],[2,0],[3,1],[3,2]]))

/*
 matrix check
 */

//let n = 2
//let w = 1
//var matrix = Matrix(rows: n + 1, columns: w + 1)
//matrix[0, 1] = 1.5
//matrix[1, 0] = 3.2


//print(matrix)
//print(matrix[2,2])





//print(matrix)

let dynamicProgramming = DP()
//print(dynamicProgramming.knapsackTopDown(nArray: [1, 2, 3, 5], w: 7))
//print(dynamicProgramming.subsetSum(arr: [2, 3, 7, 8, 10], sum: 11))

//print(dynamicProgramming.equalSumPartition(arr: [1, 5, 11, 6]))
//print(dynamicProgramming.countSubsetSumWithGivenSum(arr: [1, 1, 2, 3], sum: 4))

//print(dynamicProgramming.countSubsetSumWithGivenSumTopDown(arr: [1, 1, 2, 3], sum: 4))

//print(dynamicProgramming.coinChange([1, 2, 3], 5))
//print(dynamicProgramming.coinChange2([1,2,5], 5))
//print(dynamicProgramming.coinChange2(5, [1,2,5]))
//print(dynamicProgramming.coinChange1([2], 3))
//print(dynamicProgramming.lengthOfLIS([3,5,6,2,5,4,19,5,6,7,12]))


let lcs = LCS()
//print(lcs.longestCommonSubsequence("fcvafurqjylclorwfoladwfqzkbebslwnmpmlkbezkxoncvwhstwzwpqxqtyxozkpgtgtsjobujezgrkvevklmludgtyrmjaxyputqbyxqvupojutsjwlwluzsbmvyxifqtglwvcnkfsfglwjwrmtyxmdgjifyjwrsnenuvsdedsbqdovwzsdghclcdexmtsbexwrszihcpibwpidixmpmxshwzmjgtadmtkxqfkrsdqjcrmxkbkfoncrcvoxuvcdytajgfwrcxivixanuzerebuzklyhezevonqdsrkzetsrgfgxibqpmfuxcrinetyzkvudghgrytsvwzkjulmhanankxqfihenuhmfsfkfepibkjmzybmlkzozmluvybyzsleludsxkpinizoraxonmhwtkfkhudizepyzijafqlepcbihofepmjqtgrsxorunshgpazovuhktatmlcfklafivivefyfubunszyvarcrkpsnglkduzaxqrerkvcnmrurkhkpargvcxefovwtapedaluhclmzynebczodwropwdenqxmrutuhehadyfspcpuxyzodifqdqzgbwhodcjonypyjwbwxepcpujerkrelunstebopkncdazexsbezmhynizsvarafwfmnclerafejgnizcbsrcvcnwrolofyzulcxaxqjqzunedidulspslebifinqrchyvapkzmzwbwjgbyrqhqpolwjijmzyduzerqnadapudmrazmzadstozytonuzarizszubkzkhenaxivytmjqjgvgzwpgxefatetoncjgjsdilmvgtgpgbibexwnexstipkjylalqnupexytkradwxmlmhsnmzuxcdkfkxyfgrmfqtajatgjctenqhkvyrgvapctqtyrufcdobibizihuhsrsterozotytubefutaxcjarknynetipehoduxyjstufwvkvwvwnuletybmrczgtmxctuny", "nohgdazargvalupetizezqpklktojqtqdivcpsfgjopaxwbkvujilqbclehulatshehmjqhyfkpcfwxovajkvankjkvevgdovazmbgtqfwvejczsnmbchkdibstklkxarwjqbqxwvixavkhylqvghqpifijohudenozotejoxavkfkzcdqnoxydynavwdylwhatslyrwlejwdwrmpevmtwpahatwlaxmjmdgrebmfyngdcbmbgjcvqpcbadujkxaxujudmbejcrevuvcdobolcbstifedcvmngnqhudixgzktcdqngxmruhcxqxypwhahobudelivgvynefkjqdyvalmvudcdivmhghqrelurodwdsvuzmjixgdexonwjczghalsjopixsrwjixuzmjgxydqnipelgrivkzkxgjchibgnqbknstspujwdydszohqjsfuzstyjgnwhsrebmlwzkzijgnmnczmrehspihspyfedabotwvwxwpspypctizyhcxypqzctwlspszonsrmnyvmhsvqtkbyhmhwjmvazaviruzqxmbczaxmtqjexmdudypovkjklynktahupanujylylgrajozobsbwpwtohkfsxeverqxylwdwtojoxydepybavwhgdehafurqtcxqhuhkdwxkdojipolctcvcrsvczcxedglgrejerqdgrsvsxgjodajatsnixutihwpivihadqdotsvyrkxehodybapwlsjexixgponcxifijchejoxgxebmbclczqvkfuzgxsbshqvgfcraxytaxeviryhexmvqjybizivyjanwxmpojgxgbyhcruvqpafwjslkbohqlknkdqjixsfsdurgbsvclmrcrcnulinqvcdqhcvwdaxgvafwravunurqvizqtozuxinytafopmhchmxsxgfanetmdcjalmrolejidylkjktunqhkxchyjmpkvsfgnybsjedmzkrkhwryzan"))
//print(lcs.numDistinct("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"))

//print(lcs.longestCommonSubstring("babad", "dabab"))

//print(lcs.shortestCommonSupersequence("bbbaaaba", "bbababbb"))

let sliding = SlidingWindow()
//print(sliding.findOccurenceOfAnagrams("cbaebabacd", "abc"))
//print(sliding.maxOfAllSubarrays(array: [1,3,-1,-3,5,3,6,7], k: 3))
//print(sliding.largestSubArray(array: [4,1,1,2,3,5], k: 5))
//print(sliding.longestSubstring(s: "aabacbebec", k: 3))


//let twoPointers = TwoPointers()
//print(twoPointers.isSubsequence("abc", "ahbgdc"))
//
//print(lcs.isSubsequence("axc", "ahbgdc"))
//print(lcs.longestCommonSubsequence("axc", "ahbgdc"))


let binarySearch = BinarySearch()
//print(binarySearch.peakIndexInMountainArray([3,5,3,2,0]))
//print(binarySearch.findMin([1, 3, 5]))
//print(binarySearch.numberOfTimesRotated([2, 5, 6, 8, 11, 12, 15, 18]))
//print(binarySearch.binarySearch(arr: [1, 2, 3, 4, 5], start: 0, end: 4, element: 6))

//print(binarySearch.search([1, 3, 5], 3))

//print(binarySearch.findPeakElement([1]))

//print(binarySearch.searchMatrix([[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], 5))
//print(binarySearch.minEatingSpeed([3,6,7,11], 8))
//print(binarySearch.splitArray([7,2,5,10,8], 2))
//print(binarySearch.shipWithinDays([1,2,3,4,5,6,7,8,9,10], 5))
//print(binarySearch.shipWithinDays([1,2,3,4,5,6,7,8,9,10], 5))
//print(binarySearch.smallestDivisor([44,22,33,11,1], 5))
//print(binarySearch.minDays([7,7,7,7,12,7,7], 2, 3))
//print(binarySearch.firstOccurance([2,4,10,10,10,18,20], k: 10))
//print(binarySearch.lastOccurance([2,4,10,10,10,18,20], k: 10))
//print(binarySearch.countElement([2,4,10,10,10,18,20], k: 10))

let graphRevision = GraphRevision()
//print(graphRevision.isCycleForDirected(2, [[1, 0], [0, 1]]))
//print(graphRevision.isCycleForUndirected(3, [[1, 2], [0, 2], [0, 1]]))
//print(graphRevision.topologicalSort(4, [[1,0],[2,0],[3,1],[3,2]]))
//print(graphRevision.pacificAtlantic([[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]]))
//print(graphRevision.findRedundantConnection([[3,7],[1,4],[2,8],[1,6],[7,9],[6,10],[1,7],[2,3],[8,9],[5,9]]))
//print(graphRevision.orangesRotting([[0,2]]))
//print(graphRevision.maximumDetonation([[2,1,3],[6,1,4]]))


//let heapSolutions = HeapProblems()
//print(heapSolutions.findKthLargest([3,2,1,5,6,4], 2))


//let trie = Trie()
//
//trie.insert(word: "cute")
//print(trie.contains(word: "cute")) // true
//
//print(trie.contains(word: "cut")) // false
//trie.insert(word: "cut")
//print(trie.contains(word: "cut")) // true
//
//print(trie.search("cut")) // true
//print(trie.startsWith("cu")) // true


// [[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
//let wordDictionary = WordDictionary()
//wordDictionary.addWord("bad")
//wordDictionary.addWord("dad")
//wordDictionary.addWord("mad")
//
//print(wordDictionary.search("pad"))
//print(wordDictionary.search("bad"))
//print(wordDictionary.search(".ad"))
//print(wordDictionary.search("b.."))

let bitwise = Bitwise()
//bitwise.containsDuplicate([1, 2, 3, 4 ])
//print(bitwise.getSum(2, 3))


//print(removeSmallerElements(array: [3, -1], element: -3))

let treeNode1 = TreeNode(4, TreeNode(5, TreeNode(7), TreeNode(9)), TreeNode(1))

let trees = Trees()
//trees.bfsTrees(root: treeNode1)

//print(trees.leftViewTree(root: treeNode1))
//print(trees.rightViewTree(root: treeNode1))
//print(trees.topViewTree(root: treeNode1))
//print(trees.bottomView(root: treeNode1))
//print(trees.flattenTree(root: treeNode1) as Any)
let treeNode2 = TreeNode(4, TreeNode(5), TreeNode(1))
//print(trees.diameterOfTree(root: treeNode2))
//print(trees.maxSumBetweenNodes(root: treeNode2))

let treeNode3 = TreeNode(8, TreeNode(6), TreeNode(12, TreeNode(10), nil))
//print(trees.sumIsPresent(root: treeNode3, k: 14))
//print(trees.lcsBST(root: treeNode1, p: 7, q: 9))

let arrayProblem = ArrayProblems()
//print(arrayProblem.topKFrequent([4,1,-1,2,-1,2,3], 2))
//print(arrayProblem.findKthLargest([1], 1))
//print(arrayProblem.findKthLargest2([1], 1))

let recurssion = RecurssionProblems()
//recurssion.printValues(7)
//recurssion.printValuesReverse(7)
//print(recurssion.heightOfTree(node: treeNode3))
var arr = [1,2,3,4,5,6]
//recurssion.sortArray(arr: &arr)
//recurssion.deleteMiddle(arr: &arr)
//recurssion.reverse(&arr)
//print(arr)

//recurssion.printSubsets("ab")
//recurssion.printPermutations("ABC")
//recurssion.printPermutationsWithCaseChange("AB")
//recurssion.printPermutationsForCases("a1B2")
//print(recurssion.generateBalancedParanthesis(n: 2))
recurssion.prefixOne(n: 3)
