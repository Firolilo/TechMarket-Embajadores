import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/api_constants.dart';
import 'core/network/api_client.dart';
import 'core/router/app_router.dart';
import 'core/services/token_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/services/auth_service.dart';
import 'features/dashboard/providers/dashboard_provider.dart';
import 'features/earnings/providers/earnings_provider.dart';
import 'features/missions/providers/mission_provider.dart';
import 'features/opportunities/providers/opportunity_provider.dart';

class TechMarketApp extends StatelessWidget {
  const TechMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenService = TokenService();

    final apiClient = ApiClient(
      baseUrl: ApiConstants.apiBaseUrl,
      tokenService: tokenService,
    );

    final authService = AuthService(
      apiClient: apiClient,
      tokenService: tokenService,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(service: authService)),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => EarningsProvider()),
        ChangeNotifierProvider(create: (_) => OpportunityProvider()),
        ChangeNotifierProvider(create: (_) => MissionProvider()),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = context.watch<AuthProvider>();
          final router = createRouter(authProvider);
          return MaterialApp.router(
            title: 'TechMarket Embajadores',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
