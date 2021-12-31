module SIGRanking

import List;
import util::Math;

data Ranking = score(str label, str rating, int val);

public Ranking VERY_HIGH = score("Very High", "++", 5);
public Ranking HIGH = score("High", "+",4);
public Ranking MODEST = score("Modest", "o",3);
public Ranking LOW = score("Low", "-", 2);
public Ranking VERY_LOW = score("Very Low", "--", 1);

public Ranking getRanking(int val){
	switch(val){
	  case 5: return VERY_HIGH;
	  case 4: return HIGH;
	  case 3: return MODEST;
	  case 2: return LOW;
	  default: return VERY_LOW;
	}
}

public Ranking averageRanking(list[Ranking] rankings){
	int total = sum([r.val |r <- rankings]);
	real average = toReal(total) / toReal(size(rankings));
	return getRanking(round(average));
}