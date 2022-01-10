module Results

import SIGRanking;
import metrics::UnitComplexityMetric;
import lang::java::jdt::m3::AST;

alias UnitScores  = tuple[real, real, real, real]; // low, moderate, high, very_high
alias MethodScore = tuple[loc, Statement, int, int]; //location, Method, Number of lines, and UnitComplexity Score.

alias UnitComplexityScores = tuple[UnitScores scores, Ranking rating];
alias UnitSizeScores       = tuple[UnitScores scores, Ranking rating];

alias UnitMetricsResult = tuple[UnitSizeScores unitSizeScores, UnitComplexityScores unitComplexityScores, int totalUnits, real averageUnitSize, real averageUnitComplexity, list[MethodScore] mscores];

alias DuplicationMetricsResult = tuple[Ranking ranking, real percentage];
alias TestCoverageMetricResult = tuple[Ranking ranking, int totalAsserts, real coverage];
alias VolumeMetricsResult      = tuple[Ranking ranking, map[loc, list[str]] normalizedFiles, int files, int totalLines, int codeLines, int blankLines];

data Results = results(
		//str project naam
		//M3
		UnitMetricsResult unitMetricsResult,
 		DuplicationMetricsResult duplicationMetricsResult,
 		TestCoverageMetricResult testCoverageMetricResult,
 		VolumeMetricsResult volumeMetricsResult
  ) | empty();
  