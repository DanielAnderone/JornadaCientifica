import 'package:flutter/material.dart';

// PÁGINAS (use prefixos para evitar conflitos)
import 'views/auth/login.dart';
import 'views/sidebar/sidebar.dart';

import 'views/dashbord/dashboard.dart' as dash;
import 'views/aulas/aulas.dart' as aulas;
import 'views/feedbacks/feedbacks.dart' as fb;
import 'views/relatorios/relatorios_page.dart' as rel;
import 'views/notificacoes/notificacoes_page.dart' as not;
import 'views/reclamacoes/reclamacoes_page.dart' as rec;

class AppRoutes {
  static const String login = '/login';

  /// Shell sem conteúdo (placeholder “Acesse um item no menu”)
  static const String shell = '/shell';

  /// Conteúdos dentro do shell
  static const String dashboard = '/dashboard';
  static const String aulas = '/aulas';
  static const String feedbacks = '/feedbacks';

  /// detalhe (passa argumentos via `RouteSettings.arguments`)
  static const String feedbackDetail = '/feedbacks/detail';

  // Página de relatórios
  static const String relatorios = '/relatorios';

  // Página de Notificações dos feedbacks dos usuários
  static const String notificacoes = '/notificacoes';

  // Página de REclamações e feedbacks dos usuários
  static const String reclamacoes = '/reclamacoes';
}

class AppRouter {
  /// Rotas simples (sem args)
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (_) => const AuthPage(),

    // Shell vazio com mensagem
    AppRoutes.shell: (_) => const _SidebarShellPage(selectedIndex: -1),

    // Telas dentro do shell (note os prefixos e os `const` nos filhos)
    AppRoutes.dashboard: (_) => const _SidebarShellPage(
        selectedIndex: 0,
        child: dash.DashboardPage(),
      ),
    AppRoutes.aulas: (_) => _SidebarShellPage(
        selectedIndex: 1,
        child: aulas.AulasPage(),
      ),
    AppRoutes.feedbacks: (_) => const _SidebarShellPage(
        selectedIndex: 2,
        child: fb.FeedbacksReportPage(),
      ),
    AppRoutes.relatorios: (_) => const _SidebarShellPage(
      selectedIndex: 3,
      child: rel.RelatoriosPage(),
    ),
    AppRoutes.notificacoes: (_) => const _SidebarShellPage(
      selectedIndex: 4,
      child: not.NotificacoesPage(),
    ),
    AppRoutes.reclamacoes: (_) => const _SidebarShellPage(
      selectedIndex: 7,
      child: rec.ReclamacoesPage(),
    ),
  };

  /// Rotas que precisam de argumentos (ex.: detalhe de feedback)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.feedbackDetail:
        final args =
            (settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{};
        return MaterialPageRoute(
          builder: (_) => fb.FeedbackDetailPage(feedback: args),
          settings: settings,
        );
    }
    return null;
  }
}

/// Shell com sidebar à esquerda.
/// - Se [child] for nulo, mostra o placeholder “Acesse um item no menu”.
class _SidebarShellPage extends StatelessWidget {
  final int selectedIndex; // -1 para nada selecionado
  final Widget? child;

  const _SidebarShellPage({
    super.key,
    required this.selectedIndex,
    this.child,
  });

  static const _bg = Color(0xFFF8FAFC);

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
              onSelect: (i, _) {
                switch (i) {
                  case 0:
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.dashboard);
                    break;
                  case 1:
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.aulas);
                    break;
                  case 2:
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.feedbacks);
                    break;
                  case 3:
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.relatorios);
                    break;
                  case 4:
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.notificacoes);
                    break;
                  case 7:
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.reclamacoes);
                    break;
                  case 8: // Sair
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (r) => false,
                    );
                    break;
                  default:
                    break;
                }
              },
            ),
          ),
          Expanded(
            child: child ?? const _EmptyState(),
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
