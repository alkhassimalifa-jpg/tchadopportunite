import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: user?.photoUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    user!.photoUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.person_rounded,
                                  size: 44,
                                  color: AppColors.primary,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.fullName ?? 'Mon Profil',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Badge(
                          label: _roleLabel(context, user?.role),
                          color: AppColors.primary,
                        ),
                        if (user?.isVerified == true) ...[
                          const SizedBox(width: 8),
                          const _Badge(
                            label: '✓ Vérifié',
                            color: AppColors.success,
                          ),
                        ],
                        if (user?.isPremium == true) ...[
                          const SizedBox(width: 8),
                          const _Badge(
                            label: '★ Premium',
                            color: AppColors.gold,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Menu items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      label: context.tr('edit_profile'),
                      onTap: () => context.push(AppRoutes.editProfile),
                    ),

                    // ─── Entreprise ──────────────────────────
                    if (user?.role == 'COMPANY') ...[
                      _MenuItem(
                        icon: Icons.work_outline_rounded,
                        label: context.tr('my_posted_jobs'),
                        onTap: () => context.push('/company/jobs'),
                      ),
                      _MenuItem(
                        icon: Icons.people_outline_rounded,
                        label: context.tr('received_applications'),
                        onTap: () => context.push('/company/applications'),
                      ),
                    ],

                    // ─── Client / Prestataire ────────────────
                    if (user?.role == 'CLIENT' || user?.role == 'PROVIDER') ...[
                      _MenuItem(
                        icon: Icons.send_outlined,
                        label: context.tr('my_applications'),
                        onTap: () => context.push('/applications'),
                      ),
                      _MenuItem(
                        icon: Icons.favorite_border_rounded,
                        label: context.tr('favorites'),
                        onTap: () => context.push('/favorites'),
                      ),
                    ],

                    // ─── Tous les rôles ──────────────────────
                    _MenuItem(
                      icon: Icons.star_outline_rounded,
                      label: context.tr('my_reviews'),
                      onTap: () => context.push(
                        '/profile/${user?.id}',
                        extra: {
                          'name': '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                          'photo': user?.photoUrl,
                        },
                      ),
                    ),
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      label: context.tr('notifications'),
                      onTap: () => context.push('/notifications'),
                    ),
                    _MenuItem(
                      icon: Icons.language_outlined,
                      label: context.tr('language'),
                      trailing: Text(
                        _languageLabel(Localizations.localeOf(context)),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      onTap: () => _showLanguageDialog(context, ref),
                    ),
                    _MenuItem(
                      icon: Icons.dark_mode_outlined,
                      label: context.tr('theme'),
                      trailing: Switch(
                        value: ref.watch(themeModeProvider) == ThemeMode.dark,
                        activeColor: AppColors.primary,
                        onChanged: (_) =>
                            ref.read(themeModeProvider.notifier).toggle(),
                      ),
                      onTap: () =>
                          ref.read(themeModeProvider.notifier).toggle(),
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: context.tr('help_support'),
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    _MenuItem(
                      icon: Icons.logout_rounded,
                      label: context.tr('logout'),
                      color: AppColors.error,
                      onTap: () async {
                        await ref.read(authStateProvider.notifier).logout();
                        if (context.mounted) context.go(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  String _roleLabel(BuildContext context, String? role) {
    switch (role) {
      case 'CLIENT': return context.tr('client');
      case 'PROVIDER': return context.tr('provider');
      case 'COMPANY': return context.tr('company');
      case 'ADMIN': return 'Admin';
      default: return 'Utilisateur';
    }
  }

  String _languageLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'en': return 'English';
      case 'ar': return 'العربية';
      default: return 'Français';
    }
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr('language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              label: 'Français',
              flag: '🇫🇷',
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('fr'));
                Navigator.of(ctx).pop();
              },
            ),
            _LanguageOption(
              label: 'English',
              flag: '🇬🇧',
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.of(ctx).pop();
              },
            ),
            _LanguageOption(
              label: 'العربية',
              flag: '🇹🇩',
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String flag;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.flag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(label),
      onTap: onTap,
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final Color? color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.trailing,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: c, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: c,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textHint,
                ),
          ],
        ),
      ),
    );
  }
}