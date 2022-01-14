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
	println(<tempTotalLines, result.unitMetricsResult.totalUnitLines>);
	
	return scrollable(treemap(boxes), size(1200,550),resizable(false));
}

private list[Figure] getBoxesForUnits(list[MethodScore] methodScores, int totalLines)
{
	list[Figure] boxes = [];
	boxes = [getBoxForUnit(x, totalLines) | x <- methodScores];
	return boxes;
}

private Figure getBoxForUnit(MethodScore mscore, int totalLines)
{
	return box(area(getBoxSize(mscore[2],totalLines)), fillColor(getColor(mscore[3])), popup(mscore));
}

public FProperty popup(MethodScore methodScore) {
			return mouseOver(box(vcat([
						text("Location:\t<methodScore[0]>", fontBold(true), left()), 
						text("Method:\t<methodScore[1]>", fontItalic(true), left()), 
						text("Complexity:\t<methodScore[3]>", fontItalic(true), left()), 
						text("Lines of code:\t<methodScore[2]>", fontItalic(true), left())//,
						], vgap(5)),
					 fillColor("White"),
					 gap(5), startGap(true), endGap(true),
					 resizable(false)));
}

private real getBoxSize(int lines, int totalLines)
{
	tempTotalLines += percentage(lines,totalLines) * 100; 
	return percentage(lines,totalLines * 100);
}

private Color getColor(int complexity)
{
	if(complexity > 50) return rgb(255,99,71);
	if(complexity > 20) return rgb(255,165,0);
	if(complexity > 10) return rgb(255,253,141);
	return rgb(144,238,144);
}
