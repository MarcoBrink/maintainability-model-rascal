module tests::VolumeMetricTest

import lang::java::jdt::m3::AST;

import metrics::rankings::VolumeRanking;
import metrics::VolumeMetric;
import SIGRanking;
import IO;
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

public test bool test3(){
  loc file =  |project://maintainability-metrics//testData//CyclomaticTestData.java|;
	//Declaration declaration = createAstFromFile(file,true);
	VolumeMetricsResult result = calculateVolumeMetrics(file); 
	println(result);
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