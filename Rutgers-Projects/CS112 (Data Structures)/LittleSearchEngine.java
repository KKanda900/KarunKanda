package lse;

import java.io.*;
import java.util.*;

/**
 * This class builds an index of keywords. Each keyword maps to a set of pages in
 * which it occurs, with frequency of occurrence in each page.
 *
 */
public class LittleSearchEngine {
	
	/**
	 * This is a hash table of all keywords. The key is the actual keyword, and the associated value is
	 * an array list of all occurrences of the keyword in documents. The array list is maintained in 
	 * DESCENDING order of frequencies.
	 */
	HashMap<String,ArrayList<Occurrence>> keywordsIndex;
	
	/**
	 * The hash set of all noise words.
	 */
	HashSet<String> noiseWords;
	
	/**
	 * Creates the keyWordsIndex and noiseWords hash tables.
	 */
	public LittleSearchEngine() {
		keywordsIndex = new HashMap<String,ArrayList<Occurrence>>(1000,2.0f);
		noiseWords = new HashSet<String>(100,2.0f);
	}
	
	/**
	 * Scans a document, and loads all keywords found into a hash table of keyword occurrences
	 * in the document. Uses the getKeyWord method to separate keywords from other words.
	 * 
	 * @param docFile Name of the document file to be scanned and loaded
	 * @return Hash table of keywords in the given document, each associated with an Occurrence object
	 * @throws FileNotFoundException If the document file is not found on disk
	 */
	public HashMap<String,Occurrence> loadKeywordsFromDocument(String docFile) 
	throws FileNotFoundException {
		/** COMPLETE THIS METHOD **/
		if (docFile == null) {
			throw new FileNotFoundException();
		}
		HashMap<String, Occurrence> keyWordMap = new HashMap<String, Occurrence>();
		Scanner sc = new Scanner(new File(docFile));
		while (sc.hasNext()) {
			String keywords = getKeyword(sc.next());
			if (keywords != null) {
				if (keyWordMap.containsKey(keywords)) {
					Occurrence oc = keyWordMap.get(keywords);
					oc.frequency++;
				}
				else {
					Occurrence oc = new Occurrence(docFile, 1);
					keyWordMap.put(keywords, oc);
				}
			}
		}
		return keyWordMap;
	}
	/**
	 * Merges the keywords for a single document into the master keywordsIndex
	 * hash table. For each keyword, its Occurrence in the current document
	 * must be inserted in the correct place (according to descending order of
	 * frequency) in the same keyword's Occurrence list in the master hash table. 
	 * This is done by calling the insertLastOccurrence method.
	 * 
	 * @param kws Keywords hash table for a document
	 */
	public void mergeKeywords(HashMap<String,Occurrence> kws) {
		/** COMPLETE THIS METHOD **/
		for(String keyword: kws.keySet()) {
			ArrayList<Occurrence> occur = new ArrayList<>();
			if(keywordsIndex.containsKey(keyword)) {
				occur = keywordsIndex.get(keyword);
			}
			occur.add(kws.get(keyword));
			insertLastOccurrence(occur);
			keywordsIndex.put(keyword, occur);
		}
	}
	
	/**
	 * Given a word, returns it as a keyword if it passes the keyword test,
	 * otherwise returns null. A keyword is any word that, after being stripped of any
	 * trailing punctuation(s), consists only of alphabetic letters, and is not
	 * a noise word. All words are treated in a case-INsensitive manner.
	 * 
	 * Punctuation characters are the following: '.', ',', '?', ':', ';' and '!'
	 * NO OTHER CHARACTER SHOULD COUNT AS PUNCTUATION
	 * 
	 * If a word has multiple trailing punctuation characters, they must all be stripped
	 * So "word!!" will become "word", and "word?!?!" will also become "word"
	 * 
	 * See assignment description for examples
	 * 
	 * @param word Candidate word
	 * @return Keyword (word without trailing punctuation, LOWER CASE)
	 */
	private static boolean isChar(String w) {
		int counter = 0;
		boolean top = false;
		while (counter < w.length()) {
			char ch = w.charAt(counter);
			if (!(Character.isLetter(ch))) {
				top = true;
			}
			if ((top) && (Character.isLetter(ch)))
				return true;
			counter++;
		}
		return false;
	}
	
	private String removeAfterPunct(String word) {
		int i = 0;
		while (i < word.length()) {
			char c = word.charAt(i);
			if (!(Character.isLetter(c))) {
				break;
			}
			i++;
			
		}
		return word.substring(0, i);
	}

	public String getKeyword(String word) {
		/** COMPLETE THIS METHOD **/
		if ((word == null) || (word.equals(null))) {
			return null;
		}
		word = word.toLowerCase();
		
		if (isChar(word)) {
			return null;
		}
		word = removeAfterPunct(word);

		if (noiseWords.contains(word)) {
			return null;
		}
		if (word.length() <= 0) {
			return null;
		}
		return word;
	}
	
