module visualisation::TreemapPanel

import vis::Figure;
import visualisation::ScatterPlotPanel;

import IO;
import List;
import Results;
import String;
import util::Math;

import vis::KeySym;
import vis::Render;
import vis::Figure;

import util::Editors;
import Util;
import visualisation::TreemapPanel;

private real tempTotalLines;


public list[Figure] getBoxesForUnits(list[MethodScore] methodScores, int totalLines)
{
	tempTotalLines = 0.0;
	list[Figure] boxes = [];
	boxes = [getBoxForUnit(x, totalLines) | x <- methodScores];
	return boxes;
}

public Figure getBoxForUnit(MethodScore mscore, int totalLines)
{
	return box(area(getBoxSize(mscore[2],totalLines)), fillColor(getTreemapColor(mscore[3])), onBoxClick(<mscore[2], mscore[3],[<mscore[0], mscore[1]>]>));
}


private real getBoxSize(int lines, int totalLines)
{
	tempTotalLines += Util::percentage(lines,totalLines) * 100; 
	return Util::percentage(lines,totalLines * 100);
}

private Color getTreemapColor(int complexity)
{
	if(complexity > 50) return rgb(255,99,71);
	if(complexity > 20) return rgb(255,165,0);
	if(complexity > 10) return rgb(255,253,141);
	return rgb(144,238,144);
}