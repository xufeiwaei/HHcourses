package nn;
import file.TFile;
import java.util.*;

/**
 * Title:        Digits
 * Description:  Digit recognition using neural networks
 * Copyright:    Copyright (c) 2001-2002
 * Company:
 * @author Mikael Bodén
 * @version 1.0
 */

public class AppTrain {
  NeuralNetwork nn;            // the neural network
  TFile file;       // the example digits
  int nEpochs=30;   // the number of cycles through the training set
  double eta=0.1;   // a learning rate, determines magnitude of weight changes
  int seed=1;       // seed for randomizing initial network weights
  double err;

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

  public void train(int epoch) {
	  nEpochs = epoch;
	  // create a new network of given size
	  // nn=new NN(32*32, 10, seed);
	  nn=new NN2(32*32, 10, 10, seed);

	  double[] input=new double[32*32];
	  double[] target=new double[10];

	  List<List<Integer>> distribution = new ArrayList<List<Integer>>(10);
	  for(int i=0; i<10; ++i) {
		  distribution.add(i, new ArrayList<Integer>());
	  }

	  for(int r=0; r<file.rows(); ++r) {
		  distribution.get((int)file.values[r][32*32]).add(r);
	  }

	  /*
	  for(int i=0; i<distribution.size(); ++i) {
		  System.out.println("Number of data for " + i + " is " + distribution.get(i).size());
	  }
	  */

	  // the training session (below) is iterative
	  for (int e=0; e<nEpochs; e++) {
		  // reset the error accumulated over each training epoch
		  err=0;
		  // in each epoch, go through all examples/tuples/digits
		  // note: all examples are here used for training, consequently no systematic testing
		  // you may consider dividing the data set into training, testing and validation sets.
		  /*
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
		  err+=nn.train(to8x8(input), target, eta);
			 }
			 */
		  // training with half of the data
		  for(int i=0; i<distribution.size(); ++i) {
			  List<Integer> list = distribution.get(i);
			  for(int j=0; j<list.size()/2; ++j) {
				  for(int k=0; k<32*32; ++k) {
					  input[k] = file.values[list.get(j)][k];
				  }
				  // reset
				  for(int k=0; k<10; ++k) {
					  target[k] = 0;
				  }
				  target[i] = 1;
				  err+=nn.train(to8x8(input), target, eta);
			  }
		  }
		  // System.out.println("Epoch "+e+" finished with error "+err/file.rows());
	  }
	  System.out.println("Finish training with error " + err*2/file.rows());
	  // Begin testing
	  int correctTest = 0;
	  for(int i=0; i<distribution.size(); ++i) {
		  List<Integer> list = distribution.get(i);
			  // for(int j=0; j<list.size()/2; ++j) {
		  for(int j=list.size()/2; j<list.size(); ++j) {
			  for(int k=0; k<32*32; ++k) {
				  input[k] = file.values[list.get(j)][k];
			  }
			 // System.out.println("answer is " + file.values[list.get(j)][32*32]);
			  double[] temp = nn.feedforward(to8x8(input));
			  int maxIndex = 0;
			  double maxValue = temp[0];
			  for(int k=1; k<temp.length; ++k) {
				  if(temp[k] > maxValue) {
					  maxValue = temp[k];
					  maxIndex = k;
				  }
			  }
			 //System.out.println("answer is " + maxIndex);
			  if(i == maxIndex) {
				  correctTest++;
			  }
		  }
	  }
	  System.out.println("Correct test is " + correctTest);
	  System.out.println("Correct rate is " + (double)correctTest*2/file.rows());

	  // save network weights in a file for later use, e.g. in AppDigits
	  nn.save("network.m");
  }

  public void trainingWithoutPreprocessing(int epoch) {
	  nEpochs = epoch;
	  // create a new network of given size
	  nn=new NN(32*32, 10, seed);

	  double[] input=new double[32*32];
	  double[] target=new double[10];

	  List<List<Integer>> distribution = new ArrayList<List<Integer>>(10);
	  for(int i=0; i<10; ++i) {
		  distribution.add(i, new ArrayList<Integer>());
	  }

	  for(int r=0; r<file.rows(); ++r) {
		  distribution.get((int)file.values[r][32*32]).add(r);
	  }

	  /*
	  for(int i=0; i<distribution.size(); ++i) {
		  System.out.println("Number of data for " + i + " is " + distribution.get(i).size());
	  }
	  */

	  // the training session (below) is iterative
	  for (int e=0; e<nEpochs; e++) {
		  // reset the error accumulated over each training epoch
		  err=0;
		  // in each epoch, go through all examples/tuples/digits
		  // note: all examples are here used for training, consequently no systematic testing
		  // you may consider dividing the data set into training, testing and validation sets.
		  /*
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
		  err+=nn.train(to8x8(input), target, eta);
			 }
			 */
		  // training with half of the data
		  for(int i=0; i<distribution.size(); ++i) {
			  List<Integer> list = distribution.get(i);
			  for(int j=0; j<list.size()/2; ++j) {
				  for(int k=0; k<32*32; ++k) {
					  input[k] = file.values[list.get(j)][k];
				  }
				  // reset
				  for(int k=0; k<10; ++k) {
					  target[k] = 0;
				  }
				  target[i] = 1;
				  err+=nn.train(input, target, eta);
			  }
		  }
		  // System.out.println("Epoch "+e+" finished with error "+err/file.rows());
	  }
	  System.out.println("Finish training with error " + err*2/file.rows());
	  // Begin testing
	  int correctTest = 0;
	  for(int i=0; i<distribution.size(); ++i) {
		  List<Integer> list = distribution.get(i);
			  // for(int j=0; j<list.size()/2; ++j) {
		  for(int j=list.size()/2; j<list.size(); ++j) {
			  for(int k=0; k<32*32; ++k) {
				  input[k] = file.values[list.get(j)][k];
			  }
			 // System.out.println("answer is " + file.values[list.get(j)][32*32]);
			  double[] temp = nn.feedforward(input);
			  int maxIndex = 0;
			  double maxValue = temp[0];
			  for(int k=1; k<temp.length; ++k) {
				  if(temp[k] > maxValue) {
					  maxValue = temp[k];
					  maxIndex = k;
				  }
			  }
			 //System.out.println("answer is " + maxIndex);
			  if(i == maxIndex) {
				  correctTest++;
			  }
		  }
	  }
	  System.out.println("Correct test is " + correctTest);
	  System.out.println("Correct rate is " + (double)correctTest*2/file.rows());

	  // save network weights in a file for later use, e.g. in AppDigits
	  nn.save("network.m");
  }

  public AppTrain() {
	  // each row contains 32*32+1 integer
	  // create the matrix holding the data
	  // read data into the matrix
	  file=new TFile("digits.dat");
	  System.out.println(file.rows()+" digits have been loaded");
  }

  public static void main(String[] args) {
    AppTrain appTrain1 = new AppTrain();
	/*
	for(int i=0; i<10; ++i) {
	  System.out.println("Epoch is " + (i*10 + 10));
		appTrain1.train(i*10 + 10);
	}
	*/
	/*
	for(int i=1; i<=10; ++i) {
		appTrain1.eta = 0.1/i;
		System.out.println("Learning rate is " + appTrain1.eta);
		appTrain1.train(300);
	}
	*/
	appTrain1.eta = 0.01429;
	appTrain1.train(20);
	appTrain1.trainingWithoutPreprocessing(20);

  }
}
