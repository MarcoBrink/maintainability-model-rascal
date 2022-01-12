module Results

import SIGRanking;
import metrics::UnitComplexityMetric;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;


alias UnitScores  = tuple[real, real, real, real]; // low, moderate, high, very_high
alias MethodScore = tuple[loc, Statement, int, int]; //location, Method, Number of lines, and UnitComplexity Score.

alias UnitComplexityScores = tuple[UnitScores scores, Ranking rating];
alias UnitSizeScores       = tuple[UnitScores scores, Ranking rating];

alias UnitMetricsResult = tuple[UnitSizeScores unitSizeScores, UnitComplexityScores unitComplexityScores, int totalUnits, real averageUnitSize, real averageUnitComplexity, list[MethodScore] mscores, int maxComplexity, int maxLoc, int totalUnitLines];

alias DuplicationMetricsResult = tuple[Ranking ranking, real percentage];
alias TestCoverageMetricResult = tuple[Ranking ranking, int totalAsserts, real coverage];
alias VolumeMetricsResult      = tuple[Ranking ranking, map[loc, list[str]] normalizedFiles, int files, int totalLines, int codeLines, int blankLines];

data Results = results(
		loc location,
		M3 m3,
		UnitMetricsResult unitMetricsResult,
 		DuplicationMetricsResult duplicationMetricsResult,
 		TestCoverageMetricResult testCoverageMetricResult,
 		VolumeMetricsResult volumeMetricsResult
  ) | empty();
  