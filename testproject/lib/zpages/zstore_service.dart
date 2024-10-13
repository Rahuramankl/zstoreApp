import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:testproject/zpages/zstore_data.dart';



class UserService {

  Future<Data> getData() async {
    Map<String,dynamic> response = await getApi();
    List<Card_offers> cardOffer = [];
    List<Categories> categories = [];
    List<Products> products = [];

    final dataResponse = response;
    List cardList = dataResponse["card_offers"];
    for(int i= 0; i < cardList.length; i++){
      Map<String,dynamic> item = cardList[i] as Map<String,dynamic>;
      cardOffer.add(Card_offers.fromJson(item));
    }

    List categore = dataResponse["category"];
    for(int i = 0; i <categore.length ; i++){
      Map<String,dynamic> item = categore[i] as Map<String,dynamic>;
      categories.add(Categories.fromJson(item));

    }

    List product = dataResponse["products"];
    for(var i= 0; i < product.length; i++){
      Map<String,dynamic> item = product[i] as Map<String,dynamic>;
      products.add(Products.fromJson(item));
    }
    return Data(card_offers:cardOffer,categories:categories,products:products);
  }

  Future<Map<String,dynamic>> getApi() async {
    final response = await http.get(Uri.parse("https://raw.githubusercontent.com/princesolomon/zstore/main/data.json"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}