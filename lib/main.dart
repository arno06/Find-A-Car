import 'package:flutter/material.dart';
import 'widgets/OfferList.dart';

void main() => runApp(new FindACarApp());

class FindACarApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find a car',
      theme: new ThemeData(
          primaryColor: Colors.green
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new OfferList(),
      },
    );
  }
}
