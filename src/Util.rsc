module Util

import util::Math;
import util::Resources;

import IO;
import Set;
import List;
import String;

public real percentage(int x, int total){
	if(x == 0|| total == 0){
	  return 0.0;
	}
	return (toReal(x)*100.0)/total;
}

public str trim(str s){
	return String::trim(s);
}

public str toString(num n){
	return util::Math::toString(n);
}

public real toReal(num n){
	return util::Math::toReal(n);
}

public int sum(list[value] l){
	return List::sum([0]+l);
}

public int sum(set[value] s){
	return Set::sum({0}+s);
}

public int size(list[value] l){
	return List::size(l);
}

public int size(set[value] s){
	return Set::size(s);
}

public str formatPercentage(real n){
	real r = round(n, 0.1);
	s = toString(r)+"%";
	while(size(s) < 6){
	 s =s+ " ";
	}
	return s;
}

public set[loc] fetchFiles(loc project){
	return { a | /file(a) <- getProject(project), a.extension == "java" };
}

public list[str] readFileLines(loc l){
	return IO::readFileLines(l);
}

public void println(str s){
	return IO::println(s);
}

public void println(){
	return IO::println();
}