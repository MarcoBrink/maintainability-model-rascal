module metrics::rankings::TestCoverageRanking

import Results;

/* 
* The test coverage rating as provided by SIG
*/
public Ranking getTestCoverageRanking(int totalAsserts, int totalUnits, real averageUnitComplexity){
	real coverage;
	try{
		coverage = totalAsserts / (totalUnits *averageUnitComplexity);
	
	}catch: coverage = 0.0;
	
	if(coverage >= 0.95) return VERY_HIGH;
	if(coverage >= 0.80) return HIGH;
	if(coverage >= 0.60) return MODEST;
	if(coverage >= 0.20) return LOW;
	return VERY_LOW;
}