import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/restaurant_provider.dart';
import '../../common/result_state.dart';
import '../../data/models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_widget.dart' as custom;
import 'restaurant_detail_page.dart';

/// Search Page - Allows users to search for restaurants
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<RestaurantProvider>().searchRestaurants(query);
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<RestaurantProvider>().clearSearch();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.primary,
          ),
          onPressed: () {
            context.read<RestaurantProvider>().clearSearch();
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search restaurants...',
            hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          style: theme.textTheme.bodyLarge,
          textInputAction: TextInputAction.search,
          onChanged: _onSearch,
          onSubmitted: _onSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close_rounded, color: theme.colorScheme.primary),
              onPressed: _clearSearch,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          return switch (provider.searchState) {
            LoadingState() => const LoadingIndicator(
              message: 'Searching restaurants...',
            ),
            SuccessState<List<Restaurant>>(:final data) => _buildSearchResults(
              context,
              data,
            ),
            ErrorState(:final message) => custom.ErrorWidget(
              message: message,
              onRetry: () => _onSearch(_searchController.text),
            ),
            NoDataState(:final message) => _buildEmptyState(context, message),
          };
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_rounded,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter a restaurant name, city, or menu item to find restaurants',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    List<Restaurant> restaurants,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            '${restaurants.length} result${restaurants.length > 1 ? 's' : ''} found',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                onTap: () => _navigateToDetail(context, restaurant),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToDetail(BuildContext context, Restaurant restaurant) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RestaurantDetailPage(restaurantId: restaurant.id),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
