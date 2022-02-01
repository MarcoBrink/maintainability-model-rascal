module metrics::rankings::UnitRanking

import Results;

/* 
* The unit ranking as provided by SIG
*/
public Ranking getUnitRanking(tuple[real, real, real, real] rls){
	if(rls[1] <= 25 && rls[2]<=0 && rls[3]<=0)
		return VERY_HIGH;

	if(rls[1] <= 30 && rls[2]<=5 && rls[3]<=0)
		return HIGH;
	
	if(rls[1] <= 40 && rls[2]<=10 && rls[3]<=0)
		return MODEST;
	
	if(rls[1] <= 50 && rls[2]<=15 && rls[3]<=5)
		return LOW;
	
	return VERY_LOW;
}