import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../reviews/data/review_service.dart';
import '../../../reviews/presentation/widgets/reviews_list_widget.dart';
import '../../../reviews/presentation/widgets/review_form_dialog.dart';

class PublicProfileScreen extends ConsumerWidget {
  final String userId;
  final String userName;
  final String? userPhoto;

  const PublicProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.userPhoto,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final isOwnProfile = currentUser?.id == userId;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(userName),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage:
                        userPhoto != null ? NetworkImage(userPhoto!) : null,
                    child: userPhoto == null
                        ? Text(
                            userName.isNotEmpty ? userName[0] : '?',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Avis et évaluations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (!isOwnProfile)
                  TextButton.icon(
                    onPressed: () async {
                      final result = await ReviewFormDialog.show(
                        context,
                        receiverId: userId,
                        receiverName: userName,
                      );
                      if (result == true) {
                        ref.invalidate(userReviewsProvider(userId));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Avis envoyé avec succès !'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.star_outline_rounded, size: 18),
                    label: const Text('Évaluer'),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            ReviewsListWidget(userId: userId),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}