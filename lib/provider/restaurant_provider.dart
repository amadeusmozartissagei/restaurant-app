import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../data/models/restaurant.dart';
import '../data/models/restaurant_detail.dart';
import '../common/result_state.dart';

/// Provider class to manage restaurant state
/// Uses sealed class ResultState for type-safe state management
class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    fetchRestaurantList();
  }

  // State for restaurant list
  ResultState<List<Restaurant>> _restaurantListState = const LoadingState();
  ResultState<List<Restaurant>> get restaurantListState => _restaurantListState;

  // State for restaurant detail
  ResultState<RestaurantDetail> _restaurantDetailState = const LoadingState();
  ResultState<RestaurantDetail> get restaurantDetailState =>
      _restaurantDetailState;

  // State for search
  ResultState<List<Restaurant>> _searchState = const NoDataState(
    'Search for restaurants',
  );
  ResultState<List<Restaurant>> get searchState => _searchState;

  /// Fetch list of all restaurants
  Future<void> fetchRestaurantList() async {
    _restaurantListState = const LoadingState();
    notifyListeners();

    try {
      final response = await apiService.getRestaurantList();

      if (response.error) {
        _restaurantListState = ErrorState(response.message);
      } else if (response.restaurants.isEmpty) {
        _restaurantListState = const NoDataState('No restaurants found');
      } else {
        _restaurantListState = SuccessState(response.restaurants);
      }
    } catch (e) {
      _restaurantListState = ErrorState(
        'Failed to load restaurants. Please check your internet connection.',
      );
    }
    notifyListeners();
  }

  /// Fetch detail of a specific restaurant
  Future<void> fetchRestaurantDetail(String id) async {
    _restaurantDetailState = const LoadingState();
    notifyListeners();

    try {
      final response = await apiService.getRestaurantDetail(id);

      if (response.error) {
        _restaurantDetailState = ErrorState(response.message);
      } else {
        _restaurantDetailState = SuccessState(response.restaurant);
      }
    } catch (e) {
      _restaurantDetailState = ErrorState(
        'Failed to load restaurant detail. Please check your internet connection.',
      );
    }
    notifyListeners();
  }

  /// Search restaurants by query
  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      _searchState = const NoDataState('Search for restaurants');
      notifyListeners();
      return;
    }

    _searchState = const LoadingState();
    notifyListeners();

    try {
      final response = await apiService.searchRestaurants(query);

      if (response.error) {
        _searchState = ErrorState(response.message);
      } else if (response.restaurants.isEmpty) {
        _searchState = NoDataState('No restaurants found for "$query"');
      } else {
        _searchState = SuccessState(response.restaurants);
      }
    } catch (e) {
      _searchState = ErrorState(
        'Failed to search restaurants. Please check your internet connection.',
      );
    }
    notifyListeners();
  }

  /// Clear search results
  void clearSearch() {
    _searchState = const NoDataState('Search for restaurants');
    notifyListeners();
  }

  // State for posting review
  ResultState<String> _postReviewState = const NoDataState('');
  ResultState<String> get postReviewState => _postReviewState;

  /// Post a review for a restaurant
  Future<bool> postReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    _postReviewState = const LoadingState();
    notifyListeners();

    try {
      final response = await apiService.postReview(
        restaurantId: restaurantId,
        name: name,
        review: review,
      );

      if (response.error) {
        _postReviewState = ErrorState(response.message);
        notifyListeners();
        return false;
      } else {
        _postReviewState = const SuccessState('Review posted successfully!');
        // Refresh restaurant detail to show new review
        await fetchRestaurantDetail(restaurantId);
        return true;
      }
    } catch (e) {
      _postReviewState = const ErrorState(
        'Failed to post review. Please check your internet connection.',
      );
      notifyListeners();
      return false;
    }
  }

  /// Reset post review state
  void resetPostReviewState() {
    _postReviewState = const NoDataState('');
    notifyListeners();
  }
}
