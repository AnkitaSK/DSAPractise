import Foundation

class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(val: Int, next: ListNode? = nil) {
        self.val = val
        self.next = next
    }
}

struct LinkedListProblems {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var newNode: ListNode?
        var currentNode: ListNode?
        
        var l1 = l1
        var l2 = l2
        
        var carry = 0
        
        while l1 != nil || l2 != nil {
            let sum = carry + (l1?.val ?? 0) + (l2?.val ?? 0)
            carry = Int(sum / 10)
            
            if newNode == nil {
                newNode = ListNode(val: sum % 10)
                currentNode = newNode
            } else {
                currentNode?.next = ListNode(val: sum % 10)
                currentNode = currentNode?.next
            }
            
            l1 = l1?.next
            l2 = l2?.next
        }
        
        if carry != 0 {
            currentNode?.next = ListNode(val: carry)
            carry = 0
        }
        
        return newNode
    }
    
    // 23. Merge k Sorted Lists
    func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
        var lists = lists
        if lists == nil || lists.count == 0 {
            return nil
        }
        
        while lists.count > 1 {
            var mergedLists = [ListNode?]()
            for i in stride(from: 0, through: lists.count - 1, by: 2) {
                let l1 = lists[i]
                let l2 = i + 1 < lists.count ? lists[i + 1] : nil
                mergedLists.append(merge2Lists(l1, l2))
            }
            lists = mergedLists
        }
        
        func merge2Lists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
            var l1 = l1
            var l2 = l2
            
            let dummyNode = ListNode(val: 0)
            var current = dummyNode
            
            while l1 != nil && l2 != nil {
                if l1!.val < l2!.val {
                    current.next = l1
                    l1 = l1?.next
                } else {
                    current.next = l2
                    l2 = l2?.next
                }
                current = current.next!
            }
            
            if l1 == nil {
                current.next = l2
            }
            
            if l2 == nil {
                current.next = l1
            }
            
            return dummyNode.next
        }
        
        return lists.first ?? nil
    }
}
