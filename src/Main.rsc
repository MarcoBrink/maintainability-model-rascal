module Main

import vis::Figure;
import vis::Render;

private int maxHor = 100;
private int maxVer = 55;

public void test1(){
   b1  = box(fillColor("Gray"));
   b2 =  box( fillColor("Yellow"));
   b3 =  box( fillColor("Red"));
	render(createMain(b1,b2,b3));

}

public Figure createMain(Figure mainpanel, Figure projectBrowser, Figure infoPanel) {
	return overlay([f,grid])
}