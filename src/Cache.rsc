module Cache

import Results;
import IO;
import ValueIO;
import String;

str cacheFolder = "file:///C:/Temp/";


/*
* Check wether a project is already cached
*/
public bool isCached(loc project){
  str path = project.authority;
  loc location = toLocation(cacheFolder+path+".txt");
  return isFile(location);
}

/*
* Retrieve results from a project that has already been cached
*/
public Results getResults(loc project){
  str path = project.authority;
  loc location = toLocation(cacheFolder+path+".txt");
  return readTextValueFile(#Results, location);
}

/*
* Cache the results of a project to a .txt file
*/
public void saveResults(loc project, Results results){
  str path = project.authority;
  loc location = toLocation(cacheFolder+path+".txt");
  writeTextValueFile(location, results);
}