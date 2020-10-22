package structures;

import java.util.*;

/**
 * This class implements an HTML DOM Tree. Each node of the tree is a TagNode, with fields for
 * tag/text, first child and sibling.
 * 
 */
public class Tree {
	
	/**
	 * Root node
	 */
	TagNode root=null;
	
	/**
	 * Scanner used to read input HTML file when building the tree
	 */
	Scanner sc;
	
	/**
	 * Initializes this tree object with scanner for input HTML file
	 * 
	 * @param sc Scanner for input HTML file
	 */
	public Tree(Scanner sc) {
		this.sc = sc;
		root = null;
	}
	
	/**
	 * Builds the DOM tree from input HTML file, through scanner passed
	 * in to the constructor and stored in the sc field of this object. 
	 * 
	 * The root of the tree that is built is referenced by the root field of this object.
	 */
	
	public void build() {
		/** COMPLETE THIS METHOD **/
		Stack<TagNode> tags = new Stack<TagNode>();
		sc.nextLine();
		root = new TagNode("html", null, null);
		tags.push(root); 
		
		while(sc.hasNextLine()) {
			String str = sc.nextLine();
			Boolean isTag = false;
			if(str.charAt(0) == '<') {
				if(str.charAt(1) == '/') {
					tags.pop();
					continue;
				} else {
					str = str.replace("<", "");
					str = str.replace(">", "");
					isTag = true;
				}
			}
			TagNode temp = new TagNode(str, null, null);
			if(tags.peek().firstChild == null) {
				tags.peek().firstChild = temp; 
			} else {
				TagNode ptr = tags.peek().firstChild;
				while(ptr.sibling != null) {
					ptr = ptr.sibling;
				}
				ptr.sibling = temp;
			}
			if(isTag) tags.push(temp);
		}
	}
	/**
	 * Replaces all occurrences of an old tag in the DOM tree with a new tag
	 * 
	 * @param oldTag Old tag
	 * @param newTag Replacement tag
	 */
	
	private void replaceTag(TagNode root, String oldTag, String newTag) {
		if(root == null) { 
			return;
		}
		if(root.tag.equals(oldTag) && root.firstChild != null) { 
			root.tag = newTag;
		}
		replaceTag(root.sibling, oldTag, newTag);
		replaceTag(root.firstChild, oldTag, newTag);
	}
	
	public void replaceTag(String oldTag, String newTag) {
		/** COMPLETE THIS METHOD **/
		replaceTag(root, oldTag, newTag);
	}
	
	/**
	 * Boldfaces every column of the given row of the table in the DOM tree. The boldface (b)
	 * tag appears directly under the td tag of every column of this row.
	 * 
	 * @param row Row to bold, first row is numbered 1 (not 0).
	 */
	private TagNode boldRowHelper(TagNode root) { 
		if(root == null) { 
			return null; 
		}
		if(root.tag.equals("table")) { 
			return root; 
		}
			TagNode j = boldRowHelper(root.sibling);
			TagNode k = boldRowHelper(root.firstChild);
		if(j != null) { 
			return j; 
		}
		if(k != null) { 
			return k; 
		}
		return null;
	}
	
	public void boldRow(int row) {
		/** COMPLETE THIS METHOD **/
		TagNode tableset = boldRowHelper(root);
		TagNode tr = tableset.firstChild;
			for(int r=1; r != row; r++) { 
				tr = tr.sibling;
			}
			for(TagNode td = tr.firstChild; td != null; td = td.sibling) { 
				TagNode b = new TagNode("b", td.firstChild, null);
				td.firstChild = b;
			}
	}
	
	/**
	 * Remove all occurrences of a tag from the DOM tree. If the tag is p, em, or b, all occurrences of the tag
	 * are removed. If the tag is ol or ul, then All occurrences of such a tag are removed from the tree, and, 
	 * in addition, all the li tags immediately under the removed tag are converted to p tags. 
	 * 
	 * @param tag Tag to be removed, can be p, em, b, ol, or ul
	 */
	private void removeTagSet1(TagNode root, String tag) { 
		if(root == null) { 
			return;
		}
		if(root.tag.equals(tag) && root.firstChild != null) {
			root.tag = root.firstChild.tag;
				if(root.firstChild.sibling != null) {
					TagNode ptr = null;
					for(ptr = root.firstChild; ptr.sibling != null; ptr = ptr.sibling); 
					ptr.sibling = root.sibling;
					root.sibling = root.firstChild.sibling;
				}
				root.firstChild = root.firstChild.firstChild;
			}
			removeTagSet1(root.firstChild, tag); 
			removeTagSet1(root.sibling, tag);
	}
	
	private void removeTagSet2(TagNode root, String tag) { 
			if(root == null) {
				return;
			}
			if(root.tag.equals(tag) && root.firstChild != null) {
				root.tag = "p";
				TagNode ptr = null;
					for(ptr = root.firstChild; ptr.sibling != null; ptr = ptr.sibling) ptr.tag = "p"; 
						ptr.tag = "p";
						ptr.sibling = root.sibling;
						root.sibling = root.firstChild.sibling;
						root.firstChild = root.firstChild.firstChild;
			}
		removeTagSet2(root.firstChild, tag); 
		removeTagSet2(root.sibling, tag);
	}
	
