package nn;

/**
 * <p>Title: Simple neural network</p>
 * <p>Description: A basic implementation of a feedforward neural network and backpropagation learning</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author Mikael Bodén
 * @version 1.0
 */

/** ToDo:
 *  1. implement batched (epoch-based) weight update
 *  2. add "momentum" to weight adjustments
 *  3. enable more (or fewer) node layers.
 *  4. try alternative output functions (e.g. hyperbolic tangens, or softmax)
 *  5. try alternative error measures for gradient calculations (maximum likelihood)
 */

import java.util.*;

public class NN2 extends NeuralNetwork {
  double[] hiddenNode, outputNode;              // the values produced by each node (indices important, see weights/biases)
  public double[][] inputWeight, outputWeight;         // the trainable weight values [to node][from node]
  public double[] hiddenBias, outputBias;              // the trainable bias values for hidden and output node layers
  Random rand;                                  // a random number generator for initial weight values

  /** Constructs a neural network structure and initializes weights to small random values.
   *  @param  nInput  Number of input nodes
   *  @param  nHidden Number of hidden nodes
   *  @param  nOutput Number of output nodes
   *  @param  seed    Seed for the random number generator used for initial weights.
   *
   */
  public NN2(int nInput, int nHidden, int nOutput, int seed) {

    // allocate space for node and weight values
    hiddenNode=new double[nHidden];
    outputNode=new double[nOutput];
    inputWeight=new double[nHidden][nInput];
    hiddenBias=new double[nHidden];
    outputWeight=new double[nOutput][nHidden];
    outputBias=new double[nOutput];

    // initialize weight and bias values
    rand=new Random(seed);
    for (int j=0; j<nHidden; j++) {
      for (int i=0; i<nInput; i++) {
        inputWeight[j][i]=rand.nextGaussian()*.1;
      }
      for (int k=0; k<nOutput; k++) {
        outputWeight[k][j]=rand.nextGaussian()*.1;
        if (j==0) outputBias[k]=rand.nextGaussian()*.1;
      }
      hiddenBias[j]=rand.nextGaussian()*.1;
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
   *  @param  inputNode  The vector of input values
   *  @return double[]    The vector of computed output values
   */
  public double[] feedforward(double[] inputNode) {
    // compute the activation of each hidden node (depends on supplied input values)
    for (int j=0; j<hiddenNode.length; j++) {
      double sum=0; // reset summed activation value
      for (int i=0; i<inputNode.length; i++)
        sum+=inputNode[i]*inputWeight[j][i];
      hiddenNode[j]=outputFunction(sum+hiddenBias[j]);
    }

    // compute the activation of each output node (depends on hidden node activations computed above)
    for (int k=0; k<outputNode.length; k++) {
      double sum=0; // reset summed activation value
      for (int j=0; j<hiddenNode.length; j++)
        sum+=hiddenNode[j]*outputWeight[k][j];
      outputNode[k]=outputFunction(sum+outputBias[k]);
    }
    return outputNode;
  }

  /** Adapts weights in the network given the specification of which values that should appear at the output (target)
   *  when the input has been presented.
   *  The procedure is known as error backpropagation. This implementation is "online" rather than "batched", that is,
   *  the change is not based on the gradient of the golbal error, merely the local -- pattern-specific -- error.
   *  @param  target  The desired output values.
   *  @param  eta     The learning rate, always between 0 and 1, typically a small value, e.g. 0.1
   *  @return double  An error value (the root-mean-squared-error).
   */
  public double train(double[] input, double[] target, double eta) {

    // present the input and calculate the outputs
    feedforward(input);

    // allocate space for errors of individual nodes
    double[] outputError=new double[outputNode.length];
    double[] hiddenError=new double[hiddenNode.length];

    // compute the error of output nodes (explicit target is available -- so quite simple)
    // also, calculate the root-mean-squared-error to indicate progress
    double rmse=0;
    for (int k=0; k<outputNode.length; k++) {
      double diff=target[k]-outputNode[k];
      outputError[k]=diff*outputFunctionDerivative(outputNode[k]);
      rmse+=diff*diff;
    }
    rmse=Math.sqrt(rmse/outputNode.length);

    // compute the error of hidden nodes (indirect contribution to error at output layer -- so a bit trickier -- depends on the output error)
    for (int j=0; j<hiddenNode.length; j++) {
      double errsum=0;  // sum of errors of nodes which this particular hidden contributes to (proportionally to the weight)...
      for (int k=0; k<outputNode.length; k++) {
        errsum+=outputError[k]*outputWeight[k][j];
      }
      hiddenError[j]=errsum*outputFunctionDerivative(hiddenNode[j]);
    }

    // change weights according to errors
    for (int k=0; k<outputNode.length; k++) {
      for (int j=0; j<hiddenNode.length; j++) {
        outputWeight[k][j]+=outputError[k]*hiddenNode[j]*eta;
      }
      outputBias[k]+=outputError[k]*1.0*eta; // bias can be understood as a weight from a node which is always 1.0.
    }
    for (int j=0; j<hiddenNode.length; j++) {
      for (int i=0; i<input.length; i++) {
        inputWeight[j][i]+=hiddenError[j]*input[i]*eta;
      }
      hiddenBias[j]+=hiddenError[j]*1.0*eta; // bias can be understood as a weight from a node which is always 1.0.
    }

    return rmse;
  }


}
