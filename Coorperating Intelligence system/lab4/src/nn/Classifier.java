package nn;

/**
 * Title:        Digits
 * Description:  Digit recognition using neural networks
 * Copyright:    Copyright (c) 2001-2002
 * Company:
 * @author Mikael Bodén
 * @version 1.0
 */

public class Classifier {
  NN nn; // the neural network

  public Classifier() {
    // initialize classifier, load NN
    nn=new NN("network.m");       // open the saved network weights
  }

  /** to8x8 converts an 32x32 bitmap to an 8x8 map
   *  @param  origInput the 32x32 bitmap vector
   *  @return double[] 8x8 vector (based on 32x32 vector)
   */
  private double[] to8x8(double[] origInput) {
    double[] newInput=new double[64];
    for (int r=0; r<8; r++) {
      for (int k=0; k<8; k++) {
        for (int rr=0; rr<4; rr++) {
          for (int kk=0; kk<4; kk++) {
            newInput[r*8+k]+=origInput[r*128+k*4+rr*32+kk];
          }
        }
        newInput[r*8+k]/=16.0;
      }
    }
    return newInput;
  }

  /** classify
   *  @param  map the bitmap on the screen
   *  @return int the most likely digit (0-9) according to network
   */
  public int classify(boolean[][] map) {
    double[] input=new double[32*32];
    for (int c=0; c<map.length; c++) {
      for (int r=0; r<map[c].length; r++) {
        if (map[c][r]) // bit set
          input[r*map[r].length+c]=1;
        else
          input[r*map[r].length+c]=0;
      }
    }
    // activate the network, produce output vector
    // double[] output=nn.feedforward(input);
    double[] output=nn.feedforward(to8x8(input));
    // alternative version assumes that the network has been trained on an 8x8 map
    // double[] output=nn.feedforward(to8x8(input));
    double highscore=0;
    int highscoreIndex=0;
    // print out each output value (gives an idea of the network's support for each digit).
    System.out.println("--------------");
    for (int k=0; k<10; k++) {
      System.out.println(k+":"+(double)((int)(output[k]*1000)/1000.0));
      if (output[k]>highscore) {
        highscore=output[k];
        highscoreIndex=k;
      }
    }
    System.out.println("--------------");
    return highscoreIndex;
  }
}
