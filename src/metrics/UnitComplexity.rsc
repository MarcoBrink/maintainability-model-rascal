module metrics::UnitComplexity

import lang::java::m3::AST;
import lang::java::m3::Core;

import metrics::VolumeUtil;
import metrics::UnitMetrics;

import List; 
import Set;
import IO;
import util::Math;

alias Methods = rel[loc, Statement];
alias MethodScore = tuple[loc, Statement, int, int]; //location, Method, Number of lines, and UnitComplexity Score.
alias AbsoluteLOCs = tuple[int, int, int, int]; // low, moderate, high, very_high
alias RelativeLOCs = tuple[int, int, int, int]; // low, moderate, high, very_high

public str calculateUnitMetrics(Methods methods) {
	println("starting");
	list[MethodScore] mscores = [<a,b,volume(a),calcCC(b)> | <a,b> <- methods];
	int totalLinesOfCode = totalLinesOfCode(mscores);
	println("Total LOC: "+toString(totalLinesOfCode));
	AbsoluteLOCs alocs = groupByRiskGroup(mscores);
	println(alocs);
	RelativeLOCs rlocs = relative(alocs, totalLinesOfCode);
	println(rlocs);
	str ranking = calculateRank(rlocs);
	println("Complexity per unit Ranking = "+ranking);
	return ranking;
}

private int calcCC(Statement statement) {
	//method from metrics::calculations::UnitMetrics
	int result = calculateCyclomaticComplexityPerUnit(statement);
	println(result);
	return result;
}


private int volume(loc location) {
	//method frome util::VolumeUtil
	int result = calculateLinesOfCode(location);
	return result;
}

private int totalLinesOfCode(list[MethodScore] ms){
	//method from List
	return sum([x | <_,_,x,_> <-ms]);
}

private AbsoluteLOCs groupByRiskGroup(list[MethodScore] mss){
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



private RelativeLOCs relative(tuple[int,int,int,int] abs, int total){
	return <percentage(abs[0],total),percentage(abs[1],total),percentage(abs[2],total),percentage(abs[3],total)>;
}

private int percentage(int x, int total){
	return (x*100)/total;
}

private str calculateRank(RelativeLOCs rls){
	if(rls[1] < 26 && rls[2]<1 && rls[3]< 1){
		return "++";
	}

	if(rls[1] < 31 && rls[2]<6 && rls[3]< 1){
		return "+";
	}

	if(rls[1] < 41 && rls[2]<11 && rls[3]< 1){
		return "o";
	}
	

	if(rls[1] < 51 && rls[2]<16 && rls[3]<6){
		return "-";
	}
	
	return "--";
}