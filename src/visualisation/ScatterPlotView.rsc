module visualisation::ScatterPlotView

import IO;
import List;
import Results;
import String;
import util::Math;
import util::Editors;

import vis::KeySym;
import vis::Render;
import vis::Figure;

import Util;


alias Method = tuple[loc location, str name];
alias DataUnit = tuple[int volume, int complexity, list[Method] methods];
alias DataMatrix = list[list[DataUnit]];
alias VisualGrid = list[list[Figure]];
alias MethodUnitData = tuple[loc location, str name, int volume, int complexity];
alias DataMatrixLarge = list[list[list[MethodUnitData]]];

/*
*  Attributes
*/
private Results results;
private bool withColor;
private bool showTotalPerCategory;
private bool percentage;
private bool asLines;
private bool selected;

/*
*  Internal Status
*/
private DataUnit selectedData = <-1,-1,[]>; 
private DataMatrix dataMatrix;
private DataMatrixLarge dataMatrixCategories;

/*
* Dimensions
*/
private int maxHor = 110;
private int maxVer = 65; 

private int boxSize = 7;//7
private int vertical = (maxVer+1)*(boxSize+2);
private int horizontal = (maxHor+1)*(boxSize+2);

//grid column sizes
 int c1w = 15*(boxSize+2); int c2w = 15*(boxSize+2); int c3w = 45*(boxSize+2); int c4w = 36*(boxSize+2);
 //grid row sizes
 int r1h =  16 *(boxSize+2);int r2h = 30 * (boxSize+2); int r3h = 10 *(boxSize+2); int r4h =  10*(boxSize+2); //edit

/*
* Redrawing Method
*/
private bool redraw = false;
private bool toRedraw(){
	if(redraw){
		redraw = false;
		return true;
	}
	return false;
}

/*
*  Constructor
*/
public Figure scatterPlotView(Results _results){ 
	results = _results;
	reset();
	return computeFigure(toRedraw, Figure (){return canvas();});
}

private void reset(){
	withColor = true;
	showTotalPerCategory = false;
	percentage = false;
 	asLines = false;
 	selected = false;
 	selectedData = <-1,-1,[]>; 
}

/*
*  Setters
*/
public void spv_setColor(bool _withColor){
  witchColor = _withColor;
}

public void spv_toggleColor(){
  withColor = !withColor;
}

public void spv_setCategories(bool _showTotalPerCategory){
  showTotalPerCategory = _showTotalPerCategory;
}

public void spv_setPercentage(bool _percentage){
  percentage = _percentage;
}

public void spv_setLines(bool _asLines){
  asLines = _asLines;
}

/*
*  Commands
*/
public void spv_reset(){
	withColor = true;
	showTotalPerCategory = false;
	percentage = false;
 	asLines = false;
}

public void spv_redraw(){
  redraw = true;
}

/*
* Private Methods
*/
private Figure canvas(){ 
  return hcat(
		[
			vcat([infoPanel()]),
			vcat([box(text("Cyclomatic Complexity \u2192", textAngle(270)),size(20, vertical), resizable(false), lineWidth(2)),box(size(20,20),resizable(false), lineWidth(2)),box(size(20,20),resizable(false), lineWidth(2))], resizable(false)),
			vcat(getVertAxes() +[ box(size(20,20),resizable(false), lineWidth(2)), box(size(20,20),resizable(false), lineWidth(2))], resizable(false)),
			vcat([overlay([getGrid(true),scatterPlotFigure(), getGrid(false)]), box(getHorzAxes(),size(horizontal,20), resizable(false), lineWidth(2)),box(text("Lines of Code \u2192"),size(horizontal,20), resizable(false), lineWidth(2))  ],resizable(false))
		],resizable(false)
	);
}

private Figure infoPanel(){
	return box(vcat(getTextBoxes(selectedData, true)),
			fillColor("White"),
			size(300,vertical + 40),
			lineWidth(2),
 			resizable(false)	
		);
}

