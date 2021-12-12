module metrics::DuplicationMetric

import metrics::calculations::Duplication;

public tuple[real,str] calculateDuplicationMetrics(loc project) {	
	real percentage = calculateDuplicationPercentage(project);
	
	return <percentage, getDuplicationRanking(percentage)>;
}


private str getDuplicationRanking(real percentage){
	if(percentage < 3)
		return ranking = "++";

	if(percentage <5)
		return ranking = "+";

	if(percentage <10)
		return ranking = "o";
	
	if(percentage <20)
		return ranking = "-";
	
	return "--";
}