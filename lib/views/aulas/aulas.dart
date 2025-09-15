import 'package:flutter/material.dart';

class AulasPage extends StatelessWidget {
  const AulasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aulas')),
      body: const Center(
        child: Text('Lista de aulas (placeholder)'),
      ),
    );
  }
}
