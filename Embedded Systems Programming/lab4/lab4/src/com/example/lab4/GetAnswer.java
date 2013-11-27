package com.example.lab4;

import android.os.Bundle;
import android.widget.Toast;
import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;

public class GetAnswer extends Activity {

	public static final String SEND_ACTION = "com.example.lab4.SEND";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		//setContentView(R.layout.answer);
		
		NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
		mNotificationManager.cancel(1);
		
		final Intent outIntent = new Intent(this, TCPService.class);
		
		Toast.makeText(GetAnswer.this, "The teacher have received the answer! Show you later!", Toast.LENGTH_SHORT).show();
		
		outIntent.putExtra("what", TCPService.ECHO);
	    Bundle b = new Bundle();
	    b.putString("data", "");
	    outIntent.putExtra("arguments",b);
		startService(outIntent);
		finish();
	}
}
