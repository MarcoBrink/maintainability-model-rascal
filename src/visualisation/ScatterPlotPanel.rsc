module visualisation::ScatterPlotPanel

import vis::Figure;

import IO;
import List;
import Results;


alias DataUnit = tuple[int volume, int complexity, list[loc] locations];
alias DataMatrix = list[list[DataUnit]];
//alias DataMatrix = list[list[list[loc]]];
alias VisualGrid = list[list[Figure]];

private int minHor = 1;
private int minVer = 1;
private int maxHor = 110;
private int maxVer = 55;

private int boxSize = 7;

public Figure scatterPlotPanel(Results results) {
	Figure spFigure = scatterPlotFigure(results);
	Figure name = box(text("Project "+ results.location.uri),fillColor("Gray"), vshrink(0.05));

	
	int vertical = (maxVer+1)*(boxSize+2);
	int horizontal = (maxHor+1)*(boxSize+2);
	
	return scrollable(		
		vcat(
			[
				name,
				
				hcat(
					[
					vcat([box(text("Cyclomatic Complexity \u2192", textAngle(270)),size(20, vertical), resizable(false), lineWidth(2)),box(size(20,20),resizable(false), lineWidth(2))], resizable(false)),
					vcat([overlay([spFigure,getGrid()]),box(text("Lines of Code \u2192"),size(horizontal,20), resizable(false), lineWidth(2))],resizable(false))
					],resizable(false)
				)
				 
				   
				
			]
		)
	);
}

private Figure getGridBox(int h, int w){
	return box(
	size(h,w),
	fillColor(color("Gray",0.1)),
	resizable(false,false),
	lineWidth(2)
	);
}

public Figure getGrid(){
 	
	
    c1w = 16*(boxSize+2); c2w = 15*(boxSize+2); c3w = 40*(boxSize+2); c4w = 40*(boxSize+2);
    
	r1h =  5 *(boxSize+2);
	row1 = [getGridBox(c1w,r1h),getGridBox(c2w,r1h),getGridBox(c3w,r1h),getGridBox(c4w,r1h)];
	
	r2h = 30 * (boxSize+2);
	row2 = [getGridBox(c1w,r2h),getGridBox(c2w,r2h),getGridBox(c3w,r2h),getGridBox(c4w,r2h)];
	
	
	r3h = 10 *(boxSize+2);
	row3 = [getGridBox(c1w,r3h),getGridBox(c2w,r3h),getGridBox(c3w,r3h),getGridBox(c4w,r3h)];
	
	r4h =  11*(boxSize+2); 	
	row4 = [getGridBox(c1w,r4h),getGridBox(c2w,r4h),getGridBox(c3w,r4h),getGridBox(c4w,r4h)];


return grid([row1, row2, row3, row4], size((c1w+c2w+c3w+c4w),(r4h+r3h+r2h+r1h)), resizable(false), fillColor("Yellow"));
}

private Figure scatterPlotFigure(Results results) {
	
	DataMatrix dm = [y |y := [z |z := <-1,-1,[]>, _ <- [0 .. maxHor+1]], _ <- [0 .. maxVer+1]];
	dm = fillMatrix(dm, results.unitMetricsResult.mscores);

	return grid(getGridForMatrix(dm), resizable(false), size(111*(boxSize+2),56*(boxSize+2)));
}



private list[list[Figure]] getGridForMatrix(DataMatrix dm)
{
	return reverse([getRow(x) | x <- dm]);
}

private list[Figure] getRow(list[DataUnit] units)
{
	return [getBox(u) | u <- units];
}

private Figure getBox(DataUnit unit)
{
	if(unit.volume>0){
		return box(
		 fillColor(getColor(size(unit.locations))),
		 lineColor("White"),
		 popup(unit)
		 //onMouseDown(treemapBoxClickHandler(s.unit))
		);
	}else{
	  return box(
		 fillColor("White"),
		 lineColor("White")
		 //popup(unit)//,
		 //onMouseDown(treemapBoxClickHandler(s.unit))
		);
	}
	
}

private Color getColor(int size)
{
	if(size > 5) return rgb(255,0,0);
	if(size > 1 ) return rgb(255,80,80);
	if(size == 1) return rgb(255,160,160);
	
	
	return rgb(255,255,255);
}

private DataMatrix fillMatrix(DataMatrix dm, list[MethodScore] methodScores)
{
	for(MethodScore methodScore <- methodScores)
	{
		int linesOfCode = methodScore[2];
		int complexity = methodScore[3];
		int y = (linesOfCode > maxHor) ? maxHor : linesOfCode;
		int x = (complexity > maxVer) ? maxVer : complexity;

		dm[x][y].locations = dm[x][y].locations + [methodScore[0]];
		dm[x][y].volume = linesOfCode;
		dm[x][y].complexity = complexity;			
	}
	return dm;
}

/**
 * Returns an FProperty representing a mouse over popup for the specified UnitInfo.
 * @param s The UnitInfo to return the FProperty for.
 * @returns An FProperty representing the popup.
 */
public FProperty popup(DataUnit unit) {
			return mouseOver(box(vcat([
						//text(location, fontBold(true), left()), 
						text("Complexity:\t<unit.complexity>", fontItalic(true), left()), 
						text("Lines of code:\t<unit.volume>", fontItalic(true), left())//,
						//text("")//,
						//text("ctrl+click to view source...", left())
						], vgap(5)),
					 fillColor("White"),
					 gap(5), startGap(true), endGap(true),
					 resizable(false)));
}
