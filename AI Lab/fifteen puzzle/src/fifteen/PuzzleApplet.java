package fifteen;

import java.awt.*;
import java.awt.event.*;
import java.applet.*;

/**
 * <p>Title: 15-puzzle</p>
 * <p>Description: Game for studying search techniques</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author Mikael Bod
 * @version 1.0
 */

public class PuzzleApplet extends Applet {
	  int shuffleSeed=0;    // the seed to use for randomizing shuffle
	  int shuffleSteps=10;  // how many attempted random moves in each shuffle
	  boolean isStandalone = false;
	  Panel panelSolve = new Panel();
	  BorderLayout borderLayout1 = new BorderLayout();
	  Button buttonShuffle = new Button();
	  Button buttonSolve = new Button();
	  PuzzlePanel panelGame = new PuzzlePanel();
	  Panel panelControl = new Panel();
	  Button buttonStep = new Button();
	  Label labelSearched = new Label();
	  BorderLayout borderLayout3 = new BorderLayout();
	  BorderLayout borderLayout2 = new BorderLayout();
	  
	  Button buttonH1 = new Button();
	  Button buttonH2 = new Button();
	  Button buttonH3 = new Button();
	  
	  String stringtable = new String("BFS\nDisplaceNumber\nManhattanDistance\nDepthfirst\n");
	  TextArea text1 = new TextArea (20,30); 
	  Button butontable = new Button("Input in the Table");
	  Panel panelSolve2 = new Panel();
	  BorderLayout borderLayout4 = new BorderLayout();
	  
	  //Get a parameter value
	  public String getParameter(String key, String def) {
	    return isStandalone ? System.getProperty(key, def) :
	      (getParameter(key) != null ? getParameter(key) : def);
	  }

	  //Construct the applet
	  public PuzzleApplet() {

	  }

	  //Initialize the applet
	  public void init() {

	    try {
	      jbInit();
	    }
	    catch(Exception e) {
	      e.printStackTrace();
	    }
	  }

	  //Component initialization
	  private void jbInit() throws Exception {
	    this.setLayout(borderLayout1);
	    panelSolve.setLayout(borderLayout2);
	    buttonShuffle.setLabel("Shuffle");
	    buttonSolve.setLabel("BFS");
	    buttonH1.setLabel("DisplaceNumber");
	    buttonH2.setLabel("ManhattanDistance");
	    buttonH3.setLabel("DFS");
	    panelSolve2.setLayout(borderLayout4);
	    text1.setText(stringtable);
	    panelSolve2.add(text1,BorderLayout.CENTER);
	    panelSolve2.add(butontable, BorderLayout.SOUTH);

	    
	    buttonStep.setEnabled(false);
	    buttonStep.setLabel("Step");
	    labelSearched.setText("#states:<> level:<>");
		 
	   // panelControl.setLayout(borderLayout3);
	    panelSolve.add(labelSearched, BorderLayout.CENTER);
		 
		panelControl.setLayout(new GridLayout(5, 1, 10, 20));
	    panelControl.add(buttonStep);    
	    panelControl.add(buttonH1);
	    panelControl.add(buttonSolve);
	    panelControl.add(buttonH2);  
	    panelControl.add(buttonH3); 
	    panelControl.add(buttonShuffle);

		 
	    this.add(panelSolve2, BorderLayout.WEST);
	    this.add(panelSolve, BorderLayout.SOUTH);
	    this.add(panelGame, BorderLayout.CENTER);
	    this.add(panelControl, BorderLayout.EAST); 
	    
	    buttonShuffle.addActionListener(new ActionListener() {
	                                      public void actionPerformed(ActionEvent e) {
	                                        panelGame.shuffle(shuffleSeed++, shuffleSteps);
	                                      }}
	                                  );
	    buttonSolve.addActionListener(new ActionListener() {
	                                      public void actionPerformed(ActionEvent e) {
	                                        buttonSolve.setEnabled(false);
	                                        int nStep=panelGame.solve(labelSearched, (Button) e.getSource());
	                                        if (nStep>0)
	                                          buttonStep.setEnabled(true);
	                                        buttonSolve.setEnabled(true);
	                                      }}
	                                  );
	    buttonStep.addActionListener(new ActionListener() {
	                                      public void actionPerformed(ActionEvent e) {
	                                        int nStep=panelGame.step();
	                                        if (nStep==0)
	                                          buttonStep.setEnabled(false);
	                                      }}
	                                  );
	    buttonH1.addActionListener(new ActionListener() {
	        						public void actionPerformed(ActionEvent e) {
	        							buttonH1.setEnabled(false);
	        							int nStep=panelGame.solve(labelSearched,(Button) e.getSource());
	        							if (nStep>0)
	        								buttonStep.setEnabled(true);
	        							buttonH1.setEnabled(true);
	        						}}
	    						   );
	    buttonH2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				buttonH2.setEnabled(false);
				int nStep=panelGame.solve(labelSearched,(Button) e.getSource());
				if (nStep>0)
					buttonStep.setEnabled(true);
				buttonH2.setEnabled(true);
			}}
		   	);
	    buttonH3.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				buttonH3.setEnabled(false);
				int nStep=panelGame.solve(labelSearched,(Button) e.getSource());
				if (nStep>0)
					buttonStep.setEnabled(true);
				buttonH3.setEnabled(true);
			}}
		   	);
	    butontable.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String newstring= panelGame.solveForTable(labelSearched,(Button) e.getSource());
				stringtable += newstring +"\n";
			    text1.setText(stringtable);
				repaint();
			}}
		   	);
	    
	  }
  //Start the applet
  public void start() {
	  
  }

  //Stop the applet
  public void stop() {
	  
  }

  //Destroy the applet
  public void destroy() {
  }

  //Get Applet information
  public String getAppletInfo() {
    return "Applet Information";
  }

  //Get parameter info
  public String[][] getParameterInfo() {
    return null;
  }
}