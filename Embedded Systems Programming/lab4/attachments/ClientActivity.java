package se.hh.embedded.network;

import android.app.Activity;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.Toast;
import android.view.View.OnKeyListener;
import android.view.KeyEvent;
import android.view.View;
import android.content.Intent;
import android.util.Log;
import android.content.Context;
import android.app.NotificationManager;

public class ClientActivity extends Activity{

    public static final String SEND_ACTION = "se.hh.embedded.network.SEND";

    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.client);
	
	NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
	mNotificationManager.cancel(1);

	final Intent outIntent = new Intent(this, TheService.class);
	//@@ essa Intent to  get the question.
	final Intent intGetString = getIntent();
   final String clientString = intGetString.getExtras().getString("clientString");
	
	final EditText edittext = (EditText) findViewById(R.id.edittext);
	edittext.setOnKeyListener(new OnKeyListener() {
		public boolean onKey(View v, int keyCode, KeyEvent event) {
			//@@ essa display the question
		    Toast.makeText(ClientActivity.this, clientString, Toast.LENGTH_SHORT).show();

		    if ((event.getAction() == KeyEvent.ACTION_DOWN) &&
			(keyCode == KeyEvent.KEYCODE_ENTER)) {
		   
			String data = edittext.getText().toString();
			toTheService(data, outIntent);
			finish();
			return true;
		    }
		    return false;
		}
	    });
    }


    private void toTheService(String data, Intent intent){
	if(data.equals("x"))
	    intent.putExtra("what", TheService.CONCLUDE);
	else{
	    intent.putExtra("what", TheService.ECHO);
	    Bundle b = new Bundle();
	    b.putString("data", data);
	    intent.putExtra("arguments",b);
	}
	startService(intent);
    }
}
