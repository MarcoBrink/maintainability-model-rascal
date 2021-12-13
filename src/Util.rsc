module Util

import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import util::Resources;

alias Methods = rel[loc, Statement];
alias MethodScore = tuple[loc, Statement, int, int]; //location, Method, Number of lines, and UnitComplexity Score.

public Methods findAllMethodsInProject(loc currentProject){
	set[Declaration] declarations = createAstsFromEclipseProject(currentProject, true); //Move to analyze??
	return allMethods(declarations);
}

public Methods allMethods(set[Declaration] decls){
	results = {};
	visit(decls){
		case m: \method(_,_,_,_, Statement s): results += <m.src, s>;
		case c: \constructor(_,_,_, Statement s): results += <c.src, s>;
	}
	return results; 
}

public real percentage(int x, int total){
	if(x == 0|| total == 0){
	  return 0.0;
	}
	return (toReal(x)*100.0)/total;
}

public set[loc] fetchFiles(loc project){
	return { a | /file(a) <- getProject(project), a.extension == "java" };
}
