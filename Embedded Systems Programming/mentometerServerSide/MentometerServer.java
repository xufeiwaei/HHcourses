/*

  This program is meant to be used to test the android mentometer app
  that you have to develop for the course embedded systems
  programming.

  It sends choices and replies stored in a file lecture.txt

  To start the server run
  
  > java MentometerServer

  To stop listening for connections press return.
  
  to send a question press return
  RET

  To collect the answers sent by the students press return.

  The program terminates when there are no more choices in the
  lecture.txt file.

  An interaction with 3 questions will look like this (I have marked
  the RET that are not seen in the terminal) The questions and replies
  are in a special file lecture.txt

> java MentometerServer RET
Started server on port 4444
Accepted connection from client
RET
done connecting 1 students.
RET
RET
ANSWER from student vero
RET
RET
ANSWER from student vero
RET
RET
ANSWER from student vero
Closing down ...
mentometer > 

*/

import java.net.Socket;
import java.net.ServerSocket;
import java.net.SocketTimeoutException;
import java.io.*;
import java.util.Scanner;
import java.util.ArrayList;

public class MentometerServer  {

    private static boolean accepting = true;
    private static Scanner stdIn =  new Scanner(new BufferedInputStream(System.in));
    private static Scanner lecture;
    private static ArrayList<Socket> theConnections = new ArrayList<Socket>(); 
    private static ArrayList<Scanner> ins = new ArrayList<Scanner>(); 
    private static ArrayList<InputStream> inps = new ArrayList<InputStream>(); 
    private static ArrayList<PrintWriter> outs = new ArrayList<PrintWriter>(); 

    public static void main(String[] args)throws java.io.FileNotFoundException, java.io.IOException  {
        int port = 4444;
	lecture = new Scanner(new File("lecture.txt"));
	buildConnections(port);
	doChoices();
	conclude();
    }

    private static void doChoices() throws java.io.IOException{
	String choice;
	PrintWriter out;
	InputStream is;
	Scanner in;
	String answer;
	int answerNr;
	Choice c; 
	String s;
	int p;
	while(lecture.hasNextLine()){ // while(stdIn.hasNextLine()){
	    stdIn.nextLine();
	    choice = lecture.nextLine();
	    for(int i = 0;i<outs.size();i++){
		out = outs.get(i);
		is = inps.get(i);
		in = ins.get(i);
		if(is.available()>0){
		    in.nextLine();
		}
		out.println(choice);
		out.flush();
	    }
	    stdIn.nextLine();
	    answer = lecture.nextLine();
	    answerNr = 0;
	    for(int i = 0; i<ins.size();i++){
		in = ins.get(i);
		is = inps.get(i);
		out = outs.get(i);
		c = new Choice(choice);
		if(is.available()>0){
		    s = in.nextLine();
		    System.err.println(s);

		    p = s.indexOf("\"");
		    answerNr = Integer.parseInt(s.substring(p+1,s.indexOf("\"",p+1)));

		    p = answer.indexOf("\"");
		    s = answer.substring(p+1,answer.indexOf("\"",p+1));
		    s = s.equals(c.getChoice(answerNr))?"R":"W";

		    out.print("<reply> ");
		    out.print(answer);
		    out.print("<received text = \"" + s + "\"/>");
		    out.println("</reply>");
		    out.flush();
		}
		else{
		    out.print("<reply> ");
		    out.print(answer);
		    out.print("<received text = \"U\"/>");
		    out.println("</reply>");
		    out.flush(); 
		}
	    }
	}
    }


    private static void buildConnections(int port){
	// wait for a return to stop listening to connections
	new Thread(new Runnable(){
		public void run(){
		    stdIn.nextLine();
		    accepting = false;
		}
	    }).start();
	
	try {
	    
	    final ServerSocket serverSocket = new ServerSocket(port);
	    serverSocket.setSoTimeout(1000); // to be able to stop blocking now and then
	    System.err.println("Started server on port " + port);
	    while (accepting) {
		try{
		    Socket clientSocket = serverSocket.accept();
		    InputStream is = clientSocket.getInputStream();
		    Scanner in = new Scanner(new BufferedInputStream(is));
		    PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true); 
		    theConnections.add(clientSocket);
		    inps.add(is);
		    ins.add(in);
		    outs.add(out);
		    System.err.println("Accepted connection from client");
		}catch(SocketTimeoutException e){}
	    }
	    System.err.println("done connecting " + theConnections.size() + " students.");
	} catch (IOException ioe) {System.err.println("here" + ioe);}
    }
    


    public static void conclude(){
	System.err.println("Closing down ...");
	for(PrintWriter out : outs){
	    out.println("<conclude/>");
	    out.close();
	}
	for(Scanner in : ins){
	    in.close();
	}
	for(Socket s : theConnections){
	    try{s.close();}catch(IOException e){System.out.println("problems closing a socket");}
	}
    }
}


