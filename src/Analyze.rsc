module Analyze

import IO;
import String;
import util::Math;
import metrics::UnitComplexity;
import metrics::Volume;


import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

public void startAnalyses(){
	//loc currentProject = |project://consumer|;
	//loc currentProject = |project://Jabberpoint-le3|;
	loc currentProject = |project://testProject|;
	//loc currentProject = |project://hsqldb|;
	//loc currentProject = |project://test|;

	startAnalyses(currentProject);
}

public void startAnalyses(loc currentProject ){

	//TODO MOVE
	// Global variables used by UnitComplexity and Unit Size
	//from lang::java::jdt::m3::AST
	M3 model = createM3FromEclipseProject(currentProject);
	
	//calc volume
	calculateVolume(model, false);
	//calc complexity per unit and unit Size
	//calculateUnitMetrics(methods);
	
	//display unit size
	calculateUnitSizeAndComplexity(currentProject);
	
	//calc duplication
	
	//calc unit testing
	
}



//private void calculateUnitComplexity(Methods methodes){
//	//from metrics::UnitComplexity
//	str rating = calculateUnitMetrics(methods);
//	println(rating);
//}

private void calculateUnitSizeAndComplexity(loc currentProject){
	//from metrics::UnitComplexity
	list[tuple[UnitScores,str]]  ratings = calculateUnitMetrics(currentProject);
	println("-----------------Start Unit Metrics-----------------");
	println();
	printUnitScores("Unit Size", ratings[0]);
	printUnitScores("Unit Complexity", ratings[1]);
	println("------------------End Unit Metrics------------------");
}


private void printUnitScores(str label, tuple[UnitScores,str] ranking){
	UnitScores scores = ranking[0];
	str overall = ranking[1];
	
	println("  Results of " +label + " analyses.");
	println("||  low  ||   mid   ||   high   ||  very high ||");
	println("|| "+format(scores[0])+" ||  "+format(scores[1])+"  ||  "+format(scores[2])+"   ||   "+format(scores[3])+"    ||");
	println();
	println("Overal Ranking: "+overall);
	println();
}

private str format(real n){
	real r = round(n, 0.1);
	s = toString(r)+"%";
	while(size(s) < 5){
	 s =s+ " ";
	}
	return s;
}