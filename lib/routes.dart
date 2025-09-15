import 'package:flutter/material.dart';

// IMPORTA AS TUAS PÁGINAS
import 'views/auth/login.dart';
import 'views/dashbord/dashboard.dart';
import 'views/aulas/aulas.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String aulas = '/aulas';
}

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (_) => const AuthLandingPage(),
    AppRoutes.dashboard: (_) => const DashboardPage(),
    AppRoutes.aulas: (_) => const AulasPage(),
  };
}
