package fr.arnaud_nicolas.findacar.adapters;

import android.content.Intent;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.util.Base64;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.ArrayList;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import fr.arnaud_nicolas.findacar.MainActivity;
import fr.arnaud_nicolas.findacar.R;
import fr.arnaud_nicolas.findacar.activity.FullscreenActivity;
import fr.arnaud_nicolas.findacar.data.Offer;
import fr.arnaud_nicolas.findacar.tools.Loader;

public class OfferAdapter extends RecyclerView.Adapter<OfferAdapter.OfferHolder>
{

    static public final String IMG_URL = "offer_adapter.img_url";

    private ArrayList<Offer> mDataset;

    static public class OfferHolder extends RecyclerView.ViewHolder
            implements View.OnClickListener
    {
        TextView title;
        TextView price;
        TextView source;
        NetworkImageView image;
        String offerURL;

        public OfferHolder(View itemView)
        {
            super(itemView);
            title = (TextView) itemView.findViewById(R.id.titleView);
            price = (TextView) itemView.findViewById(R.id.priceView);
            image = (NetworkImageView) itemView.findViewById(R.id.preview);
            source = (TextView) itemView.findViewById(R.id.sourceView);
            image.setOnClickListener(this);
            Log.d("OfferHolder", "Constructor");
        }

        @Override
        public void onClick(View v) {
            byte[] data = offerURL.getBytes();
            String url = Base64.encodeToString(data, Base64.DEFAULT);

            Intent intent = new Intent(v.getContext(), FullscreenActivity.class);
            intent.putExtra(IMG_URL, MainActivity.URL_IMAGE+url);

            v.getContext().startActivity(intent);
        }
    }

    public OfferAdapter(ArrayList<Offer> pDataSet) {
        mDataset = pDataSet;
    }

    public void updateData(ArrayList<Offer> pDataSet)
    {
        mDataset.clear();
        mDataset.addAll(pDataSet);
        notifyDataSetChanged();
    }

    @Override
    public OfferHolder onCreateViewHolder(ViewGroup parent,
                                               int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.card_view_row, parent, false);

        return new OfferHolder(view);
    }

    @Override
    public void onBindViewHolder(OfferHolder holder, int position) {

        Offer o = mDataset.get(position);

        holder.title.setText(o.getTitle());
        holder.price.setText(o.getPrice());
        holder.source.setText(o.getSource());
        holder.source.setTextColor(Color.parseColor(o.getSourceColor()));
        holder.offerURL = o.getOfferURL();

        ImageLoader loader = Loader.getInstance(holder.image.getContext()).getImageLoader();
        holder.image.setImageUrl(mDataset.get(position).getImageURL(), loader);
    }

    public void addItem(Offer dataObj, int index) {
        mDataset.add(index, dataObj);
        notifyItemInserted(index);
    }

    public void deleteItem(int index) {
        mDataset.remove(index);
        notifyItemRemoved(index);
    }

    @Override
    public int getItemCount() {
        return mDataset.size();
    }
}

