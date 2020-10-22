package friends;

import structures.Queue;
import structures.Stack;

import java.util.*;

public class Friends {

    /**
     * Finds the shortest chain of people from p1 to p2.
     * Chain is returned as a sequence of names starting with p1,
     * and ending with p2. Each pair (n1,n2) of consecutive names in
     * the returned chain is an edge in the graph.
     * 
     * @param g Graph for which shortest chain is to be found.
     * @param p1 Person with whom the chain originates
     * @param p2 Person at whom the chain terminates
     * @return The shortest chain from p1 to p2. Null if there is no
     *         path from p1 to p2
     */
    public static ArrayList<String> shortestChain(Graph g, String p1, String p2) {
        /** COMPLETE THIS METHOD **/
        //Initialize variables for starting DFS
        boolean[] visitList = new boolean[g.members.length]; //this is to check we do not repeat anything
        Queue<Person> chainQueue = new Queue<>(); //Queue is used to return the list we found into the arraylist efficiently
        int index = g.map.get(p1);
        chainQueue.enqueue(g.members[index]); //Enqueue p1 into the queue
        
        //Initialize p1 because that is the starting spot
        Queue<ArrayList<String>> chains = new Queue<>();
        ArrayList<String> first = new ArrayList<>();
        //Add the first
        first.add(g.members[index].name);
        chains.enqueue(first);
        
        //Traverse through the Graph to find the shortest path
        //Return the shortest path when found
        while(!chainQueue.isEmpty()) {
            Person ppl = chainQueue.dequeue();
            int pplIndx = g.map.get(ppl.name);
            visitList[pplIndx] = true; //This keeps track of the vertexes we visited
            ArrayList<String> list = chains.dequeue();
            Friend temp = g.members[pplIndx].first;
            //traverse through the Friends
            while(temp != null) { 
                if(!visitList[temp.fnum]) {
                    ArrayList<String> shortChain = new ArrayList<>(list);
                    String name = g.members[temp.fnum].name; //This is for string arraylist
                    shortChain.add(name);
                    //The conditional on the bottom, guarantees to find the shortest of all the list
                    if(name.equals(p2)) {return shortChain;}
                //Keep going if not found
                //Enqueue
                chainQueue.enqueue(g.members[temp.fnum]);
                chains.enqueue(shortChain);
                }
                temp = temp.next; //iteration step
            }
        }
        
        //If there is nothing in queue ----> There is no shortest path
        return null;
        
    }
    
    /**
     * Finds all cliques of students in a given school.
     * 
     * Returns an array list of array lists - each constituent array list contains
     * the names of all students in a clique.
     * 
     * @param g Graph for which cliques are to be found.
     * @param school Name of school
     * @return Array list of clique array lists. Null if there is no student in the
     *         given school
     */
    
    private static void cliqueDFS(Graph graph, boolean[] visitedList, ArrayList<String> cliqMem, String sch, int i) {
        //Lets initialize the first variables to traverse through later
        Person cliqueppl = graph.members[i];
        //Check if not visited and if not visited then add to arrayList
        if(!visitedList[i] && cliqueppl.student && cliqueppl.school.equals(sch)) {
            cliqMem.add(cliqueppl.name); //Checking conditional to add
        }    
        
        //Lets use DFS to check everything
        visitedList[graph.map.get(cliqueppl.name)] = true;
        Friend ptr = graph.members[i].first;
        //Traverse the graph to find the common schools between the cliqueppl
        while(ptr != null) {
            int fnumb = ptr.fnum;
            Person friendPerson = graph.members[fnumb];    
            //Recursive call
            if(visitedList[fnumb] == false && friendPerson.student && friendPerson.school.equals(sch)) {cliqueDFS(graph, visitedList, cliqMem, sch, fnumb); //Recursively call similar to DFS
            }    
            ptr = ptr.next; //transition ptr
        }        
    }

    
    public static ArrayList<ArrayList<String>> cliques(Graph g, String school) {
        /** COMPLETE THIS METHOD **/
        //This will act as a driver essentially
        //Again lets initialize the first variables to start
        boolean[] cliqueVisited = new boolean[g.members.length];
        ArrayList<ArrayList<String>> allCliq = new ArrayList<>();
        
        //Traverse through the graph array to find the cliques
        for(int i = 0; i < g.members.length; i++) {
            Person ppl = g.members[i];
            //Continue if not visited
            if(cliqueVisited[i] || !ppl.student) {continue;}
            //Lets find the mainClique
            ArrayList<String> mainClique = new ArrayList<>(); //Main
            cliqueDFS(g, cliqueVisited, mainClique, school, i); //Recursive call
            if(mainClique != null && mainClique.size() > 0) {allCliq.add(mainClique); //Add each
            }
        }
        
        //Now loop/traversal is done
        //Return the clique
        return allCliq;
        
    }
    
