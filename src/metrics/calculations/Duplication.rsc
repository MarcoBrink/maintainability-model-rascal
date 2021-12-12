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
  
  	int duplicateLinesSize = size(duplicateLines); 
  	return toReal(size(duplicateLines)*100.0)/totalLines;
  	
  	println((realTime()-starttime)/1000);
}

private tuple[int, map[str, set[str]]] calculateDuplicationPerFile(loc file, int blockSize, map[str, set[str]] lineblocks){	
	result = ();
	
	<x,_> = removeComments(file);
	list[str] cleanLines = removeWhitespace(x); //remove all comments and whitespace from lines
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
		set[str] numbers = {path + "_"+toString(c) | int c  <- [i .. i+blockSize]};
		
		if (block in lineblocks)
			lineblocks[block] += numbers;
		else
			lineblocks += (block : numbers);
	}
	
	return lineblocks;
}

list[str] removeWhitespace(list[str] lines) =
	[ removeWhitespace(l) | l <- lines ];
str removeWhitespace(str txt) = visit(txt) {
	case /[\ \t\n\r]/ => ""
};