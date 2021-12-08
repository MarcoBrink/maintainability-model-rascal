module Analyze

import IO;
import String;
import util::Math;
import metrics::UnitComplexity;

alias UnitScores = tuple[real, real, real, real]; // low, moderate, high, very_high

public void startAnalyses(){
	//loc currentProject = |project://consumer|;
	//loc currentProject = |project://Jabberpoint-le3|;
	loc currentProject = |project://smallsql|;
	//loc currentProject = |project://hsqldb|;
	//loc currentProject = |project://test|;
	startAnalyses(currentProject);
}

public void startAnalyses(loc currentProject ){
	//calc volume
	
	//calc complexity per unit and unit Size
	calculateUnitSizeAndComplexity(currentProject);
	
	//calc duplication
	
	//calc unit testing
	
}

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
	
	println("  Results of " +label + " risk analyses.");
	println("||  low  ||   moderate   ||   high   ||  very high ||");
	println("|| "+format(scores[0])+" ||    "+format(scores[1])+"     ||  "+format(scores[2])+"   ||   "+format(scores[3])+"    ||");
	println();
	println("Overal "+label+" Risk Ranking: "+overall);
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