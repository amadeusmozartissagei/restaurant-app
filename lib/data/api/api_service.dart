import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/restaurant_detail.dart';

/// API Service for fetching restaurant data from Dicoding Restaurant API
class ApiService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetch list of restaurants
  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await client.get(Uri.parse('$baseUrl/list'));

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  /// Fetch restaurant detail by ID
  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  /// Search restaurants
  Future<RestaurantListResponse> searchRestaurants(String query) async {
    final response = await client.get(Uri.parse('$baseUrl/search?q=$query'));

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurants');
    }
  }

  /// Post a review for a restaurant
  Future<ReviewResponse> postReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/review'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': restaurantId, 'name': name, 'review': review}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReviewResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post review');
    }
  }
}

/// Review Response Model
class ReviewResponse {
  final bool error;
  final String message;

  ReviewResponse({required this.error, required this.message});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
