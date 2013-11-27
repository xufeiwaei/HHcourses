package fifteen;

import java.awt.*;
import java.util.*;

/**
 * <p>Title: 15-puzzle</p>
 * <p>Description: Game for studying search techniques</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author Mikael Bod�
 * @version 1.0
 */

/** This panel is designed for keeping track of the current config of tiles and display it.
 *  It supplies methods for "shuffling", "solving" and "stepping through a solution".
 */
public class PuzzlePanel extends Panel {
	int[][] tiles={   {  1,  2,  3,  4},
                      {  5,  6,  7,  8},
                      {  9, 10, 11, 12},
                      { 13, 14, 15,  0}};  // goal state

int[][] puzzle=tiles; // how the tiles of the puzzle looks like right now.

Color backColor=Color.blue;
Color tileColor=Color.red;
Color fontColor=Color.yellow;
int fontSize=20;
Font font=new Font("sanserif", Font.BOLD, fontSize);
PuzzleEngine engine;

public PuzzlePanel() {
engine=new PuzzleEngine(puzzle); // this is the engine we use for solving the puzzle
}

public void shuffle(int seed, int nStep) {
engine.randomize(seed, nStep);
puzzle=engine.getState();
repaint();
}

public int solve(Label labelSearched, Button source) {
int nNodes=0;String label;
label = source.getLabel();
Vector solution = new Vector();
if (label.equals( "BFS" )) {
solution=engine.search(tiles, labelSearched);
}
if (label.equals( "DisplaceNumber" )) {
solution=engine.searchwithdisplace(tiles, labelSearched);
}
if (label.equals( "ManhattanDistance" )) {
solution=engine.searchwithManhattan(tiles, labelSearched);
}
if (label.equals( "DFS" )) {
solution=engine.searchwithDFS(tiles, labelSearched);
}
//solution=engine.search(tiles, labelSearched);
if (solution!=null) {
nNodes=solution.size();
labelSearched.setText("#states:"+engine.evalCount+" level:"+nNodes);
} else
labelSearched.setText("#states:"+engine.evalCount+" FAILED/ABORTED"+nNodes);
return nNodes;
}

/** take a step towards the current solution
*  Updates the current puzzle state
*  @return int number of steps remaining after step taken
*/
public int step() {
puzzle=engine.step();
repaint();
return engine.solution.size();
}

public void paint(Graphics g) {
int width=getWidth();
int height=getHeight();
int tileWidth=width/4;
int tileHeight=height/4;
g.setFont(font);
g.setColor(backColor);
g.fillRect(0,0,width,height);
for (int r=0; r<puzzle.length; r++) { // for each row...
for (int c=0; c<puzzle[r].length; c++) { // for each column...
if (puzzle[r][c]!=0) {
  g.setColor(tileColor);
  g.fillRect((c*tileWidth)+2, (r*tileHeight)+2, tileWidth-4, tileHeight-4);
  g.setColor(fontColor);
  g.drawString((new Integer(puzzle[r][c])).toString(), c*tileWidth+tileWidth/2-fontSize/2, r*tileHeight+tileHeight/2+fontSize/2);
}
}
}
}

public String solveForTable(Label labelSearched, Button source) {
int nNodes=0;String label;
String text= new String("1");
label = source.getLabel();
Vector solution = new Vector();
solution=engine.search(tiles, labelSearched);
text = Integer.toString(engine.evalCount) + "\t\t";
solution=engine.searchwithdisplace(tiles, labelSearched);
text +=Integer.toString(engine.evalCount) + "\t\t"; 
solution=engine.searchwithManhattan(tiles, labelSearched);
text +=Integer.toString(engine.evalCount) + "\t\t";
solution=engine.searchwithDFS(tiles, labelSearched);
text +=Integer.toString(engine.evalCount) + "\t";

return text;
}

}