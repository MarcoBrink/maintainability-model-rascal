module visualisation::AnalysisResults

import visualisation::Controls;
import vis::Figure;
import Results;
import SIGRanking;
import Set;
import Map;
import String;

private Results _results;

/*****************************/
/* Initializer				 */
/*****************************/
private bool _isInitialized = false;

/**
 * Initializes the analysis results component.
 */
public void mrp_initialize() {
	if(!_isInitialized) {	
		
		_isInitialized = true;
	}
	
	//_results = empty();
}

/*****************************/
/* Redraw panel				 */
/*****************************/
private bool _redraw = false;
private void redraw() { _redraw = true; }
private bool shouldRedraw() { bool temp = _redraw; _redraw = false; return temp; }

/**
 * Sets new results
 */
public void mrp_setResults(Results results) {
	_results = results;
	redraw();
}

/**
 * Defines the rank fill colors.
 */
private map[Ranking, FProperty] rankColors = (
	VERY_LOW:fillColor("Red"),
	LOW:fillColor("Orange"),
	MODEST:fillColor("Yellow"),
	HIGH:fillColor("Green"),
	VERY_HIGH:fillColor("DarkGreen"),
	UNKNOWN:fillColor("White")
);

/**
 * Defines the rank font colors.
 */
private map[Ranking, FProperty] rankFontColors = (
	VERY_LOW:fontColor("White"),
	LOW:fontColor("Black"),
	MODEST:fontColor("Black"),
	HIGH:fontColor("White"),
	VERY_HIGH:fontColor("White"),
	UNKNOWN:fontColor("Black")
);

/**
 * Default label width.
 */
private int labelWidth = 350;

/**
 * Default font style.
 */
private list[FProperty] fontStyle = [ fontSize(11), left(), vresizable(false), height(22) ];

/**
 * Label, icon, rank Figure helpers.
 */
private Figure label(Ranking rank) = box(text(rank.label), left(), width(labelWidth));
private Figure label(str label) = box(text(label, fontStyle), left(), width(labelWidth));
private Figure label(str label, list[FProperty] styles) = box(text(label, fontStyle + styles), left(), width(labelWidth));
//private Figure rank(Ranking rank) = box(text(rank.rank), left(), width(labelWidth));
//private Figure icon(Ranking rank) = box(text(rank.rank, fontBold(true), rankFontColors[rank]), rankColors[rank], width(30));

/**
 * Creates a figure representing the specified risk category and risk evaluation.
 
private Figure riskCategory(str riskCategory, str evaluation) {
	Figure figure;
	str text;
	
	if (riskCategory in evaluation) {
		RiskValues values = evaluation[riskCategory];
		text = "<left(riskCategory.risk + " (" + riskCategory.category + ")", 30)> <values.percentage> % (totalling <values.linesOfCode> lines of code in <size(values.units)> units)";
	}
	else {
		text = "<left(riskCategory.risk + " (" + riskCategory.category + ")", 30)> 0.00 %";		
	}
	
	return label(text, [font("Consolas"), fontSize(10)]);
}

/**
 * Creates a Figure representing the ranking icon for the specified VolumeAnalysisResult.
 
private Figure icon(VolumeAnalysisResult result) {
	Rank rank = result.ranking;	
	
	Figure content = vcat([
		label("VOLUME RANKING", [fontBold(true)]),
		label(""),
		label("Total <result.totalLinesOfCode> lines of which:"),
		label("<result.codeLines> lines of code"),
		label("<result.commentLines> comment lines"),
		label("<result.blankLines> blank lines"),
		label(""),
		label("Calculated volume ranking: <rank.rank> (<rank.label>)")
	], [std(fillColor(ColorPopupBackground))]);
	
	return box(text(rank.rank, fontBold(true), rankFontColors[rank]), rankColors[rank], width(30), popup(content));
}

/**
 * Creates a Figure representing the ranking icon for the specified UnitAnalysisResult.
 
private Figure icon(str name, UnitAnalysisResult result) {
	Rank rank = result.ranking;	
	
	Figure content = vcat([
		label(toUpperCase(name), [fontBold(true), height(20), resizable(false)]),
		label(""),
		label("Total <result.unitsCount> units of which:"),		
		riskCategory(RiskCategories.veryHigh,  result.risk),
		riskCategory(RiskCategories.high,  result.risk),
		riskCategory(RiskCategories.moderate,  result.risk),
		riskCategory(RiskCategories.low,  result.risk),
		label(""),
		label("Calculated <name> ranking: <rank.rank> (<rank.label>)")
	], [std(fillColor(ColorPopupBackground))]);
	
	return box(text(rank.rank, fontBold(true), rankFontColors[rank]), rankColors[rank], width(30), popup(content));
}

/**
 * Creates a Figure representing the ranking icon for the specified DuplicationAnalysisResult.
 
private Figure icon(DuplicationAnalysisResult result) {
	Rank rank = result.ranking;
	
	Figure content = vcat([
		label("DUPLICATIONS RANKING", [fontBold(true)]),
		label(""),
		label("<result.duplicateLines> of <result.totalLinesOfCode> lines are duplicate: <result.percentage>%"),
		label(""),
		label("Calculated duplications ranking: <result.ranking.rank> (<result.ranking.label>)")
	], [std(fillColor(ColorPopupBackground))]);
	
	return box(text(rank.rank, fontBold(true), rankFontColors[rank]), rankColors[rank], width(30), popup(content));
}
*/

private Figure icon(str s){
	return label(s);
}

private Figure icon(str s, str a){
	return label(s);
}


/**
 * Creates a Figure representing the overall maintainability ranking table.
 */
public Figure maintainabilityRankingPanel(Results results) {

	return computeFigure(
		shouldRedraw,
		Figure () {
			return panel(grid([
				[ label("Metrics:", [fontBold(true)]) ],
				[ label("Volume"), icon("_results.volume")],
				[ label("Unit Size"), icon("unit size", "_results.unitSize")],
				[ label("Complexity"), icon("complexity", "_results.complexity")],
				[ label("Duplication"), icon("_results.duplicates")],
				[ box() ],		
				[ label("Quality Aspects:", [fontBold(true)]) ],
				//[ label(MaintainabilityAspects.analyzability), icon(_results.score.aspects[MaintainabilityAspects.analyzability])],		
				//[ label(MaintainabilityAspects.changeability), icon(_results.score.aspects[MaintainabilityAspects.changeability])],
				//[ label(MaintainabilityAspects.stability), icon(_results.score.aspects[MaintainabilityAspects.stability])],
				//[ label(MaintainabilityAspects.testability), icon(_results.score.aspects[MaintainabilityAspects.testability])],
				[ box() ],
				[ label("Overall Maintainability Ranking:", [fontBold(true)]), icon("_results.score.overall")]			
			], [top(), std(lineWidth(0)), std(fontSize(11)), std(hresizable(false))]),
				"System Maintainability Ranking", 5
			); 
		}
	);
}