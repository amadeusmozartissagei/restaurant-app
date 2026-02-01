import 'package:flutter/foundation.dart';
import '../common/result_state.dart';
import '../data/db/database_helper.dart';
import '../data/models/restaurant.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  ResultState<List<Restaurant>> _state = const LoadingState();
  ResultState<List<Restaurant>> get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    if (_favorites.isNotEmpty) {
      _state = SuccessState(_favorites);
    } else {
      _state = const NoDataState('No favorites yet');
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _getFavorites();
    } catch (e) {
      _state = ErrorState('Error: $e');
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _state = ErrorState('Error: $e');
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
