package bigint;

/**
 * This class encapsulates a BigInteger, i.e. a positive or negative integer with 
 * any number of digits, which overcomes the computer storage length limitation of 
 * an integer.
 * 
 */
public class BigInteger {

    /**
     * True if this is a negative integer
     */
    boolean negative;
    
    /**
     * Number of digits in this integer
     */
    int numDigits;
    
    /**
     * Reference to the first node of this integer's linked list representation
     * NOTE: The linked list stores the Least Significant Digit in the FIRST node.
     * For instance, the integer 235 would be stored as:
     *    5 --> 3  --> 2
     *    
     * Insignificant digits are not stored. So the integer 00235 will be stored as:
     *    5 --> 3 --> 2  (No zeros after the last 2)        
     */
    DigitNode front;
    
    /**
     * Initializes this integer to a positive number with zero digits, in other
     * words this is the 0 (zero) valued integer.
     */
    public BigInteger() {
        negative = false;
        numDigits = 0;
        front = null;
    }
    
    /**
     * Parses an input integer string into a corresponding BigInteger instance.
     * A correctly formatted integer would have an optional sign as the first 
     * character (no sign means positive), and at least one digit character
     * (including zero). 
     * Examples of correct format, with corresponding values
     *      Format     Value
     *       +0            0
     *       -0            0
     *       +123        123
     *       1023       1023
     *       0012         12  
     *       0             0
     *       -123       -123
     *       -001         -1
     *       +000          0
     *       
     * Leading and trailing spaces are ignored. So "  +123  " will still parse 
     * correctly, as +123, after ignoring leading and trailing spaces in the input
     * string.
     * 
     * Spaces between digits are not ignored. So "12  345" will not parse as
     * an integer - the input is incorrectly formatted.
     * 
     * An integer with value 0 will correspond to a null (empty) list - see the BigInteger
     * constructor
     * 
     * @param integer Integer string that is to be parsed
     * @return BigInteger instance that stores the input integer.
     * @throws IllegalArgumentException If input is incorrectly formatted
     */
    private static boolean hasLetter(String integer) {
        for(int i = 0; i <= integer.length() - 1; i++) {
            if(Character.isLetter(integer.charAt(i))){
                return true;
            }
        }
        return false;
    }
    
    public static BigInteger parse(String integer) 
    throws IllegalArgumentException {
        /* IMPLEMENT THIS METHOD */
        //Create the resultant BigInteger
        BigInteger result = new BigInteger(); 
        
        if(hasLetter(integer)) {
            throw new IllegalArgumentException("Incorrect Format");
        }
        
        //Conditional Check: if the integer string has only one value
        integer = integer.replaceFirst("^0+(?!$)", "");
        if(integer.length() == 1) {
            result.negative = false;
            result.numDigits = 1;
            char digi = integer.charAt(0);
            int char2dig = Character.getNumericValue(digi);
            result.front = new DigitNode(char2dig, result.front);
            return result;
        }
        
        //Create the Big Integer value now 
        char a = integer.charAt(0);
        if(a == '-') {
            result.negative = true;
            integer = integer.substring(1);
        } 
        else if(a == '+') {
            integer = integer.substring(1).trim();
        }
        for(int i = 0; i <= integer.length() - 1; i++) {
            char b = integer.charAt(i);
            if(!Character.isDigit(b)) {
                throw new IllegalArgumentException("Incorrect Format");
            }
            int dig = Character.getNumericValue(b);
            DigitNode newNode = new DigitNode(dig, result.front);
            result.front = newNode;
            result.numDigits++;
        }
    // After you make the linked list, return the big integer value
    return result;        
    }
    
    /**
     * Adds the first and second big integers, and returns the result in a NEW BigInteger object. 
     * DOES NOT MODIFY the input big integers.
     * 
     * NOTE that either or both of the input big integers could be negative.
     * (Which means this method can effectively subtract as well.)
     * 
     * @param first First big integer
     * @param second Second big integer
     * @return Result big integer
     */
    
