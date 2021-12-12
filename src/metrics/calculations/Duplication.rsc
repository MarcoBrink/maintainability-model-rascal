module metrics::calculations::Duplication

import metrics::calculations::RemoveComments;
import util::Resources;
import util::Math;
import util::Benchmark;

import IO;
import String;
import List;
import Set;

private int blockSize = 6; // Sig defined standaard codeblock size.

public real calculateDuplicationPercentage(loc project){	
	set[loc] files = fetchFiles(project);
	
  	map[str, set[str]] lineblocks = ();
  	int totalLines = 0;
  	for(loc l <- files){
  		<total, result> = calculateDuplicationPerFile(l,blockSize, lineblocks); 
  		lineblocks = result;
  		totalLines += total;
  	}
  
	set[str] duplicateLines = {};
	for(key <- lineblocks){
	  	int numberOfLines = size(lineblocks[key]);
	  	if(numberOfLines>blockSize){
	  	 duplicateLines += lineblocks[key];
	  
	  	}
	}
  	
  	set[str] duplicteLinesWithoutClones = {x| x<-duplicateLines, !startsWith(x, "|newline|")};
  	
  	int duplicateLinesSize = size(duplicteLinesWithoutClones); 
 
  	return toReal(duplicateLinesSize*100.0)/totalLines;
  	
  	println((realTime()-starttime)/1000);
}

private tuple[int, map[str, set[str]]] calculateDuplicationPerFile(loc file, int blockSize, map[str, set[str]] lineblocks){	
	result = ();
	
	<x,_> = removeComments(file);
	list[str] cleanLines = removeWhitespace(x); //remove all comments and whitespace from lines
	//list[str] cleanLines = trimListEntries(x);
	
	int totalLines = size(cleanLines);
	
	if(totalLines >= blockSize){
		result = lineBlocks(cleanLines, file.path, blockSize, lineblocks);
	}
	return <totalLines,result>;
}

private set[loc] fetchFiles(loc project){
	return { a | /file(a) <- getProject(project), a.extension == "java" };
}

private map[str, set[str]] lineBlocks(list[str] lines, str path, int blockSize, map[str, set[str]] lineblocks) {
	for (i <- [0 .. size(lines)-blockSize], block := intercalate("", lines[i .. i+blockSize])) {	
		set[str] numbers = {path +toString(c) | int c  <- [i .. i+blockSize]};
		
		if (block in lineblocks){ 
			set[str] numbers = {path +toString(c) | int c  <- [i .. i+blockSize]}; 
			lineblocks[block] += numbers;
		}
			
		else{
			//new lines get a special prefix.
			set[str] numbers = {"|newline|"+path +toString(c) | int c  <- [i .. i+blockSize]};
			lineblocks += (block : numbers);
		}
			
	}
	
	return lineblocks;
}

list[str] trimListEntries(list[str] lines){
  return [trim(l)| l <-lines];
}

list[str] removeWhitespace(list[str] lines) =
	[ removeWhitespace(l) | l <- lines ];
str removeWhitespace(str txt) = visit(txt) {
	case /[\ \t\n\r]/ => ""
};