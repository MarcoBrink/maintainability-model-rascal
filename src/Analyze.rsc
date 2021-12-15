module Analyze

import IO;
import String;
import util::Math;

import lang::java::m3::AST;
import lang::java::m3::Core;

import metrics::UnitComplexityMetric;
import metrics::DuplicationMetric;
import metrics::VolumeMetric;
import metrics::TestCoverageMetric;

import metrics::calculations::Normalize;


public void startAnalyses(){
	//loc currentProject = |project://consumer|;
	loc currentProject = |project://Jabberpoint-le3|;
	//loc currentProject = |project://testProject|;
	//loc currentProject = |project://hsqldb|;
	//1loc currentProject = |project://smallsql|;

	startAnalyses(currentProject);
}

public void startAnalyses(loc currentProject ){
	
	tuple[map[loc, list[str]] normalizedFiles, VolumeInfo metadata] result = normalizeFiles(currentProject);
	
	//calc volume metrics
	calculateVolume(result.metadata);
	
	//calculate  unit size and complexity metrics
	calculateUnitSizeAndComplexity(currentProject);
	
	//calc duplication metrics
	calculateDuplication(currentProject, result.normalizedFiles);
	
	//calc unit testing metrics
	calculateTestCoverage(currentProject, result.metadata.codeLines);
}

private void calculateVolume(VolumeInfo metadata)
{
	//from metrics::VolumeMetric
	str volumeRanking = calculateVolumeMetrics(metadata);
	println("-----------------Start volume Metrics-----------------");
	println();
	println("Results of volume analyses.");
	println("Total lines: <metadata.totalLines>");
	println("Code lines: <metadata.codeLines>");
	println("Comment lines: <metadata.totalLines - (metadata.codeLines + metadata.blankLines)>");
	println("Blank lines: <metadata.blankLines>");
	println();
	println("Volume ranking: " + volumeRanking);	
	println("-----------------End volume Metrics-----------------");
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

private void calculateDuplication(loc project, map[loc, list[str]] normalizedFiles){
	//from metrics::DuplicationMetric
	tuple[real,str] score = calculateDuplicationMetrics(project, normalizedFiles);
	
	println("-----------------Start Duplication Metrics-----------------");
	println();
	println("Results of duplication analyses.");
	println("Duplication: "+formatPercentage(score[0]));
	println();
	println("Overal Duplication Risk Ranking: "+score[1]);
	println();
	println("------------------End Duplication Metrics------------------");
}

private void calculateTestCoverage(loc currentProject, int totalLOC){
  tuple[int, real] score = calculateTestCoverageMetrics(currentProject, totalLOC);
  <numberOfAsserts, locPerAssert> = score;
 
  println("-----------------Start TestCoverage Metrics-----------------");
  println();
  println("Found: "+toString(numberOfAsserts)+" assert statements");
  println("Average lines of code per assert: "+toString(locPerAssert));
  println();
  println("-----------------End TestCoverage Metrics-----------------");
 }