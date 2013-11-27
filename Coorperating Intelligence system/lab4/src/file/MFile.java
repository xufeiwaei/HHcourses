package file;

/**
 * <p>Title: file</p>
 * <p>Description: File utilities</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author Mikael Bodén
 * @version 1.0
 */

import java.io.*;
import java.util.*;

/** Helpclass for writing and reading MatLab-like matrices to/from file.
    Specifies the syntax of the stored matrices/variables.
    Originates from the jnn package.
    */

class MFileTokenizer extends StreamTokenizer {
    /** Constructor which initializes the syntax for the MFile
        @param  reader  Reader file-handler
    */
    MFileTokenizer(Reader reader) {
	    super(reader);
    	eolIsSignificant(true);
    	lowerCaseMode(true);
    	parseNumbers();
    	commentChar('%');
    	wordChars('A','Z');
    	wordChars('a','z');
    	wordChars('0','9');
        wordChars('-','-');
        wordChars('+','+');
    	ordinaryChars('=','=');
    	ordinaryChars('[',']');
    	ordinaryChars(';',';');
    	ordinaryChars('\'','\'');
    	whitespaceChars(' ',' ');
    	whitespaceChars('\t','\t');
    }
}

/** Class for writing and reading MatLab-like matrices to/from file.
*/
public class MFile {
    Double[][][] matrix;
    String[] matrixNames;
    boolean[] matrixDouble;
    BufferedReader reader;
    MFileTokenizer mtoken;

    static int maxMatrixSize=300000; // max no of elements in a loadable matrix, to improve load performance...

    /** Creates an empty MFile structure.
    */
    public MFile() {
    	matrix=new Double[0][0][0];
    	matrixNames=new String[0];
    	matrixDouble=new boolean[0];
    }

    /** Creates an MFile structure which is associated with a file containing
     ** all matrices/variables. Normally followed by a call to MFile.loadAll()
        @param  filename  The file to read matrices from
        @see MFile#loadAll
    */
    public MFile(String filename) {
    	this();
    	try {
	      reader=new BufferedReader(new FileReader(filename));
	      mtoken=new MFileTokenizer(reader);
    	} catch (Exception io) {
	      System.out.println("Load failed: "+io);
      	}
    }

    public MFile(File file) {
    	this();
    	try {
	      reader=new BufferedReader(new FileReader(file));
	      mtoken=new MFileTokenizer(reader);
    	} catch (Exception io) {
	      System.out.println("Load failed: "+io);
      	}
    }

    /** Creates an MFile structure which is associated with a file containing
     ** all matrices/variables. Normally followed by a call to MFile.loadAll()
     ** This version is useful for loading very large matrices.
        @param  filename  The file to read matrices from
        @param  allocSize The size of the largest matrix
        @see MFile#loadAll
    */
    public MFile(String filename, int allocSize) {
    	this();
	    maxMatrixSize=allocSize;
    	try {
	      reader=new BufferedReader(new FileReader(filename));
	      mtoken=new MFileTokenizer(reader);
    	} catch (Exception io) {
	      System.out.println("Load failed: "+io);
    	}
    }

