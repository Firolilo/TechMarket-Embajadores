import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/invitation_screen.dart';
import '../../features/auth/screens/participation_screen.dart';
import '../../features/auth/screens/confirmation_screen.dart';
import '../../features/auth/screens/payment_setup_screen.dart';
import '../../features/auth/screens/success_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/impact/screens/impact_screen.dart';
import '../../features/opportunities/screens/opportunities_screen.dart';
import '../../features/earnings/screens/earnings_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/invite/screens/invite_screen.dart';
import '../../features/missions/screens/missions_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/education/screens/education_screen.dart';
import '../../features/help/screens/help_center_screen.dart';
import '../../features/legal/screens/legal_notices_screen.dart';
import '../widgets/bottom_nav_bar.dart';

/// Shell con bottom navigation.
class MainShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  const MainShell({super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0: context.go('/dashboard'); break;
            case 1: context.go('/impact'); break;
            case 2: context.go('/opportunities'); break;
            case 3: context.go('/earnings'); break;
            case 4: context.go('/profile'); break;
          }
        },
      ),
    );
  }
}

/// Configuración del router.
GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isAuth = authProvider.isAuthenticated;
      final loc = state.matchedLocation;
      final isSplash = loc == '/splash';
      final isAuthRoute = loc == '/login' || loc.startsWith('/register') || loc == '/onboarding';

      if (isSplash) return null;
      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth && isAuthRoute) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, s) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (ctx, s) => OnboardingScreen(
        onComplete: () { ctx.read<AuthProvider>().completeOnboarding(); ctx.go('/login'); })),
      GoRoute(path: '/login', builder: (_, s) => const LoginScreen()),
      // Flujo de registro multi-paso
      GoRoute(path: '/register', builder: (_, s) => const RegisterScreen()),
      GoRoute(path: '/register/invitation', builder: (_, s) => const InvitationScreen()),
      GoRoute(path: '/register/participation', builder: (_, s) => const ParticipationScreen()),
      GoRoute(path: '/register/confirmation', builder: (_, s) => const ConfirmationScreen()),
      GoRoute(path: '/register/payment', builder: (_, s) => const PaymentSetupScreen()),
      GoRoute(path: '/register/success', builder: (_, s) => const SuccessScreen()),
      // Backoffice con shell
      ShellRoute(
        builder: (_, state, child) {
          int index = 0;
          final loc = state.matchedLocation;
          if (loc.startsWith('/impact')) { index = 1; }
          else if (loc.startsWith('/opportunities')) { index = 2; }
          else if (loc.startsWith('/earnings')) { index = 3; }
          else if (loc.startsWith('/profile') || loc.startsWith('/invite') ||
                   loc.startsWith('/missions') || loc.startsWith('/history') ||
                   loc.startsWith('/education') || loc.startsWith('/help') ||
                   loc.startsWith('/legal')) { index = 4; }
          return MainShell(currentIndex: index, child: child);
        },
        routes: [
          GoRoute(path: '/dashboard', builder: (_, s) => const DashboardScreen()),
          GoRoute(path: '/impact', builder: (_, s) => const ImpactScreen()),
          GoRoute(path: '/opportunities', builder: (_, s) => const OpportunitiesScreen()),
          GoRoute(path: '/earnings', builder: (_, s) => const EarningsScreen()),
          GoRoute(path: '/profile', builder: (_, s) => const ProfileScreen()),
          GoRoute(path: '/invite', builder: (_, s) => const InviteScreen()),
          GoRoute(path: '/missions', builder: (_, s) => const MissionsScreen()),
          GoRoute(path: '/history', builder: (_, s) => const HistoryScreen()),
          GoRoute(path: '/education', builder: (_, s) => const EducationScreen()),
          GoRoute(path: '/help', builder: (_, s) => const HelpCenterScreen()),
          GoRoute(path: '/legal', builder: (_, s) => const LegalNoticesScreen()),
        ],
      ),
    ],
  );
}
