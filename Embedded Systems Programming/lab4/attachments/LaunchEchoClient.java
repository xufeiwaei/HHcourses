package se.hh.embedded.network;

import android.app.Activity;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.Button;
import android.widget.Toast;
import android.view.View.OnClickListener;
import android.view.View;
import android.content.Intent;
import android.util.Log;


public class LaunchEchoClient extends Activity
{
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

	final EditText phone = (EditText)findViewById(R.id.phone);
	phone.setText("Vero's");

	final EditText ip = (EditText)findViewById(R.id.ipNumber);
//	ip.setText("10.0.1.60");
	ip.setText("192.168.82.55");


	final Intent intent = new Intent(this, TheService.class);
	Button connect = (Button)findViewById(R.id.connect);
	connect.setOnClickListener(new OnClickListener(){
		public void onClick(View v){
		    intent.putExtra("what", TheService.CONNECT);
		    Bundle b = new Bundle();
		    b.putInt("port",4444);
		    b.putString("host",ip.getText().toString());
		    b.putString("phone", phone.getText().toString());
		    intent.putExtra("arguments",b);
		    startService(intent);
		    Toast.makeText(LaunchEchoClient.this, "I am active!", Toast.LENGTH_SHORT).show();

		    finish();
		}
	    });
    }
}
