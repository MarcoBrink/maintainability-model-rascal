module tests::TestCoverageMetricTest

import lang::java::jdt::m3::AST;
import metrics::TestCoverageMetric;
import metrics::rankings::TestCoverageRanking;
import IO;
import SIGRanking;
import Results;

public test bool test1(){
  loc file =  |project://maintainability-metrics//testData//TestCoverageTestData.java|;
	Declaration declaration = createAstFromFile(file,true);
	TestCoverageMetricResult testResult = calculateTestCoverageMetrics({declaration}, 500, 50, 3.0);
	
	try{
	  assert testResult[1] == 9;
	  assert testResult[2] > 55.55 && testResult[2] < 55.56;	
	}catch: return false;
	
	return true;
}

public test bool test2(){
	try{
	
		assert getTestCoverageRanking(20, 10, 2.0) == VERY_HIGH; 
		assert getTestCoverageRanking(19, 10, 2.0) == VERY_HIGH; 
		
		assert getTestCoverageRanking(32, 10, 4.0) == HIGH;
		assert getTestCoverageRanking(16, 10, 2.0) == HIGH;
		assert getTestCoverageRanking(17, 10, 2.0) == HIGH;
		
		
		assert getTestCoverageRanking(16, 10, 2.0) == HIGH;
		assert getTestCoverageRanking(7, 10, 1.0) == MODEST;
		assert getTestCoverageRanking(15, 10, 2.0) == MODEST;
		
		
		assert getTestCoverageRanking(12, 10, 2.0) == MODEST; //60%
		assert getTestCoverageRanking(11, 10, 2.0) == LOW; //55%
		assert getTestCoverageRanking(9, 20, 1.0) == LOW; 
		
		assert getTestCoverageRanking(4, 10, 2.0) == LOW; //20%
		assert getTestCoverageRanking(3, 10, 2.0) == VERY_LOW; //15%
		
		assert getTestCoverageRanking(2, 10, 2.0) == VERY_LOW; //10%
		assert getTestCoverageRanking(0, 10, 2.0) == VERY_LOW; //0%
		assert getTestCoverageRanking(0, 10, 0.0) == VERY_LOW; 
		
		assert getTestCoverageRanking(0, 0, 0.0) == VERY_LOW;
	}catch: return false;
	
	return true;
}