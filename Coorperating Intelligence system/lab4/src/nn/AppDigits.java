package nn;

import javax.swing.UIManager;
import java.awt.*;

/**
 * Title:        Digits
 * Description:  Digit recognition using neural networks
 * Copyright:    Copyright (c) 2001
 * Company:
 * @author Mikael Bodén
 * @version 1.0
 */

public class AppDigits {
  /**Construct the application*/
  public AppDigits() {
    DigitsFrame frame = new DigitsFrame();
    frame.validate();
    //Center the window
    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    Dimension frameSize = frame.getSize();
    if (frameSize.height > screenSize.height) {
      frameSize.height = screenSize.height;
    }
    if (frameSize.width > screenSize.width) {
      frameSize.width = screenSize.width;
    }
    frame.setLocation((screenSize.width - frameSize.width) / 2, (screenSize.height - frameSize.height) / 2);
    frame.setVisible(true);
  }
  /**Main method*/
  public static void main(String[] args) {
    new AppDigits();
  }
}