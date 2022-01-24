module visualisation::ScatterPlotPanel

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

alias Method = tuple[loc location, str name];
alias DataUnit = tuple[int volume, int complexity, list[Method] methods];
alias DataMatrix = list[list[DataUnit]];
alias VisualGrid = list[list[Figure]];
alias MethodUnitData = tuple[loc location, str name, int volume, int complexity];
alias DataMatrixLarge = list[list[list[MethodUnitData]]];

//private int minHor = 1;
//private int minVer = 1;
private int maxHor = 110;
private int maxVer = 65; 

private int boxSize = 7;//7
private int vertical = (maxVer+1)*(boxSize+2);
private int horizontal = (maxHor+1)*(boxSize+2);

//grid column sizes
 int c1w = 15*(boxSize+2); int c2w = 15*(boxSize+2); int c3w = 45*(boxSize+2); int c4w = 36*(boxSize+2);
 //grid row sizes
 int r1h =  16 *(boxSize+2);int r2h = 30 * (boxSize+2); int r3h = 10 *(boxSize+2); int r4h =  10*(boxSize+2); //edit

private str title = "Distribution Cyclomatic Complexity vs Volume (Lines of Code) per Method";
private str subtitle = "";

private bool redraw = false;
private bool redrawTitle = false;

private bool withColor = true;
private bool showTotalPerCategory = false;
private bool percentage = false;
private bool asLines = false;
private bool asTreeMap = false;

private bool selected = false;
private DataUnit selectedData = <-1,-1,[]>; 

private DataMatrix dataMatrix;
private DataMatrixLarge dataMatrixCategories;

private Results results;
private list[Figure] boxes = [];


private bool toRedraw(){
	if(redraw){
		redraw = false;
		println("Redrawing");
		return true;
	}
	return false;
}

private bool toRedrawTitle(){
	if(redrawTitle){
		redrawTitle = false;
		println("Redrawing Title");
		return true;
	}
	return false;
}

public Figure scatterPlotPanel(Results _results) {
	results = _results;
	boxes = getBoxesForUnits(_results.unitMetricsResult.mscores, _results.unitMetricsResult.totalUnitLines);
	
			
	return box(vcat([
			box(text(title, fontSize(20)),lineWidth(0), top()),
			computeFigure(toRedrawTitle, Figure (){return box(text(subtitle, fontSize(14)),lineWidth(0), fillColor(color("White", 0.0)));}),
			box(getMenu(), hsize(40), lineWidth(2)),
			computeFigure(toRedraw, Figure (){return canvas();})
		], resizable(false))); 
}

private Figure getMenu(){
	return 	box(
		hcat([
		  box(text("Reset"), resetAction()),
		  box(text("Toggle Color"), toggleColorAction()),
		  box(text("Nr. methods per Cat."), showCatAbsAction()),
		  box(text("% methods per Cat."), showCatPerAction()),
		  box(text("Nr. loc per Cat."), showCatAbsLocAction()),
		  box(text("% loc per Cat."), showCatPerLocAction()),
		  box(text("Toggle view"), toggleTreemapAction())
		])
	);
}

private FProperty resetAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){redraw =true;redrawTitle= true; withColor = true;showTotalPerCategory=false;percentage = false; subtitle ="";asTreeMap = false;return true;});
}

private FProperty toggleColorAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){redraw =true; withColor = !withColor; return true;});
}

private FProperty showCatAbsAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){redraw =true;redrawTitle= true;  showTotalPerCategory=true;percentage = false;asLines = false; subtitle ="Total number of methods per category"; return true;});
}
/*
private FProperty showCatAbsAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){redraw =true; showTotalPerCategory=true;percentage = false;asLines = false; return true;});
}*/

private FProperty showCatPerAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){redraw =true;redrawTitle= true; showTotalPerCategory=true;percentage = true;asLines = false; subtitle ="Percentage of methods per category"; return true;});
}