	public void removeTag(String tag) {
		/** COMPLETE THIS METHOD **/
		if((tag.equals("p") || tag.equals("em") || tag.equals("b"))) { 
			removeTagSet1(root, tag);
			}
		if((tag.equals("ol") || tag.equals("ul"))) { 
			removeTagSet2(root, tag);	
			}
	}
	
	/**
	 * Adds a tag around all occurrences of a word in the DOM tree.
	 * 
	 * @param word Word around which tag is to be added
	 * @param tag Tag to be added
	 */
	private void AddHelper(TagNode root, String word, String tag){
		if(root == null) {
			return;
		}
		AddHelper(root.firstChild, word, tag);
			if(root.firstChild != null && root.firstChild.tag.contains(word)){
				String[] words = root.firstChild.tag.split(word);
					if(words.length == 2){
						TagNode right = new TagNode(words[1], null, root.firstChild.sibling);
						TagNode left = new TagNode(words[0], null , null);
						TagNode tagged = new TagNode(word, null, null);
						TagNode tagger = new TagNode(tag, tagged, right);
						root.firstChild = left;
						left.sibling = tagger;
						tagger.sibling = right;
						if(words[0].equals(""))
							root.firstChild = tagger;
						}
						else if(words.length == 0){
							TagNode tagger = new TagNode(tag, root.firstChild, root.sibling);
							root.firstChild = tagger;
							System.out.println("length 0");
						}
						else{	
							if(words[0].charAt(0)==' '){
							TagNode tagged = new TagNode(word, null, null);
							TagNode tagger = new TagNode(tag, tagged, null);
							TagNode right = new TagNode(words[0], null, root.firstChild.sibling);
							tagger.sibling = right;
							root.firstChild = tagger;
						} 
				else{
					TagNode tagged = new TagNode(word, null, null);
					TagNode tagger = new TagNode(tag, tagged, root.firstChild.sibling);
					TagNode left = new TagNode(words[0], null, tagger);
					root.firstChild = left;
				}
			}
			
		}
			if(root.sibling != null && root.sibling.tag.contains(word)){
				String[] words = root.sibling.tag.split(word);
				if(words.length > 0){
					TagNode rightside = new TagNode(words[1], null, root.sibling.sibling);
					TagNode leftside = new TagNode(words[0], null, null);
					TagNode tagged = new TagNode(word, null, null);
					TagNode tagger = new TagNode(tag, tagged, rightside);
					root.sibling = leftside;
					leftside.sibling = tagger;
					tagger.sibling = rightside;
				}
			else if(words.length == 0){
				TagNode tagger = new TagNode(tag, root.sibling, root.sibling.sibling);
				root.sibling = tagger;
				System.out.println("length 0");
			}
			else{
				TagNode tagged = new TagNode(word, null, null);
				TagNode tagger = new TagNode(tag, tagged, null);
				if(words[0].charAt(0) == ' '){
					TagNode right = new TagNode(words[0], null, root.sibling.sibling);
					tagger.sibling = right;
					root.sibling = tagger;
				}
				else{
					TagNode left = new TagNode(words[0], null, tagger);
					root.sibling = left;
				}
			}
		}
		AddHelper(root.sibling, word, tag);
	}
	public void addTag(String word, String tag) {
		/** COMPLETE THIS METHOD **/
		AddHelper(root, word, tag);
	}
	
	/**
	 * Gets the HTML represented by this DOM tree. The returned string includes
	 * new lines, so that when it is printed, it will be identical to the
	 * input file from which the DOM tree was built.
	 * 
	 * @return HTML string, including new lines. 
	 */
	public String getHTML() {
		StringBuilder sb = new StringBuilder();
		getHTML(root, sb);
		return sb.toString();
	}
	
	private void getHTML(TagNode root, StringBuilder sb) {
		for (TagNode ptr=root; ptr != null;ptr=ptr.sibling) {
			if (ptr.firstChild == null) {
				sb.append(ptr.tag);
				sb.append("\n");
			} else {
				sb.append("<");
				sb.append(ptr.tag);
				sb.append(">\n");
				getHTML(ptr.firstChild, sb);
				sb.append("</");
				sb.append(ptr.tag);
				sb.append(">\n");	
			}
		}
	}
	
	/**
	 * Prints the DOM tree. 
	 *
	 */
	public void print() {
		print(root, 1);
	}
	
	private void print(TagNode root, int level) {
		for (TagNode ptr=root; ptr != null;ptr=ptr.sibling) {
			for (int i=0; i < level-1; i++) {
				System.out.print("      ");
			};
			if (root != this.root) {
				System.out.print("|----");
			} else {
				System.out.print("     ");
			}
			System.out.println(ptr.tag);
			if (ptr.firstChild != null) {
				print(ptr.firstChild, level+1);
			}
		}
	}
}