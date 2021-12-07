module metrics::Volume

import IO;
import String;
import List;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import lang::java::m3::AST;


public list[str] readProjectFileAsArray(loc file){
	return readFileLines(file);
}

public void calculateVolume(M3 model)
{
	map[str,int] LOC = ();
	
	LOC["code"] = 0;
	LOC["comment"] = 0;
	LOC["blank"] = 0;
	
	for(x <- model.declarations)
	{
		//if(contains(x.src.path, "junit")) continue;
		//if(contains(x.src.path, "/test/")) continue;
		
		if(isCompilationUnit(x.name))
		{
			list[str] lines = readFileLines(x.src);
			map[str,int] result = determineCategoryPerLine(lines, LOC);
			
			LOC["code"] = result["code"];
			LOC["comment"] = result["comment"];
			LOC["blank"] = result["blank"];
		}
	}
	
	println("Code: <LOC["code"]>");
	println("Blank: <LOC["blank"]>");
	println("Comment: <LOC["comment"]>");
	println("total lines: <LOC["code"] + LOC["blank"] + LOC["comment"]>");
}

private map[str,int] determineCategoryPerLine(list[str] lines, map[str,int] lineCategories)
{
	bool multiLineCommentActive = false;
	
	for(str line <- lines)
	{
		line = removeWhiteSpace(line);
		tuple[bool multiLineActive, map[str,int] lineCategories] result = determineLineType(multiLineCommentActive, lineCategories, line);
		
		multiLineCommentActive = result.multiLineActive;
		lineCategories = result.lineCategories;
	}

	return lineCategories;
}

private tuple[bool,map[str,int]] determineLineType(bool multiLineCommentActive, map[str,int] lineCategories, str line)
{	
	// Check if line is a blank line
	if(line == "")
	{
		return addBlankLine(multiLineCommentActive, lineCategories);
	}
	
	// Check if line starts in an active multi-line comment
	if(multiLineCommentActive)
	{
		return determineMultiLineCommentCategory(multiLineCommentActive, lineCategories, line);
	}
	
	// Check if the line is a full single line comment or a full mulit-line comment on a single line
	if(isSingleLineComment(line) || isMultiLineCommentOnSingleLine(line))
	{
		return addCommentLine(multiLineCommentActive, lineCategories);
	}
	
	//Remove multi-line after so a comment can be distinguished from a blank line
	line = removeMultiLineComment(line);
	
	//Check if the line contains the start of a new multi-line comment
	if(hasMultiLineCommentStartSymbol(line))
	{
		// line contains multi-line start
		multiLineCommentActive = true;
		// If the line starts with a multi-line, no code is included
		if(startsWith(line, "/*"))
		{
			return addCommentLine(multiLineCommentActive,lineCategories);
		}
	}

	return addCodeLine(multiLineCommentActive,lineCategories);
}

private tuple[bool,map[str,int]] determineMultiLineCommentCategory(bool multiLineCommentActive, map[str,int] lineCategories, str line)
{
	// Find all multi-line comment end nodes in line
	list[int] multiLineEndNodes = findAll(line, "*/");				
	
	//Check if the comment ends			
	if(size(multiLineEndNodes) > 0)
	{
		determineLineWithMultiLineEndingCategory(multiLineCommentActive, lineCategories, line, multiLineEndNodes);					
	}
	// Multi-line comment doesn't end
	return addCommentLine(multiLineCommentActive, lineCategories);
}

private tuple[bool,map[str,int]] determineLineWithMultiLineEndingCategory(bool multiLineCommentActive, map[str,int] lineCategories, str line, list[int] multiLineEndNodes)
{
	if(size(multiLineEndNodes) == 1)
	{
		// The current multi-line comment ends
		return determineEndingMultiLineCategory(multiLineCommentActive, lineCategories, line);
	}
	else
	{
		return determineLineWithMultipleEndNodesCategory(multiLineCommentActive, lineCategories, line);
	}
}

