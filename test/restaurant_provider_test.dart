import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';

import 'restaurant_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;
  late RestaurantProvider restaurantProvider;
  late RestaurantListResponse tResponse;

  setUp(() {
    mockApiService = MockApiService();
    tResponse = RestaurantListResponse(
      error: false,
      message: 'success',
      count: 1,
      restaurants: [
        Restaurant(
          id: 'rqdv5juczeskfw1e867',
          name: 'Melting Pot',
          description: 'Lorem ipsum dolor sit amet',
          pictureId: '14',
          city: 'Medan',
          rating: 4.2,
        )
      ],
    );
  });

  group('RestaurantProvider Tests', () {
    test('should return LoadingState initially', () {
      when(mockApiService.getRestaurantList())
          .thenAnswer((_) async => tResponse);
      restaurantProvider = RestaurantProvider(apiService: mockApiService);
      expect(restaurantProvider.restaurantListState, isA<LoadingState>());
    });

    test('should return SuccessState when data is fetched successfully',
        () async {
      when(mockApiService.getRestaurantList())
          .thenAnswer((_) async => tResponse);
      restaurantProvider = RestaurantProvider(apiService: mockApiService);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(restaurantProvider.restaurantListState, isA<SuccessState>());
      final state = restaurantProvider.restaurantListState
          as SuccessState<List<Restaurant>>;
      expect(state.data.length, tResponse.restaurants.length);
    });

    test('should return ErrorState when data fetching fails', () async {
      when(mockApiService.getRestaurantList())
          .thenThrow(Exception('Failed to load restaurant list'));

      restaurantProvider = RestaurantProvider(apiService: mockApiService);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(restaurantProvider.restaurantListState, isA<ErrorState>());
      final state = restaurantProvider.restaurantListState as ErrorState;
      expect(state.message, contains('Failed to load restaurants'));
    });
  });
}
