import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:find_a_car/providers/Offers.dart';
import 'AnimatedIntro.dart';

class OfferDetails extends StatefulWidget{

  OfferDetails(this.offer);

  Offer offer;

  @override
  _OfferDetailsState createState()=>new _OfferDetailsState(this.offer);
}

class _OfferDetailsState extends State<OfferDetails> with TickerProviderStateMixin{

  static const DETAILS_URL = 'https://api.arnaud-nicolas.fr/fac/details/';

  _OfferDetailsState(this.offer);

  Offer offer;
  AnimationController controller;
  Animation<double> animation;

  initState(){
    super.initState();
    controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    animation = new Tween(begin:0.0, end: 1.0).animate(controller)
      ..addStatusListener((state){
        if(state == AnimationStatus.completed){
          setState(() {
            offer.completed = true;
          });
        }
      });
  }

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

  void loadDetails(){
    http.get(DETAILS_URL+this.offer.base64Url).then((pResponse){
      controller.forward();
      this.offer.completeFromJson(pResponse.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = offer.completed?_buildDetailsState():new AnimatedIntro(animation:animation);
    if(!offer.completed)
      loadDetails();
    return new Scaffold(
      body: body,
    );
  }
}