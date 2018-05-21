import 'dart:convert';

class Offers{
  static List<Offer> fromJson(String jsonString){
    List<dynamic> data = json.decode(jsonString)['offers'];
    return data.map((v)=> new Offer(
              v['title'], v['price'], new Source(v['source'], v['sourceColor']),
              v['offerURL'], v['image'])
      ).toList();
  }
}

class Offer{
  final String title;
  final String price;
  final Source source;
  final String url;
  final String preview;
  List<dynamic> images;
  String date;
  String year;
  String mileage;
  bool completed = false;

  Offer(this.title, this.price, this.source, this.url, this.preview);

  completeFromJson(String jsonString){
    Map<String, dynamic> data = json.decode(jsonString);
    this.images = data['images'];
    this.date = data['offerDate'];
    this.year = data['year'];
    this.mileage = data['mileage'];
  }

  String get base64Url=>base64.encode(utf8.encode(this.url));
}

class Source{
  final String name;
  final String color;

  Source(this.name, this.color);
}