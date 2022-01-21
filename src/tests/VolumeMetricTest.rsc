module tests::VolumeMetricTest

import lang::java::jdt::m3::AST;
import metrics::rankings::VolumeRanking;
import metrics::UnitComplexityMetric;
import metrics::calculations::Normalize;
import metrics::VolumeMetric;
import SIGRanking;
import IO;
import List;
import Results;

public test bool test1(){
  loc project =  |project://maintainability-metrics|;
  VolumeMetricsResult result = calculateVolumeMetrics(project);
  
  try{
    assert result.files == 3;
    assert result.totalLines == 452;
    assert result.codeLines == 369;
    assert result.blankLines == 49;
  }catch: return false;
  
  return true;
}

public test bool test2(){
  try{
	  assert getVolumeRanking(0) == VERY_HIGH;
	  assert getVolumeRanking(30000) == VERY_HIGH;
	  assert getVolumeRanking(65000) == VERY_HIGH;
	  
	  assert getVolumeRanking(66000) == HIGH;
	  assert getVolumeRanking(245000) == HIGH;
	  
	  assert getVolumeRanking(246000) == MODEST;
	  assert getVolumeRanking(664000) == MODEST;
	  
	  assert getVolumeRanking(665000) == LOW;
	  assert getVolumeRanking(1309000) == LOW;
	
	  assert getVolumeRanking(1310000) == VERY_LOW;
	  assert getVolumeRanking(99999000) == VERY_LOW;
  }catch: return false;

  return true;
}

public test bool test3()
{
	loc file =  |project://maintainability-metrics//testData//VolumeTestData.java|;
	Declaration declaration = createAstFromFile(file, false);
	Methods methods = allMethods({declaration});
	methodsInfo = (c : normalizedUnit.metadata | <a,b,c> <- methods,  tuple[list[str] unit, VolumeInfo metadata] normalizedUnit := normalize(a));
	try
	{
		VolumeInfo currentInfo = methodsInfo["VolumeTest1"];
		assert(currentInfo.totalLines) == 10;
		assert(currentInfo.codeLines) == 10;
		assert(currentInfo.blankLines) == 0;
		
		currentInfo = methodsInfo["VolumeTest2"];
		assert(currentInfo.totalLines) == 8;
		assert(currentInfo.codeLines) == 6;
		assert(currentInfo.blankLines) == 1;
		
		currentInfo = methodsInfo["VolumeTest3"];
		assert(currentInfo.totalLines) == 13;
		assert(currentInfo.codeLines) == 4;
		assert(currentInfo.blankLines) == 4;
		
		currentInfo = methodsInfo["VolumeTest4"];
		assert(currentInfo.totalLines) == 8;
		assert(currentInfo.codeLines) == 5;
		assert(currentInfo.blankLines) == 0;
		
		currentInfo = methodsInfo["VolumeTest5"];
		assert(currentInfo.totalLines) == 15;
		assert(currentInfo.codeLines) == 4;
		assert(currentInfo.blankLines) == 4;
		
		currentInfo = methodsInfo["VolumeTest6"];
		assert(currentInfo.totalLines) == 9;
		assert(currentInfo.codeLines) == 5;
		assert(currentInfo.blankLines) == 1;
		
		currentInfo = methodsInfo["VolumeTest7"];
		assert(currentInfo.totalLines) == 18;
		assert(currentInfo.codeLines) == 18;
		assert(currentInfo.blankLines) == 0;
		
		currentInfo = methodsInfo["VolumeTest8"];
		assert(currentInfo.totalLines) == 30;
		assert(currentInfo.codeLines) == 4;
		assert(currentInfo.blankLines) == 20;
		
		currentInfo = methodsInfo["VolumeTest9"];
		assert(currentInfo.totalLines) == 18;
		assert(currentInfo.codeLines) == 4;
		assert(currentInfo.blankLines) == 6;
		
		currentInfo = methodsInfo["VolumeTest10"];
		assert(currentInfo.totalLines) == 45;
		assert(currentInfo.codeLines) == 8;
		assert(currentInfo.blankLines) == 12;
		
	}catch: return false;
	return true;
}