private list[Figure] getTextBoxes(DataUnit unit, bool addMethods){
  if(unit.volume == -1){
    return [text("Select a dot on the right panel")];
  }

   list[Figure] methods = [];
    
   if(addMethods){
	 for(<a,b><-unit.methods){
	   str name = b;
	   str path = a.path;
	   str rownr = toString(a.begin.line);
	   methods = methods + box(text(name +" || " +path+" || "+rownr), resizable(false), left(), top(), size(298,12), lineWidth(0), highlight(), onMouseDown(openLocation(a)));
	 }  
   }
   
   str complexity =  toString(unit.complexity);
   str volume =  toString(unit.volume);
   complexity = (unit.complexity>65)?"65+":complexity;
   volume = (unit.volume>110)?"110+":volume;
    
   list[Figure] tbs = [
      vcat([
      box(vcat([
        text("Information", fontBold(true), left()), 
        text("", fontItalic(true), left()), 
        text("Complexity:\t<complexity>", fontItalic(true), left(),resizable(false)), 
        text("Lines of code:\t<volume>", fontItalic(true), left(),resizable(false)),
        text("Number of methods:\t<size(unit.methods)>", fontItalic(true), left(), resizable(false)),
        text("", fontItalic(true), left()), 
        text("[Method name || Location || Line number]", fontItalic(true), fontSize(10), left()),
        text("") 
        ]),
        size(298,100),
        lineWidth(0),
        top(),
        resizable(false)
        ),
        scrollable(
          vcat([
          box(vcat(methods, vgap(2)), size(298, size(methods)*12),resizable(false),top(), lineWidth(1)),
          box(lineWidth(0))
          ])
        )
        
        ])
    ];
   
	return tbs;
}

private FProperty highlight() {
	return mouseOver(box(fillColor(color("Gray", 0.3))));
}

private bool (int, map[KeyModifier, bool]) openLocation(loc ref) { 
	return bool (int butnr, map[KeyModifier, bool] modifiers) {
		  edit(ref);
		  return true;
	};
}

private Figure getHorzAxes(){
	return hcat([
	  box(text("LOW",  fontSize(7)), fillColor("Green"), size(c1w, 20), resizable(false), lineWidth(2)),
	  box(text("MODEST",  fontSize(7)),fillColor("Yellow"), size(c2w, 20), resizable(false), lineWidth(2)),
	  box(text("HIGH",  fontSize(7)), fillColor("Orange"), size(c3w, 20), resizable(false), lineWidth(2)),
	  box(text("CRITICAL", fontSize(7)), fillColor("Red"), size(c4w, 20), resizable(false), lineWidth(2))
	]);
}

private list[Figure] getVertAxes(){
	 return [
		box(text("CRITICAL", textAngle(270), fontSize(7)),fillColor("Red"), size(20, r1h), resizable(false), lineWidth(2)),
		box(text("HIGH", textAngle(270),fontSize(7)),fillColor("Orange"),size(20, r2h), resizable(false), lineWidth(2)),
		box(text("MODEST", textAngle(270),fontSize(7)),fillColor("Yellow"),size(20, r3h), resizable(false), lineWidth(2)),
		box(text("LOW", textAngle(270),fontSize(7)),fillColor("Green"),size(20, r4h), resizable(false), lineWidth(2))
	];
}

private Figure getGridBox(int h, int w, Color c, bool wbgc, tuple[int,int] index){
	if(!wbgc){
	  c = color("White",0.0);
	}
	return box(
		getCatInfo(index),
		size(h,w),
		fillColor(c),
		resizable(false,false),
		lineWidth(2)
	);
}

private Figure getCatInfo(tuple[int,int] index){
	Color colour;
	str label;
	int linewidth;
	if(showTotalPerCategory){
		list[MethodUnitData] muds = dataMatrixCategories[index[0]][index[1]];
		colour = color("White");
		linewidth = 1;
		if(!percentage && !asLines){
			int numOfMethods = size(muds);
			label = toString(numOfMethods);
		}
		if(percentage && !asLines){
			int numOfMethods = size(muds);
			real percentageMethods = Util::percentage(numOfMethods, results.unitMetricsResult.totalUnits);
			label = Util::formatPercentage(percentageMethods);		
		}
		if(!percentage && asLines){
			int sumOfLines = sum([0]+[v| v<-muds.volume]);
			label = toString(sumOfLines);
		}
		if(percentage && asLines){
			int sumOfLines = sum([0]+[v| v<-muds.volume]);
			real percentageMethods = Util::percentage(sumOfLines, results.unitMetricsResult.totalUnitLines);

			label = Util::formatPercentage(percentageMethods);		
		}
		
		
	}else{
		colour = color("White",0.0);
		label = "";
		linewidth = 0;
	}
	 return ellipse(text(label),size(30), fillColor(colour), lineWidth(linewidth), resizable(false));
}

