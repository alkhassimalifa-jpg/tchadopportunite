import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/favorite_service.dart';
import '../../../jobs/presentation/widgets/job_card.dart';

class FavoriteJobsScreen extends ConsumerWidget {
  const FavoriteJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteJobsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Mes favoris'),
        backgroundColor: Colors.white,
      ),
      body: favoritesAsync.when(
        data: (jobs) {
          if (jobs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      size: 64, color: AppColors.divider),
                  SizedBox(height: 16),
                  Text(
                    'Aucune offre favorite',
                    style: TextStyle(color: AppColors.textHint),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Touchez le cœur sur une offre pour la sauvegarder',
                    style: TextStyle(color: AppColors.textHint, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(favoriteJobsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, i) => JobCard(
                job: jobs[i],
                onTap: () => context.push('/jobs/${jobs[i].id}', extra: jobs[i]),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              const Text('Erreur de chargement'),
              TextButton(
                onPressed: () => ref.invalidate(favoriteJobsProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}