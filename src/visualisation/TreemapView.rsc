module visualisation::TreemapView

import vis::Figure;
import vis::KeySym;
import util::Editors;

import Util;
import util::Math;
import IO;
import Results;

private real tempTotalLines;
private bool clicked = false;
private bool ctrlClicked = false;
private MethodScore selected;

public Figure TreemapPanel(Results result, int width, int height){
	tempTotalLines = 0.0;
	list[Figure] boxes = getBoxesForUnits(result.unitMetricsResult.mscores, result.unitMetricsResult.totalUnitLines);
	
	return vcat([
		box(treemap(boxes), size(width,height-60),resizable(false), onClick()),
		box(getLegend(),size(width,40),resizable(false))
	],vgap(3));
}

private Figure getLegend(){
	return hcat([getColorLegend(), getExplination()]);
}

private Figure getColorLegend(){
	return box(hcat([
	box(fillColor(getColor(51)),lineWidth(2)),
	text(" = 50+ Cyclomatic Complexity (CC) "),
	box(fillColor(getColor(21)),lineWidth(2)),
	text(" = 20 - 50 CC "),
	box(fillColor(getColor(11)),lineWidth(2)),
	text(" = 10 - 20 CC "),
	box(fillColor(getColor(1)),lineWidth(2)),
	text(" = Under 10 CC ")
	]), lineWidth(2));
}

private Figure getExplination(){
	return box(text(" The larger the surface area, the larger (more lines of code) the method. "),lineWidth(2));
}

private FProperty onClick(){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){mouseClick(modifiers); return false;});
}

private void mouseClick(map[KeyModifier,bool] modifiers){
	if(modifiers[modCtrl()]){
		println("modCtrl true");
		ctrlClicked = true;
	}else{
	   clicked = true;
	}
}

private list[Figure] getBoxesForUnits(list[MethodScore] methodScores, int totalLines) {
	list[Figure] boxes = [];
	boxes = [getBoxForUnit(x, totalLines) | x <- methodScores];
	return boxes;
}

private Figure getBoxForUnit(MethodScore mscore, int totalLines) {
	return box(area(getBoxSize(mscore[2],totalLines)), fillColor(getColor(mscore[3])), popup(mscore),highlight());
}

private FProperty popup(MethodScore methodScore) {
	return mouseOver(computeFigure(Figure (){return calcPopup(methodScore);}));
}

private Figure calcPopup(MethodScore methodScore){
	if(ctrlClicked){
		ctrlClicked = false;
		edit(methodScore[0]);
	}
	if(clicked){
		return getPopup(methodScore);
	}else{
		return dummy();
	}
}

private Figure getPopup(MethodScore methodScore){
	clicked=false;
	return box(vcat(
			[
				text("Location:\t<methodScore[0]>", fontBold(true), left()), 
				text("Method:\t<methodScore[1]>", fontItalic(true), left()), 
				text("Complexity:\t<methodScore[3]>", fontItalic(true), left()), 
				text("Lines of code:\t<methodScore[2]>", fontItalic(true), left()),
				text("Hold down CTRL and click for code.", fontItalic(true), left())
			], vgap(5)),
			fillColor("White"),
			gap(5), startGap(true), endGap(true),
			resizable(false)
	);
}

private Figure dummy(){
	return box(fillColor(color("White",0.0)));
}

private FProperty highlight() {
	return mouseOver(box(fillColor(color("Gray", 0.3))));
}

private real getBoxSize(int lines, int totalLines) {
	tempTotalLines += percentage(lines,totalLines) * 100; 
	return percentage(lines,totalLines * 100);
}

private Color getColor(int complexity) {
	if(complexity > 50) return rgb(255,99,71);
	if(complexity > 20) return rgb(255,165,0);
	if(complexity > 10) return rgb(255,253,141);
	return rgb(144,238,144);
}
