package se.hh.embedded.primes;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import android.view.View;
import android.widget.Button;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.TextView;
import android.view.View.OnKeyListener;
import android.view.KeyEvent;
import android.widget.Toast;
import android.util.Log;

public class Primes extends Activity{

    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.primes);
	final TextView showtext = (TextView) findViewById(R.id.showtext);
	final EditText edittext = (EditText) findViewById(R.id.edittext);
	edittext.setOnKeyListener(new OnKeyListener() {
		public boolean onKey(View v, int keyCode, KeyEvent event) {
		    if ((event.getAction() == KeyEvent.ACTION_DOWN) &&
			(keyCode == KeyEvent.KEYCODE_ENTER)) {
			new Thread(new Runnable() {
				public void run() {
				    int nr = Integer.parseInt(edittext.getText().toString());
				    final long prime = primeNr(nr);
				    showtext.post(new Runnable() {
					    public void run() {
						showtext.setText(""+ prime);
					    }
					});
				}
			    }).start();		  
			return true;
		    }
		    return false;
		}
	    });
	


	Button button = (Button) findViewById(R.id.toast);
	button.setOnClickListener(new OnClickListener() {
		public void onClick(View v) {
		    Toast.makeText(Primes.this, "I am active!", Toast.LENGTH_SHORT).show();
		}
	    });
    }
    
    
    private static long primeNr(int n){
	long res = 1;
	for(int i = 0; i<n; i++){
	    res = nextPrime(res+1);
	}
	return res;
    } 

    private static long nextPrime(long p){
	while(!isPrime(p))p++;
	return p;
    }

    private static boolean isPrime(long p){
	if(p<2) return false;
	for(int i = 2; i < p; i++){
	    if(p%i==0) return false;
	}
	return true;
    }    
    
}