    /** Reads the associated file and creates the matrices in memory.
        @see MFile(string)
    */
    public void loadAll() {
    	// read: check syntax and read values
    	boolean insideMatrix=false;
    	boolean insideQuotes=false;
    	boolean matrixIsDouble=true;
    	Double[] values=new Double[maxMatrixSize];
    	String newWord=new String("nil");
    	String matrixName=new String("nil");
    	int[] dim=new int[2]; dim[0]=0; dim[1]=0;
    	int colCount=0, rowCount=0, prevColCount=0, valueCount=0;
    	try {
	      int tt=mtoken.nextToken();
	      while (tt!=MFileTokenizer.TT_EOF) {
      		switch (tt) {
      		case MFileTokenizer.TT_EOL:
      		case ';':
		        if (insideMatrix && colCount!=0) {
        			rowCount++;
        			if ((prevColCount!=0) && (prevColCount!=colCount)) {
			          System.out.println("Warning: Columns mismatch (now "+colCount+", prev "+prevColCount+") at line "+mtoken.lineno());
        			}
         			prevColCount=colCount;
        			colCount=0;
		        }
    		    break;
		      case MFileTokenizer.TT_WORD:
    		    newWord=new String(mtoken.sval);
		        if (insideMatrix) {
              if (newWord.equalsIgnoreCase("NaN")) {
          			colCount++;
        	  		values[valueCount++]=new Double(0.0/0.0);
              }
            }
		        break;
      		case MFileTokenizer.TT_NUMBER:
		        if (insideMatrix) {
        			colCount++;
        			values[valueCount++]=new Double(mtoken.nval);
		        }
    		    break;
		      case '=':
    		    break;
		      case '[':
    		    insideMatrix=true;
		        matrixName=new String(newWord);
		        matrixIsDouble=true;
    		    rowCount=colCount=prevColCount=0;
		        valueCount=0;
    		    break;
		      case ']':
    		    if (insideMatrix) {
		        	dim[0]=rowCount+1;
        			dim[1]=colCount;
        			Double[][] m=new Double[dim[0]][dim[1]];
        			int step=0;
        			for (int r=0; r<dim[0]; r++) {
			          for (int c=0; c<dim[1]; c++) {
          				m[r][c]=values[step++];
      			    }
        			}
        			addMatrix(matrixName, m);
        			matrixDouble[matrix.length-1]=matrixIsDouble;
        			insideMatrix=false;
		        } else
        			System.out.println("Warning: Syntax error at line "+mtoken.lineno());
		        break;
      		case '\'':
		        if (insideQuotes==false)
        			insideQuotes=true;
		        else {
        			if (insideMatrix) {
			          colCount+=newWord.length();
        		    for (int s=0; s<newWord.length(); s++)
                  values[valueCount++]=new Double((double)newWord.charAt(s));
        			  matrixIsDouble=false;
              }
              insideQuotes=false;
            }
            break;
      		default:
		        break;
      		}
      		tt=mtoken.nextToken();
	      }
    	} catch (Exception io) {
	      System.out.println("Load failed: "+io);
    	}
    }

    /** Returns the index by which the named matrix is stored
        @param name  The matrix identifier
        @return int The index
        @see MFile#getMatrix(int)
    */
    public int getMatrixIndex(String name) {
    	for (int i=0; i<matrix.length; i++) {
        if (matrixNames[i].equalsIgnoreCase(name))
      		return i;
      }
      return -1;
    }

    /** Returns the matrix at index
        @param  index Index for matrix
        @return double[][] The matrix
    */
    public Double[][] getMatrix(int index) {
    	return matrix[index];
    }

    /** Returns the matrix as a character string
        @param  index Index for matrix
        @return String Matrix values translated to characters (ASCII)
    */
    public String getString(int index) {
      char[] str=new char[matrix[index][0].length];
      for (int i=0; i<matrix[index][0].length; i++) {
        str[i]=(char)matrix[index][0][i].doubleValue();
      }
      return new String(str);
    }

    /** Adds a matrix to the MFile structure
        @param  name  Matrix identifier
        @param  m The matrix
    */
    public int addMatrix(String name, Double[][] m) {
    	int matrixCount=matrix.length;
    	String[] bufNames;
    	boolean[] bufDouble;
    	Double[][][] backup;
      int index;

      if ((index=getMatrixIndex(name))==-1) {
      	backup=new Double[matrixCount][][];
      	for (int i=0; i<matrixCount; i++)
	        backup[i]=matrix[i];
    	  matrix=new Double[matrixCount+1][][];
      	for (int i=0; i<matrixCount; i++)
	        matrix[i]=backup[i];
      	matrix[matrixCount]=m;
    	  bufNames=new String[matrixCount];
      	for (int i=0; i<matrixCount; i++)
	        bufNames[i]=matrixNames[i];
      	matrixNames=new String[matrixCount+1];
    	  for (int i=0; i<matrixCount; i++)
	        matrixNames[i]=bufNames[i];
      	matrixNames[matrixCount]=name;
      	bufDouble=new boolean[matrixCount];
      	for (int i=0; i<matrixCount; i++)
	        bufDouble[i]=matrixDouble[i];
      	matrixDouble=new boolean[matrixCount+1];
      	for (int i=0; i<matrixCount; i++)
	        matrixDouble[i]=bufDouble[i];
    	  matrixDouble[matrixCount]=true;
        return matrixCount;
      } else { // overwriting previous entry
        matrix[index]=m;
        return index;
      }
    }

