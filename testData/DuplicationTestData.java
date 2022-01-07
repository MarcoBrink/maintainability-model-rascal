import java.awt.Graphics;
import java.awt.Rectangle;
import java.awt.image.ImageObserver;

public class Duplication {
	public void method1() {
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 
		 System.out.println("HelloWorld");
		 /*
		  * 
		  */
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
	}
	
	public void method2() {
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 
		 System.out.println("HelloWorld");
		 //
		 //
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld"); ///
	}
	
	public void method3() {
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 
		 
		 
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 //
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
		 System.out.println("HelloWorld");
	}
	
	public void draw(Graphics g, Rectangle area, ImageObserver view) {
	    float scale = getScale(area);
	    int y = area.y;
	    // De titel wordt apart behandeld
	    SlideItem slideItem = new TextItem(0, getTitle());
	    Style style = Style.getStyle(slideItem.getLevel());
	    slideItem.draw(area.x, y, scale, g, style, view);
	    y += slideItem.getBoundingBox(g, view, scale, style).height;
	    for (int number=0; number<getSize(); number++) {
	      slideItem = (SlideItem)getSlideItems().elementAt(number);
	      style = Style.getStyle(slideItem.getLevel());
	      slideItem.draw(area.x, y, scale, g, style, view);
	      y += slideItem.getBoundingBox(g, view, scale, style).height;
	    }
	}
}
