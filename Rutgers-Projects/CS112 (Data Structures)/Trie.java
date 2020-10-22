package trie;

import java.util.ArrayList;

/**
 * This class implements a Trie. 
 * 
 * @author Sesh Venugopal
 *
 */
public class Trie {
    
    // prevent instantiation
    private Trie() { }
    
    /**
     * Builds a trie by inserting all words in the input array, one at a time,
     * in sequence FROM FIRST TO LAST. (The sequence is IMPORTANT!)
     * The words in the input array are all lower case.
     * 
     * @param allWords Input array of words (lowercase) to be inserted.
     * @return Root of trie with all words inserted from the input array
     */
    
    private static int indexSim(String word1, String word2) {
        //Placeholder return statement
        int upTo = 0;
        while(upTo < word1.length() && upTo < word2.length() && word1.charAt(upTo) == word2.charAt(upTo))
            upTo++;
        
        return (upTo-1);
    }
    
    public static TrieNode buildTrie(String[] allWords) {
        /** COMPLETE THIS METHOD **/
        //Root is always null
        TrieNode root = new TrieNode(null, null, null);
        
        if(allWords.length == 0) { //Check if the array of strings is has anything to continue
            return root;
        }
        
        //Precondition is met so root has a firstchild
        root.firstChild = new TrieNode(new Indexes(0, (short)(0), (short)(allWords[0].length() - 1)), null, null);
        
        TrieNode ptr = root.firstChild; //To traverse through the root
        TrieNode prev = root.firstChild; //For connecting each node together
        int index = -1; //reference to similarity index
        int begind = -1; //reference to startIndex
        int endind = -1; //reference to endIndex
        int wordind = -1; //reference to wordIndex
        for(int i = 1; i < allWords.length; i++) {
            String insert = allWords[i];            
            while(ptr != null) { //Check for when ptr becomes null to insert new node
                begind = ptr.substr.startIndex; 
                endind = ptr.substr.endIndex; 
                wordind = ptr.substr.wordIndex;                
                if(begind > insert.length()) {
                    prev = ptr;
                    ptr = ptr.sibling;
                    continue;
                }
                index = indexSim(allWords[wordind].substring(begind, endind+1), insert.substring(begind)); 
                if(index != -1) {index += begind;}
                if(index == -1) {prev = ptr;ptr = ptr.sibling;}
                else {
                    if(index == endind) { 
                        prev = ptr;
                        ptr = ptr.firstChild;
                    }
                    else if (index < endind){ 
                        prev = ptr; 
                        break;
                        }
                }
            }
            
            //ptr is out of while loop so we insert 
            if(ptr == null) {prev.sibling = new TrieNode(new Indexes(i, (short)begind, (short)(insert.length()-1)), null, null);}        
            else {
                Indexes currIndexes = prev.substr; 
                TrieNode currFirstChild = prev.firstChild; 
                Indexes currWordNewIndexes = new Indexes(currIndexes.wordIndex, (short)(index+1), currIndexes.endIndex);
                currIndexes.endIndex = (short)index; 
                prev.firstChild = new TrieNode(currWordNewIndexes, null, null);
                prev.firstChild.firstChild = currFirstChild;
                prev.firstChild.sibling = new TrieNode(new Indexes((short)i, (short)(index+1), (short)(insert.length()-1)), null, null);
            }
            //because the for loop is not done with, lets set the ptr and prev to start again
            ptr = root.firstChild;
            prev = root.firstChild;
            index = -1; 
            begind = -1; 
            endind = -1; 
            wordind = -1;
        }
        
        //for loop is done, so lets return the tree we built
        return root;
    }
    
    
    /**
     * Given a trie, returns the "completion list" for a prefix, i.e. all the leaf nodes in the 
     * trie whose words start with this prefix. 
     * For instance, if the trie had the words "bear", "bull", "stock", and "bell",
     * the completion list for prefix "b" would be the leaf nodes that hold "bear", "bull", and "bell"; 
     * for prefix "be", the completion would be the leaf nodes that hold "bear" and "bell", 
     * and for prefix "bell", completion would be the leaf node that holds "bell". 
     * (The last example shows that an input prefix can be an entire word.) 
     * The order of returned leaf nodes DOES NOT MATTER. So, for prefix "be",
     * the returned list of leaf nodes can be either hold [bear,bell] or [bell,bear].
     *
     * @param root Root of Trie that stores all words to search on for completion lists
     * @param allWords Array of words that have been inserted into the trie
     * @param prefix Prefix to be completed with words in trie
     * @return List of all leaf nodes in trie that hold words that start with the prefix, 
     *             order of leaf nodes does not matter.
     *         If there is no word in the tree that has this prefix, null is returned.
     */
    public static ArrayList<TrieNode> completionList(TrieNode root,
                                        String[] allWords, String prefix) {
        /** COMPLETE THIS METHOD **/
        //Precondition: Check if root is null
        if(root == null) {
            return null;
        }
        
        //Now we know root has more nodes
        TrieNode ptr = root; //Set a pointer to traverse through the trie strucucture
        //Now we also need to allocate an arraylist to keep the prefix words
        ArrayList result = new ArrayList<>();
        
        //Traverse the linked list
        while(ptr != null) {
            //Check if ptr is at root
            if(ptr.substr == null) {ptr = ptr.firstChild;}
            //Allocate a string to compare the ptr word with prefix
            //Allocate another string for the prefixes that are not fully there
            String compWrd = allWords[ptr.substr.wordIndex], upTo = compWrd.substring(0, ptr.substr.endIndex+1); 
            if(compWrd.startsWith(prefix) || prefix.startsWith(upTo)) {
                if(ptr.firstChild != null) {
                    result.addAll(completionList(ptr.firstChild, allWords, prefix));
                    ptr = ptr.sibling;
                } else {
                    result.add(ptr);
                    ptr = ptr.sibling;
                }
            } 
            else {ptr = ptr.sibling;}
        }
        //Loop terminates return result(the words attached to the prefix)
        return result;
    }
    
    public static void print(TrieNode root, String[] allWords) {
        System.out.println("\nTRIE\n");
        print(root, 1, allWords);
    }
    
    private static void print(TrieNode root, int indent, String[] words) {
        if (root == null) {
            return;
        }
        for (int i=0; i < indent-1; i++) {
            System.out.print("    ");
        }
        
        if (root.substr != null) {
            String pre = words[root.substr.wordIndex]
                            .substring(0, root.substr.endIndex+1);
            System.out.println("      " + pre);
        }
        
        for (int i=0; i < indent-1; i++) {
            System.out.print("    ");
        }
        System.out.print(" ---");
        if (root.substr == null) {
            System.out.println("root");
        } else {
            System.out.println(root.substr);
        }
        
        for (TrieNode ptr=root.firstChild; ptr != null; ptr=ptr.sibling) {
            for (int i=0; i < indent-1; i++) {
                System.out.print("    ");
            }
            System.out.println("     |");
            print(ptr, indent+1, words);
        }
    }
 }