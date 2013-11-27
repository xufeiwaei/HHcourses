package nn;
import file.TFile;

/**
 * Title:        Digits
 * Description:  Digit recognition using neural networks
 * Copyright:    Copyright (c) 2001-2002
 * Company:
 * @author Mikael Bodén
 * @version 1.0
 */

public class AppTrain {
  NN nn;            // the neural network
  TFile file;       // the example digits
  int nEpochs=500;   // the number of cycles through the training set
  double eta=0.1;   // a learning rate, determines magnitude of weight changes
  int seed=1;       // seed for randomizing initial network weights

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

  public AppTrain() {
    // create a new network of given size
    nn=new NN(32*32, 10, seed);

    // each row contains 32*32+1 integer
    // create the matrix holding the data
    // read data into the matrix
    file=new TFile("digits.dat");
    System.out.println(file.rows()+" digits have been loaded");

    double[] input=new double[32*32];
    double[] target=new double[10];

    // the training session (below) is iterative
    for (int e=0; e<nEpochs; e++) {
      // reset the error accumulated over each training epoch
      double err=0;
      // in each epoch, go through all examples/tuples/digits
      // note: all examples are here used for training, consequently no systematic testing
      // you may consider dividing the data set into training, testing and validation sets.
      for (int p=0; p<file.rows(); p++) {
        for (int i=0; i<32*32; i++)
          input[i]=file.values[p][i];
        // the last value on each row contains the target (0-9)
        // convert it to a double[] target vector
        for (int i=0; i<10; i++) {
          if (file.values[p][32*32]==i)
            target[i]=1;
          else
            target[i]=0;
        }
        // present a sample and
        // calculate errors and adjust weights
        err+=nn.train(input, target, eta);
      }
      System.out.println("Epoch "+e+" finished with error "+err/file.rows());
    }

    // save network weights in a file for later use, e.g. in AppDigits
    nn.save("network.m");
  }

  public static void main(String[] args) {
    AppTrain appTrain1 = new AppTrain();
  }
}