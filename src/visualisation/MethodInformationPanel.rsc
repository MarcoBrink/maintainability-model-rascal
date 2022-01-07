module visualisation::MethodInformationPanel

import Prelude;
//import DataTypes;
import vis::Figure;
import vis::Render;
import vis::KeySym;
import lang::java::jdt::m3::Core;
import analysis::graphs::Graph;
import util::Editors;
import util::Math;
import Utils::MetricsInformation;
import visualisation::Controls;

private loc currentMethod = NotFound;

/*****************************/
/* Initializer				 */
/*****************************/
private bool _isInitialized = false;

/**
 * Initializes the method information panel.
 */
public void mip_initialize() {
	if(!_isInitialized) {
		mip_addNewMethodSelectedEventListener(onNewMethodSelected);		
		
		_isInitialized = true;
	}
	
	currentMethod = NotFound;
}

/*****************************/
/* Redraw panel				 */
/*****************************/
private bool _redraw = false;
private void redraw() { _redraw = true; }
private bool shouldRedraw() { bool temp = _redraw; _redraw = false; return temp; }

/*****************************/
/* New Method Selected event */
/*****************************/
private list[void(loc method)] newMethodSelectedEventListeners = [];

/**
 * Adds an event listener for the new method selected event.
 */
public void mip_addNewMethodSelectedEventListener(void(loc method) listener) {
	if(indexOf(newMethodSelectedEventListeners, listener) == -1) {
		newMethodSelectedEventListeners += [listener];
	}
}

/**
 * Trigger the new method selected event listener.
 */
private void newMethodSelected(loc method) {
	for(l <- newMethodSelectedEventListeners) l(method);
}

/**
 * Local event handler for selecting new method.
 */
private void onNewMethodSelected(loc method) {
	mip_setCurrentMethod(method);
}

/**
 * Sets the specified location as the current method.
 * @param method The location of the method.
 */
public void mip_setCurrentMethod(loc method) {
	currentMethod = method;
	redraw();
}

/**
 * Clears the method information panel.
 */
public void mip_clearMethodInformationPanel() {
	currentMethod = NotFound;
	redraw();
}

/**
 * Returns a Figure representing the method information panel.
 */
public Figure methodInformationPanel() {
	mip_initialize();

	return computeFigure(
			shouldRedraw,
			Figure() { 			
				return panel(
					vcat([
						label("Unit Maintainability Ranking:"),
						box(hscrollable(getGraph())),
						box(
							hcat([
								text("Complexity: <mi_getUnitComplexity(currentMethod)>", left()),
								getLineCountsFigure(currentMethod),
								text("Unitsize: <mi_getUnitLOC(currentMethod)>", left()),
								myButton("View source", void(){edit(mi_getDeclaration(currentMethod));}, hresizable(false), width(60))
							],hgap(40), vsize(40), vresizable(false), startGap(true), endGap(true)),
						vsize(60), vresizable(false))
						
					]),
					getName(currentMethod)
				); 
			}
		);
}

/**
 * Returns a Figure representing the line counts stacked bar graph for the specified location.
 * @param location The location to get the bar graph for.
 * @returns A Figure representing the line counts stacked bar graph.
 */
Figure getLineCountsFigure(loc location) {
	LineCounts lc = mi_getLineCountsForMethod(location);
	
	comments = (0.00 + lc.comment) / (0.000001 + lc.total);
	blank = (0.00 + lc.blank) / (0.000001 + lc.total);
	code = 1.0 - comments - blank;
	
	return 
		hcat([
			text("Line Counts:"),
			box(
				hcat([
					box(/*text("<lc.comment>", fontColor("white")),*/fillColor("black"), lineWidth(0), hshrink(comments)),
					box(/*text("<lc.code>",    fontColor("white")),*/fillColor("green"), lineWidth(0), hshrink(code)),
					box(/*text("<lc.blank>",   fontColor("white")),*/fillColor("white"), lineWidth(0), hshrink(blank))
				],std(vsize(40))), popup("Comments:\t <lc.comment>\nCode:\t\t <lc.code>\nBlank:\t\t <lc.blank>"),
				std(vresizable(false))
			)
		], hgap(5));
	
}

/**
 * Returns a Figure representing a graph for the current method.
 * @returns A figure representing the graph for the current method.
 */
Figure getGraph(){
	pred = mi_getPredecessors(currentMethod);
	succ = mi_getSuccessors(currentMethod);
	
	nodes = [ graphNode(pr) | pr <- (pred + succ +{currentMethod}) ];
	
	edges = [ edge(method.path, currentMethod.path) | method <- pred ];
	edges += [ edge(currentMethod.path, method.path) | method <- succ ];
	
	return graph(nodes, edges, hint("layered"), hgap(10), vgap(50));
}

/**
 * Returns a Figure representing a graph node for the specified location.
 */
Figure graphNode(loc l) = box(
							text(getName(l)), 
							id(l.path),
							hgap(10),
							hsize(100), vsize(50), resizable(false), fillColor(getNodeColor(l)),
							top(), left(),
							popup("Filename: <l.file>\nFilepath: <l.path>"),
							onMouseDown(graphNodeClickHandler(l))
						  );

/**
 * Gets the node color for the specified location.
 */
Color getNodeColor(loc l) {
	if(l == currentMethod) return color("red");
	if(mi_getDeclaration(l) == NotFound) return color("grey");
	return color("green");
}

/**
 * Mouse click handler for graph nodes.
 */
private bool(int, map[KeyModifier, bool]) graphNodeClickHandler(loc location) = bool(int btn, map[KeyModifier, bool] mdf) {
	if(btn == 1){
		newMethodSelected(location);
		return true;
	}
	return false;
};

/**
 * Gets the name for the specified location.
 * @param l The location to get the name for.
 * @returns A string representing the name.
 */
private str getName(loc l) {
	return /^<n:.*>\(.*$/ := l.file ? n + "()" : l.file;	
}
