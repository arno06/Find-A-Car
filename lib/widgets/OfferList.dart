import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:http/http.dart' as http;
import 'package:find_a_car/providers/Offers.dart';
import 'OfferDetails.dart';
import 'AnimatedIntro.dart';

class OfferList extends StatefulWidget{
  OfferList({Key key}):super(key:key);

  @override
  _OfferListState createState()=>new _OfferListState();
}

class _OfferListState extends State<OfferList> with SingleTickerProviderStateMixin{

  static const SEARCH_URL = 'https://api.arnaud-nicolas.fr/fac/find?model=Lotus%20Elise';

  bool loaded = false;
  List<Offer> list;
  AnimationController controller;
  Animation<double> animation;

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

  initState(){
    super.initState();
    controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    animation = new Tween(begin:0.0, end: 1.0).animate(controller)
      ..addStatusListener((state){
      if(state == AnimationStatus.completed){
        setState(() {
          loaded = true;
        });
      }
    });
  }

  init() async{
    http.get(SEARCH_URL).then((response){
      list = Offers.fromJson(response.body);
      controller.forward();
    });
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = loaded?buildListState(context):new AnimatedIntro(animation:animation);
    if(!loaded)
      init();
    return new Scaffold(
      body:body
    );
  }
}