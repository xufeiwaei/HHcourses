package nn;
import file.MFile;
import java.util.*;

/**
 * <p>Title: Simple single-layered neural network</p>
 * <p>Description: A basic implementation of a single-layered feedforward neural network and backpropagation learning</p>
 * @author Mikael Bodén
 * @version 1.0
 * You are granted to use and/or modify this code in whichever way you like.
 */

/** Here's a list of things one can do:
 *  1. implement batched (epoch-based) weight update
 *  2. add "momentum" to weight adjustments
 *  3. enable more node layers (hidden layers).
 *  4. try alternative output functions (e.g. hyperbolic tangens, or softmax)
 *  5. try alternative error measures for gradient calculations (maximum likelihood)
 *  6. after a hidden layer has been added, a simple recurrent network can be constructed (see Elman, 1990)
 */

public class NN extends NeuralNetwork {
  double[] y;             // the values produced by each node (indices important, see weights/biases)
  public double[][] w;    // the trainable weight values [to node][from input]
  public double[] bias;   // the trainable bias values for nodes
  Random rand;            // a random number generator for initial weight values

  /** Constructs a neural network structure and initializes weights to small random values.
   *  @param  nInput  Number of input nodes
   *  @param  nOutput Number of output nodes
   *  @param  seed    Seed for the random number generator used for initial weights.
   *
   */
  public NN(int nInput, int nOutput, int seed) {

    // allocate space for node and weight values
    y=new double[nOutput];
    w=new double[nOutput][nInput];
    bias=new double[nOutput];

    // initialize weight and bias values
    rand=new Random(seed);
    for (int j=0; j<nOutput; j++) {
      for (int i=0; i<nInput; i++) {
        w[j][i]=rand.nextGaussian()*.1;
      }
      bias[j]=rand.nextGaussian()*.1;
    }
  }

  /** Loads a neural network structure including weights.
   *  @param  filename  the file (matlab format) from which the network is loaded
   */
  public NN(String filename) {
    // load the file into the MFile structure
    try {
      MFile mf = new MFile(filename);
      mf.loadAll();
      // look for the matrices that make up the network, "w1"...
      int w1index = mf.getMatrixIndex("w1");
      Double[][] w1 = mf.getMatrix(w1index);
      // ... and "b1"...
      int b1index = mf.getMatrixIndex("b1");
      Double[][] b1 = mf.getMatrix(b1index);
      // initialize the network
      y = new double[b1.length];
      w = new double[w1.length][w1[0].length];
      bias = new double[b1.length];
      for (int j = 0; j < w.length; j++) {
        for (int i = 0; i < w[j].length; i++) {
          w[j][i] = w1[j][i].doubleValue();
        }
        bias[j] = b1[j][0].doubleValue();
      }
      // use the first bias as a seed in case a random number is needed later on
      rand = new Random( (long) bias[0]);
    } catch (Exception ex) {
      System.out.println("Error loading nn-file "+filename+": "+ex.getMessage());
    }

  }

  /** The so-called output function. Computes the output value of a node given the summed incoming activation.
   *  You can use anyone you like if it is differentiable.
   *  This one is called the logistic function (a sigmoid) and produces values bounded between 0 and 1.
   *  @param  net The summed incoming activation
   *  @return double
   */
  public double outputFunction(double net) {
    return 1.0/(1.0+Math.exp(-net));
  }

  /** The derivative of the output function.
   *  This one is the derivative of the logistic function which is efficiently computed with respect to the output value
   *  (if you prefer computing it wrt the net value you can do so but it requires more computing power.
   *  @param  x The value by which the gradient is determined.
   *  @return double  the gradient at x.
   */
  public double outputFunctionDerivative(double x) {
    return x*(1.0-x);
  }

  /** Computes the output values of the output nodes in the network given input values.
   *  @param  x  The input values.
   *  @return double[]    The vector of computed output values
   */
  public double[] feedforward(double[] x) {
    // compute the activation of each output node (depends on input values)
    for (int j=0; j<y.length; j++) {
      double sum=0; // reset summed activation value
      for (int i=0; i<x.length; i++)
        sum+=x[i]*w[j][i];
      y[j]=outputFunction(sum+bias[j]);
    }
    return y;
  }

  /** Adapts weights in the network given the specification of which values that should appear at the output (target)
   *  when the input has been presented.
   *  The procedure is known as error backpropagation. This implementation is "online" rather than "batched", that is,
   *  the change is not based on the gradient of the global error, merely the local -- pattern-specific -- error.
   *  @param  x  The input values.
   *  @param  d  The desired output values.
   *  @param  eta     The learning rate, always between 0 and 1, typically a small value, e.g. 0.1
   *  @return double  An error value (the root-mean-squared-error).
   */
  public double train(double[] x, double[] d, double eta) {

    // present the input and calculate the outputs
    feedforward(x);

    // allocate space for errors of individual nodes
    double[] error=new double[y.length];

    // compute the error of output nodes (explicit target is available -- so quite simple)
    // also, calculate the root-mean-squared-error to indicate progress
    double rmse=0;
    for (int j=0; j<y.length; j++) {
      double diff=d[j]-y[j];
      error[j]=diff*outputFunctionDerivative(y[j]);
      rmse+=diff*diff;
    }
    rmse=Math.sqrt(rmse/y.length);

    // change weights according to errors
    for (int j=0; j<y.length; j++) {
      for (int i=0; i<x.length; i++) {
        w[j][i]+=error[j]*x[i]*eta;
      }
      bias[j]+=error[j]*1.0*eta; // bias can be understood as a weight from a node which is always 1.0.
    }

    return rmse;
  }

  /** Saves the network into a matlab-file. Two matrices are used ("w1" and "b1" for
   * weights and biases), from which the network can be re-loaded using one of the constructors.
   * @param filename the file to which the network is saved
   */
  public void save(String filename) {
    // initialize the structure to be saved as a matlab-file
    MFile mf=new MFile();
    // add the weight matrix, call it "w1"
    mf.addMatrix("w1",w);
    // convert the biases to a matrix and add them to the MFile as "b1"
    double[][] b=new double[bias.length][1];
    for (int i=0; i<bias.length; i++)
      b[i][0]=bias[i];
    mf.addMatrix("b1",b);
    // chuck it on file
    try {
      mf.save(filename);
    } catch (Exception ex) {
      System.err.println("Error saving nn-file "+filename+": "+ex.getMessage());
    }
  }

}
