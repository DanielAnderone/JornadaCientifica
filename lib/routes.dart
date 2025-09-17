import 'package:flutter/material.dart';

// PÁGINAS
import 'views/auth/login.dart';
import 'views/dashbord/dashboard.dart';
import 'views/aulas/aulas.dart';
import 'views/feedbacks/feedbacks.dart'; // sua página de “relatório de feedbacks”

// Sidebar visual (apenas o widget da barra)
import 'views/sidebar/sidebar.dart';

class AppRoutes {
  static const String login = '/login';

  /// Shell sem conteúdo (placeholder “Acesse um item no menu”)
  static const String shell = '/shell';

  /// Conteúdos dentro do shell
  static const String dashboard = '/dashboard';
  static const String aulas = '/aulas';
  static const String feedbacks = '/feedbacks';

  /// detalhe (opcional), se você tiver uma página que exige argumentos
  static const String feedbackDetail = '/feedbacks/detail';
}

class AppRouter {
  /// Rotas simples (sem args)
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (_) => const AuthPage(),

    // Shell vazio com mensagem “Acesse um item no menu”
    AppRoutes.shell: (_) => const _SidebarShellPage(selectedIndex: -1),

    // As telas reais dentro do shell
    AppRoutes.dashboard: (_) => const _SidebarShellPage(
          selectedIndex: 0,
          child: DashboardPage(),
        ),
    AppRoutes.aulas: (_) => const _SidebarShellPage(
          selectedIndex: 1,
          child: AulasPage(),
        ),
    AppRoutes.feedbacks: (_) => const _SidebarShellPage(
          selectedIndex: 2,
          child: FeedbacksReportPage(), // página geral de relatórios de feedbacks
        ),
  };

  /// Rotas que precisam de argumentos (ex.: detalhe de feedback)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.feedbackDetail:
        final dynamic arg = settings.arguments; // passe seu modelo/ID pelo arguments
        return MaterialPageRoute(
          builder: (_) => FeedbackDetailPage(feedback: arg),
          settings: settings,
        );
    }
    return null;
  }
}

/// Shell com sidebar à esquerda.
/// - Se [child] for nulo ➜ mostra placeholder “Acesse um item no menu”.
class _SidebarShellPage extends StatelessWidget {
  final int selectedIndex; // -1 para nada selecionado
  final Widget? child;

  const _SidebarShellPage({
    super.key,
    required this.selectedIndex,
    this.child,
  });

  static const _bg = Color(0xFFF8FAFC);
  static const _blue1 = Color(0xFF1E3A8A);
  static const _blue2 = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: AppSidebar(
              selectedIndex: selectedIndex,
              onSelect: (i, label) {
                // Navegação centralizada por índice
                switch (i) {
                  case 0:
                    Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
                    break;
                  case 1:
                    Navigator.of(context).pushReplacementNamed(AppRoutes.aulas);
                    break;
                  case 2:
                    Navigator.of(context).pushReplacementNamed(AppRoutes.feedbacks);
                    break;
                  case 8: // Sair
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
                    break;
                  default:
                    // ainda não implementadas (Relatórios, Conta, etc.)
                    break;
                }
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
              
                // Conteúdo ou placeholder
                Expanded(
                  child: child ?? const _EmptyState(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Acesse um item no menu',
        style: TextStyle(
          color: Colors.black.withOpacity(.55),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
  