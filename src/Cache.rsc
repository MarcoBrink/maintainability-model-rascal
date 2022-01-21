module Cache

import Results;
import IO;
import ValueIO;
import String;

str cacheFolder = "file:///C:/Temp/";

public bool isCached(loc project){
  str path = project.authority;
  loc location = toLocation(cacheFolder+path+".txt");
  return isFile(location);
}

public Results getResults(loc project){
  str path = project.authority;
  loc location = toLocation(cacheFolder+path+".txt");
  return readTextValueFile(#Results, location);
}

public void saveResults(loc project, Results results){
  str path = project.authority;
  loc location = toLocation(cacheFolder+path+".txt");
  writeTextValueFile(location, results);
}