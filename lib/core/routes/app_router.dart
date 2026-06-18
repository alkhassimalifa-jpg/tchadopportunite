import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/language_selection_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/jobs/presentation/screens/jobs_list_screen.dart';
import '../../features/jobs/presentation/screens/job_detail_screen.dart';
import '../../features/jobs/presentation/screens/create_job_screen.dart';
import '../../features/jobs/domain/entities/job_entity.dart';
import '../../features/users/presentation/screens/edit_profile_screen.dart';
import '../../features/providers_map/presentation/screens/providers_map_screen.dart';
import '../../features/jobs/presentation/screens/my_applications_screen.dart';
import '../../features/company/presentation/screens/company_jobs_screen.dart';
import '../../features/company/presentation/screens/company_applications_screen.dart';
import '../../features/users/presentation/screens/public_profile_screen.dart';
import '../../features/favorites/presentation/screens/favorite_jobs_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';

// ─── Routes ───────────────────────────────────────────────────

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String languageSelection = '/language-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String roleSelection = '/role-selection';
  static const String home = '/home';
  static const String jobs = '/jobs';
  static const String jobDetail = '/jobs/:id';
  static const String editProfile = '/profile/edit';
}

// ─── Router Provider ──────────────────────────────────────────

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.languageSelection,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.jobs,
        builder: (context, state) => const JobsListScreen(),
      ),
      GoRoute(
        path: '/jobs/create',
        builder: (context, state) => const CreateJobScreen(),
      ),
      GoRoute(
        path: AppRoutes.jobDetail,
        builder: (context, state) {
          final job = state.extra as JobEntity;
          return JobDetailScreen(job: job);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const ProvidersMapScreen(),
      ),
      GoRoute(
        path: '/applications',
        builder: (context, state) => const MyApplicationsScreen(),
      ),
      GoRoute(
        path: '/company/jobs',
        builder: (context, state) => const CompanyJobsScreen(),
      ),
      GoRoute(
        path: '/company/applications',
        builder: (context, state) => const CompanyApplicationsScreen(),
      ),
      GoRoute(
        path: '/profile/:id',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PublicProfileScreen(
            userId: state.pathParameters['id']!,
            userName: extra?['name'] ?? 'Utilisateur',
            userPhoto: extra?['photo'],
          );
        },
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoriteJobsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page introuvable: ${state.uri}'),
      ),
    ),
  );
});