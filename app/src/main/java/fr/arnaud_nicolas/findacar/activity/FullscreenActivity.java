package fr.arnaud_nicolas.findacar.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ProgressBar;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import fr.arnaud_nicolas.findacar.R;
import fr.arnaud_nicolas.findacar.adapters.OfferAdapter;
import fr.arnaud_nicolas.findacar.tools.Loader;

public class FullscreenActivity extends Activity
    implements View.OnClickListener
{
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_fullscreen);

        Intent intent = getIntent();

        final ProgressBar progressBar = (ProgressBar) findViewById(R.id.progressBar);

        String imgUrl = intent.getStringExtra(OfferAdapter.IMG_URL);

        final NetworkImageView imgView = (NetworkImageView) findViewById(R.id.fullscreen_image);

        ImageLoader loader = Loader.getInstance(this).getImageLoader();
        imgView.setImageUrl(imgUrl, loader);
        imgView.addOnLayoutChangeListener(new View.OnLayoutChangeListener(){
            @Override
            public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                if (imgView.getDrawable() != null)
                {
                    progressBar.setVisibility(View.INVISIBLE);
                }
            }
        });

        imgView.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        finish();
    }
}
