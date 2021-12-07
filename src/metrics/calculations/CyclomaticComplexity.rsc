module metrics::calculations::CyclomaticComplexity

import lang::java::m3::AST;
import lang::java::m3::Core;
//import IO;

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
	 	case \continue():			complexity += 1;
	 	case \continue(_):			complexity += 1;
	 	case \break():				complexity += 1;
	 	case \break(_):				complexity += 1;
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