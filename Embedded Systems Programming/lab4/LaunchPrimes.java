package se.hh.embedded.primes;

import android.app.Activity;
import android.os.Bundle;
import android.content.Intent;
import android.widget.Button;
import android.widget.RadioButton;
import android.view.View.OnClickListener;
import android.view.View;
import android.util.Log;

public class LaunchPrimes extends Activity
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

	final Intent primesIntent = new Intent(this, Primes.class);
	final RadioButton radioPrimes  = (RadioButton) findViewById(R.id.radio_primes);
	radioPrimes.setOnClickListener(new OnClickListener() {
		public void onClick(View v) {
		    startActivity(primesIntent);
		}
	    });

	final Intent hiThereIntent = new Intent(this, HiThere.class);	
	final RadioButton radioHiThere = (RadioButton) findViewById(R.id.radio_hi_there);
	radioHiThere.setOnClickListener(new OnClickListener() {
		public void onClick(View v) {
		    startActivity(hiThereIntent);
		}
	    });
	
	Button q = (Button)findViewById(R.id.quitButton);
	q.setOnClickListener(new Button.OnClickListener(){
		public void onClick(View view) {
		    LaunchPrimes.this.finish(); }
	    });
    }
}