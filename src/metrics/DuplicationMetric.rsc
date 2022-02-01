module metrics::DuplicationMetric

import metrics::calculations::Duplication;
import metrics::rankings::DuplicationRanking;
import Results;

/* 
*	Calculate duplication metric result
*/
public DuplicationMetricsResult calculateDuplicationMetrics(map[loc, list[str]] normalizedFiles) {	
	real percentage = calculateDuplicationPercentage(normalizedFiles);
	
	return <getDuplicationRanking(percentage), percentage>;
}