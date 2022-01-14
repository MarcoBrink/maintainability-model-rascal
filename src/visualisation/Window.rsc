module visualisation::Window

import IO;
import String;
import Prelude;
import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;

//import DataTypes;
//import Main;

//import Utils::MetricsInformation;

import visualisation::ProjectBrowser;
import visualisation::MethodInformationPanel;
import visualisation::ScatterPlotPanel;
import visualisation::TreemapPanel;
import visualisation::ComplexityTreemapPanel;
import visualisation::AnalysisResults;
import visualisation::SettingsPanel;
import visualisation::Controls;

import lang::java::jdt::m3::Core;
import analysis::graphs::Graph;

import Results;

private int numberOfPanels = 2;
private int previousIndex = 0;
private int currentIndex = 0;

/**
 * Event listener for project browser new location selected.
 */
void onPBNewLocationSelected(loc location) {
	println("Location selected:");
	println(location);
	/*
	if(isMethod(location)){
		//mip_setCurrentMethod(location);
		currentIndex = 1;
	} else {
		//ctp_setMethods(location.path, pb_getMethodsOfSelectedLocation());
		currentIndex = 2;
	}
	*/
	//updateMaintainabilityRankingPanel();
}

/**
 * Event listener for MethodInformationPanel new selected method.
 */
void onMIPNewMethodSelected(loc method) {
	pb_setLocation(method);
	updateMaintainabilityRankingPanel();
}

/**
 * Event listener for complexity tree panel new selected method.
 */
void onCTPMethodSelected(loc method) {
	pb_setLocation(method);
	mip_setCurrentMethod(method);
	currentIndex = 1;
	updateMaintainabilityRankingPanel();
}

/**
 * Updates the maintainability ranking panel.
 */
void updateMaintainabilityRankingPanel(){
	currentProject = pb_getCurrentProject();
	results = mi_getResultsOfProject(currentProject);
	mrp_setResults(results);
}

void settingsPanelButtonCallback() {
	previousIndex = currentIndex;
	currentIndex = 3;
} 

void settingsPanelClosed(){
	currentIndex = previousIndex;
}

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
void begin(list[Results] results) {
	set[M3] models = {r.m3| r<-results};
	println(size(models));
	previousIndex = 0;
	currentIndex = 0;
	
	
	//Project Browser callbacks
	pb_addNewLocationSelectedEventListener(onPBNewLocationSelected);
	//pb_addProjectRefreshRequestEventListener(mi_refreshProjectMetrics);
  
  
  /*
	bool miReInit = mi_initialize(false);
	pb_initialize(miReInit);
	sp_initialize();
	
	mip_addNewMethodSelectedEventListener(onMIPNewMethodSelected);
	
	sp_addColorschemeChangedEventListener(ctp_setColorscheme);
	sp_addSettingsSavedEventListener(settingsPanelClosed);
	
	ctp_addMethodSelectedEventListener(onCTPMethodSelected);
	*/
	render(
		page("Maintainability Metrics Analyzer",
			 menuBar([myButton("Change View", nextPanel, vresizable(false), height(30))]),
			 createMain(
			 /*
			 	panel(projectBrowser(), "", 0),
			 	maintainabilityRankingPanel(),
			 	fswitch(int(){return currentIndex;},[
			 		welcomePanel()//,
			 		//methodInformationPanel(),
			 		//complexityTreemapPanel(),
			 		//settingsPanel()
			 	])*/
			 	//panel(projectBrowser(models), "", 0),
			 	box(),
			 	maintainabilityRankingPanel(results[0]),
			 	fswitch(int(){return currentIndex;},[
			 		scatterPlotPanel(results[0]),
			 		TreemapPanel(results[0])
			 	])
				 ),
			 footer("Copyright by A. Walgreen & E. Postma ©2019\t")
		)
	);
}

public Figure createDummyFigure(){
  return panel(
				text(
					"Select a project in the browser on the left to start", 
					center()
				), 
				"Welcome to the Maintainability Analyzer"
			);
}

/**
 * Creates a figure representing the main window.
 * @param leftTop The figure to put in the left top.
 * @param leftBottom The figure to put in the left bottom.
 * @param right The figure for the right side area.
 * @returns A Figure representing the composed main window.
 */


public Figure createMain(Figure leftTop, Figure leftBottom, Figure right) {
	int width = 1500;
	int height = 700;
	int leftwidth = 350;
	int rightwidth = width-leftwidth;
	return box(
		hcat(
		[
			
			box(leftTop,resizable(false), size(leftwidth,height)),
				
		
			
			box(right, size(rightwidth,height), resizable(false))
		],
		gap(20), startGap(true), endGap(true)), size(1050,height), resizable(false),
		fillColor(color("white", 0.0)), lineWidth(0)
	);
}

/**
 * Creates the welcome pannel.
 * @returns A Figure representing the welcome panel.
 */
private Figure welcomePanel() {
	return panel(
				text(
					"Select a project in the browser on the left to start", 
					center()
				), 
				"Welcome to the Maintainability Analyzer"
			);
}