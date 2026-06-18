import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  List<_RoleData> _roles(BuildContext context) => [
    _RoleData(
      role: 'CLIENT',
      icon: Icons.person_search_outlined,
      title: context.tr('client'),
      desc: context.tr('role_client_desc'),
      color: AppColors.primary,
    ),
    _RoleData(
      role: 'PROVIDER',
      icon: Icons.handyman_outlined,
      title: context.tr('provider'),
      desc: context.tr('role_provider_desc'),
      color: AppColors.secondary,
    ),
    _RoleData(
      role: 'COMPANY',
      icon: Icons.business_outlined,
      title: context.tr('company'),
      desc: context.tr('role_company_desc'),
      color: const Color(0xFF8B5CF6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final roles = _roles(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                context.tr('what_is_your_role'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('choose_role_desc'),
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.separated(
                  itemCount: roles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final role = roles[i];
                    final selected = _selectedRole == role.role;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedRole = role.role),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: selected
                              ? role.color.withOpacity(0.06)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected ? role.color : AppColors.divider,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: role.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(role.icon, color: role.color, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role.title,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? role.color
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    role.desc,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selected)
                              Icon(Icons.check_circle_rounded,
                                  color: role.color, size: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectedRole == null
                    ? null
                    : () => context.go(
                          AppRoutes.register,
                          extra: _selectedRole,
                        ),
                child: Text(context.tr('continue')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleData {
  final String role;
  final IconData icon;
  final String title;
  final String desc;
  final Color color;

  _RoleData({
    required this.role,
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });
}