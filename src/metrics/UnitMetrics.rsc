module metrics::UnitMetrics

import lang::java::m3::AST;
import lang::java::m3::Core;
import IO;

public int calculateCyclomaticComplexityPerUnit(Statement statement) {
	
	int methodCC = 1;
			
			
			visit (statement) {
				case \if(Expression condition, Statement thenBranch): {
					methodCC += countAndOr(condition);
				}
				case \if(Expression condition, Statement thenBranch, Statement elseBranch): {
					methodCC += countAndOr(condition);
				}
				case \case(Expression expression): {
					methodCC += 1;
				}
				case \while(Expression condition, Statement body): {
					methodCC += countAndOr(condition);
				}
				case \foreach(Declaration parameter, Expression collection, Statement body): {
					methodCC += 1;
				}
				case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body): {
					methodCC += countAndOr(condition);
				}
				case \for(list[Expression] initializers, list[Expression] updaters, Statement body): {
					methodCC += 1;
				}
				case \catch(Declaration exception, Statement body): {
					methodCC += 1;
				}
				case \continue(): {
					methodCC += 1;
				}
				case \continue(str label): {
					methodCC += 1;
				}
				case \break(): {
					methodCC += 1;
				}
				case \break(str label): {
					methodCC += 1;
				}
				//UITZOEKEN
				//case \throw(Expression expression): {
				//	methodCC += 1;
				//}
				//DO IETS MET RETURNS
				
				
			};
		
			return methodCC;
}

private int countAndOr(Expression expression) {
	int expressionCC = 1;
	
	visit (expression) {
		case \infix(Expression lhs, str operator, Expression rhs): {
			//iprintln("OPERATOR: <operator>");
			if (operator == "&&" || operator == "||") { 
				expressionCC += 1;
			}
		}
	};
	
	return expressionCC; 
}