    //Find if one BigInteger value is bigger than the other
    private static boolean isBigger(BigInteger first, BigInteger second){
           if(first.numDigits > second.numDigits){return false;}
           else if(second.numDigits > first.numDigits){return true;}
           else{
              DigitNode ptr = first.front;
              DigitNode ptr2 = second.front;
              boolean bigger = false;
              while (ptr != null && ptr2!=null){
                 if(ptr2.digit > ptr.digit){bigger=true;}
                 else if(ptr2.digit < ptr.digit){ bigger=false;}
                 ptr = ptr.next;
                 ptr2 = ptr2.next;
              }
              return bigger;
           }

        }
    
    public static BigInteger add(BigInteger first, BigInteger second) {
        /* IMPLEMENT THIS METHOD */
        //initialize the larger of the two and smaller of the two 
        BigInteger larger,smaller;
           if(first.front == null){return second;}
           if(second.front == null){return first;}
        
           //Initialize 1. the greater BigInt, 2. the result of both, 3. the least BigInt
           BigInteger result = new BigInteger();
           BigInteger Greater = new BigInteger();
           BigInteger Least = new BigInteger();
           
           //Now go through the conditional checks
           if(first.negative == second.negative){
              result.negative=first.negative;
              result.front=new DigitNode(0,null);
              DigitNode ptr1 = first.front;
              DigitNode ptr2 = second.front;
              DigitNode ptr3 = result.front;
              int carry = 0;
              for (;ptr1 != null && ptr2 != null; ptr1 = ptr1.next, ptr2 = ptr2.next) {
                 int digitsum = ptr1.digit + ptr2.digit + carry;
                 carry = digitsum/10;
                 ptr3.digit = digitsum%10;
                 if(ptr1.next != null || ptr2.next != null){
                    ptr3.next=new DigitNode(0,null);
                    ptr3 = ptr3.next;
                 }
              }
              for(;ptr1 != null; ptr1 = ptr1.next){
                 int digitsum= ptr1.digit + carry;
                 carry = digitsum/10;
                 ptr3.digit = digitsum % 10;
                 if(ptr1.next != null){
                    ptr3.next = new DigitNode(0,null);
                    ptr3 = ptr3.next;
                 }
              }
              for(; ptr2 != null; ptr2 = ptr2.next) {
                 int digitSum = ptr2.digit + carry;
                 carry = digitSum / 10;
                 ptr3.digit = digitSum % 10;
                 if(ptr2.next != null) {
                    ptr3.next = new DigitNode(0,null);
                    ptr3 = ptr3.next;
                 }
              }
              if(carry != 0){
                 ptr3.next=new DigitNode(carry,null);
              }

           }
           else {
              if(isBigger(first, second) == true){
                 larger=second;
                 smaller=first;
              }
              else{
                 larger=first;
                 smaller=second;
              }
              //the negative correlates with the larger value
              result.negative = larger.negative;
              
              DigitNode bigptr = larger.front;
              DigitNode smallptr = smaller.front;
              DigitNode answer = result.front;
              boolean a = false;
              boolean b = false;
              for(; bigptr != null && smallptr != null; bigptr = bigptr.next, smallptr = smallptr.next, answer = answer.next){
                 int bigdigit = bigptr.digit;
                 if(b){
                    bigdigit--;
                 }
                 
                 if(bigdigit<smallptr.digit || bigdigit < 0) {
                     bigdigit += 10;
                     a = true;
                 }
                 int diff = bigdigit - smallptr.digit;
                 answer.digit = diff;


                 if(bigptr.next != null || smallptr.next != null) {
                    answer.next = new DigitNode(0,null);
                 }
                 b = a;
                 a = false;
              }
              for(; bigptr != null; bigptr = bigptr.next) {
                 //Transfer and check
                 int bigdigit = bigptr.digit;
                 if(b) {
                    bigdigit--;
                 }
                 if(bigdigit < 0) {
                    bigdigit += 10;
                    a = true;
                 }
                 answer.digit = bigdigit;

                 //create a new node if anything is able to be copied
                 if(bigptr.next != null) {
                    answer.next = new DigitNode(0,null);
                    answer = answer.next;
                 }

                 b = a;
                 a = false;
              }
           }
           int count = 0; 
           int nonzero = 0;
           result.numDigits = 0;
           for(DigitNode ptr = result.front; ptr != null; ptr = ptr.next, count++) {
              if(ptr.digit != 0) {nonzero = count;}
           }
           count = 0;
           for(DigitNode ptr = result.front; ptr != null; ptr = ptr.next, count++) {
              result.numDigits++;
              if(count == nonzero) {ptr.next = null;break;}

           }
           if(result.numDigits == 1 && result.front.digit == 0 || result.numDigits == 0) {
              result.negative = false;
              result.front = null;
              result.numDigits = 0;
           }

           return result;
        }
    
