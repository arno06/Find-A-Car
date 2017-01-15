package fr.arnaud_nicolas.findacar.data;

import fr.arnaud_nicolas.findacar.R;

public class Offer {

    private String sourceColor;
    private String source;
    private String title;
    private String price;
    private String imageURL;
    private String offerURL;

    public Offer(String pTitle, String pPrice, String pImageURL, String pSource, String pSourceColor, String pOfferURL)
    {
        this.title = pTitle;
        this.price = pPrice;
        this.imageURL = pImageURL;
        this.source = pSource;
        this.sourceColor = pSourceColor;
        this.offerURL = pOfferURL;
    }

    public String getTitle()
    {
        return title;
    }

    public String getPrice()
    {
        return price+" €";
    }

    public String getImageURL(){ return imageURL; }

    public String getSource(){ return source; }

    public String getSourceColor(){ return sourceColor; }

    public String getOfferURL(){ return offerURL; }
}
