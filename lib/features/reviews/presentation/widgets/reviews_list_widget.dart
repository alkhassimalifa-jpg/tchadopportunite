import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/theme/app_theme.dart';
import '../../data/review_service.dart';

class ReviewsListWidget extends ConsumerWidget {
  final String userId;

  const ReviewsListWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(userReviewsProvider(userId));

    return reviewsAsync.when(
      data: (data) {
        final reviews = data['reviews'] as List;
        final avgRating = data['averageRating'] as double;
        final total = data['totalReviews'] as int;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.gold.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Text(
                    avgRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < avgRating.round()
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: AppColors.gold,
                            size: 18,
                          );
                        }),
                      ),
                      Text(
                        '$total avis',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (reviews.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Aucun avis pour le moment',
                    style: TextStyle(color: AppColors.textHint),
                  ),
                ),
              )
            else
              ...reviews.map((review) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primaryLight,
                            backgroundImage: review.giverPhoto != null
                                ? NetworkImage(review.giverPhoto!)
                                : null,
                            child: review.giverPhoto == null
                                ? Text(
                                    review.giverName.isNotEmpty
                                        ? review.giverName[0]
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.giverName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < review.rating
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      color: AppColors.gold,
                                      size: 13,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            timeago.format(review.createdAt, locale: 'fr'),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      if (review.comment != null &&
                          review.comment!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          review.comment!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
          ],
        );
      },
      loading: () => const Center(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      )),
      error: (e, st) => const SizedBox(),
    );
  }
}