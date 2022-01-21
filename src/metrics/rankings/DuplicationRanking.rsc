module metrics::rankings::DuplicationRanking

import Results;

public Ranking getDuplicationRanking(real percentage){
	if(percentage < 3)
		return ranking = VERY_HIGH;

	if(percentage <5)
		return ranking = HIGH;

	if(percentage <10)
		return ranking = MODEST;
	
	if(percentage <20)
		return ranking = LOW;
	
	return VERY_LOW;
}