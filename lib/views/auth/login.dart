import 'package:flutter/material.dart';
import '../../routes.dart'; // usa AppRoutes.shell após login

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: _ResponsiveShell(),
    );
  }
}

class _Tokens {
  static const blue1 = Color(0xFF1E3A8A); // azul escuro
  static const blue2 = Color(0xFF2563EB); // azul principal
  static const textDark = Color(0xFF111827);
  static const label = Color(0xFF6B7280);
  static const inputFill = Color(0xFFF9FAFB);
  static const divider = Color(0xFFE5E7EB);
  static const radius = 12.0;
}

class _ResponsiveShell extends StatelessWidget {
  const _ResponsiveShell();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 1024;

        if (!wide) {
          // mobile: só o formulário centralizado
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: const _RightForm(),
              ),
            ),
          );
        }

        // desktop/tablet largo — margens brancas, cartão azul à esquerda e formulário à direita
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 60),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Esquerda: cartão azul CENTRALIZADO (não ocupa 50%)
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: const _LeftHeroCard(),
                  ),
                ),
              ),
              const SizedBox(width: 80),
              // Direita: formulário CENTRALIZADO e com largura fixa
              SizedBox(
                width: 560,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: const _RightForm(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Cartão azul com textos e botão centralizados
class _LeftHeroCard extends StatelessWidget {
  const _LeftHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_Tokens.blue1, _Tokens.blue2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Pronto para melhorar as suas aulas?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Colete feedbacks dos estudantes, avalie a qualidade das '
                  'aulas e acompanhe métricas que ajudam a crescer como docente.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(.92),
                        height: 1.55,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.4),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      // TODO: rota cadastro
                    },
                    child: const Text('Criar conta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RightForm extends StatefulWidget {
  const _RightForm();

  @override
  State<_RightForm> createState() => _RightFormState();
}

class _RightFormState extends State<_RightForm> {
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

  InputDecoration _input(String hint) {
    OutlineInputBorder _b(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(_Tokens.radius),
          borderSide: BorderSide(color: c, width: 1.2),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 16),
      filled: true,
      fillColor: _Tokens.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      enabledBorder: _b(_Tokens.divider),
      focusedBorder: _b(_Tokens.blue2),
    );
  }

  String? _emailValidator(String? v) {
    if (v == null || v.isEmpty) return 'Informe o e-mail';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v);
    if (!ok) return 'E-mail inválido';
    return null;
  }

  String? _passValidator(String? v) {
    if (v == null || v.isEmpty) return 'Informe a senha';
    if (v.length < 6) return 'Senha inválida';
    return null;
  }

  // LOGIN: valida e navega para o SHELL (sidebar + placeholder)
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 300)); // simulação
    if (!mounted) return;
    setState(() => _loading = false);

    // Vai para o shell vazio (sidebar + "Acesse um item no menu")
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.shell,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360), // largura dos campos/botão
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // “logo” do app
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _Tokens.blue2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.school, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feedback Aulas',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: _Tokens.textDark,
                        ),
                      ),
                      Text(
                        'Melhore com cada lição',
                        style: TextStyle(fontSize: 13, color: _Tokens.label),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // ocupa toda a largura do bloco
                children: [
                  // Label E-mail
                  const Text(
                    'E-mail',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: _Tokens.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 56,
                    child: TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username, AutofillHints.email],
                      decoration: _input('Digite seu e-mail'),
                      validator: _emailValidator,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Label Senha
                  const Text(
                    'Senha',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: _Tokens.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 56,
                    child: TextFormField(
                      controller: _pass,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _loading ? null : _submit(),
                      autofillHints: const [AutofillHints.password],
                      decoration: _input('Digite sua senha').copyWith(
                        suffixIcon: IconButton(
                          tooltip: _obscure ? 'Mostrar senha' : 'Ocultar senha',
                          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: _passValidator,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Botão
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_Tokens.blue2, _Tokens.blue1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(_Tokens.radius),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_Tokens.radius),
                          ),
                        ),
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'ENTRAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  TextButton(
                    onPressed: () {}, // TODO: recuperar senha
                    style: TextButton.styleFrom(
                      foregroundColor: _Tokens.label,
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    child: const Text('Esqueceu senha?'),
                  ),

                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Não possui conta? ', style: TextStyle(color: _Tokens.label)),
                      TextButton(
                        onPressed: () {}, // TODO: cadastro
                        child: const Text(
                          'Crie uma agora!',
                          style: TextStyle(
                            color: _Tokens.blue2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
