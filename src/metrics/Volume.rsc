module Metrics::Volume

import IO;
import String;
import List;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import lang::java::m3::AST;

private int countCommentLines(list[str] lines)
{
	int commentLines = 0;
	bool multiLineComment = false;
	
	for(str line <- lines)
	{
		if(startsWith(trim(line), "/*"))
		{
			if(!endsWith(trim(line),"*/"))
			{
				multiLineComment = true;
			}
			commentLines += 1;
		}
		else if (startsWith(trim(line),"*/") || endsWith(trim(line),"*/")) {
				multiLineComment = false;
				commentLines += 1;
			}
		else if (multiLineComment || startsWith(trim(line),"/") || startsWith(trim(line),"*")) {
				commentLines += 1;
			}
		else
		{
			if (endsWith(trim(line),"/*")) {
					commentBlock = true;
				}
		}
	}	
	
	return commentLines;
}

private bool isSingleLineComment(str line)
{
	return startsWith(trim(line),"//");
}

private int countBlankLines(list[str] lines) = size([x | x <- lines, trim(x) == ""]);