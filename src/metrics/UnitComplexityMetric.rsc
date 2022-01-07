module metrics::UnitComplexityMetric

//import lang::java::m3::AST;
//import lang::java::m3::Core;
//import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import metrics::rankings::UnitRanking;
import metrics::calculations::CyclomaticComplexity;
import metrics::calculations::Normalize;

import SIGRanking;
import Results;
import Util;

alias Methods = rel[loc, Statement];
//alias UnitScores = tuple[real, real, real, real]; // low, moderate, high, very_high
alias MethodScore = tuple[loc, Statement, int, int]; //location, Method, Number of lines, and UnitComplexity Score.

//alias UnitComplexityScores = tuple[UnitScores scores, Ranking rating];
//alias UnitSizeScores = tuple[UnitScores scores, Ranking rating];

//alias UnitMetricsResult = tuple[UnitSizeScores unitSizeScores, UnitComplexityScores unitComplexityScores, int totalUnits, real averageUnitSize, real averageUnitComplexity];

public UnitMetricsResult calculateUnitMetrics(set[Declaration] declarations) {	
	
	Methods methods = allMethods(declarations);
	list[MethodScore] mscores = calculateVolumeAndComplexityPerUnit(methods);
	
	scores = [x|<_,_,_,x> <- mscores];
	int sumCC = sum(scores);
	int totalUnits = size(scores);
	int totalLinesOfCode = totalLinesOfCodeOfAllMethods(mscores);
	
	real averageComplexity = 1.0;
	real averageSize = 0.0;
	
	if(totalUnits >0){
	  averageComplexity = toReal(sumCC)/totalUnits;
	  averageSize = toReal(totalLinesOfCode)/totalUnits;
	}
	
	
	
	UnitScores unitSizeCategories = calculateUnitSizePerCategory(mscores, totalLinesOfCode);
	Ranking sizeRank = getUnitRanking(unitSizeCategories);
	
	UnitScores unitComplexityCategories = calculateUnitComplexityPerCategory(mscores, totalLinesOfCode);
	Ranking complexityRank = getUnitRanking(unitComplexityCategories);
	
	return <<unitSizeCategories,sizeRank>,<unitComplexityCategories,complexityRank>, totalUnits, averageSize, averageComplexity>;
}

public Methods allMethods(set[Declaration] decls){
	methods = {};
	visit(decls){
		case m: \method(_,_,_,_, Statement s): methods += <m.src, s>;
		case c: \constructor(_,_,_, Statement s): methods += <c.src, s>;
	}
	return methods; 
}

private list[MethodScore] calculateVolumeAndComplexityPerUnit(Methods methods){
    //normalize from metrics::calculations::Normalize
	return [<a,b,normalizedUnit.metadata.codeLines,calcCC(b)> | <a,b> <- methods, tuple[list[str] unit, VolumeInfo metadata] normalizedUnit := normalize(a)];
}

private int calcCC(Statement statement) {
	//method from metrics::calculations::CyclomaticComplexity;
	int result = calculateCyclomaticComplexityPerUnit(statement);
	return result;
}

private int totalLinesOfCodeOfAllMethods(list[MethodScore] ms){
	//method from List
	return sum([0]+[x | <_,_,x,_> <-ms]);
}

private UnitScores calculateUnitSizePerCategory(list[MethodScore] mscores, totalLinesOfCode){
	tuple[int, int, int, int] alocs = groupSizeByRiskGroup(mscores);
	return relative(alocs, totalLinesOfCode);
}

private UnitScores calculateUnitComplexityPerCategory(list[MethodScore] mscores, totalLinesOfCode){
	tuple[int, int, int, int] alocs = groupComplexityByRiskGroup(mscores);
	return relative(alocs, totalLinesOfCode);
}

private tuple[int, int, int, int] groupSizeByRiskGroup(list[MethodScore] mss){
	tuple[int,int,int,int] score = <0,0,0,0>;
	
	for(ms <-mss){
		int lines = ms[2];
		if(lines>75){
			score = <score[0],score[1],score[2],score[3]+lines>;
			continue;		
		}
		if(lines>30){
			score = <score[0],score[1],score[2]+lines,score[3]>;
			continue;	
		}
		
		if(lines>15){
			score = <score[0],score[1]+lines,score[2],score[3]>;
			continue;	
		}
			
		score = <score[0]+lines,score[1],score[2],score[3]>;	
		
	}	
	return score;
}

/**
Group score according to McCabe's categorisation
1-10 low risk
11-20 moderate risk
21-50 high risk
50+ very high risk
*/
private tuple[int, int, int, int] groupComplexityByRiskGroup(list[MethodScore] mss){
	tuple[int,int,int,int] score = <0,0,0,0>;
	
	for(ms <-mss){
		int x = ms[3];
		int lines = ms[2];
	
		if(x>50){
			score = <score[0],score[1],score[2],score[3]+lines>;
			continue;		
		}
		if(x>20){
			score = <score[0],score[1],score[2]+lines,score[3]>;
			continue;	
		}
		
		if(x>10){
			score = <score[0],score[1]+lines,score[2],score[3]>;
			continue;	
		}
			
		score = <score[0]+lines,score[1],score[2],score[3]>;	
		
	}	
	return score;
}

private tuple[real, real, real, real] relative(tuple[int,int,int,int] abs, int total){
	return <percentage(abs[0],total),percentage(abs[1],total),percentage(abs[2],total),percentage(abs[3],total)>;
}