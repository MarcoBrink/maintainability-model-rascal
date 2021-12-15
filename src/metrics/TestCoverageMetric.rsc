module metrics::TestCoverageMetric
import Util;
import util::Resources;
import util::Benchmark;
import lang::java::m3::AST;
import lang::java::m3::Core;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import util::Math;
import IO;
import String;

import metrics::calculations::Normalize;



public tuple[int, real] test1(){
  loc project = |project://hsqldb|;
  //loc project = |project://Jabberpoint-le3|;
  //loc project = |project://test|;
 
 tuple[int, real] result = calculateTestCoverageMetrics(project);  
 <numberOfAsserts, locPerAssert> = result;
 println("Found: "+toString(numberOfAsserts)+" assert statements");
 println("Average lines of code per assert: "+toString(locPerAssert));
 return result;
}

public tuple[int, real] calculateTestCoverageMetrics(loc project){
  set[Declaration] asts = createAstsFromEclipseProject(project, true);
  
  tuple[map[loc, list[str]] normalizedFiles, VolumeInfo metadata] result = normalizeFiles(project);
  int totalLOC = result.metadata.codeLines;
  return calculateTestCoverageMetrics(asts, totalLOC);
}

public tuple[int, real] calculateTestCoverageMetrics(loc project, int totalLOC){
  set[Declaration] asts = createAstsFromEclipseProject(project, true);
  return calculateTestCoverageMetrics(asts, totalLOC);
}

public tuple[int, real] calculateTestCoverageMetrics(set[Declaration] asts, int totalLOC){
  int count = 0;
  visit(asts){
	case m: \method(_,_, _,_, Statement implementation): count+= countAsserts(implementation);
  }
  if(count == 0){
    return <0, 0.0>;
  }
  return <count,toReal(totalLOC)/count>;
}

private int countAsserts(Statement implementation){
  int count = 0;
  visit(implementation) {
    case \assert(_,_): count += 1;
	case \assert(_): count += 1;
	case \methodCall(_,_,n,_): if(startsWith(n,"assert")){count += 1;}
	case \methodCall(_,n,_): if(startsWith(n,"assert")){count += 1;}
  }
  return count;		  
}
