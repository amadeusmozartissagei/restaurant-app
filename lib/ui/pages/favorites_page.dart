import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/database_provider.dart';
import '../../common/result_state.dart';
import '../widgets/restaurant_card.dart'; // Reuse validation needed
import 'restaurant_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          return switch (provider.state) {
            LoadingState() => const Center(child: CircularProgressIndicator()),
            SuccessState(:final data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return RestaurantCard(
                  restaurant: data[index],
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return RestaurantDetailPage(
                        restaurantId: data[index].id,
                      );
                    }));
                  },
                );
              },
            ),
            NoDataState(:final message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(message),
                ],
              ),
            ),
            ErrorState(:final message) => Center(child: Text(message)),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
