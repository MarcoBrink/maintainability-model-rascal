module metrics::DuplicationMetric

import metrics::calculations::Duplication;
import metrics::rankings::DuplicationRanking;
import SIGRanking;

alias DuplicationMetricsResult = tuple[real percentage, Ranking rating];

public DuplicationMetricsResult calculateDuplicationMetrics(map[loc, list[str]] normalizedFiles) {	
	real percentage = calculateDuplicationPercentage(normalizedFiles);
	
	return <percentage, getDuplicationRanking(percentage)>;
}