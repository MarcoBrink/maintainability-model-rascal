module Results

import metrics::UnitComplexityMetric;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import List;
import util::Math;

alias UnitScores  = tuple[real, real, real, real]; // low, moderate, high, very_high
alias MethodScore = tuple[loc, str, int, int]; //location, Method, Number of lines, and UnitComplexity Score.

alias UnitComplexityScores = tuple[UnitScores scores, Ranking rating];
alias UnitSizeScores       = tuple[UnitScores scores, Ranking rating];

alias UnitMetricsResult = tuple[UnitSizeScores unitSizeScores, UnitComplexityScores unitComplexityScores, int totalUnits, real averageUnitSize, real averageUnitComplexity, list[MethodScore] mscores, int maxComplexity, int maxLoc, int totalUnitLines];

alias DuplicationMetricsResult = tuple[Ranking ranking, real percentage];
alias TestCoverageMetricResult = tuple[Ranking ranking, int totalAsserts, real coverage];
alias VolumeMetricsResult      = tuple[Ranking ranking, map[loc, list[str]] normalizedFiles, int files, int totalLines, int codeLines, int blankLines];

data Results = results(
		loc location,
		UnitMetricsResult unitMetricsResult,
 		DuplicationMetricsResult duplicationMetricsResult,
 		TestCoverageMetricResult testCoverageMetricResult,
 		VolumeMetricsResult volumeMetricsResult
  ) | empty();

  
data Ranking = score(str label, str rating, int val);

public Ranking VERY_HIGH = score("Very High", "++", 5);
public Ranking HIGH = score("High", "+",4);
public Ranking MODEST = score("Modest", "o",3);
public Ranking LOW = score("Low", "-", 2);
public Ranking VERY_LOW = score("Very Low", "--", 1);
public Ranking UNKNOWN = score("unknown", "", 0);

public Ranking getRanking(int val){
	switch(val){
	  case 5: return VERY_HIGH;
	  case 4: return HIGH;
	  case 3: return MODEST;
	  case 2: return LOW;
	  case 1 : return VERY_LOW;
	  default: return UNKNOWN;
	}
}

public Ranking averageRanking(list[Ranking] rankings){
	int total = sum([r.val |r <- rankings]);
	real average = toReal(total) / toReal(size(rankings));
	return getRanking(round(average));
}