    /**
     * Returns the BigInteger obtained by multiplying the first big integer
     * with the second big integer
     * 
     * This method DOES NOT MODIFY either of the input big integers
     * 
     * @param first First big integer
     * @param second Second big integer
     * @return A new BigInteger which is the product of the first and second big integers
     */
    
    public static BigInteger multiply(BigInteger first, BigInteger second) {
          //Set the value of BigInteger to allocate the product of BigInteger one and two
            BigInteger result = new BigInteger();
            
           //check if both are null or not, if null return the result
           if(first.front == null||second.front == null){return result;}
           
           //counter 
           int a = 0;

           for(DigitNode ptr2 = second.front; ptr2 != null; ptr2 = ptr2.next, a++) {
              BigInteger value = new BigInteger();
              value.front = new DigitNode(0, null);
              DigitNode valueptr = value.front;
              for(int k = 0; k < a; k++) {
                 valueptr.digit = 0;
                 valueptr.next = new DigitNode(0,null);
                 valueptr = valueptr.next;
              }
              int carry = 0;
              for(DigitNode ptr1 = first.front; ptr1 != null; ptr1 = ptr1.next) {
                 int product = ptr1.digit*ptr2.digit + carry;
                 carry = product / 10;
                 valueptr.digit = product % 10;
                 if(ptr1.next != null) {
                    valueptr.next = new DigitNode(0,null);
                    valueptr = valueptr.next;
                 } else {
                    if(carry != 0)
                       valueptr.next = new DigitNode(carry,null);
                       break;
                 }
              }
              //add both sets like in paper pencil multiplication
              result = result.add(value,result);
           }

           //Check for the rest of the conditions
           if(first.negative == second.negative) {
              result.negative = false;
           }
           else {
              result.negative = true;
           }
           int one = 0;
           int nthZero = 0;
           result.numDigits = 0;
           for(DigitNode ptr = result.front; ptr!= null; ptr = ptr.next,one++) {if(ptr.digit != 0) {nthZero = one;}}
           one = 0;
           for(DigitNode ptr = result.front; ptr!= null; ptr = ptr.next,one++) { result.numDigits++;if(one == nthZero) {ptr.next = null;break;}}
           if(result.numDigits == 1 && result.front.digit == 0 || result.numDigits == 0) {result.front = null;result.numDigits = 0;result.negative = false;}
           return result;
        }
        
        
    
    /* (non-Javadoc)
     * @see java.lang.Object#toString()
     */
    public String toString() {
        if (front == null) {
            return "0";
        }
        String retval = front.digit + "";
        for (DigitNode curr = front.next; curr != null; curr = curr.next) {
                retval = curr.digit + retval;
        }
        
        if (negative) {
            retval = '-' + retval;
        }
        return retval;
    }
}