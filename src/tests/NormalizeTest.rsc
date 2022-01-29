module tests::NormalizeTest

import metrics::calculations::Normalize;
import IO;
import Results;

alias VolumeInfo = tuple[int files, int totalLines, int codeLines, int blankLines];
alias NormalizedData = tuple[map[loc, list[str]] normalizedFiles, VolumeInfo volumeInfo];

public test bool test1(){
	loc testfile = |project://maintainability-metrics//testData//NormalizeTestData.java|;
	normalized = normalize(testfile);
	VolumeInfo info = normalized[1];
	println(info);
	
	return true;
}