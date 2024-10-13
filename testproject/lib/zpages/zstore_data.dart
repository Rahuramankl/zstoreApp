

class Data {
  final List<Categories> categories;
  final List<Card_offers> card_offers;
  final List<Products> products;


  Data({
    required this.categories,
    required this.card_offers,
    required this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      categories: (json['categories'] as List<dynamic>)
          .map((categoriesJson) => Categories.fromJson(categoriesJson))
          .toList(),
      card_offers: (json['card_offers'] as List<dynamic>)
          .map((cardOfferJson) => Card_offers.fromJson(cardOfferJson))
          .toList(),
      products: (json['products'] as List<dynamic>)
          .map((productJson) => Products.fromJson(productJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((category) => category.toJson()).toList(),
      'card_offers': card_offers.map((cardOffer) => cardOffer.toJson()).toList(),
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

}



class Categories {
  final String id;
  final String name;
  final String layout;

  Categories({
    required this.id,
    required this.name,
    required this.layout,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'] as String,
      name: json['name'] as String,
      layout: json['layout'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'layout': layout,
    };
  }
}
class Card_offers {
  final String id;
  final double percentage;
  final String cardName;
  final String offerDesc;
  final String maxDiscount;
  final String imageUrl;

  Card_offers({
    required this.id,
    required this.percentage,
    required this.cardName,
    required this.offerDesc,
    required this.maxDiscount,
    required this.imageUrl,
  });

  factory Card_offers.fromJson(Map<String, dynamic> json) {
    return Card_offers(
      id: json['id'] as String,
      percentage: json['percentage'] as double,
      cardName: json['card_name'] as String,
      offerDesc: json['offer_desc'] as String,
      maxDiscount: json['max_discount'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'percentage': percentage,
      'card_name': cardName,
      'offer_desc': offerDesc,
      'max_discount': maxDiscount,
      'image_url': imageUrl,
    };
  }
}

class Products {
  final String id;
  final String name;
  final double rating;
  final int reviewCount;
  final int price;
  final String categoryId;
  final List<String> cardOfferIds;
  final String imageUrl;
  final String description;

  Products({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.categoryId,
    required this.cardOfferIds,
    required this.imageUrl,
    required this.description,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: json['rating'] != null ? json['rating'].toDouble() : 0.0,
      reviewCount: json['review_count'] as int,
      price: json['price'] != null ? json['price'].toInt() : 0,
      categoryId: json['category_id'] as String,
      cardOfferIds: (json['card_offer_ids'] as List<dynamic>).cast<String>(),
      imageUrl: json['image_url'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'review_count': reviewCount,
      'price': price,
      'category_id': categoryId,
      'card_offer_ids': cardOfferIds,
      'image_url': imageUrl,
      'description': description,
    };
  }
}

