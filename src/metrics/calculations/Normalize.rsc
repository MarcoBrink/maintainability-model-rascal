module metrics::calculations::Normalize

import lang::java::m3::AST;
import lang::java::m3::Core;

import String;

import metrics::VolumeMetric;
import Util;

alias VolumeInfo = tuple[int files, int totalLines, int codeLines, int blankLines];
alias NormalizedData = tuple[map[loc, list[str]] normalizedFiles, VolumeInfo volumeInfo];

public NormalizedData normalizeFiles(loc project)
{
	VolumeInfo volumeInfo = <0,0,0,0>;
	set[loc] bestanden = fetchFiles(project);
	map[loc, list[str]] normalizedFiles = (); 
	volumeInfo.files = size(bestanden);
	
 	for(loc l <- bestanden){
  		<normalizedFile, cumulativeVolumeInfo> = normalize(l, volumeInfo);
  		normalizedFiles += (l : normalizedFile);
  		volumeInfo = cumulativeVolumeInfo;
  	}
  	
  	return <normalizedFiles, volumeInfo>;
}

public tuple[list[str],VolumeInfo] normalize(loc location){
	VolumeInfo meta = <0,0,0,0>;
	return normalize(location, meta);
}

public tuple[list[str], VolumeInfo] normalize(loc location, VolumeInfo meta){	

	list[str] result = [];

	bool inMulti = false;
	
	for (l <- readFileLines(location)) {
		meta.totalLines += 1;
		
		if(trim(l) == ""){
			meta.blankLines += 1;
			continue;
		}
		
		str cleanLine = "";
		int index = 0;
		bool singleQuoteString = false;
		bool multiQuoteString = false;
		bool inString = false;
		
		while(hasNextChar(l, index)){	
		   str token = getChar(l,index);
		   
		   if(!inString){
		     <r,s,m> = isStringStart(token, singleQuoteString, multiQuoteString, inMulti);
		     inString = r;
		     singleQuoteString = s;
		     multiQuoteString = m;
		   }else{
		     <r,s,m> = isStringEnd(token, singleQuoteString, multiQuoteString);
		     inString = !r;
		     singleQuoteString = s;
		     multiQuoteString = m;
		   }
		 
		   if(!inString && !inMulti && isStartComment(token, l, index)){ // search for start of a comment '//' or '/*' unless in multicomment block
				if(isLineComment(token, l, index)){ // if single line ignore rest of line
					break;
				}else{ // if multiline ignore rest of characters until end comment token '*/' is found
					inMulti = true;
					index += 2; // ignore next token, because start comment is 2 characters
					continue; // skip this and an extra character and continue crawling
				}
			}
			
			if(!inString && inMulti && isEndComment(token, l, index)){ // search for end of multi comment, if found no longer in comment block. 
				inMulti = false;
				index += 2;
				continue; // skip an extra character and continue crawling
			}
			
			if(!inMulti){
				cleanLine += token;			
			}
			
			index += 1;
		}
		
		if(trim(cleanLine) != ""){
			result += cleanLine;
			meta.codeLines += 1;
		}
	}
	
	return <result,meta>;
}

private tuple[bool, bool, bool] isStringStart(str token, bool single, bool multi, bool inMultiLineComment){
	
	if(!inMultiLineComment)
	{
		if(single||multi){
			return <false, single, multi>;
		}
		if(token == "\""){
			return <true,false,true>;
		}
		if(token == "\'"){
		return <true, true, false>;
		}
	}
	
	return <false, single, multi>;
}

private tuple[bool, bool, bool] isStringEnd(str token, bool single, bool multi){
	if((single||multi) && (single && token == "\'" || (multi && token == "\""))){
		return <true, false, false>;
	}
	return <false, single, multi>;
}

private bool isEndComment(str token, str line, int index){
	return (token =="*") && (nextChar(line,index) == "/");
}

private bool isLineComment(str token, str line, int index){
	return (token == "/") && (nextChar(line,index) == "/");
}

private bool isStartComment(str token, str line, int index){
	return (token == "/" ) && (nextChar(line,index) == "/" || nextChar(line,index)  =="*");
}

private str nextChar(str line, int index){
	return (hasNextChar(line,index))?getChar(line, index+1):"";
}

private bool hasNextChar(str line, int index){
	return (index < size(line));
}

private str getChar(str line, int index){
	return (index < size(line))?stringChar(charAt(line,index)):"";
}