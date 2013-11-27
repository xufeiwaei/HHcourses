package com.example.lab4;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.Toast;
import android.view.View.OnClickListener;
import android.view.View;
import android.content.Intent;
import android.content.Context;
import android.app.NotificationManager;

public class AnswerQuestion extends Activity{

    public static final String SEND_ACTION = "com.example.lab4.SEND";
    char ChoiceNumber;
    
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.answer_question);
	
	NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
	mNotificationManager.cancel(1);

	final Intent outIntent = new Intent(this, TCPService.class);
	//@@ essa Intent to  get the question.
	final Intent intGetString = getIntent();
    final String clientString = intGetString.getExtras().getString("clientString");
	
    
    final TextView QuestionText = (TextView) findViewById(R.id.QuestionText);
    final RadioButton choice1  = (RadioButton) findViewById(R.id.choice1);
    final RadioButton choice2  = (RadioButton) findViewById(R.id.choice2);
    final RadioButton choice3  = (RadioButton) findViewById(R.id.choice3);
    final Button submit = (Button)findViewById(R.id.submit);

    
    String question="",c1="",c2="",c3="";
    int i = 0;
    while(clientString.charAt(i++)!='>');
    while(clientString.charAt(i++)!='"');
    for(;clientString.charAt(i)!='"';i++)
    {
    	question+=clientString.charAt(i);
    }
    
    i++;
    while(clientString.charAt(i++)!='"');
    for(;clientString.charAt(i)!='"';i++)
    {
    	c1 = c1+clientString.charAt(i);
    }
    
    i++;
    while(clientString.charAt(i++)!='"');
    for(;clientString.charAt(i)!='"';i++)
    {
    	c2 = c2+clientString.charAt(i);
    }
    
    i++;
    while(clientString.charAt(i++)!='"');
    for(;clientString.charAt(i)!='"';i++)
    {
    	c3 = c3+clientString.charAt(i);
    }
    
	QuestionText.setText(question);
	choice1.setText(c1);
	choice2.setText(c2);
	choice3.setText(c3);
	
	choice1.setOnClickListener(new OnClickListener() {
		public void onClick(View v) {
		    ChoiceNumber = 1;
		}
	    });
	
	choice2.setOnClickListener(new OnClickListener() {
		public void onClick(View v) {
		    ChoiceNumber = 2;
		}
	    });
	
	choice3.setOnClickListener(new OnClickListener() {
		public void onClick(View v) {
		    ChoiceNumber = 3;
		}
	    });
	
	submit.setOnClickListener(new OnClickListener() {
		public void onClick(View v) {
			if(ChoiceNumber != 0)
			{
				switch(ChoiceNumber)
				{
					case 1:toTheService("1", outIntent);break;
					case 2:toTheService("2", outIntent);break;
					case 3:toTheService("3", outIntent);break;
				}
				Toast.makeText(AnswerQuestion.this, "The answer is submitted!", Toast.LENGTH_SHORT).show();
				finish();
			}
			else
			{
				Toast.makeText(AnswerQuestion.this, "The answer can't be empty!", Toast.LENGTH_SHORT).show();
			}
		}
	    });


    }


    private void toTheService(String data, Intent intent){
	if(data.equals("x"))
	    intent.putExtra("what", TCPService.CONCLUDE);
	else{
	    intent.putExtra("what", TCPService.ECHO);
	    Bundle b = new Bundle();
	    b.putString("data", data);
	    intent.putExtra("arguments",b);
	}
	startService(intent);
    }
}
