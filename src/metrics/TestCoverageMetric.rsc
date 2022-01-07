module metrics::TestCoverageMetric

import lang::java::jdt::m3::AST;

import util::Math;
import String;

import metrics::calculations::Normalize;
import metrics::rankings::TestCoverageRanking;

import Util;
import SIGRanking;

alias TestCoverageMetricResult = tuple[Ranking ranking, int totalAsserts, real coverage];

public TestCoverageMetricResult calculateTestCoverageMetrics(set[Declaration] asts, int totalLOC, int totalUnits, real averageUnitComplexity){
  int count = 0;
  
  visit(asts){
	case m: \method(_,_, _,_, Statement implementation): count+= countAsserts(implementation);
  }
  
  if(count == 0){
    return <VERY_LOW, 0, 0.0>;
  }
  
  Ranking ranking = getTestCoverageRanking(count, totalUnits, averageUnitComplexity);
  
  return <ranking, count, toReal(totalLOC)/count>;
}

private int countAsserts(Statement implementation){
  int count = 0;
  visit(implementation) {
    case \assert(_,_): count += 1;
	case \assert(_): count += 1;
	case \methodCall(_,_,n,_): if(startsWith(n,"assert")){count += 1;}
	case \methodCall(_,n,_): if(startsWith(n,"assert")){count += 1;}
  }
  return count;		  
}
