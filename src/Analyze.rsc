module Analyze

import lang::java::jdt::m3::AST;

import metrics::UnitComplexityMetric;
import metrics::DuplicationMetric;
import metrics::VolumeMetric;
import metrics::TestCoverageMetric;

import SIGRanking;
import Util;

public void startAnalyses(){
	//loc currentProject = |project://consumer|;
	//loc currentProject = |project://Jabberpoint-le3|;
	//loc currentProject = |project://testProject|;

	//loc currentProject = |project://hsqldb|;
	loc currentProject = |project://smallsql|;
	startAnalyses(currentProject, true);
}

public void startAnalyses(loc project, bool print){
	//calc volume metrics
	//from metrics::VolumeMetric
	VolumeMetricsResult volResult = calculateVolumeMetrics(project);
	Ranking volumeRating = volResult.ranking;
	
	//calculate  unit size and complexity metrics
	set[Declaration] declarations = createAstsFromEclipseProject(project, true);
	//from metrics::UnitComplexity
	UnitMetricsResult unitResult = calculateUnitMetrics(declarations);
	Ranking unitSizeRating = unitResult.unitSizeScores.rating;
	Ranking unitComplexityRating = unitResult.unitComplexityScores.rating;
	
	//calc duplication metrics
	//from metrics::DuplicationMetric
	DuplicationMetricsResult dupResult = calculateDuplicationMetrics(volResult.normalizedFiles);
	Ranking duplicationRating = dupResult.rating;
	
	//calc unit testing metrics
	TestCoverageMetricResult testResult = calculateTestCoverageMetrics(declarations, volResult.codeLines, unitResult.totalUnits, unitResult.averageUnitComplexity);
	Ranking testCoverageRating = testResult.ranking;
	
	//print results
	if(print){
	  printVolumeMetrics(volResult);
	  printUnitSizeAndComplexity(unitResult);
	  printDuplicationScore(dupResult);
	  printTestCoverage(testResult);	
	}
	
	
	Ranking analysability = averageRanking([volumeRating, duplicationRating, unitSizeRating, testCoverageRating]);
	Ranking changeability = averageRanking([unitComplexityRating,duplicationRating]);
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
	println("Duplication: "+formatPercentage(score[0]));
	println();
	println("Overal Duplication Risk Ranking: "+score[1].rating);
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