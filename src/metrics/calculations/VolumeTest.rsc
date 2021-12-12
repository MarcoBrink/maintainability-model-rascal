module metrics::calculations::VolumeTest

import IO;
import String;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import lang::java::m3::AST;
import util::Benchmark;

alias VolumeInfo = tuple[int totalLines, int codeLines, int blankLines];

public void testVolume()
{
	int startTime = realTime();

	M3 model = createM3FromEclipseProject(|project://smallsql/|);
	
	VolumeInfo volumeInfo= <0,0,0>;
	
	for(file <- model.declarations)
	{
		if(isCompilationUnit(file.name))
		{
			tuple[list[str] normalizedFile, VolumeInfo volumeInfo] normalizedFile = normalizeFile(file.src);
			volumeInfo.totalLines += normalizedFile.volumeInfo.totalLines;
			volumeInfo.codeLines += normalizedFile.volumeInfo.codeLines;
			volumeInfo.blankLines += normalizedFile.volumeInfo.blankLines;
		}
	}
	int endTime = realTime();
	println((endTime - startTime) / 1000);
	println("total: <volumeInfo.totalLines> code: <volumeInfo.codeLines> blank: <volumeInfo.blankLines> comment: <volumeInfo.totalLines - (volumeInfo.codeLines + volumeInfo.blankLines)>");
}

public tuple[list[str], VolumeInfo] normalizeFile(loc file)
{
	bool multiLineActive = false;
	list[str] normalizedFile = [];
	VolumeInfo volumeInfo = <0,0,0>;
	for(l <- readFileLines(file))
	{
		volumeInfo.totalLines += 1;
		
		if(isBlankLine(trim(l))) // if the line is blank no need to process the line any further
		{
			volumeInfo.blankLines += 1;
			normalizedFile += l;
			continue;		
		}
		
		if(multiLineActive)
		{
			if(!contains(l, "*/")) // if multi-line is active and an end-node is not included in the line, processing can continue on next line
			{
				continue;
			}
		}
	 	
	 	tuple[str commentFreeLine, bool multiLineActive] result = normalizeLine(l, multiLineActive);
	 	multiLineActive = result.multiLineActive;
	 	
	 	if(trim(result.commentFreeLine) != "")
	 	{
	 		volumeInfo.codeLines += 1;
	 		normalizedFile += result.commentFreeLine;
	 		//if(contains( result.commentFreeLine, "/") || contains( result.commentFreeLine, "*"))
	 		//{
		 	//	println(result.commentFreeLine);
	 		//}
	 	}
	}

	return <normalizedFile, volumeInfo>;
}

private tuple[str,bool] normalizeLine(str line, bool multiLineActive)
{
	str commentFreeLine = "";
	int index = 0;
	
 	while(hasNextCharacter(index, line))
 	{
 		str currentChar = stringChar(charAt(line, index));
 		str remainingString = substring(line, index);
 		if(multiLineActive)
 		{
 			 tuple[bool multiLineActive,int indexAddition] result = processMultiLineCommentChar(currentChar, remainingString, line, index, multiLineActive);
 			 multiLineActive = result.multiLineActive;
 			 index += result.indexAddition;
 			 continue;
 		}
 		else
 		{
 			tuple[bool multiLineActive,int indexAddition, str lineAddition] result = processLineChar(currentChar, remainingString, line, index, multiLineActive);
		 	multiLineActive = result.multiLineActive;
 			index += result.indexAddition;
 			commentFreeLine += result.lineAddition;
 		}
 	}
 	
 	return <commentFreeLine, multiLineActive>;
}

private tuple[bool,int,str] processLineChar(str currentChar, str remainingString, str line, int index, bool multiLineActive)
{
	if(size(remainingString) > 1)// if the remainstring is 1 or smaller no single or multi-line node can be started
	{
		if(isCommentStart(substring(line, index, index+2)))
		{
			if(isSingleLineComment(substring(line, index, index + 2)))
			{
				return <multiLineActive, size(remainingString) , "">; //if a single line comment is started, jump to the end of the line, no further processing needed
			}
			else
			{
				multiLineActive = true;
				index += 2;
				return <multiLineActive, 2, "">;	
			}
		}
	}
	return <multiLineActive, 1, currentChar>;	
}

private tuple[bool,int] processMultiLineCommentChar(str currentChar, str remainingString, str line, int index, bool multiLineActive)
{
	if(currentChar == "*" && size(remainingString) > 1) // if a multi-line is active an end node can only be started if the current char is * and the size of the remaining string is larger than one
	{
		bool isEnding = IsMultiLineEndNode(substring(line, index, index+2));
		if(isEnding)
		{
			multiLineActive = false;
			return <multiLineActive, 2>;
		}
	}
	return <multiLineActive, 1>;
}

private bool isCommentStart(str linePart)
{
	return linePart == "/*" || linePart == "//";
}

private bool hasNextCharacter(int index, str line)
{
	return index < size(line);
}

private bool IsMultiLineEndNode(str substring)
{
	return substring == "*/";
}

private bool isSingleLineComment(str line)
{
	return line == "//";
}

private bool isBlankLine(str line)
{
	return line == "";
}