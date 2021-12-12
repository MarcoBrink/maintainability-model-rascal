module metrics::calculations::RemoveComments

import IO;
import String;
import Set;

import util::Resources;

import lang::java::m3::AST;
import lang::java::m3::Core;
import util::Benchmark;


alias VolumeInfo = tuple[int files, int totalLines, int codeLines, int blankLines];

public void testRC(){
int starttime = realTime();
  //loc project = |project://Jabberpoint-le3|;
  //loc project = |project://smallsql|;
  loc project = |project://hsqldb|;
  //loc project = |project://test|;
  
  VolumeInfo metadata = <0,0,0,0>;
  
  set[loc] bestanden = fetchFiles(project);
  metadata.files = size(bestanden);
  for(loc l <- bestanden){
  	<_,x> = removeComments(l, metadata);
  	metadata = x;
  }
  
  println(metadata);
  println((realTime()-starttime)/1000);
}

public tuple[list[str],VolumeInfo] removeComments(loc location){
	VolumeInfo meta = <0,0,0,0>;
	return removeComments(location, meta);
}

public tuple[list[str],VolumeInfo] removeComments(loc location, VolumeInfo meta){	
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
		     <r,s,m> = isStringStart(token, singleQuoteString, multiQuoteString);
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

private tuple[bool, bool, bool] isStringStart(str token, bool single, bool multi){
	if(single||multi){
		return <false, single, multi>;
	}
	if(token == "\""){
		return <true,false,true>;
	}
	if(token == "\'"){
	return <true, true, false>;
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

private set[loc] fetchFiles(loc project){
	return { a | /file(a) <- getProject(project), a.extension == "java" };
}