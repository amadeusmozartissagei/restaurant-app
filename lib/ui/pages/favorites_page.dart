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
          if (provider.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == ResultState.hasData) {
            return ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                return RestaurantCard(
                  restaurant: provider.favorites[index],
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return RestaurantDetailPage(
                        restaurantId: provider.favorites[index].id,
                      );
                    }));
                  },
                );
              },
            );
          } else if (provider.state == ResultState.noData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('You have no favorites yet'),
                ],
              ),
            );
          } else {
            return Center(child: Text(provider.message));
          }
        },
      ),
    );
  }
}
