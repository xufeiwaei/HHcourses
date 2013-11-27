package fifteen;

import java.awt.*;
import java.awt.event.*;
import java.applet.*;

/**
 * <p>Title: 15-puzzle</p>
 * <p>Description: Game for studying search techniques</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author Mikael Bodén
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
    buttonSolve.setLabel("Solve");
    buttonStep.setEnabled(false);
    buttonStep.setLabel("Step");
    labelSearched.setText("#states:<> level:<>");
    panelControl.setLayout(borderLayout3);
    panelSolve.add(labelSearched, BorderLayout.CENTER);
    this.add(panelControl, BorderLayout.EAST);
    panelControl.add(buttonStep, BorderLayout.CENTER);
    panelControl.add(buttonSolve, BorderLayout.SOUTH);
    panelControl.add(buttonShuffle, BorderLayout.NORTH);
    this.add(panelSolve, BorderLayout.SOUTH);
    this.add(panelGame, BorderLayout.CENTER);
    buttonShuffle.addActionListener(new ActionListener() {
                                      public void actionPerformed(ActionEvent e) {
                                        panelGame.shuffle(shuffleSeed++, shuffleSteps);
                                      }}
                                  );
    buttonSolve.addActionListener(new ActionListener() {
                                      public void actionPerformed(ActionEvent e) {
                                        buttonSolve.setEnabled(false);
                                        int nStep=panelGame.solve(labelSearched);
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