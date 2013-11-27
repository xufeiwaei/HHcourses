package fifteen;
import java.util.*;
import java.awt.*;

/**
 * <p>Title: 15-puzzle</p>
 * <p>Description: Game for studying search techniques</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.9
 */

/** The PuzzleEngine class manages the search process.
 *  It has a current "state".
 *  If a search has been completed and there is a solution, it knows it and how to approach a goal state.
 *
 */
public class PuzzleEngine {

  PuzzleState state;        // the current state
  public int evalCount=0;   // the number of nodes searched, re-initial when search is re-started
  Vector solution=null;     // the steps to a goal state (in temporal order)
  public int[][] initial;
  public int[][] destination;

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
    Vector open=new Vector();
    Vector close=new Vector();
    state.clear();
    state.hn=state.getManhattan(goal, state.state);
    state.fn=state.gn+state.hn;
    open.add(state);
    return search(goal, open,close);
  }
  public Vector searchwithdisplace(int[][] goal, Label labelSearched) {
	    evalCount=0;
	    solution=null;
	    label=labelSearched;
	    Vector open=new Vector();
	    Vector close=new Vector();
	    state.clear();
	    state.hn=state.getnomissgoal(goal, state.state);
	    state.fn=state.gn+state.hn;
	    open.add(state);
	    return searchwithdisplace(goal, open,close);
	  }
  public Vector searchwithManhattan(int[][] goal, Label labelSearched) {
	    evalCount=0;
	    solution=null;
	    label=labelSearched;
	    Vector open=new Vector();
	    Vector close=new Vector();
	    state.clear();
	    state.hn=state.getManhattan(goal, state.state);
	    state.fn=state.gn+state.hn;
	    open.add(state);
	    return searchwithManhattan(goal, open,close);
	  }
  public Vector searchwithDFS(int[][] goal, Label labelSearched) {
	    evalCount=0;
	    solution=null;
	    label=labelSearched;
	    Vector open=new Vector();
	    Vector close=new Vector();
	    state.clear();
	    open.add(state);
	    return searchwithDepthfirst(goal, open,close);
	  }
  /** start search with a initialized queue,
   *  @see search(int[][] goal, Label labelSearched)
   *  @param  goal  what to search for
   *  @param  queue which states to start with
   *  @return the trace of steps towards the solution (also stored in "solution").
   */
  public Vector search(int[][] goal, Vector open, Vector close) {
	  PuzzleState inimap=(PuzzleState)open.firstElement();
	  initial=inimap.state;                       // save the initial state before move
	  while (!open.isEmpty()) {                   // if queue is empty, all options are exhausted
      evalCount++;                                // keep track of how many states we've looked at
      if (evalCount>100000)                       // too many evaluations are required...
        return null;                              // abort!
      PuzzleState head=(PuzzleState)open.firstElement(); // first state in queue...
      if (head.goal(goal))                        // ...was a success!
        return (solution=head.history);           //    hence return it's trace

      if (label!=null && evalCount%100==0) {      // update search status
        label.setText("#states:"+evalCount+" level:"+head.history.size());
      }
      PuzzleState[] newNodes=head.expandState();  // expand the current state
      open.removeElementAt(0);                   // remove the expanded state
      // below: breadth-first strategy (new states are put at the end of the queue).
      for (int n=0; n<newNodes.length; n++) {
        open.add(newNodes[n]);                   // adds one node at a time
      }
    }
    return null;                                  // failure!
  } 
  public Vector searchwithdisplace(int[][] goal, Vector open, Vector close) {
	  PuzzleState inimap=(PuzzleState)open.firstElement();
	  initial=inimap.state;                       // save the initial state before move
	  while (!open.isEmpty()) {                   // if queue is empty, all options are exhausted
      //sort open
      /*for (int j= 1; j<open.size(); j++) {
        	PuzzleState temp2=(PuzzleState)open.firstElement();
          	PuzzleState temp1=(PuzzleState)open.elementAt(j);
            if(temp1.hn<=temp2.hn)
            {
            	open.setElementAt(temp1,0);           	
            	open.setElementAt(temp2,j);
            }        
          }
      for (int i= 1; i<open.size(); i++) {
      	    PuzzleState temp3=(PuzzleState)open.elementAt(0);
        	PuzzleState temp4=(PuzzleState)open.elementAt(i);
            if(temp3.hn==temp4.hn && temp4.fn <= temp3.fn)
            {
          	  open.setElementAt(temp4,0);           	
          	  open.setElementAt(temp3,i);
            }        
          }*/
      for (int i= 1; i<open.size(); i++) {
    	PuzzleState temp5=(PuzzleState)open.elementAt(0);
      	PuzzleState temp6=(PuzzleState)open.elementAt(i);
        if(temp6.fn<=temp5.fn)
        {
        	open.setElementAt(temp6,0);           	
        	open.setElementAt(temp5,i);
        }        
      }
      for (int j= 1; j<open.size(); j++) {
    	PuzzleState temp7=(PuzzleState)open.elementAt(0);
      	PuzzleState temp8=(PuzzleState)open.elementAt(j);
        if(temp7.fn==temp8.fn&&temp8.hn<temp7.hn)
        {
        	open.setElementAt(temp8,0);           	
        	open.setElementAt(temp7,j);
        }        
      }
      //to determine the head node whether have been extended 
      /*for(int i=0; i<close.size(); i++)
      {
    	  PuzzleState headbool=(PuzzleState)open.firstElement();
    	  PuzzleState temphead=(PuzzleState)close.elementAt(i);
    	  if(test(temphead.state,headbool.state) && i!=0)
    	  {
    		  open.removeElementAt(0);
    		  i=1;
    	  }
      }*/
      PuzzleState head=(PuzzleState)open.firstElement(); // first state in queue...
      close.add(head);
      destination=goal;      
      if (head.goal(goal))                        // ...was a success!
        return (solution=head.history);           //    hence return it's trace
      int expandlength=head.expandStateWithH1(goal).length;
      Vector newNodes=new Vector();               // expand the current state
      for (int i=0; i<expandlength; i++)
      {
    	  newNodes.add(head.expandStateWithH1(goal)[i]);
      }
      open.removeElementAt(0);// remove the expanded state  
      //to determine the head node whether have been extended 
      //for(int j=0; j<close.size(); j++)
      for(int i=0; i<newNodes.size(); i++)   	  
      {
    	  PuzzleState headbool=(PuzzleState)newNodes.elementAt(i);
    	  //PuzzleState temphead=(PuzzleState)close.elementAt(j);
    	  if(/*test(temphead.state,headbool.state)*/close.contains(headbool))
    	  {
    		  newNodes.removeElementAt(i);
    		  i=0;
    	  }
      }
      for(int j=0; j<open.size(); j++)
          for(int i=0; i<newNodes.size(); i++)   	  
          {
        	  PuzzleState headbool=(PuzzleState)newNodes.elementAt(i);
        	  PuzzleState temphead=(PuzzleState)open.elementAt(j);
        	  if(test(temphead.state,headbool.state))
        	  {
        		  newNodes.removeElementAt(i);
        		  i=0;
        	  }
          }
      for (int n=0; n<newNodes.size(); n++) {
        open.add(newNodes.elementAt(n));                   // adds one node at a time
      }
      if(newNodes.size()>0)
      evalCount++;                                // keep track of how many states we've looked at
      if (evalCount>100000)                       // too many evaluations are required...
        return null;                              // abort!
      if (label!=null && evalCount%100==0) {      // update search status
          label.setText("#states:"+evalCount+" level:"+head.history.size());
        }
    }
    return null;                                 // failure!
  } 
  public Vector searchwithManhattan(int[][] goal, Vector open, Vector close) {
	  PuzzleState inimap=(PuzzleState)open.firstElement();
	  initial=inimap.state;                       // save the initial state before move
	  while (!open.isEmpty()) {                   // if queue is empty, all options are exhausted
      //sort open
      /*for (int j= 1; j<open.size(); j++) {
        	PuzzleState temp2=(PuzzleState)open.firstElement();
          	PuzzleState temp1=(PuzzleState)open.elementAt(j);
            if(temp1.hn<=temp2.hn)
            {
            	open.setElementAt(temp1,0);           	
            	open.setElementAt(temp2,j);
            }        
          }
      for (int i= 1; i<open.size(); i++) {
      	    PuzzleState temp3=(PuzzleState)open.elementAt(0);
        	PuzzleState temp4=(PuzzleState)open.elementAt(i);
            if(temp3.hn==temp4.hn && temp4.fn <= temp3.fn)
            {
          	  open.setElementAt(temp4,0);           	
          	  open.setElementAt(temp3,i);
            }        
          }*/
      for (int i= 1; i<open.size(); i++) {
    	PuzzleState temp5=(PuzzleState)open.elementAt(0);
      	PuzzleState temp6=(PuzzleState)open.elementAt(i);
        if(temp6.fn<=temp5.fn)
        {
        	open.setElementAt(temp6,0);           	
        	open.setElementAt(temp5,i);
        }        
      }
      for (int j= 1; j<open.size(); j++) {
    	PuzzleState temp7=(PuzzleState)open.elementAt(0);
      	PuzzleState temp8=(PuzzleState)open.elementAt(j);
        if(temp7.fn==temp8.fn&&temp8.hn<temp7.hn)
        {
        	open.setElementAt(temp8,0);           	
        	open.setElementAt(temp7,j);
        }        
      }
      //to determine the head node whether have been extended 
      /*for(int i=0; i<close.size(); i++)
      {
    	  PuzzleState headbool=(PuzzleState)open.firstElement();
    	  PuzzleState temphead=(PuzzleState)close.elementAt(i);
    	  if(test(temphead.state,headbool.state) && i!=0)
    	  {
    		  open.removeElementAt(0);
    		  i=1;
    	  }
      }*/
      PuzzleState head=(PuzzleState)open.firstElement(); // first state in queue...
      close.add(head);
      destination=goal;      
      if (head.goal(goal))                        // ...was a success!
        return (solution=head.history);           //    hence return it's trace
      int expandlength=head.expandStateWithH2(goal).length;
      Vector newNodes=new Vector();               // expand the current state
      for (int i=0; i<expandlength; i++)
      {
    	  newNodes.add(head.expandStateWithH2(goal)[i]);
      }
      open.removeElementAt(0);// remove the expanded state  
      //to determine the head node whether have been extended 
      for(int j=0; j<close.size(); j++)
      for(int i=0; i<newNodes.size(); i++)   	  
      {
    	  PuzzleState headbool=(PuzzleState)newNodes.elementAt(i);
    	  PuzzleState temphead=(PuzzleState)close.elementAt(j);
    	  if(test(temphead.state,headbool.state)/*close.contains(headbool)*/)
    	  {
    		  newNodes.removeElementAt(i);
    		  i=0;
    	  }
      }
      for(int j=0; j<open.size(); j++)
          for(int i=0; i<newNodes.size(); i++)   	  
          {
        	  PuzzleState headbool=(PuzzleState)newNodes.elementAt(i);
        	  PuzzleState temphead=(PuzzleState)open.elementAt(j);
        	  if(test(temphead.state,headbool.state)/*open.contains(headbool)*/)
        	  {
        		  newNodes.removeElementAt(i);
        		  i=0;
        	  }
          }
      for (int n=0; n<newNodes.size(); n++) {
        open.add(newNodes.elementAt(n));                   // adds one node at a time
      }
      if(newNodes.size()>0)
          evalCount++;                                // keep track of how many states we've looked at
          if (evalCount>100000)                       // too many evaluations are required...
            return null;                              // abort!
          if (label!=null && evalCount%100==0) {      // update search status
              label.setText("#states:"+evalCount+" level:"+head.history.size());
            }
    }
    return null;                                 // failure!
  } 
  public Vector searchwithDepthfirst(int[][] goal, Vector open, Vector close) {
	  PuzzleState inimap=(PuzzleState)open.firstElement();
	  initial=inimap.state;                       // save the initial state before move
	  int depth=15;                               // define the depth we can expand
	  while (!open.isEmpty()) {                   // if queue is empty, all options are exhausted
      PuzzleState head=(PuzzleState)open.firstElement(); // first state in queue...
      close.add(head);
      if (head.goal(goal))                        // ...was a success!
        return (solution=head.history);           //    hence return it's trace
      int expandlength=head.expandStateWithH3(goal).length;
      Vector newNodes=new Vector();               // expand the current state
      if (head.gn<depth)
      {for (int i=0; i<expandlength; i++)
    	  newNodes.add(head.expandStateWithH3(goal)[i]);
      }
      open.removeElementAt(0); 
      //to determine the head node whether have been extended 
      for(int j=0; j<close.size(); j++)
      for(int i=0; i<newNodes.size(); i++)   	  
      {
    	  PuzzleState headbool=(PuzzleState)newNodes.elementAt(i);
    	  PuzzleState temphead=(PuzzleState)close.elementAt(j);
    	  if(test(temphead.state,headbool.state))
    	  {
    		  newNodes.removeElementAt(i);
    		  i=0;
    	  }
      }
      /*for(int j=0; j<open.size(); j++)
          for(int i=0; i<newNodes.size(); i++)   	  
          {
        	  PuzzleState headbool=(PuzzleState)newNodes.elementAt(i);
        	  PuzzleState temphead=(PuzzleState)open.elementAt(j);
        	  if(test(temphead.state,headbool.state))
        	  {
        		  newNodes.removeElementAt(i);
        		  i=0;
        	  }
          }*/
      for (int n=0; n<newNodes.size(); n++) {
        open.add(n, newNodes.elementAt(n));      // adds one node at a time
      }
      if(newNodes.size()>0)
          evalCount++;                                // keep track of how many states we've looked at
          if (evalCount>100000)                       // too many evaluations are required...
            return null;                              // abort!
          if (label!=null && evalCount%100==0) {      // update search status
              label.setText("#states:"+evalCount+" level:"+head.history.size());
            }
    }
    return null;                                 // failure!
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
  //quick sort     
  /**   
   * 递归快速排序实现   
   * @param array 待排序数组   
   * @param low 低指针   
   * @param high 高指针   
   * @param c 比较器   
   */
 /* public void sort(Vector open, int low, int high) {     
      quickSort(open, low, high);     
  }       
  private void quickSort(Vector open, int low, int high) {        
      if (low < high) {     
          int pivot = partition(open, low, high);           
          quickSort(open, low, pivot - 1);     
          quickSort(open, pivot + 1, high);     
      }      
  }        
  private int partition(Vector open, int low, int high) {     
	  PuzzleState temp5=(PuzzleState)open.elementAt(low);     
      int border = low;         
      for (int i = low + 1; i <= high; i++) 
      {     
    	  PuzzleState temp6=(PuzzleState)open.elementAt(i);
    	  ++border;
    	  PuzzleState temp7=(PuzzleState)open.elementAt(border);
          if (temp6.fn<temp5.fn) 
          {     
              open.setElementAt(temp6, border);
              open.setElementAt(temp7, i);  
          }     
      }     
      PuzzleState temp8=(PuzzleState)open.elementAt(border);
	  PuzzleState temp9=(PuzzleState)open.elementAt(low);
	  open.setElementAt(temp8, low);
      open.setElementAt(temp9, border);   
      return border;     
  }*/
  public boolean test(int[][] a, int b[][]) {
	  int count = 0;
	  for(int i=0;i<=3;i++)
			{for(int j=0;j<=3;j++)
			{   
				if(a[i][j]!=b[i][j])
				{
					count++;
				}			        	
			} }
	  if (count==0)
	  return true;
	  else
		  return false;
	 }

}