module visualisation::MainPanel

import vis::KeySym;
import vis::Figure;
import vis::Render;

import Results;
import visualisation::ScatterPlotView;
import visualisation::TreemapView;

private str title = "Distribution Cyclomatic Complexity vs Volume (Lines of Code) per Method";
private str subtitle = "Scatterplot";
private bool redrawSubTitle = false;

/*
private bool withColor = true;
private bool showTotalPerCategory = false;
private bool percentage = false;
private bool asLines = false;
*/
private int currentPanel = 0;

private Results results;

/*
* Constructor
*/
public void begin(Results _results){
	results = _results;
	currentPanel = 0;
	render(
		box(controllerPanel(), size(1500, 800), resizable(true), gap(20), startGap(true), endGap(true))
	);
}

private Figure controllerPanel() {	
	return box(vcat([
			box(box(text("Project:  "+ results.location.authority, fontSize(15), fontColor("White"),fontBold(true), fillColor("Black")),lineWidth(1), left(), resizable(false),fillColor("Black")), fillColor("Black")),
			box(text(title, fontSize(20)),lineWidth(0), top()),
			computeFigure(toRedrawTitle, Figure (){return box(text(subtitle, fontSize(14)),lineWidth(0), fillColor(color("White", 0.0)));}),
			getMenu(),
			box(mainpanel(), resizable(false), size(1340, 640), lineWidth(0))
		], resizable(false),vgap(2))); 
}

private bool toRedrawTitle(){
	if(redrawSubTitle){
		redrawSubTitle = false;
		return true;
	}
	return false;
}

private Figure mainpanel(){
	return fswitch(int(){return currentPanel;},[
		scatterPlotView(results),
		TreemapPanel(results, 1340, 640)
	]);
}

private Figure getMenu(){
	return 	box(
		hcat([
		  box(text("Scatterplot"), resetAction(),highlight()),
		  box(text("Toggle bg color"), toggleColorAction(),highlight()),
		  box(text("Nr. methods per Cat."), showCatAbsAction(),highlight()),
		  box(text("% methods per Cat."), showCatPerAction(),highlight()),
		  box(text("Nr. loc per Cat."), showCatAbsLocAction(),highlight()),
		  box(text("% loc per Cat."), showCatPerLocAction(),highlight()),
		  box(text("Treemap Volume"), showTreemapAction(),highlight()),
		  box(text("Treemap Relative"), showTreemapRelAction(),highlight())
		]), hsize(40), lineWidth(2)
	);
}

private FProperty resetAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){spv_redraw(); currentPanel =0;spv_reset(); setSubtitle("Scatterplot"); return true;});
}

private FProperty toggleColorAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){spv_redraw(); currentPanel =0;spv_toggleColor(); setSubtitle("Scatterplot"); return true;});
}

private FProperty showCatAbsAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){spv_redraw(); currentPanel =0;spv_setCategories(true);spv_setPercentage(false);spv_setLines(false); setSubtitle("Scatterplot: Total number of methods per category"); return true;});
}

private FProperty showCatPerAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){spv_redraw(); currentPanel =0;spv_setCategories(true);spv_setPercentage(true);spv_setLines(false); setSubtitle("Scatterplot: Percentage of methods per category"); return true;});
}

private FProperty showCatAbsLocAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){spv_redraw(); currentPanel =0;spv_setCategories(true);spv_setPercentage(false);spv_setLines(true); setSubtitle("Scatterplot: Total number of lines of code (loc) per category"); return true;});
}

private FProperty showCatPerLocAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){spv_redraw(); currentPanel =0; spv_setCategories(true);spv_setPercentage(true);spv_setLines(true); setSubtitle("Scatterplot: Percentage of lines of code (loc) per category"); return true;});
}

private FProperty showTreemapAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){currentPanel = 1; setSubtitle("Treemap Volume"); tmv_setRelativeView(false); return true;});
}

private FProperty showTreemapRelAction() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){currentPanel = 1; setSubtitle("Treemap Relative"); tmv_setRelativeView(true); return true;});
}

/*
* Label popups
*/

private FProperty highlight() {
	return mouseOver(box(fillColor(color("Gray", 0.3))));
}

/*
*
*/

private void setSubtitle(str s){
  redrawSubTitle= true;
  subtitle = s;
}