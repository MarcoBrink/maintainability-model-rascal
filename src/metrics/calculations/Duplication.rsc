module metrics::calculations::Duplication

import List;
import String;
import Util;

private int blockSize = 6; // Sig defined standard codeblock size.

public real calculateDuplicationPercentage(map[loc, list[str]] normalizedFiles){	
  	map[str, set[str]] lineblocks = ();
  	int totalLines = 0;
  	for(l <- normalizedFiles){
  		<total, result> = calculateDuplicationPerFile(l, normalizedFiles[l], blockSize, lineblocks); 
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
  	
  	set[str] duplicteLinesWithOnlyClones = {x| x<-duplicateLines, !startsWith(x, "|newline|")};
  	
  	int duplicateLinesSize = size(duplicteLinesWithOnlyClones); 
 
  	return toReal(duplicateLinesSize*100.0)/totalLines;
}

private tuple[int, map[str, set[str]]] calculateDuplicationPerFile(loc file, list[str] normalizedFile, int blockSize, map[str, set[str]] lineblocks){	
	result = ();
	
	list[str] cleanLines = removeWhitespace(normalizedFile); //remove all comments and whitespace from lines
		
	int totalLines = size(cleanLines);
	
	if(totalLines >= blockSize){
		result = lineBlocks(cleanLines, file.path, blockSize, lineblocks);
	}
	return <totalLines,result>;
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