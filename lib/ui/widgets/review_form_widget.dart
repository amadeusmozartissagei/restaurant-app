import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/restaurant_provider.dart';
import '../../common/result_state.dart';

/// Review Form Widget - Allows users to submit a review
class ReviewFormWidget extends StatelessWidget {
  final String restaurantId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ReviewFormWidget({super.key, required this.restaurantId});

  Future<void> _submitReview(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController reviewController,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<RestaurantProvider>();
    final success = await provider.postReview(
      restaurantId: restaurantId,
      name: nameController.text.trim(),
      review: reviewController.text.trim(),
    );

    if (success && context.mounted) {
      // Clear the form
      nameController.clear();
      reviewController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Review submitted successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else if (context.mounted) {
      // Get error message from provider state
      String errorMessage = 'Failed to submit review. Please try again.';
      if (provider.postReviewState is ErrorState) {
        errorMessage = (provider.postReviewState as ErrorState).message;
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(errorMessage),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Create controllers - they will be recreated on each build
    // but that's acceptable for this simple form
    final nameController = TextEditingController();
    final reviewController = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.08),
            theme.colorScheme.secondary.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.rate_review_rounded,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Write a Review',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Name Field
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: theme.colorScheme.primary,
                ),
                filled: true,
                fillColor: theme.cardTheme.color,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            // Review Field
            TextFormField(
              controller: reviewController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: 'Your Review',
                hintText: 'Share your experience...',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Icon(
                    Icons.comment_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                filled: true,
                fillColor: theme.cardTheme.color,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please write your review';
                }
                if (value.trim().length < 10) {
                  return 'Review must be at least 10 characters';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: Consumer<RestaurantProvider>(
                builder: (context, provider, child) {
                  final isLoading = provider.postReviewState is LoadingState;

                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => _submitReview(
                              context,
                              nameController,
                              reviewController,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Submit Review',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
