import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:find_a_car/providers/Offers.dart';
import 'OfferDetails.dart';

class OfferList extends StatefulWidget{
  OfferList({Key key}):super(key:key);

  @override
  _OfferListState createState()=>new _OfferListState();
}

class _OfferListState extends State<OfferList>{

  static const SEARCH_URL = 'https://api.arnaud-nicolas.fr/fac/find?model=Lotus%20Elise';

  bool loaded = false;
  List<Offer> list;

  Widget buildLoadingState(BuildContext context){
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

  Widget buildListState(BuildContext context){
    List<Widget> items = [];
    bool addSeparator = false;
    list.forEach((offer){
      if(addSeparator){
        items.add(new Divider());
      }
      items.add(new GestureDetector(
        onTap: (){
          Navigator.push(context, new MaterialPageRoute(builder: (context)=>new OfferDetails(offer)));
        },
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new Image.network(offer.preview, width: 100.0, height:80.0),
            ),
            new Expanded(
                child: new Container(
                  color: Colors.white,
                  height: 80.0,
                  padding:const EdgeInsets.all(10.0),
                  child: new Stack(
                    children: <Widget>[
                      new Text(offer.title,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold
                        ),),
                      new Container(
                        alignment: const FractionalOffset(0.0, 1.0),
                        child: new Text(offer.price+"€"),
                      ),
                      new Container(
                        alignment: const FractionalOffset(1.0, 1.0),
                        child: new Text(offer.source.name,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: new Color(int.parse(offer.source.color.replaceAll("#", "0xFF")))
                          ),
                        ),
                      )
                    ],
                  ),
                )
            ),
          ],
        ),
      ));
      addSeparator = true;
    });
    return new ListView(children: items,);
  }

  init() async{
    http.get(SEARCH_URL).then((response){
      list = Offers.fromJson(response.body);
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = loaded?buildListState(context):buildLoadingState(context);
    if(!loaded)
      init();
    return new Scaffold(
      body:body
    );
  }
}