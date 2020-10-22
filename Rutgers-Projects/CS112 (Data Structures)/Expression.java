package app;

import java.io.*;
import java.util.*;
import java.util.regex.*;

import structures.Stack;

public class Expression {

    public static String delims = " \t*+-/()[]";
            
    /**
     * Populates the vars list with simple variables, and arrays lists with arrays
     * in the expression. For every variable (simple or array), a SINGLE instance is created 
     * and stored, even if it appears more than once in the expression.
     * At this time, values for all variables and all array items are set to
     * zero - they will be loaded from a file in the loadVariableValues method.
     * 
     * @param expr The expression
     * @param vars The variables array list - already created by the caller
     * @param arrays The arrays array list - already created by the caller
     */
    public static void 
    makeVariableLists(String expr, ArrayList<Variable> vars, ArrayList<Array> arrays) {
        /** COMPLETE THIS METHOD **/
        /** DO NOT create new vars and arrays - they are already created before being sent in
         ** to this method - you just need to fill them in.
         **/
        StringTokenizer newString = new StringTokenizer(expr, delims);
        String[] seperateTokens = new String[newString.countTokens()];
                for(int i = 0; i <= seperateTokens.length - 1; i++) {
                    seperateTokens[i] = newString.nextToken();
                }
        int counter = 0;
                for (int i = 0; i < seperateTokens.length; i++) {
                    String newToken = seperateTokens[i];
                        if (!newToken.equals("") && !(newToken.charAt(0) >= '0' && newToken.charAt(0) <= '9')) {
                            counter = expr.indexOf(newToken, counter) + newToken.length();
                                if (counter < expr.length() && expr.charAt(counter) == '[' && !arrays.contains(new Array(newToken))) {
                                    arrays.add(new Array(newToken));
                                } else if (!vars.contains(new Variable(newToken))) {
                                    vars.add(new Variable(newToken));
                        }
                        } else {
                            continue;
                        }
                }
    }
    
    /**
     * Loads values for variables and arrays in the expression
     * 
     * @param sc Scanner for values input
     * @throws IOException If there is a problem with the input 
     * @param vars The variables array list, previously populated by makeVariableLists
     * @param arrays The arrays array list - previously populated by makeVariableLists
     */
    public static void 
    loadVariableValues(Scanner sc, ArrayList<Variable> vars, ArrayList<Array> arrays) 
    throws IOException {
        while (sc.hasNextLine()) {
            StringTokenizer st = new StringTokenizer(sc.nextLine().trim());
            int numTokens = st.countTokens();
            String tok = st.nextToken();
            Variable var = new Variable(tok);
            Array arr = new Array(tok);
            int vari = vars.indexOf(var);
            int arri = arrays.indexOf(arr);
            if (vari == -1 && arri == -1) {
                continue;
            }
            int num = Integer.parseInt(st.nextToken());
            if (numTokens == 2) { // scalar symbol
                vars.get(vari).value = num;
            } else { // array symbol
                arr = arrays.get(arri);
                arr.values = new int[num];
                // following are (index,val) pairs
                while (st.hasMoreTokens()) {
                    tok = st.nextToken();
                    StringTokenizer stt = new StringTokenizer(tok," (,)");
                    int index = Integer.parseInt(stt.nextToken());
                    int val = Integer.parseInt(stt.nextToken());
                    arr.values[index] = val;              
                }
            }
        }
    }
    
    /**
     * Evaluates the expression.
     * 
     * @param vars The variables array list, with values for all variables in the expression
     * @param arrays The arrays array list, with values for all array items
     * @return Result of evaluation
     */
    private static boolean neg(String expression) {
        expression.replaceAll("\\s+", "").trim(); 
        if (expression.charAt(0) == '-') { 
            try { Float.parseFloat(expression.substring(1));return true;}
            catch (NumberFormatException a){ return false; }
        } 
        return false;
    }
    
    private static boolean containsNeg(String expression) {
        expression.replaceAll("\\s+", "").trim();
        for (int i = 0; i < expression.length(); i++) {
            
            if (expression.charAt(i) == '-') { 
                
                try {
                    
                    if (expression.charAt(i-1) == '*' || expression.charAt(i-1) == '/') {
                        StringTokenizer string = new StringTokenizer(expression.substring(i+1),delims);
                        Float.parseFloat(string.nextToken());
                        return true;
                    }
                    
                }
                
                catch (NumberFormatException e) { return false; }
                
                catch (StringIndexOutOfBoundsException a) {
                    StringTokenizer string = new StringTokenizer(expression.substring(i+1),delims);
                    Float.parseFloat(string.nextToken());
                }
                
            } 
        } 
        return false;
    }
    
    private static String twoNeg(String expression) {
        int nn = expression.indexOf("--");
        while (nn > 0) { 
            expression = expression.substring(0, nn) + "+" + expression.substring(nn+2);
            nn = expression.indexOf("--", nn+1);
        }
        int np = expression.indexOf("-+");        
        while (np > 0) {
            expression = expression.substring(0, np) + "-" + expression.substring(np+2);
            np = expression.indexOf("-+", np+1);
        }
        int pn = expression.indexOf("+-");
        while (pn > 0) {
            expression = expression.substring(0, pn) + "-" + expression.substring(pn+2);
            pn = expression.indexOf("+-", pn+1);
        } 
        return expression;
    }
    
    private static boolean contSym(String expression, String regx) {
        regx = regx.replaceAll("\\s+", "").trim();
        char[] regxarr = regx.toCharArray();
        
        for (int i = 0; i < regxarr.length; i++) {
            if (expression.contains(Character.toString(regxarr[i]))) {return true;}
        } 
        
        return false;
    }
        
