package file;
import java.io.*;
import java.util.*;

/**
 * <p>Title: file</p>
 * <p>Description: File utilities</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author Mikael Bodén
 * @version 1.0
 */

public class TFile {
  public double[][] values;

  public TFile() {
    values=new double[0][0];
  }

  public TFile(String filename, String separators) {
    this();
    File f;
    BufferedReader in;
    try {
      f=new File(filename);
      in=new BufferedReader(new FileReader(f));
      int row=0;
      int maxcol=0;
      Vector mat=new Vector();
      String line=in.readLine();
      while (line!=null) {
        StringTokenizer st=new StringTokenizer(line, separators, false);
        int cnt=0;
        Vector vec=new Vector();
        for (; st.hasMoreTokens(); cnt++)
          vec.add(new Double(st.nextToken()));
        if (cnt>maxcol)
          maxcol=cnt;

        if (cnt>0) {
          mat.add(vec);
          row++;
        }
        line=in.readLine();
      }
      in.close();
      values=new double[row][maxcol];
      for (int r=0; r<mat.size(); r++) {
        Vector vec=(Vector)mat.get(r);
        for (int c=0; c<vec.size(); c++) {
          values[r][c]=((Double)vec.get(c)).doubleValue();
        }
      }
    } catch (IOException exc) {
      System.err.println(exc.toString());
    }
  }

  public TFile(String filename) {
    this(filename, ", \t");
  }

  public boolean save(String filename) {
    File f;
    BufferedWriter out;
    FileWriter fw;
    try {
      f=new File(filename);
      out=new BufferedWriter(new FileWriter(f));
      for (int r=0; r<values.length; r++) {
        for (int c = 0; c < values[r].length; c++) {
          out.write((new Double(values[r][c])).toString());
        }
        out.newLine();
      }
      return true;
    } catch (IOException exc) {
      System.err.println(exc.toString());
      return false;
    }
  }

  public void set(double[][] matrix) {
    values=matrix;
  }

  public int rows() {
    return values.length;
  }

  public int cols() {
    return values[0].length;
  }

}