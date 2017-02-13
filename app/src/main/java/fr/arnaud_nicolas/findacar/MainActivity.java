package fr.arnaud_nicolas.findacar;

import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.transition.Fade;
import android.transition.Scene;
import android.transition.Transition;
import android.transition.TransitionManager;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.ViewGroup;

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;

import fr.arnaud_nicolas.findacar.activity.AboutActivity;
import fr.arnaud_nicolas.findacar.activity.PreferencesActivity;
import fr.arnaud_nicolas.findacar.tools.Loader;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import fr.arnaud_nicolas.findacar.adapters.OfferAdapter;
import fr.arnaud_nicolas.findacar.data.Offer;

public class MainActivity extends AppCompatActivity implements SharedPreferences.OnSharedPreferenceChangeListener
{
    public static final String URL_FIND = "https://api.arnaud-nicolas.fr/fac/find?model=Lotus%20Elise";
    public static final String URL_IMAGE = "https://api.arnaud-nicolas.fr/fac/image/";

    private Boolean initialized = false;
    private OfferAdapter mOfferAdapter;
    private SwipeRefreshLayout mSwipeRefreshLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        PreferenceManager.getDefaultSharedPreferences(this).registerOnSharedPreferenceChangeListener(this);
        refreshData();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        Intent intent;
        switch(item.getItemId())
        {
            case R.id.item_about:
                intent = new Intent(this, AboutActivity.class);
                startActivity(intent);
                return true;
            case R.id.item_settings:
                intent = new Intent(this, PreferencesActivity.class);
                startActivity(intent);
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private void refreshData()
    {
        Loader.getInstance(this);

        final MainActivity se = this;
        StringRequest strreq = new StringRequest(Request.Method.GET, URL_FIND,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        se.displayResult(response);
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.d("NOP", "errorResponse", error);
            }
        });

        strreq.setRetryPolicy(new DefaultRetryPolicy(5000, 2, 2));

        Loader.getInstance(this).addToQueue(strreq);

        if(!this.initialized)
            Loader.getInstance(this).start();
    }

    private void displayResult(String pResult)
    {
        ArrayList<Offer> dataSet = getDataSet(pResult);
        if(!this.initialized)
        {
            ViewGroup mSceneRoot = (ViewGroup) findViewById(R.id.activity_main);
            Scene mListScene = Scene.getSceneForLayout(mSceneRoot, R.layout.list_scene, this);

            Transition mFadeTransition = new Fade();

            TransitionManager.go(mListScene, mFadeTransition);

            RecyclerView mRecyclerView = (RecyclerView) findViewById(R.id.my_recycler_view);
            mRecyclerView.setHasFixedSize(true);

            LinearLayoutManager mLayoutManager = new LinearLayoutManager(this);
            mRecyclerView.setLayoutManager(mLayoutManager);
            mOfferAdapter = new OfferAdapter(dataSet);
            mRecyclerView.setAdapter(mOfferAdapter);

            mSwipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.list_scene);

            mSwipeRefreshLayout.setColorSchemeResources(R.color.colorAccent);

            mSwipeRefreshLayout.setOnRefreshListener(
                    new SwipeRefreshLayout.OnRefreshListener(){
                        @Override
                        public void onRefresh() {
                            refreshData();
                        }
                    }
            );

            this.initialized = true;
        }
        else
        {
            mOfferAdapter.updateData(dataSet);
            mSwipeRefreshLayout.setRefreshing(false);
        }
    }

    @Nullable
    private ArrayList<Offer> getDataSet(String pResult)
    {
        ArrayList<Offer> d = new ArrayList<>();
        SharedPreferences pref = PreferenceManager.getDefaultSharedPreferences(this);
        int max_price = Integer.parseInt(pref.getString("max_price_preference", "100000"));
        try
        {
            JSONObject json = new JSONObject(pResult);
            JSONArray offers = json.getJSONArray("offers");

            JSONObject offer;
            int price;
            for(int i = 0, max = offers.length(); i<max; i++)
            {
                offer = offers.getJSONObject(i);
                price = Integer.parseInt(offer.getString("price"));
                if(price > max_price)
                    continue;
                d.add(i, new Offer(offer.getString("title"), offer.getString("price"), offer.getString("image"), offer.getString("source"), offer.getString("sourceColor"), offer.getString("offerURL")));
            }
        }
        catch(final JSONException e)
        {
            return null;
        }
        return d;
    }

    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
        switch(key)
        {
            case "max_price_preference":
                refreshData();
                break;
        }
    }
}
