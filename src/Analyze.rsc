module Analyze

import IO;
import String;
import util::Math;

import metrics::UnitComplexityMetric;
import metrics::DuplicationMetric;

public void startAnalyses(){
	//loc currentProject = |project://consumer|;
	//loc currentProject = |project://Jabberpoint-le3|;
	loc currentProject = |project://smallsql|;
	//loc currentProject = |project://hsqldb|;
	//loc currentProject = |project://test|;
	//loc currentProject = |project://testDup|;
	startAnalyses(currentProject);
}

public void startAnalyses(loc currentProject ){
	//calc volume
	
	
	//calc complexity per unit and unit Size
	calculateUnitSizeAndComplexity(currentProject);
	
	//calc duplication
	calculateDuplication(currentProject);
	
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
	println();
}

private void printUnitScores(str label, tuple[UnitScores,str] ranking){
	UnitScores scores = ranking[0];
	str overall = ranking[1];
	str lowScore = formatPercentage(scores[0]);
	str modScore = formatPercentage(scores[1]);
	str highScore = formatPercentage(scores[2]);
	str vhighScore = formatPercentage(scores[3]);
	
	println("  Results of " +label + " risk analyses.");
	println("||   low    ||   moderate   ||   high    ||  very high ||");
	println("||   "+lowScore+" ||   "+modScore+"     ||   "+highScore+"  ||  "+vhighScore+"    ||");
	println();
	println("Overal "+label+" Risk Ranking: "+overall);
	println();
}

private str formatPercentage(real n){
	real r = round(n, 0.1);
	s = toString(r)+"%";
	while(size(s) < 6){
	 s =s+ " ";
	}
	return s;
}

private void calculateDuplication(loc project){
	//from metrics::DuplicationMetric
	tuple[real,str] score = calculateDuplicationMetrics(project);
	
	println("-----------------Start Duplication Metrics-----------------");
	println();
	println("Results of duplication analyses.");
	println("Duplication: "+formatPercentage(score[0]));
	println();
	println("Overal Duplication Risk Ranking: "+score[1]);
	println();
	println("------------------End Duplication Metrics------------------");
}