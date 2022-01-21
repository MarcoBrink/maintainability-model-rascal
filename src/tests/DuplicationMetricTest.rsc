module tests::DuplicationMetricTest

import metrics::DuplicationMetric;
import metrics::VolumeMetric;
import metrics::rankings::DuplicationRanking;
import SIGRanking;
import IO;
import util::Math;
import Results;

public test bool test1(){
  loc project =  |project://maintainability-metrics|;
  VolumeMetricsResult volResult = calculateVolumeMetrics(project);
  DuplicationMetricsResult result = calculateDuplicationMetrics(volResult.normalizedFiles);
  
  println(result[0]);
  try assert round(result[0], 0.1) == 44.4;
  catch: return false;
  
  
  return true;
}

public test bool test2(){
  try{
    assert getDuplicationRanking(0.) == VERY_HIGH;
    assert getDuplicationRanking(2.) == VERY_HIGH;
    assert getDuplicationRanking(0.1) == VERY_HIGH;
    
    assert getDuplicationRanking(4.) == HIGH;
    assert getDuplicationRanking(3.4) == HIGH;
    assert getDuplicationRanking(3.0) == HIGH;
    
    assert getDuplicationRanking(7.) == MODEST;
    assert getDuplicationRanking(9.4) == MODEST;
    
    assert getDuplicationRanking(10.0) == LOW;
    assert getDuplicationRanking(19.4) == LOW;

	assert getDuplicationRanking(20.0) == VERY_LOW;
    assert getDuplicationRanking(45.4) == VERY_LOW;
    
    assert getDuplicationRanking(100.0) == VERY_LOW;
    assert getDuplicationRanking(145.4) == VERY_LOW;
  }catch: return false;

  return true;
}