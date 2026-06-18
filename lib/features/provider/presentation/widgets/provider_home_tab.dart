import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../users/data/profile_service.dart';
import '../../../jobs/data/job_service.dart';

class ProviderHomeTab extends ConsumerStatefulWidget {
  const ProviderHomeTab({super.key});

  @override
  ConsumerState<ProviderHomeTab> createState() => _ProviderHomeTabState();
}

class _ProviderHomeTabState extends ConsumerState<ProviderHomeTab> {
  bool _isUpdatingAvailability = false;

  Future<void> _toggleAvailability(bool value) async {
    setState(() => _isUpdatingAvailability = true);
    try {
      await ref.read(profileServiceProvider).updateProfile(availability: value);
      ref.invalidate(myProfileProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdatingAvailability = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(myProfileProvider);
    final statsAsync = ref.watch(myStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myProfileProvider);
            ref.invalidate(myStatsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          user?.firstName.isNotEmpty == true
                              ? user!.firstName[0]
                              : '?',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour, ${user?.firstName ?? ''}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Text(
                            'Espace prestataire',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Availability card
                profileAsync.when(
                  data: (profile) {
                    final isAvailable = profile?.availability ?? true;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? AppColors.success.withOpacity(0.08)
                            : AppColors.textHint.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isAvailable
                              ? AppColors.success.withOpacity(0.3)
                              : AppColors.divider,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isAvailable
                                ? Icons.check_circle_rounded
                                : Icons.pause_circle_filled_rounded,
                            color: isAvailable
                                ? AppColors.success
                                : AppColors.textHint,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAvailable
                                      ? 'Vous êtes disponible'
                                      : 'Vous êtes indisponible',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  isAvailable
                                      ? 'Visible pour les nouvelles missions'
                                      : 'Masqué des recherches',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _isUpdatingAvailability
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Switch(
                                  value: isAvailable,
                                  activeColor: AppColors.success,
                                  onChanged: _toggleAvailability,
                                ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 70,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, st) => const SizedBox(),
                ),

                const SizedBox(height: 20),

                // Stats
                statsAsync.when(
                  data: (stats) => Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.send_outlined,
                          value: '${stats['applicationsCount'] ?? 0}',
                          label: 'Candidatures envoyées',
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.star_outline_rounded,
                          value: (stats['averageRating'] ?? 0)
                              .toStringAsFixed(1),
                          label: '${stats['reviewsCount'] ?? 0} avis',
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  loading: () => const SizedBox(
                    height: 90,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, st) => const SizedBox(),
                ),

                const SizedBox(height: 28),

                // Quick actions
                const Text(
                  'Actions rapides',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.work_outline_rounded,
                        label: 'Voir les offres',
                        color: AppColors.primary,
                        onTap: () => context.push(AppRoutes.jobs),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.send_outlined,
                        label: 'Mes candidatures',
                        color: AppColors.secondary,
                        onTap: () => context.push('/applications'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.map_outlined,
                        label: 'Prestataires proches',
                        color: const Color(0xFF8B5CF6),
                        onTap: () => context.push('/map'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.person_outline_rounded,
                        label: 'Mon profil',
                        color: AppColors.warning,
                        onTap: () => context.push(AppRoutes.editProfile),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}