private Figure getGrid(bool withBackgroundColor){
	bool bgc = withBackgroundColor && withColor;
	
	row1 = [getGridBox(c1w,r1h,color("Red",    0.2), bgc, <0,3>),	getGridBox(c2w,r1h,color("Red",    0.3), bgc, <1,3>),	getGridBox(c3w,r1h,color("Red",    0.4), bgc, <2,3>),	getGridBox(c4w,r1h,color("Red", 0.5), bgc, <3,3>)];
	row2 = [getGridBox(c1w,r2h,color("Orange", 0.1), bgc, <0,2>),	getGridBox(c2w,r2h,color("Orange", 0.2), bgc, <1,2>),	getGridBox(c3w,r2h,color("Orange", 0.4), bgc, <2,2>),	getGridBox(c4w,r2h,color("Red", 0.4), bgc, <3,2>)];
	row3 = [getGridBox(c1w,r3h,color("Yellow", 0.2), bgc, <0,1>),	getGridBox(c2w,r3h,color("Yellow", 0.4), bgc, <1,1>),	getGridBox(c3w,r3h,color("Orange", 0.2), bgc, <2,1>),	getGridBox(c4w,r3h,color("Red", 0.3), bgc, <3,1>)];
	row4 = [getGridBox(c1w,r4h,color("Green" , 0.5), bgc, <0,0>),	getGridBox(c2w,r4h,color("Yellow", 0.2), bgc, <1,0>),	getGridBox(c3w,r4h,color("Orange", 0.1), bgc, <2,0>),	getGridBox(c4w,r4h,color("Red", 0.2), bgc, <3,0>)];
	
	return grid([row1, row2, row3, row4], size((c1w+c2w+c3w+c4w),(r4h+r3h+r2h+r1h)), resizable(false));
}

private Figure scatterPlotFigure() {	
	DataMatrix dm = [y |y := [z |z := <-1,-1,[]>, _ <- [0 .. maxHor+1]], _ <- [0 .. maxVer+1]];
	DataMatrixLarge dml = [y |y := [z |z := [], _ <- [0 .. 4]], _ <- [0 .. 4]];
	
	<dm,dml> = fillMatrix(<dm,dml>, results.unitMetricsResult.mscores);

	return grid(getGridForMatrix(dm), resizable(false), size(111*(boxSize+2),66*(boxSize+2)));
}

private list[list[Figure]] getGridForMatrix(DataMatrix dm){
	return reverse([getRow(x) | x <- dm]);
}

private list[Figure] getRow(list[DataUnit] units){
	return [getBox(u) | u <- units];
}

private Figure getBox(DataUnit unit){
	Figure f;
	if(unit.volume>0){
		f= box(
		 fillColor(getColor(size(unit.methods))),
		 lineColor("Black"),
		 onBoxClick(unit),
		 highlight()
		);
	}else{
	  f= box(
		 fillColor(color("White",0.0)),
		 lineColor(color("Black", 0.0))
		);
	}
	return f;
}

private FProperty highlight() {
	return mouseOver(box(fillColor(color("Black", 0.8))));
}

private FProperty onBoxClick(DataUnit unit) {	
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		redraw = true;
		selected = true;
		selectedData = unit; 
		return true;
	});
}

private Color getColor(int size){
    int rg = (225 - size);
    rg = (rg<0)?0:rg;
    
	return rgb(rg,rg,255);
}

private tuple[DataMatrix,DataMatrixLarge] fillMatrix(tuple[DataMatrix,DataMatrixLarge] matrix, list[MethodScore] methodScores){
	DataMatrix dm = matrix[0];
	DataMatrixLarge dml = matrix[1];
	
	
	for(MethodScore methodScore <- methodScores){
		int linesOfCode = methodScore[2];
		int complexity = methodScore[3];
		int y = (linesOfCode > (maxHor+1)) ? (maxHor+1) : linesOfCode;
		int x = (complexity >= (maxVer+1)) ? (maxVer+1) : complexity;
		
		if(x-1 > -1 && y-1 > -1) {
		  dm[x-1][y-1].methods = dm[x-1][y-1].methods + [<methodScore[0], methodScore[1]>];
		  if(dm[x-1][y-1].volume == -1){
		    dm[x-1][y-1].volume = (linesOfCode);
		    dm[x-1][y-1].complexity = complexity;		  
		  }
		}
		
		dml = addToLargeMatrix(dml, linesOfCode, complexity, methodScore);
	}
	
	dataMatrix = dm;
	dataMatrixCategories = dml;

	return <dm,dml>;
}

private DataMatrixLarge addToLargeMatrix(DataMatrixLarge dml, int lc, int c, MethodScore methodScore){
	int x =0;
	int y = 0;
	
	if(lc>0 && lc<16){x=0;}
	if(lc>15 && lc<31){x=1;}
	if(lc>30 && lc<76){x=2;}
	if(lc>75 ){x =3;}
	
	if(c>0 && c<11){y=0;}
	if(c>10 && c<21){y=1;}
	if(c>20 && c<51){y=2;}
	if(c>50){y =3;}
	
	dml[x][y] = dml[x][y] + <methodScore[0], methodScore[1], lc, c>;

	return dml;
}