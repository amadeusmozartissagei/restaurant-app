/// Restaurant Detail Model with full information
class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<Category> categories;
  final Menus menus;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      pictureId: json['pictureId'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      categories: (json['categories'] as List?)
              ?.map((item) => Category.fromJson(item))
              .toList() ??
          [],
      menus: Menus.fromJson(json['menus'] ?? {}),
      customerReviews: (json['customerReviews'] as List?)
              ?.map((item) => CustomerReview.fromJson(item))
              .toList() ??
          [],
    );
  }

  /// Get the image URL for the restaurant
  String get imageUrl =>
      'https://restaurant-api.dicoding.dev/images/medium/$pictureId';

  String get largeImageUrl =>
      'https://restaurant-api.dicoding.dev/images/large/$pictureId';
}

/// Category Model
class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name'] ?? '');
  }
}

/// Menus Model containing foods and drinks
class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json['foods'] as List?)
              ?.map((item) => MenuItem.fromJson(item))
              .toList() ??
          [],
      drinks: (json['drinks'] as List?)
              ?.map((item) => MenuItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

/// Menu Item Model (for foods and drinks)
class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name'] ?? '');
  }
}

/// Customer Review Model
class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

/// Restaurant Detail Response
class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      restaurant: RestaurantDetail.fromJson(json['restaurant'] ?? {}),
    );
  }
}
