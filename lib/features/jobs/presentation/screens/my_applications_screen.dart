import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/services/api_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/application_entity.dart';

final myApplicationsProvider =
    FutureProvider.autoDispose<List<ApplicationEntity>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get('/jobs/me/applications');
  return (response.data['data']['applications'] as List)
      .map((a) => ApplicationEntity.fromJson(a))
      .toList();
});

class MyApplicationsScreen extends ConsumerWidget {
  const MyApplicationsScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'ACCEPTED': return AppColors.success;
      case 'REJECTED': return AppColors.error;
      case 'REVIEWED': return AppColors.warning;
      default: return AppColors.textSecondary;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'ACCEPTED': return 'Acceptée';
      case 'REJECTED': return 'Refusée';
      case 'REVIEWED': return 'Examinée';
      default: return 'En attente';
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'ACCEPTED': return Icons.check_circle_rounded;
      case 'REJECTED': return Icons.cancel_rounded;
      case 'REVIEWED': return Icons.visibility_rounded;
      default: return Icons.hourglass_top_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(myApplicationsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Mes candidatures'),
        backgroundColor: Colors.white,
      ),
      body: applicationsAsync.when(
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_outlined, size: 64, color: AppColors.divider),
                  SizedBox(height: 16),
                  Text(
                    'Aucune candidature envoyée',
                    style: TextStyle(color: AppColors.textHint),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Parcourez les offres et postulez !',
                    style: TextStyle(color: AppColors.textHint, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myApplicationsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: applications.length,
              itemBuilder: (context, i) {
                final app = applications[i];
                final job = app.job;
                final color = _statusColor(app.status);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job?.title ?? 'Offre supprimée',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  job?.companyName ?? '',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_statusIcon(app.status), size: 14, color: color),
                                const SizedBox(width: 4),
                                Text(
                                  _statusLabel(app.status),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 13, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(
                            'Postulé ${timeago.format(app.createdAt, locale: 'fr')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      if (job != null) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                context.push('/jobs/${job.id}', extra: job),
                            child: const Text('Voir l\'offre'),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
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
                onPressed: () => ref.invalidate(myApplicationsProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