private FProperty showCatAbsLocAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){redraw =true;redrawTitle= true; showTotalPerCategory=true;percentage = false;asLines = true; subtitle ="Total number of lines of code (loc) per category"; return true;});
}

private FProperty showCatPerLocAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){redraw =true; redrawTitle= true; showTotalPerCategory=true;percentage = true;asLines = true; subtitle ="Percentage of lines of code (loc) per category"; return true;});
}

private FProperty toggleTreemapAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){redraw =true;redrawTitle= true; withColor = true;showTotalPerCategory=false;percentage = false; subtitle ="";asTreeMap = !asTreeMap; return true;});
}

private Figure canvas(){ 

  list[Figure] figures = [];
  Figure spFigure; 
  if(!asTreeMap){
  	spFigure = scatterPlotFigure(results);
  	figures = [
			vcat([infoPanel()]),
			vcat([box(text("Cyclomatic Complexity \u2192", textAngle(270)),size(20, vertical), resizable(false), lineWidth(2)),box(size(20,20),resizable(false), lineWidth(2)),box(size(20,20),resizable(false), lineWidth(2))], resizable(false)),
			vcat(getVertAxes() +[ box(size(20,20),resizable(false), lineWidth(2)), box(size(20,20),resizable(false), lineWidth(2))], resizable(false)),
			vcat([overlay([getGrid(true),spFigure, getGrid(false)]), box(getHorzAxes(),size(horizontal,20), resizable(false), lineWidth(2)),box(text("Lines of Code \u2192"),size(horizontal,20), resizable(false), lineWidth(2))  ],resizable(false))
		];
  }else{
  	spFigure = loadTreemap();
  	figures = [
			vcat([infoPanel()]), spFigure];
  }
 
  return hcat(figures ,resizable(false)
	);
}

private Figure infoPanel(){
	return box(vcat(getTextBoxes(selectedData, true)),
			fillColor("White"),
			size(300,vertical +41),
			lineWidth(2),
 			resizable(false)	
		);
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
		//list[Figure] boxes = [box(size(mud.complexity, mud.volume))| mud <- muds];
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
			//int numOfMethods = size(muds);
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

private Figure scatterPlotFigure(Results results) {	
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
		 onBoxClick(unit)
		);
	}else{
	  f= box(
		 fillColor(color("White",0.0)),
		 lineColor(color("Black", 0.0))
		);
	}
	return f;
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
		  dm[x-1][y-1].volume = linesOfCode;
		  dm[x-1][y-1].complexity = complexity;
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


public FProperty onBoxClick(DataUnit unit) {	
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		redraw = true;
		selected = true;
		selectedData = unit; 
		return true;
	});
}

/*
public FProperty onToggleClick() {	
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		println("toggle");
		withColor = !withColor;
		return true;
	});
}

private Figure popup(DataUnit unit, bool showMethods){
	return box(vcat(getTextBoxes(unit, showMethods), vgap(5)),
				fillColor("White"),
				gap(5), startGap(true), endGap(true),
				resizable(false));
}
*/
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
	   methods = methods + box(text(name +" || " +path+" || "+rownr), resizable(false), left(), top(), size(298,12), lineWidth(0), onMouseDown(openLocation(a)));
	 }  
   }
    
    list[Figure] tbs = [
      vcat([
      box(vcat([
        text("Information", fontBold(true), left()), 
        text("", fontItalic(true), left()), 
        text("Complexity:\t<unit.complexity>", fontItalic(true), left(),resizable(false)), 
        text("Lines of code:\t<unit.volume>", fontItalic(true), left(),resizable(false)),
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
          box(vcat(methods), size(298, size(methods)*12),resizable(false),top(), lineWidth(0)),
          box(lineWidth(0))
          ])
        )
        
        ])
    ];
   
	return tbs;
}


public bool (int, map[KeyModifier, bool]) openLocation(loc ref) { 
	return bool (int butnr, map[KeyModifier, bool] modifiers) {
		  edit(ref);
		  return true;
	};
}

public Figure loadTreemap()
{
	return scrollable(treemap(boxes),size(1000,594));
}
