package nn;

import java.awt.*;
import javax.swing.*;

/**
 * Title:        Digits
 * Description:  Digit recognition using neural networks
 * Copyright:    Copyright (c) 2001
 * Company:
 * @author Mikael Bodén
 * @version 1.0
 */

public class DigitPanel extends JPanel {
  int marginX=10, marginY=10;
  int dimX, dimY;
  int width, height;
  int dx, dy;
  public boolean[][] map;

  public DigitPanel(int x, int y) {
    dimX=x;
    dimY=y;
    map=new boolean[x][y];
    for (int xx=0; xx<dimX; xx++) {
      for (int yy=0; yy<dimY; yy++) {
        map[xx][yy]=false;
      }
    }
  }

  public void clear() {
    for (int xx=0; xx<dimX; xx++) {
      for (int yy=0; yy<dimY; yy++) {
        map[xx][yy]=false;
      }
    }
    repaint();
  }

  public void brush(int xx, int yy, int thickness) {
    int posX=Math.max(Math.min((xx-marginX)/dx,dimX-1),0);
    int posY=Math.max(Math.min((yy-marginY)/dy,dimY-1),0);
    map[posX][posY]=true;
    for (int i=1; i<thickness/2; i++) {
      map[Math.min(posX+i,dimX-1)][posY]=true;
      map[Math.max(posX-i,0)][posY]=true;
      map[posX][Math.min(posY+i,dimY-1)]=true;
      map[posX][Math.max(posY-i,0)]=true;
    }
    repaint();
  }

  public void paintComponent(Graphics g) {
    Graphics2D g2d=(Graphics2D)g;
    width=getWidth();
    height=getHeight();
    g2d.setColor(Color.white);
    g2d.fillRect(0,0,width,height);
    dx=(width-marginX*2)/(dimX);
    dy=(height-marginY*2)/(dimY);
    g2d.setColor(Color.black);
    for (int x=1; x<dimX; x++) {
      g2d.drawLine(marginX+x*dx, marginY, marginX+x*dx, marginY+dimY*dy);
    }
    for (int y=1; y<dimY; y++) {
      g2d.drawLine(marginX, marginY+y*dy, marginX+dimX*dx, marginY+y*dy);
    }
    for (int x=0; x<dimX; x++) {
      for (int y=0; y<dimY; y++) {
        if (map[x][y])
          g2d.fillRect(marginX+x*dx, marginY+y*dy, dx, dy);
      }
    }
  }


}