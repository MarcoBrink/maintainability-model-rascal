module metrics::VolumeMetric

import metrics::calculations::Normalize;

public str calculateVolumeMetrics(VolumeInfo metadata)
{
	return  getVolumeRanking(metadata.codeLines);
}

private str getVolumeRanking(int totalLinesOfCode)
{
	int KLOC = totalLinesOfCode / 1000;
	
	if(KLOC < 66)
	{
		return "++";
	}
	
	if(KLOC < 246)
	{
		return "+";
	}
	
	if(KLOC < 665)
	{
		return "o";
	}
	
	if(KLOC < 1310)
	{
		return "-";
	}
	
	return "--";
}