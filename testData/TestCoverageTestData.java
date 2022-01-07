import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.awt.Graphics;
import java.awt.Rectangle;
import java.awt.image.ImageObserver;
import java.util.Vector;

import org.junit.Test;

/** Ean slide
 * <P>
 * This program is distributed under the terms of the accompanying
 * COPYRIGHT.txt file (which is NOT the GNU General Public License).
 * Please read it. Your use of the software constitutes acceptance
 * of the terms in the COPYRIGHT.txt file.
 */

public class Slide {
  public final static int referenceWidth = 800;
  public final static int referenceHeight = 600;
  protected String title; // de titel wordt apart bewaard
  protected Vector<SlideItem> items; // de slide-items wordne in een Vector bewaard

  @Test
  public void test1() {
		assertEquals(1,1);
		assertTrue(true);
		assertFalse(false);
  }
  
  @Test
  public void test2() {
		assertEquals(1,1);
		assertTrue(true);
		assertFalse(false);
		assert true;
  }
  
  @Test
  public void test3() {
	//assertEquals(1,1);
	//assertTrue(true);
	assertFalse(false);
	assert true;
  }
  
  public Slide() {
    items = new Vector<SlideItem>();
    System.out.println("HelloWorld");
    System.out.println("HelloWorld");
    System.out.println("HelloWorld");
    System.out.println("HelloWorld");
    System.out.println("HelloWorld");
    System.out.println("HelloWorld");
    System.out.println("HelloWorld");
  }

// Voeg een SlideItem toe
  public void append(SlideItem anItem) {
    items.addElement(anItem);
  }

// geef de titel van de slide
  public String getTitle() {
    return title;
  }

// verander de titel van de slide
  public void setTitle(String newTitle) {
    title = newTitle;
  }

// Maak een TextItem van String, en voeg het TextItem toe
  public void append(int level, String message) {
    append(new TextItem(level, message));
  }

// geef het betreffende SlideItem
  public SlideItem getSlideItem(int number) {
    return (SlideItem)items.elementAt(number);
  }

// geef alle SlideItems in een Vector
  public Vector getSlideItems() {
    return items;
  }

// geef de afmeting van de Slide
  public int getSize() {
    return items.size();
  }

// teken de slide
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

// geef de schaal om de slide te kunnen tekenen
  private float getScale(Rectangle area) {
    return Math.min(((float)area.width) / ((float)referenceWidth), ((float)area.height) / ((float)referenceHeight));
  }
}
