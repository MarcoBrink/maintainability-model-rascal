module tests::TestSuite

import tests::TestCoverageMetricTest;
import tests::DuplicationMetricTest;
import tests::UnitComplexityMetricTest;
import tests::VolumeMetricTest;

//Run ALL TestCoverage tests
public test bool tctest1(){
  return tests::TestCoverageMetricTest::test1();
}

public test bool tctest2(){
  return tests::TestCoverageMetricTest::test2();
}

//Run All UnitComplexity tests
public test bool uctest1(){
  return tests::UnitComplexityMetricTest::test1();
}

public test bool uctest2(){
  return tests::UnitComplexityMetricTest::test2();
}

//Run ALL Duplication tests
public test bool dtest1(){
  return tests::DuplicationMetricTest::test1();
}

public test bool dtest2(){
  return tests::DuplicationMetricTest::test2();
}

//Run ALL Volume tests
public test bool vtest1(){
  return tests::VolumeMetricTest::test1();
}

public test bool vtest2(){
  return tests::VolumeMetricTest::test2();
}
