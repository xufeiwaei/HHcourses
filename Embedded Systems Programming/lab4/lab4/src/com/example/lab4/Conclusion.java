package com.example.lab4;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;

public class Conclusion extends Activity {

	public static final String SEND_ACTION = "com.example.lab4.SEND";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.conclusion);
		
		NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
		mNotificationManager.cancel(1);
		
		//@@ essa Intent to  get the question.
		final Intent intGetString = getIntent();
	    final String clientString = intGetString.getExtras().getString("clientString");
		
	    final TextView Conclusion = (TextView) findViewById(R.id.conclusion);
	    Button connect = (Button)findViewById(R.id.Exit);
		connect.setOnClickListener(new OnClickListener(){
			public void onClick(View v){
			    finish();
			}
		    });
	    
	    
		String Show = "";
		String question = "", cr = "", result = "";
		
		int QuestionNum = clientString.charAt(0) - 48;
		
		int i = 0;
		
		for(int n = 0 ; n < QuestionNum; n++)
		{
			while(clientString.charAt(i++)!='>');
		    while(clientString.charAt(i++)!='"');
		    for(;clientString.charAt(i)!='"';i++)
		    {
		    	question+=clientString.charAt(i);
		    }
		    Show = Show+ ""+(n+1)+"."+question+"\n    Answer: ";
		    question = "";
		    
		    
		    while(!(clientString.charAt(i)=='<'&&clientString.charAt(i+1)=='/')) i++;
		    while(clientString.charAt(i++)!='"');
		    for(;clientString.charAt(i)!='"';i++)
		    {
		    	cr+=clientString.charAt(i);
		    }
		    Show += cr;
		    cr = "";
		    
			
			i++;while(clientString.charAt(i++)!='"');
			switch(clientString.charAt(i))
			{
				case 'R': result = "You are right!";break;
				case 'W': result = "You are wrong!";break;
				case 'U': result = "I don't know!";break;
			}
		    Show += "\n    " + result + "\n\n";
		    while(clientString.charAt(i++)!='<');
		}
		
		
		
	    Conclusion.setText(Show);
	}

	

}
