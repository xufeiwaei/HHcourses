package nn;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.io.*;

/**
 * Title:        Digits
 * Description:  Digit recognition using neural networks
 * Copyright:    Copyright (c) 2001
 * Company:
 * @author Mikael Bodén
 * @version 1.0
 */

public class DigitsFrame extends JFrame {
  JPanel contentPane;
  JMenuBar jMenuBar = new JMenuBar();
  JMenu jMenuFile = new JMenu();
  JMenuItem jMenuFileExit = new JMenuItem();
  BorderLayout borderLayout1 = new BorderLayout();
  DigitPanel drawPanel = new DigitPanel(32,32);
  JPanel interactPanel = new JPanel();
  JButton clearButton = new JButton();
  JButton classifyButton = new JButton();
  FlowLayout flowLayout1 = new FlowLayout();
  JTextField classTextField = new JTextField();
  Classifier classifier=new Classifier();
  JMenuItem jMenuLoad = new JMenuItem();
  JMenuItem jMenuSave = new JMenuItem();
  JSlider thicknessSlider = new JSlider();
  JLabel thicknessLabel = new JLabel();

  /**Construct the frame*/
  public DigitsFrame() {
    enableEvents(AWTEvent.WINDOW_EVENT_MASK);
    try {
      jbInit();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  /**Component initialization*/
  private void jbInit() throws Exception  {
    //setIconImage(Toolkit.getDefaultToolkit().createImage(DigitsFrame.class.getResource("[Your Icon]")));
    contentPane = (JPanel) this.getContentPane();
    contentPane.setLayout(borderLayout1);
    this.setSize(new Dimension(380, 380));
    this.setTitle("Digit Recognition");
    jMenuFile.setText("File");
    jMenuFileExit.setText("Exit");
    jMenuFileExit.addActionListener(new ActionListener()  {
      public void actionPerformed(ActionEvent e) {
        jMenuFileExit_actionPerformed(e);
      }
    });
    clearButton.setText("Clear");
    clearButton.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        clearButton_actionPerformed(e);
      }
    });
    classifyButton.setText("Classify");
    classifyButton.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        classifyButton_actionPerformed(e);
      }
    });
    interactPanel.setLayout(flowLayout1);
    drawPanel.setBackground(Color.white);
    drawPanel.addMouseListener(new java.awt.event.MouseAdapter() {
      public void mouseClicked(MouseEvent e) {
        drawPanel_mouseClicked(e);
      }
    });
    drawPanel.addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
      public void mouseDragged(MouseEvent e) {
        drawPanel_mouseDragged(e);
      }
    });
    classTextField.setBackground(Color.lightGray);
    classTextField.setBorder(null);
    classTextField.setPreferredSize(new Dimension(20, 17));
    classTextField.setDisabledTextColor(Color.lightGray);
    classTextField.setEditable(false);
    classTextField.setHorizontalAlignment(SwingConstants.CENTER);
    classTextField.setText("?");
    interactPanel.setBackground(Color.lightGray);
    jMenuLoad.setText("Load");
    jMenuLoad.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        jMenuLoad_actionPerformed(e);
      }
    });
    jMenuSave.setText("Save");
    jMenuSave.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        jMenuSave_actionPerformed(e);
      }
    });
    thicknessSlider.setPaintLabels(true);
    thicknessSlider.setMinimum(1);
    thicknessSlider.setValue(4);
    thicknessSlider.setPaintTicks(true);
    thicknessSlider.setMaximum(10);
    thicknessSlider.setSnapToTicks(true);
    thicknessSlider.setPreferredSize(new Dimension(100, 32));
    thicknessSlider.setToolTipText("Brush thickness");
    thicknessSlider.setBackground(Color.lightGray);
    thicknessLabel.setHorizontalAlignment(SwingConstants.RIGHT);
    thicknessLabel.setText("Thickness");
    jMenuFile.add(jMenuLoad);
    jMenuFile.add(jMenuSave);
    jMenuFile.add(jMenuFileExit);
    jMenuBar.add(jMenuFile);
    contentPane.add(drawPanel, BorderLayout.CENTER);
    contentPane.add(interactPanel, BorderLayout.SOUTH);
    interactPanel.add(thicknessLabel, null);
    interactPanel.add(thicknessSlider, null);
    interactPanel.add(clearButton, null);
    interactPanel.add(classifyButton, null);
    interactPanel.add(classTextField, null);
    this.setJMenuBar(jMenuBar);
  }
  /**File | Exit action performed*/
  public void jMenuFileExit_actionPerformed(ActionEvent e) {
    System.exit(0);
  }
  /**Help | About action performed*/
  /**Overridden so we can exit when window is closed*/
  protected void processWindowEvent(WindowEvent e) {
    super.processWindowEvent(e);
    if (e.getID() == WindowEvent.WINDOW_CLOSING) {
      jMenuFileExit_actionPerformed(null);
    }
  }

  void drawPanel_mouseDragged(MouseEvent e) {
    drawPanel.brush(e.getX(),e.getY(),thicknessSlider.getValue());
  }

  void drawPanel_mouseClicked(MouseEvent e) {
    drawPanel.brush(e.getX(),e.getY(),thicknessSlider.getValue());
  }

  void clearButton_actionPerformed(ActionEvent e) {
    drawPanel.clear();
    classTextField.setText("?");
  }

  void classifyButton_actionPerformed(ActionEvent e) {
    Integer myGuess=new Integer(classifier.classify(drawPanel.map));
    classTextField.setText(myGuess.toString());
  }

  void jMenuLoad_actionPerformed(ActionEvent e) {
    // load a file
    JFileChooser fc=new JFileChooser(".");
    fc.showOpenDialog(this);
    File f;
    FileInputStream stream;
    try {
      f=fc.getSelectedFile();
      stream=new FileInputStream(f);
      for (int x=0; x<drawPanel.map.length; x++) {
        for (int y=0; y<drawPanel.map[x].length; y++) {
          if (stream.read()==1)
            drawPanel.map[x][y]=true;
          else
            drawPanel.map[x][y]=false;
        }
      }
      stream.close();
    } catch(IOException exc) {
      System.out.println(exc.getMessage());
    }
    repaint();
  }

  void jMenuSave_actionPerformed(ActionEvent e) {
    // save the current digit
    JFileChooser fc=new JFileChooser(".");
    fc.showSaveDialog(this);
    File f;
    FileOutputStream stream;
    try {
      f=fc.getSelectedFile();
      stream=new FileOutputStream(f);
      for (int x=0; x<drawPanel.map.length; x++) {
        for (int y=0; y<drawPanel.map[x].length; y++) {
          if (drawPanel.map[x][y])
            stream.write(1);
          else
            stream.write(0);
        }
      }
      stream.close();
    } catch(IOException exc) {
      System.out.println(exc.getMessage());
    }
  }
}