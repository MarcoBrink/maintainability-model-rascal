module metrics::TestCoverageMetric

import util::Resources;
import util::Benchmark;
import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import Set;

public void test1(){
loc project = |project://test|;
//set[loc] bestanden  = { a | /file(a) <- getProject(project), a.extension == "java" };
M3 model = createM3FromEclipseProject(project);

rel[loc from, loc to] methodInvocations = model.methodInvocation;
//rel[loc from, loc to] methodAnnotations = model.annotations;


//step 1 get All Methods
set[Declaration] methods = findAllMethodsInProject(project);
<d, _ > = takeOneFrom(methods);
(_,_,_,_,s) <- d;
println(s);

//step 2 find all Unit Tests in Project
rel[loc from, loc to] methodAnnotations = model.annotations;

list[loc] l = [<x,y> <- methodAnnotations, y.path == "/org/junit/Test"];
 

//println(methodAnnotations);
}

private set[Declaration] findAllMethodsInProject(loc currentProject){
	set[Declaration] declarations = createAstsFromEclipseProject(currentProject, true); //Move to analyze??
	return allMethods(declarations);
}

private set[Declaration] allMethods(set[Declaration] decls){
	results = {};
	visit(decls){
		case m: \method(_,_,_,_, Statement s): results += m;
	}
	return results; 
}