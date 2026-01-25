import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/restaurant_provider.dart';
import '../../common/result_state.dart';
import '../../common/theme.dart';
import '../../data/models/restaurant_detail.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/review_form_widget.dart';

/// Restaurant Detail Page - Shows detailed information about a restaurant
class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      context.read<RestaurantProvider>().fetchRestaurantDetail(
        widget.restaurantId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          return switch (provider.restaurantDetailState) {
            LoadingState() => Scaffold(
              appBar: AppBar(leading: _buildBackButton(context, theme)),
              body: const LoadingIndicator(
                message: 'Loading restaurant details...',
              ),
            ),
            SuccessState<RestaurantDetail>(:final data) => _buildDetailContent(
              context,
              theme,
              data,
            ),
            ErrorState(:final message) => Scaffold(
              appBar: AppBar(leading: _buildBackButton(context, theme)),
              body: custom.ErrorWidget(
                message: message,
                onRetry: () =>
                    provider.fetchRestaurantDetail(widget.restaurantId),
              ),
            ),
            NoDataState(:final message) => Scaffold(
              appBar: AppBar(leading: _buildBackButton(context, theme)),
              body: custom.EmptyStateWidget(
                message: 'Restaurant Not Found',
                subtitle: message,
                icon: Icons.restaurant_menu_rounded,
              ),
            ),
          };
        },
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color?.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
        color: theme.iconTheme.color,
      ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    ThemeData theme,
    RestaurantDetail restaurant,
  ) {
    return CustomScrollView(
      slivers: [
        // Image Header
        SliverAppBar(
          expandedHeight: 280,
          collapsedHeight: 80,
          pinned: true,
          leading: _buildBackButton(context, theme),
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: 'restaurant-image-${restaurant.id}',
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    restaurant.largeImageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: theme.scaffoldBackgroundColor,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.scaffoldBackgroundColor,
                        child: Icon(
                          Icons.restaurant,
                          size: 80,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Content
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -30),
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name and Rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'restaurant-name-${restaurant.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                restaurant.name,
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.ratingColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppTheme.ratingColor,
                                size: 22,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                restaurant.rating.toString(),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: AppTheme.ratingColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Location Info
                    _buildInfoRow(
                      icon: Icons.location_on_rounded,
                      title: restaurant.city,
                      subtitle: restaurant.address,
                      theme: theme,
                    ),
                    const SizedBox(height: 24),

                    // Categories
                    if (restaurant.categories.isNotEmpty) ...[
                      Text(
                        'Categories',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: restaurant.categories.map((category) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Text(
                              category.name,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Description
                    Text(
                      'About',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      restaurant.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Menus Section
                    _buildMenuSection(
                      title: 'Food Menu',
                      icon: Icons.restaurant_menu_rounded,
                      items: restaurant.menus.foods,
                      theme: theme,
                      gradientColors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.7),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _buildMenuSection(
                      title: 'Drinks Menu',
                      icon: Icons.local_cafe_rounded,
                      items: restaurant.menus.drinks,
                      theme: theme,
                      gradientColors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.secondary.withValues(alpha: 0.7),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Customer Reviews Section
                    Row(
                      children: [
                        Icon(
                          Icons.reviews_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Customer Reviews',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (restaurant.customerReviews.isNotEmpty)
                          Text(
                            '${restaurant.customerReviews.length} reviews',
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Review Form
                    ReviewFormWidget(restaurantId: restaurant.id),

                    // Reviews List
                    if (restaurant.customerReviews.isNotEmpty) ...[
                      ...restaurant.customerReviews.map((review) {
                        return _buildReviewCard(review, theme);
                      }),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.rate_review_outlined,
                                size: 48,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No reviews yet',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Be the first to share your experience!',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection({
    required String title,
    required IconData icon,
    required List<MenuItem> items,
    required ThemeData theme,
    required List<Color> gradientColors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: gradientColors.first.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${items.length} items',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: gradientColors.first,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(item.name, style: theme.textTheme.bodyMedium),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReviewCard(CustomerReview review, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                child: Text(
                  review.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(review.date, style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"${review.review}"',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
