package fifteen;
import java.util.*;

/**
 * <p>Title: 15-puzzle</p>
 * <p>Description: Game for studying search techniques</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */

public class PuzzleState {
  public int[][] state;
  public Vector history; // the moves which took us here
  public static int MOVE_NORTH=0;
  public static int MOVE_SOUTH=1;
  public static int MOVE_WEST=2;
  public static int MOVE_EAST=3;
  public static int[] directions={MOVE_NORTH, MOVE_SOUTH, MOVE_WEST, MOVE_EAST};

  /** identify which position (row) that is empty on the map
   *
   */
  int emptyGetRow() {
    for (int r=0; r<state.length; r++) {
      for (int c=0; c<state[r].length; c++) {
        if (state[r][c]==0)
          return r;
      }
    }
    return 0; // actually one should throw an exception...
  }

  /** identify which position (column) that is empty on the map
   *
   */
  int emptyGetCol() {
    for (int r=0; r<state.length; r++) {
      for (int c=0; c<state[r].length; c++) {
        if (state[r][c]==0)
          return c;
      }
    }
    return 0; // actually one should throw an exception...
  }

  /** create a new state based on a source state and a move
   *
   */
  PuzzleState nextState(int move) {
    PuzzleState next=null;
    int rowEmpty=emptyGetRow();
    int colEmpty=emptyGetCol();
    if (move==MOVE_NORTH && rowEmpty!=0) {
      next=new PuzzleState(this, move); // make a copy of the current tile configuration
      next.state[rowEmpty][colEmpty]=next.state[rowEmpty-1][colEmpty]; // fill empty spot with tile to the NORTH
      next.state[rowEmpty-1][colEmpty]=0; // new empty spot
    } else if (move==MOVE_SOUTH && rowEmpty!=(state.length-1)) {
      next=new PuzzleState(this, move);
      next.state[rowEmpty][colEmpty]=next.state[rowEmpty+1][colEmpty];
      next.state[rowEmpty+1][colEmpty]=0;
    } else if (move==MOVE_WEST && colEmpty!=0) {
      next=new PuzzleState(this, move);
      next.state[rowEmpty][colEmpty]=next.state[rowEmpty][colEmpty-1];
      next.state[rowEmpty][colEmpty-1]=0;
    } else if (move==MOVE_EAST && colEmpty!=(state[0].length-1)) {
      next=new PuzzleState(this, move);
      next.state[rowEmpty][colEmpty]=next.state[rowEmpty][colEmpty+1];
      next.state[rowEmpty][colEmpty+1]=0;
    }
    return next;
  }

  /** Identify and return possible "next states".
   *  Note that possible states get ordered...
   *
   */
  PuzzleState[] expandState() {
    PuzzleState[] possible=new PuzzleState[directions.length];
    int cnt=0; // no of possible moves
    for (int d=0; d<directions.length; d++)
      if ((possible[d]=nextState(directions[d]))!=null)
        cnt++;
    PuzzleState[] expanded=new PuzzleState[cnt];
    cnt=0;
    for (int d=0; d<directions.length; d++) {
      if (possible[d]!=null)
        expanded[cnt++]=possible[d];
    }
    return expanded;
  }

  /** checks if goal is fulfilled
   *
   */
  public boolean goal(int[][] map) {
    for (int r=0; r<state.length; r++) {
      for (int c=0; c<state[r].length; c++)
        if (state[r][c]!=map[r][c])
          return false;
    }
    return true;
  }

  /** reset state history
   *
   */
  public void clear() {
    history=new Vector();
  }

  /** creates an instance of a state with a specified tile configuration
   *  and a clean trace.
   */
  public PuzzleState(int[][] orig) {
    state=new int[4][4];
    for (int r=0; r<orig.length; r++) {
      for (int c=0; c<orig[r].length; c++)
        state[r][c]=orig[r][c];
    }
    history=new Vector();
  }

  /** creates an instance of a state from an ascending state and a specified move.
   *  The trace is updated.
   */
  public PuzzleState(PuzzleState ascendant, int move) {
    state=new int[ascendant.state.length][ascendant.state[0].length];
    for (int r=0; r<state.length; r++) {
      for (int c=0; c<state[r].length; c++)
        state[r][c]=ascendant.state[r][c];
    }
    history=new Vector(ascendant.history);
    history.add(new Integer(move)); // add the current move to trace
  }

}