	/**
	 * Inserts the last occurrence in the parameter list in the correct position in the
	 * list, based on ordering occurrences on descending frequencies. The elements
	 * 0..n-2 in the list are already in the correct order. Insertion is done by
	 * first finding the correct spot using binary search, then inserting at that spot.
	 * 
	 * @param occs List of Occurrences
	 * @return Sequence of mid point indexes in the input list checked by the binary search process,
	 *         null if the size of the input list is 1. This returned array list is only used to test
	 *         your code - it is not used elsewhere in the program.
	 */
	public ArrayList<Integer> insertLastOccurrence(ArrayList<Occurrence> occs) {
		/** COMPLETE THIS METHOD **/
		if (occs.size() < 2) {
			return null;
		}
		int lower = 0;
		int higher = occs.size()-2;
		int goal = occs.get(occs.size()-1).frequency;
		int mid = 0;
		ArrayList<Integer> midpoints = new ArrayList<Integer>();
		while (higher >= lower) {
			mid = ((lower + higher) / 2);
			int data = occs.get(mid).frequency;
			midpoints.add(mid);
			if (data == goal)
				break;
			else if (data < goal) {
				higher = mid - 1;
			}
			else if (data > goal) {
				lower = mid + 1;
				if (higher <= mid)
					mid = mid + 1;
			}
		}
		midpoints.add(mid);
		Occurrence temp = occs.remove(occs.size()-1);
		occs.add(midpoints.get(midpoints.size()-1), temp);
		midpoints.remove(midpoints.size());
		return midpoints;
	}
	
	/**
	 * This method indexes all keywords found in all the input documents. When this
	 * method is done, the keywordsIndex hash table will be filled with all keywords,
	 * each of which is associated with an array list of Occurrence objects, arranged
	 * in decreasing frequencies of occurrence.
	 * 
	 * @param docsFile Name of file that has a list of all the document file names, one name per line
	 * @param noiseWordsFile Name of file that has a list of noise words, one noise word per line
	 * @throws FileNotFoundException If there is a problem locating any of the input files on disk
	 */
	public void makeIndex(String docsFile, String noiseWordsFile) 
	throws FileNotFoundException {
		// load noise words to hash table
		Scanner sc = new Scanner(new File(noiseWordsFile));
		while (sc.hasNext()) {
			String word = sc.next();
			noiseWords.add(word);
		}
		
		// index all keywords
		sc = new Scanner(new File(docsFile));
		while (sc.hasNext()) {
			String docFile = sc.next();
			HashMap<String,Occurrence> kws = loadKeywordsFromDocument(docFile);
			mergeKeywords(kws);
		}
		sc.close();
	}
	
	/**
	 * Search result for "kw1 or kw2". A document is in the result set if kw1 or kw2 occurs in that
	 * document. Result set is arranged in descending order of document frequencies. 
	 * 
	 * Note that a matching document will only appear once in the result. 
	 * 
	 * Ties in frequency values are broken in favor of the first keyword. 
	 * That is, if kw1 is in doc1 with frequency f1, and kw2 is in doc2 also with the same 
	 * frequency f1, then doc1 will take precedence over doc2 in the result. 
	 * 
	 * The result set is limited to 5 entries. If there are no matches at all, result is null.
	 * 
	 * See assignment description for examples
	 * 
	 * @param kw1 First keyword
	 * @param kw1 Second keyword
	 * @return List of documents in which either kw1 or kw2 occurs, arranged in descending order of
	 *         frequencies. The result size is limited to 5 documents. If there are no matches, 
	 *         returns null or empty array list.
	 */
	public ArrayList<String> top5search(String kw1, String kw2) {
		/** COMPLETE THIS METHOD **/
		//iterate through the hash map
		//search thru the keywords through conditional statements
		ArrayList<String> result = new ArrayList<String>();
		ArrayList<Occurrence> occurArr1 = new ArrayList<Occurrence>();
		ArrayList<Occurrence> occurArr2 = new ArrayList<Occurrence>();
		ArrayList<Occurrence> combination = new ArrayList<Occurrence>();
		if (keywordsIndex.containsKey(kw1)) {
			occurArr1 = keywordsIndex.get(kw1);
		}
		if (keywordsIndex.containsKey(kw2)) {
			occurArr2 = keywordsIndex.get(kw2);
		}
		combination.addAll(occurArr1);
		combination.addAll(occurArr2);
		if (!(occurArr1.isEmpty()) && !(occurArr2.isEmpty())) {
			for (int x = 0; x < combination.size()-1; x++) {
				for (int y = 1; y < combination.size()-x; y++) { 
					if (combination.get(y-1).frequency < combination.get(y).frequency) {
						Occurrence temp = combination.get(y-1);
						combination.set(y-1, combination.get(y));
						combination.set(y,  temp);
					}
				}
			}
			for (int x = 0; x < combination.size()-1; x++) {
				for (int y = x + 1; y < combination.size(); y++) {
					if (combination.get(x).document == combination.get(y).document) {
						combination.remove(y);
					}
				}
			}
		}
		while (combination.size() > 5)
			combination.remove(combination.size()-1);
		System.out.println(combination);
		for (Occurrence oc : combination)
			result.add(oc.document);
		return result;
	}
	
}
