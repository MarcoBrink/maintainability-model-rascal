module Analyze

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import metrics::UnitComplexityMetric;
import metrics::DuplicationMetric;
import metrics::VolumeMetric;
import metrics::TestCoverageMetric;

import visualisation::MainPanel;

import Results;
import IO;

import Util;
import Cache;

public void startAnalyses(){
	loc p1 = |project://consumer|;
	loc p2 = |project://Jabberpoint-le3|;
	loc p3 = |project://testProject|;
	loc p4 = |project://hsqldb|;
	loc p5 = |project://smallsql|;
	loc p6 = |project://Jabberpoint|;
	loc p7 = |project://CM5Operations|;
	
	startAnalyses(p7, true);
}

public void startAnalyses(loc project, bool print){	
	Results results;
	println("Loading the following project: "+project.authority);
	if(isCached(project)){
	  results = getResults(project);
	  println("Project found in Cache.");
	}else{
	  println("Project not in Cache, processing.");
	  results = processProject(project, print);
	  saveResults(project, results);
	}
	
	begin(results);
}


private Results processProject(loc project, bool print){
	
	//calc volume metrics
	//from metrics::VolumeMetric 
	VolumeMetricsResult volumeMetricsResult = calculateVolumeMetrics(project);
	Ranking volumeRating = volumeMetricsResult.ranking;
	
	//calculate  unit size and complexity metrics
	set[Declaration] declarations = createAstsFromEclipseProject(project, true);
	//from metrics::UnitComplexity
	UnitMetricsResult unitMetricsResult = calculateUnitMetrics(declarations);
	Ranking unitSizeRating = unitMetricsResult.unitSizeScores.rating;
	Ranking unitComplexityRating = unitMetricsResult.unitComplexityScores.rating;
	
	//calc duplication metrics
	//from metrics::DuplicationMetric
	DuplicationMetricsResult duplicationMetricsResult = calculateDuplicationMetrics(volumeMetricsResult.normalizedFiles);
	Ranking duplicationRating = duplicationMetricsResult.ranking;
	
	//calc unit testing metrics
	TestCoverageMetricResult testCoverageMetricResult = calculateTestCoverageMetrics(declarations, volumeMetricsResult.codeLines, unitMetricsResult.totalUnits, unitMetricsResult.averageUnitComplexity);
	Ranking testCoverageRating = testCoverageMetricResult.ranking;
	
	//print results
	if(print){
	  printVolumeMetrics(volumeMetricsResult);
	  printUnitSizeAndComplexity(unitMetricsResult);
	  printDuplicationScore(duplicationMetricsResult);
	  printTestCoverage(testCoverageMetricResult);	
	}
	
	
	Ranking analysability = averageRanking([volumeRating, duplicationRating, unitSizeRating, testCoverageRating]);
	Ranking changeability = averageRanking([unitComplexityRating, duplicationRating]);
	Ranking stability = averageRanking([testCoverageRating]);
	Ranking testability = averageRanking([unitComplexityRating, unitSizeRating, testCoverageRating]);
	
	Ranking maintainability = averageRanking([analysability, changeability, stability, testability]);
	
	if(print){
		println("Analysability: "+analysability.rating);
		println("Changeability: "+changeability.rating);
		println("Stability: "+stability.rating);
		println("Testability: "+testability.rating);
		println("--------------------------------------------");
		println("Overall Maintainability: "+maintainability.rating);
	}
	
	Results _results = results(
	    project,
	    //createM3FromEclipseProject(project),
		unitMetricsResult,
 		duplicationMetricsResult,
 		testCoverageMetricResult,
 		volumeMetricsResult
  	);
  	
  	return _results;
}

private void printVolumeMetrics(VolumeMetricsResult volResult) {	
	println("-----------------Start volume Metrics-----------------");
	println();
	println("Results of volume analyses.");
	println("Total lines: <volResult.totalLines>");
	println("Code lines: <volResult.codeLines>");
	println("Comment lines: <volResult.totalLines - (volResult.codeLines + volResult.blankLines)>");
	println("Blank lines: <volResult.blankLines>");
	println();
	println("Volume ranking: " + volResult.ranking.rating);	
	println("-----------------End volume Metrics-----------------");
}

private void printUnitSizeAndComplexity(UnitMetricsResult unitResults){
	println("-----------------Start Unit Metrics-----------------");
	println();
	println("number of units: "+toString(unitResults.totalUnits));
	println();
	printUnitScores("Unit Size", unitResults.unitSizeScores);
	printUnitScores("Unit Complexity", unitResults.unitComplexityScores);
	println("------------------End Unit Metrics------------------");
	println();
}

private void printUnitScores(str label, tuple[UnitScores, Ranking] ranking){
	UnitScores scores = ranking[0];
	str overall = ranking[1].rating;
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

private void printDuplicationScore(DuplicationMetricsResult score){
	println("-----------------Start Duplication Metrics-----------------");
	println();
	println("Results of duplication analyses.");
	println("Duplication: "+formatPercentage(score.percentage));
	println();
	println("Overal Duplication Risk Ranking: "+score.ranking.rating);
	println();
	println("------------------End Duplication Metrics------------------");
}

private void printTestCoverage(TestCoverageMetricResult score){
  <ranking, numberOfAsserts, locPerAssert> = score;
 
  println("-----------------Start TestCoverage Metrics-----------------");
  println();
  println("Found: "+toString(numberOfAsserts)+" assert statements");
  println("Average lines of code per assert: "+toString(locPerAssert));
  println("Overal Test Coverage Risk Ranking: "+ranking.rating);
  println();
  println("-----------------End TestCoverage Metrics-----------------");
 }