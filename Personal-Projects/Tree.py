# Here is an implementation of a Tree in Python. I haven't done anything with it yet but I plan to soon.

class BSTNode:

    def __init__ (self, data, left, right):
        self.data = data
        self.left = left
        self.right = right
    

class Tree:

    def __init__(self, size):
        self.root = BSTNode(None, None, None)
        self.size = 0
    
    def insert(self, data):
        ptr = self.root
        prev = None
        c = 0
        while ptr is not None:
            c = data.compareTo(ptr.data)
            if c == 0:
                raise ValueError('Duplicate, try again')

            prev = ptr
            if c < 0:
                ptr = ptr.left
            else:
                ptr = ptr.right
            
        
        tmp = BSTNode(data, None, None)
        if prev == None:
            self.root = tmp
            return self.root
        if c < 0:
            prev.left = tmp
        else:
            prev.right = tmp
        
        return self.root
