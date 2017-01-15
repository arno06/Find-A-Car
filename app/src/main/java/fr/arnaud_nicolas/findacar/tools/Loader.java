package fr.arnaud_nicolas.findacar.tools;


import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import android.util.LruCache;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.Volley;

public class Loader {

    private static Loader mInstance;

    private Context mContext;
    private ImageLoader mImageLoader;
    private RequestQueue mRequestQueue;

    private Loader(Context pContext)
    {
        this.mContext = pContext;

        this.mRequestQueue = this.getRequestQueue();

        this.mImageLoader = new ImageLoader(this.mRequestQueue,
                new ImageLoader.ImageCache() {
                    private final LruCache<String, Bitmap> cache = new LruCache<>(20);

                    @Override
                    public Bitmap getBitmap(String url) {
                        return cache.get(url);
                    }

                    @Override
                    public void putBitmap(String url, Bitmap bitmap) {
                        cache.put(url, bitmap);
                    }
                });
    }

    public static synchronized Loader getInstance(Context pContext)
    {
        if(mInstance == null)
        {
            mInstance = new Loader(pContext);
        }

        return mInstance;
    }

    private RequestQueue getRequestQueue()
    {
        if(mRequestQueue == null)
        {
            mRequestQueue = Volley.newRequestQueue(mContext.getApplicationContext());
        }
        return mRequestQueue;
    }

    public <T> void addToQueue(Request<T> pRequest)
    {
        this.getRequestQueue().add(pRequest);
    }

    public void start()
    {
        this.getRequestQueue().start();
    }

    public ImageLoader getImageLoader()
    {
        return this.mImageLoader;
    }
}
