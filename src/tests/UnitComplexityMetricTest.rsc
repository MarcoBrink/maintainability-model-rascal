module tests::UnitComplexityMetricTest

import lang::java::jdt::m3::AST;
import metrics::UnitComplexityMetric;
import metrics::rankings::UnitRanking;
import util::Math;
import IO;
import SIGRanking;

public test bool test1(){
	loc file =  |project://maintainability-metrics//testData//CyclomaticTestData.java|;
	Declaration declaration = createAstFromFile(file,true);
	UnitMetricsResult results = calculateUnitMetrics({declaration}); 
	
	try {
	  assert round(results[0][0][0], 0.1) == 8.0;
	  assert round(results[0][0][1], 0.1) == 10.9;
	  assert round(results[0][0][2], 0.1) == 47.9;
	  assert round(results[0][0][3], 0.1) == 33.2;
	  
	  assert round(results[1][0][0], 0.1) == 41.2;
	  assert round(results[1][0][1], 0.1) == 10.9;
	  assert round(results[1][0][2], 0.1) == 18.5;
	  assert round(results[1][0][3], 0.1) == 29.4;
	  
	  assert results.totalUnits == 6;
	  assert results.averageUnitSize > 39.66 && results.averageUnitSize < 39.67;
	  assert results.averageUnitComplexity > 18.33 && results.averageUnitComplexity < 18.34;
	} catch:
		return false;
	
	return true;
}

public test bool test2(){
	try {
	assert getUnitRanking(<75.,25.,0.,0.>) == VERY_HIGH;
	assert getUnitRanking(<80.,20.,0.,0.>) == VERY_HIGH;
	
	assert getUnitRanking(<80.,10.,0.,0.>) == VERY_HIGH;
	assert getUnitRanking(<95.,5.,0.,0.>) == VERY_HIGH;
	
	assert getUnitRanking(<65.,30.,5.,0.>) == HIGH;
	assert getUnitRanking(<67.,29.,4.,0.>) == HIGH;
	
	assert getUnitRanking(<50.,40.,10.,0.>) == MODEST;	
	assert getUnitRanking(<52.,39.,9.,0.>) == MODEST;
	
	assert getUnitRanking(<30.,50.,15.,5.>) == LOW;
	assert getUnitRanking(<33.,49.,14.,4.>) == LOW;
	
	assert getUnitRanking(<0.,51.,0.,0.>) == VERY_LOW;
	assert getUnitRanking(<0.,0.,16.,0.>) == VERY_LOW;
	assert getUnitRanking(<0.,0.,0.,6.>) == VERY_LOW;
	
	assert getUnitRanking(<29.,51.,15.,5.>) == VERY_LOW;
	assert getUnitRanking(<0.,0.,16.,0.>) == VERY_LOW;
	
	} catch: return false;
	
	return true;
}