module metrics::VolumeUtil

import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import IO;
import String;

public int calculateLinesOfCode(loc location) {
	int count = 0;
	bool inCommentBlock = false;
	
	for (l <- readFileLines(location)) {
		str line = trim(l);
		
		if(isStartOfCommentBlock(line)){
			inCommentBlock = true;
		}
		
		if(isEndOfCommentBlock(line)){
			inCommentBlock = false;
		}
		
		if(isLine(line, inCommentBlock)){
			count = count +1;
		}
	}
	
	return count;
}

private bool isLine(str line, bool block){
		if(block)
			return false;
		if(line == "")
			return false;
		if(startsWith(line, "//")) 
			return false;
		if(startsWith(line, "*/"))
			return false;
	
	return true;	
}

private bool isStartOfCommentBlock(str line){
	return (contains(line, "/*"));	
}

private bool isEndOfCommentBlock(str line){
	return (contains(line, "*/"));
}