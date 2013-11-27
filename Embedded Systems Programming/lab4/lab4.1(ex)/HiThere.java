package se.hh.embedded.primes;

import android.app.Activity;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.Button;
import android.view.View;
import android.content.Intent;
import android.net.Uri;

public class HiThere extends Activity
{
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.hithere);
	final EditText addressfield = (EditText) findViewById(R.id.address);
	final Button button = (Button)findViewById(R.id.launchmap);
	button.setOnClickListener(new Button.OnClickListener(){
		public void onClick(View view) { 
		    try { 
			String address = addressfield.getText().toString(); 
			address = address.replace(' ', '+'); 
			Intent geoIntent = new Intent(android.content.Intent.ACTION_VIEW, Uri.parse("geo:0,0?q=" + address));
			startActivity(geoIntent); 
		    } catch (Exception e) {
		    }
		}});
    }
}