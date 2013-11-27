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
  public int gn=0;
  public int hn;
  public int fn=gn+hn;
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
      next=new PuzzleState(this, move);   // make a copy of the current tile configuration
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
  //calculate the hn of function number displace
  
  public int getnomissgoal (int[][] goal,int[][] state) {
	  int heuristic = 0;
	  for(int i=0;i<=3;i++)
			{for(int j=0;j<=3;j++)			  
				if(state[i][j]!=goal[i][j]&&state[i][j]!=15)				
				  heuristic++;
					}	  
	  return heuristic;
  }
  
  //calculate the hn of function Manhattan Distance
  public int getManhattan (int[][] goal,int[][] state) {
	  int heuristic = 0;
	  for(int i=0;i<=3;i++)
			{for(int j=0;j<=3;j++)
				{for(int g=0;g<=3;g++)
					{for(int k=0;k<=3;k++)
			{   
				if(state[i][j]==goal[g][k]&&state[i][j]!=0)
				{
					heuristic=heuristic+Math.abs(i-g)+Math.abs(j-k);
				}			        	
			} 
		    }
	            }
            }
	  return heuristic;
  }
//calculate the hn of imporved function Manhattan Distance
 /* public int getManhattan (int[][] goal,int[][] state) {
	  int heuristic = 0;
	  int heuristic1 = 0;
	  int heuristic2 = 0;
	  for(int i=0;i<=3;i++)
			for(int j=0;j<=3;j++)
				for(int g=0;g<=3;g++)
					for(int k=0;k<=3;k++)
			{   
				if((state[i][j]==goal[g][k]&&state[i][j]==0)||(state[i][j]==goal[g][k]&&state[i][j]==2)
				||(state[i][j]==goal[g][k]&&state[i][j]==14)||(state[i][j]==goal[g][k]&&state[i][j]==4)
				||(state[i][j]==goal[g][k]&&state[i][j]==12)||(state[i][j]==goal[g][k]&&state[i][j]==6)
				||(state[i][j]==goal[g][k]&&state[i][j]==10)||(state[i][j]==goal[g][k]&&state[i][j]==8))
					heuristic1=heuristic1+Math.abs(i-g)+Math.abs(j-k);
						        	
			}
	  for(int i=0;i<=3;i++)
			for(int j=0;j<=3;j++)
				for(int g=0;g<=3;g++)
					for(int k=0;k<=3;k++)
			{   
				if((state[i][j]==goal[g][k]&&state[i][j]==1)||(state[i][j]==goal[g][k]&&state[i][j]==9)
				||(state[i][j]==goal[g][k]&&state[i][j]==3)||(state[i][j]==goal[g][k]&&state[i][j]==11)
				||(state[i][j]==goal[g][k]&&state[i][j]==5)||(state[i][j]==goal[g][k]&&state[i][j]==13)
				||(state[i][j]==goal[g][k]&&state[i][j]==7)||(state[i][j]==goal[g][k]&&state[i][j]==15))
					heuristic2=heuristic2+Math.abs(i-g)+Math.abs(j-k);
						        	
			}
	  heuristic=Math.max(heuristic1, heuristic2);
	  return heuristic;
  }*/
        //expand the node with heuristic function that the number miss the goal
        public PuzzleState[] expandStateWithH1(int[][] goal) {
	    PuzzleState[] possible=new PuzzleState[directions.length];
	    int cnt=0; // no of possible moves
	    int cnt1=0;
	    for (int d=0; d<directions.length; d++)
	      if ((possible[d]=nextState(directions[d])) !=null)
	    	  	cnt++;	    		
	    PuzzleState[] expanded=new PuzzleState[cnt];
	    cnt=0;
	    //add all the possible nodes in the expanded[] and calculate the values of gn,fn,hn of every node
	    for (int d=0; d<directions.length; d++) {
	      if (possible[d]!=null)	        
	        {
	    	  expanded[cnt]=possible[d];	       
	          cnt++;
	        }
	    }          
	    for (int d1=0; d1<expanded.length; d1++)
	    {
              expanded[d1].gn=this.gn+1;
	          expanded[d1].hn=getnomissgoal(goal,expanded[d1].state);
	          expanded[d1].fn=expanded[d1].hn+expanded[d1].gn;
	    }
	    //
	    /*this.hn=getnomissgoal(goal, this.state);
	    for (int i=0; i<expanded.length; i++)
	    {
	    	if (expanded[i].hn<=this.hn)
	    		cnt1++;
	    }
	    PuzzleState[] expanded1=new PuzzleState[cnt1];
	    cnt1=0;
	    for (int i=0; i<expanded.length; i++)
	    {
	    	if (expanded[i].hn<=this.hn)
	    		{
	    		    expanded1[cnt1]=expanded[i];
	    		    cnt1++;
	    		}
	    }*/
	    return expanded;
	  }
        //expand the node with heuristic function that Manhattan Distance
        public PuzzleState[] expandStateWithH2(int[][] goal) {
	    PuzzleState[] possible=new PuzzleState[directions.length];
	    int cnt=0; // no of possible moves
	    int cnt2=0;
	    for (int d=0; d<directions.length; d++)
	      if ((possible[d]=nextState(directions[d])) !=null)
	    	  cnt++;
	    PuzzleState[] expanded=new PuzzleState[cnt];
	    cnt=0;
	    //add all the possible nodes in the expanded[] and calculate the values of gn,fn,hn of every node
	    for (int d=0; d<directions.length; d++) {
		      if (possible[d]!=null)	        
		        {
		    	  expanded[cnt]=possible[d];	       
		          cnt++;
		        }
		    }          
	    for (int d1=0; d1<expanded.length; d1++)
	    {
              expanded[d1].gn=this.gn+1;
	          expanded[d1].hn=getManhattan(goal,expanded[d1].state);
	          expanded[d1].fn=expanded[d1].hn+expanded[d1].gn;
	    }  
	    //judge the expanded
	    /*for (int i=0; i<expanded.length; i++)
	    {
	    	if (expanded[i].hn<=this.hn)
	    		cnt2++;
	    }
	    PuzzleState[] expanded1=new PuzzleState[cnt2];
	    cnt2=0;
	    for (int i=0; i<expanded.length; i++)
	    {
	    	if (expanded[i].hn<=this.hn)
	    		{
	    		    expanded1[cnt2]=expanded[i];
	    		    cnt2++;
	    		}
	    }*/
	    return expanded;
	  }  
        public PuzzleState[] expandStateWithH3(int[][] goal) {
    	    PuzzleState[] possible=new PuzzleState[directions.length];
    	    int cnt=0; // no of possible moves
    	    for (int d=0; d<directions.length; d++)
    	      if ((possible[d]=nextState(directions[d])) !=null)
    	    	  cnt++;
    	    PuzzleState[] expanded=new PuzzleState[cnt];
    	    cnt=0;
    	    //add all the possible nodes in the expanded[] and calculate the values of gn,fn,hn of every node
    	    for (int d=0; d<directions.length; d++) {
    		      if (possible[d]!=null)	        
    		        {
    		    	  expanded[cnt]=possible[d];	       
    		          cnt++;
    		        }
    		    }          
    	    for (int d1=0; d1<expanded.length; d1++)
    	    {
                  expanded[d1].gn=this.gn+1;
    	    }  
    	    //judge the expanded
    	    /*for (int i=0; i<expanded.length; i++)
    	    {
    	    	if (expanded[i].hn<=this.hn)
    	    		cnt2++;
    	    }
    	    PuzzleState[] expanded1=new PuzzleState[cnt2];
    	    cnt2=0;
    	    for (int i=0; i<expanded.length; i++)
    	    {
    	    	if (expanded[i].hn<=this.hn)
    	    		{
    	    		    expanded1[cnt2]=expanded[i];
    	    		    cnt2++;
    	    		}
    	    }*/
    	    return expanded;
    	  }  
}