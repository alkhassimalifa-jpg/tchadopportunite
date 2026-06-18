import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
 
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
 
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
 
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour 👋',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        user?.firstName ?? 'Utilisateur',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
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
                            color: AppColors.primary,
                          ),
                  ),
                ],
              ),
 
              const SizedBox(height: 24),
 
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textHint),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Rechercher un métier, prestataire...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 14,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/map'),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.map_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
 
              const SizedBox(height: 28),
 
              // Categories
              const Text(
                'Catégories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _CategoryCard(icon: Icons.computer_rounded, label: 'Informatique', color: Color(0xFF1A6FDB)),
                    _CategoryCard(icon: Icons.build_rounded, label: 'Artisanat', color: Color(0xFFF59E0B)),
                    _CategoryCard(icon: Icons.local_hospital_rounded, label: 'Santé', color: Color(0xFF10B981)),
                    _CategoryCard(icon: Icons.school_rounded, label: 'Éducation', color: Color(0xFF8B5CF6)),
                    _CategoryCard(icon: Icons.restaurant_rounded, label: 'Restauration', color: Color(0xFFEF4444)),
                    _CategoryCard(icon: Icons.directions_car_rounded, label: 'Transport', color: Color(0xFF06B6D4)),
                  ],
                ),
              ),
 
              const SizedBox(height: 28),
 
              // Stats
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '2,450+',
                      label: 'Prestataires',
                      icon: Icons.people_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      value: '850+',
                      label: 'Offres d\'emploi',
                      icon: Icons.work_rounded,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
 
              const SizedBox(height: 28),
 
              // Recent jobs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Offres récentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Voir tout'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
 
              // Job cards placeholder
              _JobCard(
                title: 'Développeur Flutter',
                company: 'TechChad SARL',
                location: 'N\'Djamena',
                salary: '300 000 FCFA',
                type: 'CDI',
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              _JobCard(
                title: 'Comptable Senior',
                company: 'Banque Sahel',
                location: 'N\'Djamena',
                salary: '250 000 FCFA',
                type: 'CDI',
                color: AppColors.secondary,
              ),
              const SizedBox(height: 12),
              _JobCard(
                title: 'Électricien',
                company: 'Particulier',
                location: 'Moundou',
                salary: '15 000 FCFA/j',
                type: 'Freelance',
                color: const Color(0xFF8B5CF6),
              ),
 
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
 
  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.color,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
 
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
 
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
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
        ],
      ),
    );
  }
}
 
class _JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String salary;
  final String type;
  final Color color;
 
  const _JobCard({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.type,
    required this.color,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.business_rounded, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  company,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppColors.textHint),
                    const SizedBox(width: 2),
                    Text(
                      location,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.attach_money_rounded,
                        size: 14, color: AppColors.textHint),
                    Text(
                      salary,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}