module metrics::rankings::VolumeRanking

import Results;

public Ranking getVolumeRanking(int totalLinesOfCode){
	int KLOC = totalLinesOfCode / 1000;
	
	if(KLOC < 66)
		return VERY_HIGH;
	
	if(KLOC < 246)
		return HIGH;

	if(KLOC < 665)
		return MODEST;
	
	if(KLOC < 1310)
		return LOW;
	
	return VERY_LOW;
}