    private static float evaluate(float one, float two, char oper) {
        switch (oper) {
            case '+': return one + two;
            case '-': return one - two;
            case '*': return one * two;
            case '/': return one / two;
        } 
        throw new NullPointerException("Computation Error");    
    }
        
   private static boolean hasPriority(char one, char two) {
        if (one == '+' || one == '-' ) {
            if (two == '*' || two == '/') {return false;}
        } 
        return true;
   }
    
    public static float evaluate(String expr, ArrayList<Variable> vars, ArrayList<Array> arrays) {
        /** COMPLETE THIS METHOD **/
        expr = expr.trim();
        expr = expr.replaceAll("\\s+", "");
        expr = expr.replaceAll("\\t+", "");
        float answer = 0; //Save this variable for the return value
    
        //Easiest way to deal with this now is to break up the string like how you would evaluate real expressions
        //Time to break up expression further, to further simplify it
        //Check the brackets first
        while (contSym(expr,"[]")) {
            StringTokenizer tokens = new StringTokenizer(expr, " \t*+-/()]");
            String tmp = "", a = "";
            while (tokens.hasMoreTokens()) {
                tmp = tokens.nextToken();
                try {
                    a = tmp.substring(0, tmp.indexOf("["));
                    break;
                } catch (IndexOutOfBoundsException c) { continue; }
            }    
            //Start at the beginning bracket so "[" and look for "]"
            int start = expr.indexOf("[");
            int end = 0;
            int counter = 0;
            for (int i = start; counter >= 0; i++) {
                if (expr.charAt(i) == ']') {
                    counter -= 1;
                    if (counter == 0) { end = i; break; }    
                }
                else if (expr.charAt(i) == '[') {
                    counter += 1;
                }
            }
            float y = evaluate(expr.substring(start + 1, end),vars,arrays);
            for (int i = 0; i < arrays.size(); i++) {
                if (arrays.get(i).name.equals(a)) {
                    y = arrays.get(i).values[(int) y];
                }
            }    
            expr = expr.substring(0, start - a.length())    + Float.toString(y) + expr.substring(end+1);    
        }
        
        // Now part 2, check the expression for parenthesis
        // Same processes as with brackets but now with parenthesis
        while (contSym(expr,"()")) {
            int start = expr.indexOf("(");
            int end = 0;
            int counter = 0;
            for (int i = start; counter >= 0; i++) {
                //Check for ending parenthesis
                if (expr.charAt(i) == ')') {
                    counter -= 1;
                    if (counter == 0) { end = i; break; }    
                }
                else if (expr.charAt(i) == '(') {counter += 1;}
            }
            float a = evaluate(expr.substring(start + 1, end),vars,arrays);    
            expr = expr.substring(0,start) + Float.toString(a) + expr.substring(end+1);
        }
        
        if (!contSym(expr,delims) || neg(expr)) {
            try { 
                return Float.parseFloat(expr); 
                } catch (NumberFormatException c) {
                for (int i = 0; i < vars.size(); i++) { if (vars.get(i).name.equals(expr)) {return vars.get(i).value;}}
            }
        }
        
        // Part 3: Check for simple operations like *,/,+,-
        else if (contSym(expr,"*+-/")) {
            expr = twoNeg(expr);
            Stack<Float> opp = new Stack<Float>();                
            StringTokenizer string = new StringTokenizer(expr, " \t*+/()[]");
            while(string.hasMoreTokens()) {
                String tmp = string.nextToken();
                if (contSym(tmp,"-") && !neg(tmp)){        // account for "6*-7"
                    StringTokenizer sttok = new StringTokenizer(tmp, delims);
                    while(sttok.hasMoreTokens()) {opp.push(evaluate(sttok.nextToken(),vars,arrays));} 
                } else {opp.push(evaluate(tmp,vars,arrays));}
            }    
            Stack<Float> nums = new Stack<Float>();        
            while(!opp.isEmpty()) {nums.push(opp.pop());}    
            Stack<Character> opposite = new Stack<Character>();
            for (int i = 0; i < expr.length(); i++) {
                    if (expr.charAt(i) == '+' || expr.charAt(i) == '*'|| expr.charAt(i) == '/'){
                        opposite.push( expr.charAt(i) );
                    }
                    try {
                        if (expr.charAt(i) == '-' && neg(expr.substring(i-1)) == false) {opposite.push( expr.charAt(i) );}
                    }
                    catch (StringIndexOutOfBoundsException e) {continue;}
            }    
            Stack<Character> Operations = new Stack<Character>();
            while(!opposite.isEmpty()) {
                Operations.push(opposite.pop());
            }    
            
            while (!nums.isEmpty()) { 
                char oper = Operations.pop();
                try {
                    char check = Operations.peek();
                    if (hasPriority(oper, check)) {        
                        float a = nums.pop(); 
                        float b = nums.pop();
                        answer = evaluate(a,b,oper);        
                        if (!Operations.isEmpty()) {
                            nums.push(answer);
                        } 
                    }
                    else {        
                        float temp = nums.pop(); 
                        char tempOp = oper; 
                        char op = Operations.pop();
                        float one = nums.pop();
                        float two = nums.pop();
                        answer = evaluate(one,two,op);            
                        nums.push(answer); 
                        nums.push(temp);
                        Operations.push(tempOp);            
                    }
                }
                catch (NoSuchElementException e) {        
                    float one = nums.pop();
                    if(nums.isEmpty()) {
                        float two = -one;
                        answer = evaluate(one, two, oper);
                    } else {
                        float two = nums.pop();
                        answer = evaluate(one ,two ,oper); 
                    }            
                }
            }
            
        }
        //Done
        return answer;
        }
    }
        
    