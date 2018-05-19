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
  final String image;

  Offer(this.title, this.price, this.source, this.url, this.image);
}

class Source{
  final String name;
  final String color;

  Source(this.name, this.color);
}