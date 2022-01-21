module Main

import vis::Figure;
import vis::Render;
import IO;

private int maxHor = 100;
private int maxVer = 55;

public void test1(){
 loc l = |project://smallsql/src/smallsql/database/SQLParser.java|;
println(l.fragment);
println(l.parent);
println(l.scheme);
println(l.authority);
println(l.path);
}

