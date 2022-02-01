module metrics::calculations::CyclomaticComplexity

import lang::java::m3::AST;
import lang::java::m3::Core;


/**
Calculate cyclomatic complexity in Java
In modern parlance, especially for the Java developer, 
we can simplify the McCabe cyclomatic complexity metric calculation with the following rules:

Assign one point to account for the start of the method
Add one point for each conditional construct, such as an "if" condition
Add one point for each iterative structure
Add one point for each case or default block in a switch statement
Add one point for any additional boolean condition, such as the use of && or ||

With exceptions, you can add each throws, throw, catch or finally block as a single point when calculating the McCabe cyclomatic complexity metric. 
However, given Java's fairly verbose exception handling semantics, counting exception related flows can unfairly malign a well coded method, 
so it's sometimes wise to ignore the additional points exception handling adds to the McCabe cyclomatic complexity metric total.
*
*/
public int calculateCyclomaticComplexityPerUnit(Statement implementation) {
	int complexity = 1;
	
	visit(implementation) {
	 	case \if(c,_): 	 			complexity += 1 + nrOfOperators(c);
	 	case \if(c,_,_): 			complexity += 1 + nrOfOperators(c);
	 	case \conditional(c,_,_):   complexity += 1 + nrOfOperators(c); 
	 	case \while(c,_):			complexity += 1 + nrOfOperators(c);
	 	case \do(_,c):				complexity += 1 + nrOfOperators(c);
	 	case \for(_,c,_,_):			complexity += 1 + nrOfOperators(c);
	 	case \for(_,_,_):			complexity += 1;
	 	case \foreach(_,_,_):		complexity += 1;
	 	case \case(_):				complexity += 1;
	 	case \catch(_,_):			complexity += 1;
	}
	
	return complexity;
}
	
	
private int nrOfOperators(Expression exp) {
	nrOfOps = 0;
	
	visit(exp) {
		case \infix(_,op,_): {
			if(op == "||") nrOfOps += 1;
			if(op == "&&") nrOfOps += 1;
		}
	}
	
	return nrOfOps;
}