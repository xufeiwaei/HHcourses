package fifteen;
import java.util.*;
import java.awt.*;

/**
 * <p>Title: 15-puzzle</p>
 * <p>Description: Game for studying search techniques</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */

/** The PuzzleEngine class manages the search process.
 *  It has a current "state".
 *  If a search has been completed and there is a solution, it knows it and how to approach a goal state.
 *
 */
public class PuzzleEngine {

  PuzzleState state;        // the current state
  public int evalCount=0;   // the number of nodes searched, re-init when search is re-started
  Vector solution=null;     // the steps to a goal state (in temporal order)

  public Label label=null;  // if not null, we update this GUI label with search status

  /** returns the current configuration of tiles
   *
   */
  public int[][] getState() {
    return state.state;
  }

  /** take a step towards a solution
   *  @return the configuration of tiles resulting
   */
  public int[][] step() {
    Integer firstStep=(Integer)solution.firstElement();
    solution.removeElementAt(0);
    state=state.nextState(firstStep.intValue());
    return getState();
  }

  /** start search
   *  @param  goal the configuration of tiles to search for
   *  @param  labelSearched the GUI label to update with search status
   *  @return the trace of steps towards the solution (also stored in "solution").
   */
  public Vector search(int[][] goal, Label labelSearched) {
    evalCount=0;
    solution=null;
    label=labelSearched;
    Vector queue=new Vector();
    state.clear();
    queue.add(state);
    return search(goal, queue);
  }

  /** start search with a initialized queue,
   *  @see search(int[][] goal, Label labelSearched)
   *  @param  goal  what to search for
   *  @param  queue which states to start with
   *  @return the trace of steps towards the solution (also stored in "solution").
   */
  public Vector search(int[][] goal, Vector queue) {
    while (!queue.isEmpty()) {                    // if queue is empty, all options are exhausted
      evalCount++;                                // keep track of how many states we've looked at
      if (evalCount>100000)                       // too many evaluations are required...
        return null;                              // abort!
      PuzzleState head=(PuzzleState)queue.firstElement(); // first state in queue...
      if (head.goal(goal))                        // ...was a success!
        return (solution=head.history);           //    hence return it's trace

      if (label!=null && evalCount%100==0) {      // update search status
        label.setText("#states:"+evalCount+" level:"+head.history.size());
      }
      PuzzleState[] newNodes=head.expandState();  // expand the current state
      queue.removeElementAt(0);                   // remove the expanded state
      // below: breadth-first strategy (new states are put at the end of the queue).
      for (int n=0; n<newNodes.length; n++) {
        queue.add(newNodes[n]);                   // adds one node at a time
      }
    }
    return null;                                  // failure!
  }

  /** shuffle the board
   *  @param  seed  seeding the randomizer
   *  @param  nStep number of attempted random moves
   */
  public void randomize(int seed, int nStep) {
    Random rand=new Random(seed);
    for (int i=0; i<nStep; i++) {
      int move=rand.nextInt(state.directions.length); // choose one randomly
      PuzzleState tmp=state.nextState(state.directions[move]);
      while (tmp==null) { // illegal move
        move=rand.nextInt(state.directions.length); // choose one randomly
        tmp=state.nextState(state.directions[move]);
      }
      state=tmp;
    }
  }

  /** init engine using start state
   *
   */
  public PuzzleEngine(int[][] start) {
    state=new PuzzleState(start);
  }
}