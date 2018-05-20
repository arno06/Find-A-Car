import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:find_a_car/providers/Offers.dart';

class OfferDetails extends StatefulWidget{

  OfferDetails(this.offer);

  Offer offer;

  @override
  _OfferDetailsState createState()=>new _OfferDetailsState(this.offer);
}

class _OfferDetailsState extends State<OfferDetails>{

  static const DETAILS_URL = 'https://api.arnaud-nicolas.fr/fac/details/';

  _OfferDetailsState(this.offer);

  Offer offer;

  Widget _buildDetailsState(){
    List<Widget> widgets = [];
    for(var image in offer.images){
      widgets.add(new Image.network(image, height: 350.0,));
    }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(top:24.0),
          color: Colors.green,
          height: 300.0,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: widgets,
          ),
        ),
        new Expanded(
          child: new Container(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(offer.title,
                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
                this._getProperty("Prix", offer.price+"€"),
                this._getProperty("Année", offer.year),
                this._getProperty("Kilométrage", offer.mileage),
                this._getProperty("Date de l'offre", offer.date),
                this._getProperty("Source", offer.source.name),
              ]
            ),
          )
        ),
      ],
    );
  }

  Widget _getProperty(String label, String value){
    return new Container(
        padding: const EdgeInsets.only(top: 20.0),
        child:new Row(
          children: <Widget>[
            new Text(label+" : ",
                style: new TextStyle(fontSize: 16.0, color: Colors.blueGrey)
            ),
            new Text(value,
                style: new TextStyle(fontSize: 16.0)
            ),
          ],
        )
      );

  }

  Widget _buildLoadingState(){
    return new Center(
        child:new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding:const EdgeInsets.only(bottom: 20.0),
              child: new CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            ),
            new Text("Chargement...")
          ],
        )
    );
  }

  void loadDetails(){
    print(DETAILS_URL+this.offer.base64Url);
    http.get(DETAILS_URL+this.offer.base64Url).then((pResponse){
      this.setState((){
        this.offer.completeFromJson(pResponse.body);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = offer.completed?_buildDetailsState():_buildLoadingState();
    if(!offer.completed)
      loadDetails();
    return new Scaffold(
      body: body,
    );
  }
}