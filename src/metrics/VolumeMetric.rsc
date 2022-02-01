module metrics::VolumeMetric

import metrics::calculations::Normalize;
import metrics::rankings::VolumeRanking;

import Results;

/* 
*	Calculate the volume metrics of a project
*/
public VolumeMetricsResult calculateVolumeMetrics(loc project)
{
	NormalizedData normalized = normalizeFiles(project);
	Ranking ranking =  getVolumeRanking(normalized.volumeInfo.codeLines);
	
	return <ranking, normalized.normalizedFiles, normalized.volumeInfo.files, normalized.volumeInfo.totalLines, normalized.volumeInfo.codeLines, normalized.volumeInfo.blankLines>;
}

