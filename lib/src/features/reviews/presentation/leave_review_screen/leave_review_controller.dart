import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/utils/current_date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveReviewController extends StateNotifier<AsyncValue<void>> {
  LeaveReviewController(
      {required this.reviewService, required this.currentDateBuilder})
      : super(const AsyncData(null));

  final ReviewsService reviewService;

  final DateTime Function() currentDateBuilder;

  Future<void> submitReview({
    Review? previousReview,
    required ProductID productId,
    required double rating,
    required String comment,
    required void Function() onSuccess,
  }) async {
    // * only submit the review if it's different from the previous one
    if (previousReview == null ||
        rating != previousReview.rating ||
        comment != previousReview.comment) {
      final review = Review(
        rating: rating,
        comment: comment,
        date: currentDateBuilder(),
      );
      state = const AsyncLoading();

      final newState = await AsyncValue.guard(() async {
        await reviewService.submitReview(productId: productId, review: review);
      });

      if (mounted) {
        // * only set the state if the controller hasn't been disposed
        state = newState;
        if (state.hasError == false) {
          onSuccess();
        }
      }
    } else {
      onSuccess();
    }
  }
}

final leaveReviewControllerProvider =
    StateNotifierProvider.autoDispose<LeaveReviewController, AsyncValue<void>>(
        (ref) {
  return LeaveReviewController(
      reviewService: ref.watch(reviewsServiceProvider),
      currentDateBuilder: ref.watch(currentDateBuilderProvider));
});
