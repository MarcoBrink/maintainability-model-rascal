module Analyze

import IO;
import List;
import Set;

import util::Math;
import metrics::UnitComplexity;
import metrics::Volume;

import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

public void startAnalyses(){
	//loc currentProject = |project://consumer|;
	//loc currentProject = |project://Jabberpoint-le3|;
	//loc currentProject = |project://smallsql|;
	loc currentProject = |project://hsqldb|;
	//loc currentProject = |project://test|;
	
	//TODO MOVE
	// Global variables used by UnitComplexity and Unit Size
	//from lang::java::jdt::m3::AST
	M3 model = createM3FromEclipseProject(currentProject);
	set[Declaration] declarations = createAstsFromEclipseProject(currentProject, true); 
	Methods methods = allMethods(declarations);
	println("Found " + toString(size(methods))+" methods");
	
	//calc volume
	calculateVolume(model);
	//calc complexity per unit and unit Size
	//calculateUnitMetrics(methods);
	
	//display unit size
	
	//calc duplication
	
	//calc unit testing
	
}


//private void calculateUnitComplexity(Methods methodes){
//	//from metrics::UnitComplexity
//	str rating = calculateUnitMetrics(methods);
//	println(rating);
//}



//TODO Move to different Module
private Methods allMethods(set[Declaration] decls){
	results = {};
	visit(decls){
		case m: \method(_,_,_,_, Statement s):
			results += <m.src, s>;
		case c: \constructor(_,_,_, Statement s):
			results += <c.src, s>;
	}

	return results; 
}