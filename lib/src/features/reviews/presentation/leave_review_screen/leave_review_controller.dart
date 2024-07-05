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
    required ProductID productId,
    required double rating,
    required String comment,
  }) async {
    final review = Review(
      rating: rating,
      comment: comment,
      date: currentDateBuilder(),
    );
    state = const AsyncLoading();
    /* 
    Another issue is that if we submit a review and close the page before the operation has completed, we get this error:

    StateError (Bad state: Tried to use LeaveReviewController after `dispose` was called.)
 
    Consider checking `mounted`.
    This can be fixed by checking the mounted property in the LeaveReviewController:
    */
    // state = await AsyncValue.guard(() async {
    //   await reviewService.submitReview(productId: productId, review: review);
    // });

    final newState = await AsyncValue.guard(() async {
      await reviewService.submitReview(productId: productId, review: review);
    });

    if (mounted) {
      // * only set the state if the controller hasn't been disposed
      state = newState;
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
