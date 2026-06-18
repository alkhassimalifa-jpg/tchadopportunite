import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import 'review_entity.dart';

class ReviewService {
  final ApiClient _api;

  ReviewService(this._api);

  Future<void> createReview({
    required String receiverId,
    required int rating,
    String? comment,
  }) async {
    await _api.post('/reviews', data: {
      'receiverId': receiverId,
      'rating': rating,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    });
  }

  Future<Map<String, dynamic>> getUserReviews(String userId) async {
    final response = await _api.get('/reviews/user/$userId');
    final data = response.data['data'];
    return {
      'reviews': (data['reviews'] as List)
          .map((r) => ReviewEntity.fromJson(r))
          .toList(),
      'averageRating': (data['averageRating'] as num).toDouble(),
      'totalReviews': data['totalReviews'] as int,
    };
  }

  Future<void> deleteReview(String reviewId) async {
    await _api.delete('/reviews/$reviewId');
  }
}

final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService(ref.read(apiClientProvider));
});

final userReviewsProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, userId) async {
  return ref.read(reviewServiceProvider).getUserReviews(userId);
});