module metrics::VolumeMetric

import metrics::calculations::Normalize;
import metrics::rankings::VolumeRanking;

import SIGRanking;

alias VolumeMetricsResult = tuple[Ranking ranking, map[loc, list[str]] normalizedFiles, int files, int totalLines, int codeLines, int blankLines];

public VolumeMetricsResult calculateVolumeMetrics(loc project)
{
	NormalizedData normalized = normalizeFiles(project);
	Ranking ranking =  getVolumeRanking(normalized.volumeInfo.codeLines);
	
	return <ranking, normalized.normalizedFiles, normalized.volumeInfo.files, normalized.volumeInfo.totalLines, normalized.volumeInfo.codeLines, normalized.volumeInfo.blankLines>;
}

