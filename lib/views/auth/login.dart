import 'package:flutter/material.dart';

/// Paleta e tokens de design
class _Design {
  static const blue = Color(0xFF2563EB);        // primário
  static const title = Color(0xFF0F172A);       // azul-acinzentado escuro
  static const label = Color(0xFF334155);
  static const inputFill = Color(0xFFF8FAFC);   // quase branco
  static const divider = Color(0xFFE2E8F0);
  static const cardRadius = 16.0;
  static const maxLoginWidth = 340.0;
}

/// Página (layout responsivo)
class AuthLandingPage extends StatelessWidget {
  const AuthLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 960;

          // Mobile / estreito: só o card central
          if (!wide) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: _LoginCard(),
              ),
            );
          }

          // Desktop / largo: texto curto à esquerda + card à direita
          return Row(
            children: [
              // Lado esquerdo minimalista (sem poluir)
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 72),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Feedback de Aulas',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: _Design.title,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Melhore o ensino com feedbacks claros e objetivos.',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: _Design.title,
                                  fontWeight: FontWeight.w800,
                                  height: 1.05,
                                  letterSpacing: -0.8,
                                ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Colete opiniões dos estudantes e acompanhe métricas\nde satisfação por aula e disciplina.',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _Design.label.withOpacity(0.85),
                                  height: 1.35,
                                ),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            width: 120, height: 4,
                            decoration: BoxDecoration(
                              color: _Design.blue.withOpacity(.18),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Lado direito (card com acabamento)
              Container(
                width: 520,
                color: Colors.white,
                alignment: Alignment.center,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: _LoginCard(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Card de Login — foco no acabamento visual
class _LoginCard extends StatefulWidget {
  const _LoginCard();

  @override
  State<_LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login (demo)')),
    );
    // TODO: Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    OutlineInputBorder _border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 1),
        );

    final inputDecorationBase = InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: _Design.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: _border(_Design.divider),
      focusedBorder: _border(_Design.blue),
      errorBorder: _border(Colors.red.shade300),
      focusedErrorBorder: _border(Colors.red.shade400),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _Design.maxLoginWidth),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_Design.cardRadius),
          border: Border.all(color: const Color(0x11000000)),
          boxShadow: [
            // sombra elegante e profissional
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, 18),
            ),
            BoxShadow(
              color: _Design.blue.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Theme(
          data: theme.copyWith(inputDecorationTheme: inputDecorationBase),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bem-vindo(a) de volta',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: _Design.title,
                      letterSpacing: -.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Entre para aceder ao painel.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _Design.label.withOpacity(.85),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Email
                  _fieldLabel('Endereço de e-mail'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'voce@empresa.co.mz',
                      prefixIcon: Icon(Icons.mail_outline, size: 20),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
                      final re = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!re.hasMatch(v.trim())) return 'E-mail inválido';
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // Senha
                  _fieldLabel('Senha'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _pass,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Digite sua senha',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        tooltip: _obscure ? 'Mostrar senha' : 'Ocultar senha',
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 20),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe a senha';
                      if (v.length < 6) return 'Mínimo de 6 caracteres';
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  // Esqueci a senha alinhado à direita
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: _Design.blue,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {/* TODO: rota de recuperação */},
                      child: const Text('Esqueci a senha', style: TextStyle(fontSize: 13)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Botão Entrar (estados para Web/hover)
                  SizedBox(
                    height: 46,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.disabled)) {
                            return _Design.blue.withOpacity(.5);
                          }
                          if (states.contains(WidgetState.hovered)) {
                            return _Design.blue.withOpacity(.92);
                          }
                          return _Design.blue;
                        }),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        elevation: const WidgetStatePropertyAll(0),
                      ),
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Entrar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _Design.label,
              fontWeight: FontWeight.w600,
            ),
      );
}
