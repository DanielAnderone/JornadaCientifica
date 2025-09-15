import 'package:flutter/material.dart';
import '../../../routes.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.aulas),
              child: const Text('Ir para Aulas'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
              child: const Text('Sair (voltar ao Login)'),
            ),
          ],
        ),
      ),
    );
  }
}
