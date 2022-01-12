module visualisation::TreemapPanel

import vis::Figure;

import Util;
import util::Math;
import IO;
import Results;

private real tempTotalLines;

public Figure TreemapPanel(Results result)
{
	tempTotalLines = 0.0;
	list[Figure] boxes = getBoxesForUnits(result.unitMetricsResult.mscores, result.unitMetricsResult.totalUnitLines);
	
	return scrollable(treemap(boxes), size(800,500),resizable(false));
}

private list[Figure] getBoxesForUnits(list[MethodScore] methodScores, int totalLines)
{
	list[Figure] boxes = [];
	boxes = [getBoxForUnit(x, totalLines) | x <- methodScores];
	return boxes;
}

private Figure getBoxForUnit(MethodScore mscore, int totalLines)
{
	return box(area(getBoxSize(mscore[2],totalLines)), fillColor(getColor(mscore[3])));
}

private real getBoxSize(int lines, int totalLines)
{
	tempTotalLines += percentage(lines,totalLines) * 100; 
	return percentage(lines,totalLines * 100);
}

private Color getColor(int complexity)
{
	if(complexity > 50) return rgb(255,0,0);
	if(complexity > 30) return rgb(255,70,70);
	if(complexity > 10) return rgb(255,140,140);
	if(complexity > 6) return rgb(255,150,150);
	if(complexity > 4) return rgb(255,180,180);
	return rgb(255,200,200);
}
