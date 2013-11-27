package com.example.lab4;


import android.app.Activity;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.Button;
import android.widget.Toast;
import android.view.View.OnClickListener;
import android.view.View;
import android.content.Intent;


public class Login extends Activity
{
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login);

	final EditText phone = (EditText)findViewById(R.id.phone);
	phone.setText("Xu Fei");

	final EditText ip = (EditText)findViewById(R.id.ipNumber);
	ip.setText("192.168.1.77");
	
	final EditText port = (EditText)findViewById(R.id.portNumber);
	port.setText("4444");


	final Intent intent = new Intent(this, TCPService.class);
	Button connect = (Button)findViewById(R.id.connect);
	connect.setOnClickListener(new OnClickListener(){
		public void onClick(View v){
		    intent.putExtra("what", TCPService.CONNECT);
		    Bundle b = new Bundle();
		    b.putInt("port",Integer.parseInt(port.getText().toString()));
		    b.putString("host",ip.getText().toString());
		    b.putString("phone", phone.getText().toString());
		    intent.putExtra("arguments",b);
		    startService(intent);
		    Toast.makeText(Login.this, "I am connect!", Toast.LENGTH_SHORT).show();
		    finish();
		}
	    });
    }
}
