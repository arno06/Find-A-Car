package fr.arnaud_nicolas.findacar.activity;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import fr.arnaud_nicolas.findacar.R;

public class AboutActivity extends Activity
    implements View.OnClickListener
{
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about);
        View v = findViewById(R.id.activity_about);
        v.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        finish();
    }
}
