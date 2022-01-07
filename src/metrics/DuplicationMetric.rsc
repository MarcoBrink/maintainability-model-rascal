module metrics::DuplicationMetric

import metrics::calculations::Duplication;
import metrics::rankings::DuplicationRanking;
import SIGRanking;
import Results;

public DuplicationMetricsResult calculateDuplicationMetrics(map[loc, list[str]] normalizedFiles) {	
	real percentage = calculateDuplicationPercentage(normalizedFiles);
	
	return <getDuplicationRanking(percentage), percentage>;
}