class Node:

    def __init__(self, data,next=None):
        self.data = data
        self.next = next
    

class LinkedList:

    def __init__(self):
        self.front = None

    def printList(self):
        ptr = self.front
        while ptr:
            print(ptr.data)
            ptr = ptr.next
    
    def addToFront(self, data):
        newNode = Node(data)
        if self.front == None:
            self.front = newNode
            return 

        newNode.next = self.front
        self.front = newNode
        return self.front

    def reverse(self):
        prev = None
        current = self.front
        while current is not None:
            tmp = current.next
            current.next = prev
            prev = current
            current = tmp
        self.front = prev

    
if __name__ == "__main__":
    LL = LinkedList()
    LL.addToFront(1)
    LL.addToFront(2)
    LL.reverse()
    LL.printList()

    
            




        