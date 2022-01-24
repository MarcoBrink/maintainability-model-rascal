module visualisation::Window

import IO;
import String;
import Prelude;
import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;


import visualisation::ScatterPlotPanel;
import visualisation::TreemapPanel;

import analysis::graphs::Graph;

import Results;

private list[str] panelNames = ["Scatter plot", "Treemap"];
private int numberOfPanels = size(panelNames);
private int currentIndex = 0;


private void nextPanel(){
   if(currentIndex+1 < numberOfPanels){
     currentIndex = currentIndex+1;
   }else{
     currentIndex = 0;
   }
}

/**
 * Module entry point method.
 */
void begin(Results results) {	
	previousIndex = 0;
	currentIndex = 0;
	//text("Project:  "+ results.location.authority),fillColor(color("Gray", 0.3)), vshrink(0.05)
	render(
		//page("Maintainability Metrics Analyzer",
			 //menuBar([button("Change View", nextPanel, vresizable(false), height(30)), space(size(340,30)) ,computeFigure(Figure (){ return text(panelNames[currentIndex],fontColor("white"), fontBold(true), hcenter());})]),
			 createMain(
			 	fswitch(int(){return currentIndex;},[
			 		scatterPlotPanel(results)
			 	])
				 )//,
			// footer("")
		//)
	);
}

public Figure createMain(Figure right) {
	int width = 1500;
	int height = 800;
	return box(right, size(width,height), resizable(true), gap(20), startGap(true), endGap(true));
}

public Figure page(str title, Figure menu, Figure main, Figure footer) {
	return box(
	  vcat([header(title),
		  	menu,
		  	main,
		  	footer
	       ]),
	  fillColor(color("Gray")), lineWidth(0), std(font("Dialog"))
	  /*,hsize(1600), vsize(1000), resizable(false)*/);
}

public Figure header(str caption) {	
	if(caption != "") {
		return box(
			text("  " + caption, fontSize(20), fontColor("white"), left()),
			vresizable(false), height(60), lineWidth(0), fillColor(rgb(41,67,78))
		);
	}
	return space(size(0), resizable(false));
}

public Figure menuBar(Figure menuItems...) {
	if(size(menuItems) > 0) {
		return box(
			// Content
			hcat(menuItems, resizable(false), left()),
			
			// Styling
			std(vresizable(false)), shadow(true), std(height(60)), left(), fillColor(rgb(129,156,169)), lineWidth(0)
			);
	}
	return space(vresizable(false), height(0));
}

public Figure footer(str caption) {	
	if(caption != "") {
		return box(
			text("  " + caption, fontColor("white"), right()),
			vresizable(false), height(60), lineWidth(0), fillColor(color("Gray"))
		);
	}
	return space(size(0), resizable(false));
}