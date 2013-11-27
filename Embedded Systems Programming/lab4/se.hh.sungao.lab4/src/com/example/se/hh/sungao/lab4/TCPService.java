package com.example.se.hh.sungao.lab4;

import android.app.Service;
import android.widget.Toast;
import android.content.Intent;
import android.os.Looper;
import android.os.Message;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Process;


import android.content.Context;
import android.app.NotificationManager;
import android.app.Notification;
import android.app.PendingIntent;

import java.net.Socket;
import java.io.*;
import java.util.Scanner;


public class TCPService extends Service{
    
    private Looper mServiceLooper;
    private CommunicationHandler mServiceHandler;
    public static final int CONNECT  = 0;
    public static final int ECHO     = 1;
    public static final int CONCLUDE = 2;
    String Record = "";
    char message_state;
    int QuestionNum = 0;
    
    public void onCreate() {
	HandlerThread thread = new HandlerThread("TheServiceWorkerThread",
						 Process.THREAD_PRIORITY_BACKGROUND);
	thread.start();
	mServiceLooper = thread.getLooper();
	mServiceHandler = new CommunicationHandler(mServiceLooper);
    }
    
    
    public int onStartCommand(Intent intent, int flags, int startId) {
	Message msg = mServiceHandler.obtainMessage();
	msg.what = intent.getExtras().getInt("what");
	msg.setData(intent.getBundleExtra("arguments"));
	mServiceHandler.sendMessage(msg);
	return START_STICKY;
    }

    /* onBind has to be defined, it is a hook method in the abstract class service.
       If it is not defined the class remains abstract.
     */
    public android.os.IBinder onBind(Intent intent) {
	return null;
    }
    
    /* The rest of the program is the inner class CommunicationHandler 

       The CommunicationHandler is the Handler for the service.
       It is defined as an inner class in order to use some of the variables 
       of the Service class.
       The Service method onStartCommand that gets called when an Activity starts the service
       uses the method sendMessage(msg) with a msg built from the data in the intent. 
       The message is received by the method handleMessage.
       This method uses TCP sockets to communicate via the network.
     */

    private final class CommunicationHandler extends Handler {
	private Scanner in;
	private PrintWriter out;
	private Socket socket;
	private String phone; 

	public CommunicationHandler(Looper looper) {
	    super(looper);
	}
	
	public void handleMessage(Message msg) {
	    switch(msg.what){
		
	    case CONNECT : 
		String host = msg.getData().getString("host");
		int port = msg.getData().getInt("port");
		phone = msg.getData().getString("phone");
		try{
		    // Establish a connection with the server
		    socket = new Socket(host, port);
		    in = new Scanner(new BufferedInputStream(socket.getInputStream()));
		    out = new PrintWriter(socket.getOutputStream(), true); 
		  //@@ essa in.nextLine will read the message form server and send it to notification.
		    message_state = 1;
		    sendNotification(in.nextLine());
		}catch(java.net.UnknownHostException e){
		    Toast.makeText(TCPService.this, "Unknown host", Toast.LENGTH_SHORT).show();
		    stopSelf();
		}
		catch(java.io.IOException e){
		    Toast.makeText(TCPService.this, "IOException", Toast.LENGTH_SHORT).show();		    
		    stopSelf();
		}
		break;

	    case ECHO : 
		// Got from the activity something to send to the server
		//@@ essa data will get string ( 1,2 or 3) form ClientActivity's edittext and send it to the server 
	    	
	    	String data = msg.getData().getString("data");
		
		
		out.println("<" + phone + " answer text = \"" +data+ "\"/>");
	    //out.println("<answer text = " + data + "/>");
		// wait to receive an acknowledgement from the server
		String back = in.nextLine();
		
		char c = back.charAt(2);
		
		if(c=='h') 
		{
			message_state = 1;
			sendNotification(back);
		}
		else if(c=='e')
		{
			message_state = 2;
			Record += back;
			sendNotification("Got the answer. But I will show you later!");
		}
		else
		{
			message_state = 3;
			sendNotification("" + QuestionNum + Record);
		}
			 
		break;

	    case CONCLUDE : 
		try{
		    out.close();in.close();socket.close();stopSelf();
		}catch(java.io.IOException e){
		    Toast.makeText(TCPService.this, "IOException", Toast.LENGTH_SHORT).show();		    
		    stopSelf();
		}
		break;	
	    }
	}

	/*
	  This method prepares a  notification that calls an Activity.
	 */

	@SuppressWarnings("deprecation")
	private void sendNotification(String s){
	    String ns                                = Context.NOTIFICATION_SERVICE;
	    NotificationManager mNotificationManager = (NotificationManager) getSystemService(ns);

	    int icon        = R.drawable.ic_launcher;        // icon from resources
	    long when       = System.currentTimeMillis();         // notification time
	    Context context = getApplicationContext();      // application Context
	    Intent notifyIntent;
	    Notification notification;
	    CharSequence tickerText;
	    CharSequence contentTitle;
	    CharSequence contentText;
	  //@@ essa send notification if the string is form the server ONLY.
	   // If it is form clint that is  if String S  is  "Sent: " + data + ", Got: " + back + "." you don't have to sent notification
	    if(message_state == 2)
	    {
	    	tickerText = "Answer received";              // ticker-text
			contentTitle = "Answer received";  // message title
			contentText = "Got the answer! Show you later!";      // message text
	    }
	    else if(message_state == 1)
	    {
	    	tickerText = "NewQuestion";              // ticker-text
			contentTitle = "Question available";  // message title
			contentText = "Answer it!";      // message text
			QuestionNum ++;
			Record += s;
	    }
	    else
	    {
	    	tickerText = "Finish";              // ticker-text
			contentTitle = "Conclusion";  // message title
			contentText = "Check your result!";      // message text
	    }
	    
		
		
		notification = new Notification(icon, tickerText, when);
		
		
		
		if(message_state == 2)
		{
			/* the notification will call an activity with this intent */
			notifyIntent = new Intent(GetAnswer.SEND_ACTION);
			notifyIntent.setClass(context, GetAnswer.class);
			//@@ essa put the string  in the intent for ClientActivity
		}
		else if(message_state == 1)
		{
			/* the notification will call an activity with this intent */
			notifyIntent = new Intent(AnswerQuestion.SEND_ACTION);
			notifyIntent.setClass(context, AnswerQuestion.class);
			//@@ essa put the string  in the intent for ClientActivity
		}
		else
		{
			/* the notification will call an activity with this intent */
			notifyIntent = new Intent(Conclusion.SEND_ACTION);
			notifyIntent.setClass(context, Conclusion.class);
			//@@ essa put the string  in the intent for ClientActivity
		}
		
		
		notifyIntent.putExtra("clientString",s);
		PendingIntent contentIntent =
		    PendingIntent.getActivity(context, 0,
					      notifyIntent,  PendingIntent.FLAG_UPDATE_CURRENT | Notification.FLAG_AUTO_CANCEL);
		
		/* complete configuration and notify */
		
		notification.setLatestEventInfo(context, contentTitle, contentText, contentIntent);
		mNotificationManager.notify(1, notification);
	    
	    
	}
    }
}