    /**
     * Finds and returns all connectors in the graph.
     * 
     * @param g Graph for which connectors needs to be found.
     * @return Names of all connectors. Null if there are no connectors.
     */
    
    private static void connectorDFS(Graph graph, boolean[] visitedConnectors, ArrayList<String> connections, int[] numb, int i, boolean start, HashMap<String, Integer> numsDFS, HashMap<String, Integer> bckInt,HashSet<String> backedUp) {
        //Essentially a modification of DFS
        
        //Initialize the variables first
        Person ppl = graph.members[i];    
        visitedConnectors[graph.map.get(ppl.name)] = true; //always make the first one true
        numsDFS.put(ppl.name, numb[0]);
        bckInt.put(ppl.name, numb[1]);
        Friend ptr = graph.members[i].first;
        
        //Traverse through all the Friends list 
        while(ptr != null) {
            int personIndex = ptr.fnum;
            Person friendPerson = graph.members[personIndex];    
            //Same as in DFS conditional check to mark as visited
            if(!visitedConnectors[personIndex]) {
                numb[0]++; //Iterate 
                numb[1]++; //Iterate
                //Recursive call
                connectorDFS(graph, visitedConnectors, connections, numb, personIndex, false, numsDFS, bckInt, backedUp); //Recursion!!!!!!!!
                //backtracking conditionals
                if(numsDFS.get(ppl.name) > bckInt.get(friendPerson.name)) {
                    int backTrack = Math.min(bckInt.get(ppl.name), bckInt.get(friendPerson.name)); 
                    bckInt.put(ppl.name, backTrack);
                }
                if(numsDFS.get(ppl.name) <= bckInt.get(friendPerson.name)) {
                    if(!start || backedUp.contains(ppl.name)) {
                        //DFS like condition here to add ppl if not there (ie visited)
                        if(!connections.contains(ppl.name)) {connections.add(ppl.name);}
                    }
                }    
                backedUp.add(ppl.name);    
            } else {
                int backTrack = Math.min(bckInt.get(ppl.name), numsDFS.get(friendPerson.name));
                bckInt.put(ppl.name, backTrack);
                }    
                ptr = ptr.next; //traverse
            }    
    }
     
    public static ArrayList<String> connectors(Graph g) {
        /** COMPLETE THIS METHOD **/
        //Intialize the starting variables to start off
        boolean[] visitedConnectors = new boolean[g.members.length]; //we want to mark true so we don't "over visit"
        ArrayList<String> connectors = new ArrayList<>();
        //For ease of use lets use HashMap and HashSets
        HashMap<String, Integer> numsDFS = new HashMap<>();
        HashMap<String, Integer> backTrack = new HashMap<>();
        HashSet<String> backedUp = new HashSet<>();
        
        //This is an implementation of DFS driver
        for(int i = 0; i < g.members.length; i++) {
            //We want to check if false to continue so we can mark as true
            if(visitedConnectors[i]) { continue;}
            //recursion like seen before
            connectorDFS(g, visitedConnectors, connectors, new int[] {0,0}, i, true, numsDFS, backTrack, backedUp);
        }
        
        //Now that we are out of the loop 
        //Return the connectors you found
        return connectors;
    }
}
