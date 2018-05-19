import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:find_a_car/providers/Offers.dart';

class OfferList extends StatefulWidget{
  OfferList({Key key}):super(key:key);

  @override
  _OfferListState createState()=>new _OfferListState();
}

class _OfferListState extends State<OfferList>{

  static const SEARCH_URL = 'https://api.arnaud-nicolas.fr/fac/find?model=Lotus%20Elise';

  bool loaded = false;
  List<Offer> list;

  Widget buildLoadingScreen(BuildContext context){
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

  Widget buildList(BuildContext context){
    List<Widget> items = [];
    bool addSeparator = false;
    list.forEach((offer){
      if(addSeparator){
        items.add(new Divider());
      }
      items.add(new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            child: new Image.network(offer.image, width: 100.0,),
          ),
          new Expanded(
              child: new Container(
                color: Colors.pink,
                child: new Stack(
                  children: <Widget>[
                    new Text(offer.title),
                  ],
                ),
              )
          ),
        ],
      ));
      addSeparator = true;
    });
    return new ListView(children: items,);
  }

  init() async{
    http.get(SEARCH_URL).then((response){
      list = Offers.fromJson(response.body);
      print(list.length);
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = loaded?buildList(context):buildLoadingScreen(context);
    if(!loaded)
      init();
    return new Scaffold(
      body:body
    );
  }
}