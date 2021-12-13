module metrics::UnitComplexityMetric

import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import metrics::calculations::CyclomaticComplexity;
import metrics::calculations::Normalize;
import Util;

import List; 
import Set;
import util::Math;

alias UnitScores = tuple[real, real, real, real]; // low, moderate, high, very_high

public list[tuple[UnitScores,str]] calculateUnitMetrics(loc project) {	
	
	Methods methods = findAllMethodsInProject(project);
	list[MethodScore] mscores = calculateVolumeAndComplexityPerUnit(methods);
	
	int totalLinesOfCode = totalLinesOfCodeOfAllMethods(mscores);
	
	UnitScores unitSizeCategories = calculateUnitSizePerCategory(mscores, totalLinesOfCode);
	str sizeRank = calculateRank(unitSizeCategories);
	
	UnitScores unitComplexityCategories = calculateUnitComplexityPerCategory(mscores, totalLinesOfCode);
	str complexityRank = calculateRank(unitComplexityCategories);
	
	return [<unitSizeCategories,sizeRank>,<unitComplexityCategories,complexityRank>];
}

private list[MethodScore] calculateVolumeAndComplexityPerUnit(Methods methods){
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

private str calculateRank(tuple[real, real, real, real] rls){
	if(rls[1] <= 25 && rls[2]<=0 && rls[3]<=0){
		return "++";
	}

	if(rls[1] <= 30 && rls[2]<=5 && rls[3]<=0){
		return "+";
	}
	
	if(rls[1] <= 40 && rls[2]<=10 && rls[3]<=0){
		return "o";
	}
	

	if(rls[1] <= 50 && rls[2]<=15 && rls[3]<=5){
		return "-";
	}
	
	return "--";
}