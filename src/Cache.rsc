module Cache

import Results;
import IO;
import ValueIO;

loc projects = |file:///C:/Temp/results.txt|;

bool refreshed = false;
map[loc, Results] cache = ();

public void addToCache(Results result){
  refreshCache();
  cache = cache + (result.location: result);
  updateCache();
}

public bool isCached(loc location){
  refreshCache();
  return location in cache;
}

public list[Results] getResults(){
	refreshCache();
	return [cache[k] | k <- cache ];
}

private void updateCache(){
	writeTextValueFile(projects, cache);
}

private void refreshCache(){
	if(!refreshed){
	try{
	  cache = readTextValueFile(#map[loc,Results], projects);
	  refreshed = true;	
	}catch: println("failed to read cache.");
	}
}

public void test1(){
writeTextValueFile(projects, cache);

}