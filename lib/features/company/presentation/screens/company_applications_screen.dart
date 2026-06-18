import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/theme/app_theme.dart';
import '../../data/company_service.dart';
import '../../domain/entities/received_application_entity.dart';
import '../../../messaging/presentation/screens/chat_screen.dart';

class CompanyApplicationsScreen extends ConsumerWidget {
  const CompanyApplicationsScreen({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(receivedApplicationsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Candidatures reçues'),
        backgroundColor: Colors.white,
      ),
      body: applicationsAsync.when(
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: AppColors.divider),
                  SizedBox(height: 16),
                  Text(
                    'Aucune candidature reçue',
                    style: TextStyle(color: AppColors.textHint),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(receivedApplicationsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: applications.length,
              itemBuilder: (context, i) {
                final app = applications[i];
                return _ApplicationCard(
                  application: app,
                  statusColor: _statusColor(app.status),
                  statusLabel: _statusLabel(app.status),
                  onStatusChange: (status) async {
                    try {
                      await ref
                          .read(companyServiceProvider)
                          .updateApplicationStatus(app.id, status);
                      ref.invalidate(receivedApplicationsProvider);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur: $e')),
                        );
                      }
                    }
                  },
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
                onPressed: () => ref.invalidate(receivedApplicationsProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final ReceivedApplicationEntity application;
  final Color statusColor;
  final String statusLabel;
  final Function(String) onStatusChange;

  const _ApplicationCard({
    required this.application,
    required this.statusColor,
    required this.statusLabel,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
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
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: application.applicantPhoto != null
                    ? NetworkImage(application.applicantPhoto!)
                    : null,
                child: application.applicantPhoto == null
                    ? Text(
                        application.applicantName.isNotEmpty
                            ? application.applicantName[0]
                            : '?',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.applicantName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'pour ${application.jobTitle}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
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
                'Reçue ${timeago.format(application.createdAt, locale: 'fr')}',
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
            ],
          ),

          if (application.coverLetter != null &&
              application.coverLetter!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              application.coverLetter!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          partnerId: application.applicantId,
                          partnerName: application.applicantName,
                          partnerPhoto: application.applicantPhoto,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('Message'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PopupMenuButton<String>(
                  onSelected: onStatusChange,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'REVIEWED',
                      child: Text('Marquer comme examinée'),
                    ),
                    const PopupMenuItem(
                      value: 'ACCEPTED',
                      child: Text('Accepter'),
                    ),
                    const PopupMenuItem(
                      value: 'REJECTED',
                      child: Text('Refuser'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Statut',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}