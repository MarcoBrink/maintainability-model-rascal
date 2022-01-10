module visualisation::ScatterPlotPanel

import vis::Figure;

import IO;
import List;
import Results;

alias DataMatrix = list[list[list[loc]]];
alias VisualGrid = list[list[Figure]];

private int maxHorizontal = 85;
private int maxVertical = 55;

public Figure scatterPlotPanel(Results results)
{
	int minHorizontal = 1;
	int minVertical = 1;
		
	DataMatrix dm = [y |y := [z | z := [], _ <- [minHorizontal .. maxHorizontal]], _ <- [minVertical .. maxVertical]];
	dm = fillMatrix(dm, results.unitMetricsResult.mscores);

	
	return grid(getGridForMatrix(dm));
}

private list[list[Figure]] getGridForMatrix(DataMatrix dm)
{
	return reverse([getRow(x) | x <- dm]);
}

private list[Figure] getRow(list[list[loc]] locations)
{
	return [getBox(l) | l <- locations];
}

private Figure getBox(list[loc] locations)
{
	return box(fillColor(getColor(size(locations))),lineColor("White"));
}

private str getColor(int size)
{
	if(size == 0)
	{
		return "White";
	}
	return "Red";
}

private DataMatrix fillMatrix(DataMatrix dm, list[MethodScore] methodScores)
{
	for(MethodScore methodScore <- methodScores)
	{
		int x = (methodScore[3] > maxHorizontal) ? maxHorizontal : methodScore[3];
		int y = (methodScore[2] > maxVertical) ? maxVertical : methodScore[2];
		println("size");
		println(size(dm));
		println(<x,y>);
		dm[x][y] = dm[x][y] + [methodScore[0]];			
	}
	return dm;
}