    /** Adds a matrix to the MFile structure
        @param  name  Matrix identifier
        @param  m The matrix
    */
    public int addMatrix(String name, double[][] m) {
    	Double[][] dm=new Double[m.length][m[0].length];
    	for (int r=0; r<m.length; r++) {
      	for (int c=0; c<m[0].length; c++)
	        dm[r][c]=new Double(m[r][c]);
    	}
    	int index=addMatrix(name, dm);
    	matrixDouble[index]=true;
      return index;
    }
    /** Adds a matrix to the MFile structure
        @param  name  Matrix identifier
        @param  m The matrix
        @param  rows  Save only #rows
        @param  cols  Save only #columns
    */
    public int addMatrix(String name, double[][] m, int rows, int cols) {
    	Double[][] dm=new Double[rows][cols];
    	for (int r=0; r<rows; r++) {
      	for (int c=0; c<cols; c++)
	        dm[r][c]=new Double(m[r][c]);
    	}
    	int index=addMatrix(name, dm);
    	matrixDouble[index]=true;
      return index;
    }

    /** Adds a matrix of integers to the MFile structure
        @param  name  Matrix identifier
        @param  m The matrix
    */
    public int addMatrix(String name, int[][] m) {
    	Double[][] dm=new Double[m.length][m[0].length];
    	for (int r=0; r<m.length; r++) {
      	for (int c=0; c<m[0].length; c++)
	        dm[r][c]=new Double(m[r][c]);
    	}
    	int index=addMatrix(name, dm);
    	matrixDouble[index]=true;
      return index;
    }

    /** Adds a single value to the MFile structure
        @param  name  Matrix identifier
        @param  v The value
    */
    public int addValue(String name, double v) {
    	Double[][] dm=new Double[1][1];
	    dm[0][0]=new Double(v);
    	int index=addMatrix(name, dm);
    	matrixDouble[index]=true;
      return index;
    }


    /** Adds a matrix supplied as a text string
        @param  name  Matrix identifier
        @param  str The string
    */
    public int addString(String name, String str) {
    	Double[][] m=new Double[1][str.length()];
    	for (int i=0; i<str.length(); i++) {
	      m[0][i]=new Double((double)str.charAt(i));
    	}
    	int index=addMatrix(name, m);
    	matrixDouble[index]=false;
      return index;
    }

    /** Adds a matrix supplied as text strings, checks and fixes stringlengths
        @param  name  Matrix identifier
        @param  str The strings
    */
    public int addStrings(String name, String[] str) {
      int max=0;
    	for (int i=0; i<str.length; i++) {
        if (str[i].length()>max) max=str[i].length();
      }
    	Double[][] m=new Double[str.length][max];
      char[] tmp=new char[max];
      for (int j=0; j<str.length; j++) {
        for (int i=0; i<max; i++) {
          if (i<str[j].length())
            m[j][i]=new Double((double)str[j].charAt(i));
          else
    	      m[j][i]=new Double((double)' ');
        }
    	}
    	int index=addMatrix(name, m);
    	matrixDouble[index]=false;
      return index;
    }

    public double chop5(double x) {
      int n=(int)(x*100000);
      return (double)n/(double)100000;
    }

    /** Saves the MFile structure as a text file
        @param  filename  The name of the file
    */
    public void save(String filename) {
    	try {
	      FileOutputStream outputFile=new FileOutputStream(filename);
	      PrintWriter pw=new PrintWriter(outputFile);
  	    pw.println("% JNN m-file: "+new Date());
	      for (int j=0; j<matrix.length; j++) {
		      pw.print(matrixNames[j]+"=[");
      		if (matrixDouble[j]) {
		        for (int to=0; to<matrix[j].length; to++) {
			        pw.print("\t");
    	  	  	for (int from=0; from<matrix[j][to].length; from++) {
  			        pw.print(chop5(matrix[j][to][from].doubleValue())+" ");
	    		    }
      			  if (to==(matrix[j].length-1))
			          pw.println("];");
      			  else
			          pw.println();
       	    }
	      	} else {
		        for (int to=0; to<matrix[j].length; to++) {
      	  		pw.print("\t'");
			        for (int from=0; from<matrix[j][to].length; from++) {
    			      pw.print(""+(char)matrix[j][to][from].doubleValue());
		      	  }
        			if (to==(matrix[j].length-1))
	  		        pw.println("'];");
        			else
			          pw.println("'");
   		      }
  	    	}
	      }
	      pw.close();
	      outputFile.close();
  	  } catch (Exception io) {
	      System.out.println("Write failed: "+io);
	    }
    }

}
