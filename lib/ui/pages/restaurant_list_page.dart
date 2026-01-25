import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/restaurant_provider.dart';
import '../../provider/theme_provider.dart';
import '../../common/result_state.dart';
import '../../data/models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_widget.dart' as custom;
import 'restaurant_detail_page.dart';

/// Restaurant List Page - Main page showing all restaurants
class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: theme.scaffoldBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Restaurants',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                        theme.colorScheme.secondary.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                // Theme Toggle Button
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return RotationTransition(
                            turns: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          themeProvider.themeMode == ThemeMode.dark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          key: ValueKey(themeProvider.themeMode),
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                      tooltip: 'Toggle theme',
                    );
                  },
                ),
                // Refresh Button
                IconButton(
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    context.read<RestaurantProvider>().fetchRestaurantList();
                  },
                  tooltip: 'Refresh',
                ),
                const SizedBox(width: 8),
              ],
            ),
          ];
        },
        body: Consumer<RestaurantProvider>(
          builder: (context, provider, child) {
            return switch (provider.restaurantListState) {
              LoadingState() => const LoadingIndicator(
                  message: 'Loading restaurants...',
                ),
              SuccessState<List<Restaurant>>(:final data) =>
                _buildRestaurantList(context, data),
              ErrorState(:final message) => custom.ErrorWidget(
                  message: message,
                  onRetry: () => provider.fetchRestaurantList(),
                ),
              NoDataState(:final message) => custom.EmptyStateWidget(
                  message: 'No Restaurants',
                  subtitle: message,
                  icon: Icons.restaurant_menu_rounded,
                ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantList(BuildContext context, List<Restaurant> restaurants) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<RestaurantProvider>().fetchRestaurantList();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return RestaurantCard(
            restaurant: restaurant,
            onTap: () => _navigateToDetail(context, restaurant),
          );
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Restaurant restaurant) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RestaurantDetailPage(restaurantId: restaurant.id),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
