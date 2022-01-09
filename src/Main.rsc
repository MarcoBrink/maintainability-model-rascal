module Main

import vis::Figure;
import vis::Render;

public void flare(){
 b1 = box(size(20,30), fillColor("Red"));
 b2 = box(size(40,20), fillColor("Blue"));
b3 = box(size(40,40), fillColor("Yellow"));
b4 = box(size(10,20), fillColor("Green"));
b5 = box(size(10,20), fillColor("Purple"));
b6 = box(size(60,20), fillColor("Orange"));
b7 = box(size(10,80), fillColor("Black"));
b8 = box(size(70,10), fillColor("White"));
b9 = box(size(100,10), fillColor("Grey"));
b10 = box(size(10,100), fillColor("Silver"));
b11 = box(size(20), fillColor("Pink"));
b12 = box(size(30), fillColor("GoldenRod"));



p = pack([b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12], std(gap(10)));
e1 = ellipse(p, std(gap(20)), fillColor("red"));
panel = box(e1,size(200,200), fillColor("Grey"));



sb = scrollable(panel,shrink(0.5));
render(box(sb,fillColor("red")));

}