private tuple[bool,map[str,int]] determineEndingMultiLineCategory(bool multiLineCommentActive, map[str,int] lineCategories, str line)
{
	multiLineCommentActive = false;
	if(endsWith(line, "*/"))
	{
		return addCommentLine(multiLineCommentActive, lineCategories);
	}
	else
	{
		//Is a multiline started? 
		int afterEndNodePosition = findFirst(line, "*/") + 2;
		str afterEnd = substring(line, afterEndNodePosition);
		if(contains(afterEnd,"/*"))
		{
			//potential new line start
			int singleLineStart = findFirst(afterEnd, "//");
			if(singleLineStart != -1)
			{
				multiLineCommentActive = (findFirst(afterEnd, "/*") < singleLineStart) ?  true : false; 		
			}
			else
			{
				multiLineCommentActive = true;
			}
		}
		
		//Contains code or only comment?:
		str twoAfterEnd = substring(line, afterEndNodePosition, afterEndNodePosition + 2);
		if(twoAfterEnd != "//" && twoAfterEnd != "/*")
		{
			return addCodeLine(multiLineCommentActive, lineCategories);
		}
		
		return addCommentLine(multiLineCommentActive, lineCategories);
	}
}


private tuple[bool,map[str,int]] determineLineWithMultipleEndNodesCategory(bool multiLineCommentActive, map[str,int] lineCategories, str line)
{
	//Remove full multi-line comments from the line
	lineWithoutFullMultiLine = removeMultiLineComment(line);
	
	if(endsWith(lineWithoutFullMultiLine, "*/"))
	{
		//Comment followed by another multiline comment
		multiLineCommentActive = false;
	}
	else
	{
		int startSymbolPosition = findFirst(lineWithoutFullMultiLine, "/*");
		if(startSymbolPosition != -1)
		{
			// Contains another multi-line start
			multiLineCommentActive = true;
			
			int endNodePosition = findFirst(lineWithoutFullMultiLine, "*/");
			int positionsBetweendEndAndStartNodes = startSymbolPosition - endNodePosition;
			if(positionsBetweendEndAndStartNodes != 2)
			{
				int singleLineStart = findFirst(line, "//");
				if(singleLineStart != -1)
				{
					str afterEnd = substring(line, endNodePosition);
					multiLineCommentActive = (findFirst(afterEnd, "/*") < singleLineStart) ?  true : false; 
					if((singleLineStart - 1) == endNodePosition)
					{
						return addCommentLine(multiLineCommentActive, lineCategories);
					}
				}
				return addCodeLine(multiLineCommentActive, lineCategories);
			}
		}
		else
		{
			int singleLineStart = findFirst(line, "//");
			if(singleLineStart != -1)
			{
				int endNodePos = findFirst(line, "*/");
				println("<singleLineStart> and <endNodePos>");
				if((singleLineStart -2) == endNodePos)
				{
					return addCommentLine(multiLineCommentActive, lineCategories);
				}
			}
			return addCodeLine(multiLineCommentActive, lineCategories);
		}
	}
	return addCommentLine(multiLineCommentActive, lineCategories);
}

private str removeWhiteSpace(str input)
{
	return trim(replaceAll(input, " ", ""));
}

private tuple[bool,map[str,int]] addCommentLine(bool multiLineCommentActive, map[str,int] lineCategories)
{
	lineCategories["comment"] += 1;
	return <multiLineCommentActive,lineCategories>;
}

private tuple[bool,map[str,int]] addBlankLine(bool multiLineCommentActive, map[str,int] lineCategories)
{
	lineCategories["blank"] += 1;
	return <multiLineCommentActive,lineCategories>;
}

private tuple[bool,map[str,int]] addCodeLine(bool multiLineCommentActive, map[str,int] lineCategories)
{
	lineCategories["code"] += 1;
	return <multiLineCommentActive,lineCategories>;
}

private bool isMultiLineCommentOnSingleLine(str line)
{
	if(line == "")
	{
		return false;
	}
	return trim(removeMultiLineComment(line)) == "";
}

private bool isSingleLineComment(str line)
{
	return startsWith(line, "//");
}

private bool hasMultiLineCommentStartSymbol(str line)
{
	return contains(line, "/*");
}

private str removeMultiLineComment(str line)
{
	return visit(line) {
		case /\/\*.*?\*\//s => ""
	}
}