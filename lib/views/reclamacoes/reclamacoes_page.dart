import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/* ===================== TOKENS ===================== */
class _T {
  static const blue1 = Color(0xFF1E3A8A);
  static const blue2 = Color(0xFF2563EB);
  static const text = Color(0xFF0F172A);
  static const subtle = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const card = Colors.white;
  static const radius = 12.0;
}

/* ===================== PAGE ===================== */
class ReclamacoesPage extends StatefulWidget {
  const ReclamacoesPage({super.key});
  @override
  State<ReclamacoesPage> createState() => _ReclamacoesPageState();
}

class _ReclamacoesPageState extends State<ReclamacoesPage> {
  // --------- filtros de topo (opcionais, só para futuro dashboard) ---------
  String? curso;
  String? disc;
  String? tipoFiltro; // Reclamação / Feedback / Sugestão
  final _cursos = const ['Eng. Informática', 'Eng. Civil', 'Gestão'];
  final _disciplinas = const [
    'Algoritmos','Estruturas de Dados','Redes','Sistemas Operacionais','Banco de dados','Gestão ágil','Estruturas complexas','Workshop'
  ];
  final _tipos = const ['Reclamação', 'Feedback', 'Sugestão'];

  // --------- mock storage ---------
  final List<_Entry> _itens = [
    _Entry(
      id: 'R-001',
      data: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      tipo: 'Reclamação',
      curso: 'Eng. Civil',
      disciplina: 'Estruturas complexas',
      severidade: 'Alta',
      assunto: 'Materiais insuficientes',
      mensagem: 'Faltam exemplos resolvidos e guias para estudo da semana.',
      anonimo: true,
      status: 'Aberta',
    ),
    _Entry(
      id: 'F-002',
      data: DateTime.now().subtract(const Duration(hours: 6)),
      tipo: 'Feedback',
      curso: 'Gestão',
      disciplina: 'Gestão ágil',
      severidade: 'Média',
      assunto: 'Ritmo da aula',
      mensagem: 'Bom conteúdo, mas ritmo acelerado — talvez dividir em dois blocos.',
      anonimo: true,
      status: 'Aberta',
    ),
  ];

  // --------- form controllers ---------
  final _formKey = GlobalKey<FormState>();
  String? _tipo = 'Reclamação';
  String? _curso;
  String? _disciplina;
  String? _severidade = 'Média';
  final _assuntoCtrl = TextEditingController();
  final _mensagemCtrl = TextEditingController();
  bool _anonimo = true;

  @override
  void dispose() {
    _assuntoCtrl.dispose();
    _mensagemCtrl.dispose();
    super.dispose();
  }

  // --------- helpers ---------
  List<_Entry> get _filtrados {
    return _itens.where((e) {
      if (tipoFiltro != null && tipoFiltro!.isNotEmpty && e.tipo != tipoFiltro) return false;
      if (curso != null && curso!.isNotEmpty && e.curso != curso) return false;
      if (disc != null && disc!.isNotEmpty && e.disciplina != disc) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }

  void _submeter() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final id = '${_tipo!.substring(0,1)}-${DateTime.now().millisecondsSinceEpoch % 100000}';
    final novo = _Entry(
      id: id,
      data: DateTime.now(),
      tipo: _tipo!,
      curso: _curso ?? '—',
      disciplina: _disciplina ?? '—',
      severidade: _severidade!,
      assunto: _assuntoCtrl.text.trim(),
      mensagem: _mensagemCtrl.text.trim(),
      anonimo: _anonimo,
      status: 'Aberta',
    );
    setState(() {
      _itens.add(novo);
      // limpa o form (mantém seleções)
      _assuntoCtrl.clear();
      _mensagemCtrl.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Registo enviado (simulação).'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _toggleStatus(_Entry e) {
    setState(() {
      e.status = (e.status == 'Aberta') ? 'Em análise' : (e.status == 'Em análise' ? 'Resolvida' : 'Aberta');
    });
  }

  Color _sevColor(String s) {
    switch (s) {
      case 'Alta': return const Color(0xFFEF4444);
      case 'Baixa': return const Color(0xFF22C55E);
      default: return const Color(0xFFF59E0B); // Média
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy');
    final tf = DateFormat('HH:mm');

    return Column(
      children: [
        const _Topbar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: ListView(
              children: [
                // ====== Filtros de lista ======
                Wrap(
                  spacing: 10, runSpacing: 10,
                  children: [
                    _FilterInline(
                      label: 'Tipo',
                      placeholder: 'Tipo',
                      value: tipoFiltro,
                      items: _tipos,
                      onChanged: (v) => setState(() => tipoFiltro = v),
                      width: 180,
                    ),
                    _FilterInline(
                      label: 'Curso',
                      placeholder: 'Curso',
                      value: curso,
                      items: _cursos,
                      onChanged: (v) => setState(() => curso = v),
                      width: 220,
                    ),
                    _FilterInline(
                      label: 'Disciplina',
                      placeholder: 'Disciplina',
                      value: disc,
                      items: _disciplinas,
                      onChanged: (v) => setState(() => disc = v),
                      width: 240,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ====== Formulário de envio (simulação) ======
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _T.card,
                    border: Border.all(color: _T.border),
                    borderRadius: BorderRadius.circular(_T.radius),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Enviar registo (simulado)', style: TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: [
                            _SelectRounded(
                              label: 'Tipo',
                              value: _tipo,
                              items: _tipos,
                              width: 180,
                              onChanged: (v) => setState(() => _tipo = v),
                            ),
                            _SelectRounded(
                              label: 'Curso',
                              value: _curso,
                              items: _cursos,
                              width: 220,
                              onChanged: (v) => setState(() => _curso = v),
                            ),
                            _SelectRounded(
                              label: 'Disciplina',
                              value: _disciplina,
                              items: _disciplinas,
                              width: 240,
                              onChanged: (v) => setState(() => _disciplina = v),
                            ),
                            _SelectRounded(
                              label: 'Severidade',
                              value: _severidade,
                              items: const ['Baixa','Média','Alta'],
                              width: 160,
                              onChanged: (v) => setState(() => _severidade = v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _InputRounded(
                          controller: _assuntoCtrl,
                          label: 'Assunto',
                          hint: 'Resumo curto do registo',
                          validator: (v) => (v==null || v.trim().isEmpty) ? 'Informe o assunto' : null,
                        ),
                        const SizedBox(height: 8),
                        _InputRounded(
                          controller: _mensagemCtrl,
                          label: 'Mensagem',
                          hint: 'Descreva o ocorrido ou seu ponto de vista…',
                          lines: 4,
                          validator: (v) => (v==null || v.trim().isEmpty) ? 'Escreva a mensagem' : null,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Switch(
                              value: _anonimo,
                              onChanged: (v) => setState(() => _anonimo = v),
                              activeColor: _T.blue2,
                            ),
                            const Text('Enviar como Anônimo'),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: _submeter,
                              icon: const Icon(Icons.send_rounded, size: 18),
                              label: const Text('Enviar', style: TextStyle(fontWeight: FontWeight.w800)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _T.blue2, foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ====== Lista / timeline de registos ======
                Container(
                  decoration: BoxDecoration(
                    color: _T.card,
                    border: Border.all(color: _T.border),
                    borderRadius: BorderRadius.circular(_T.radius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Text('Registos recentes', style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(height: 8),
                      ..._filtrados.map((e) {
                        final cor = switch (e.tipo) {
                          'Reclamação' => const Color(0xFFEF4444),
                          'Sugestão' => const Color(0xFF2563EB),
                          _ => const Color(0xFF22C55E), // Feedback
                        };
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: _T.border),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(
                                    color: cor.withOpacity(.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.report_problem_rounded, color: cor, size: 20),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 8, runSpacing: 6,
                                        children: [
                                          _pill(e.tipo, cor),
                                          _chip('Status', e.status),
                                          _chip('Severidade', e.severidade, color: _sevColor(e.severidade)),
                                          _chip('Curso', e.curso),
                                          _chip('Disciplina', e.disciplina),
                                          _chip('Data', df.format(e.data)),
                                          _chip('Hora', tf.format(e.data)),
                                          _chip('Autor', e.anonimo ? 'Anônimo' : '—'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(e.assunto, style: const TextStyle(fontWeight: FontWeight.w800)),
                                      const SizedBox(height: 4),
                                      Text(e.mensagem),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  children: [
                                    IconButton(
                                      tooltip: 'Alterar status (mock)',
                                      icon: const Icon(Icons.flag_outlined, size: 18),
                                      onPressed: () => _toggleStatus(e),
                                    ),
                                    IconButton(
                                      tooltip: 'Remover (mock)',
                                      icon: const Icon(Icons.delete_outline, size: 18),
                                      onPressed: () => setState(() => _itens.remove(e)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(String k, String v, {Color? color}) {
    final c = color ?? _T.border;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: c),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('$k: ', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        Text(v, style: const TextStyle(fontSize: 12)),
      ]),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        border: Border.all(color: color.withOpacity(.30)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}

/* ===================== UI BASICS ===================== */

class _Topbar extends StatelessWidget {
  const _Topbar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 18, 16, 18),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_T.blue1, _T.blue2],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: const [
            SizedBox(width: 16),
            Text('Reclamações',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
            Spacer(),
            _UserBadge(),
          ],
        ),
      ),
    );
  }
}

class _UserBadge extends StatelessWidget {
  const _UserBadge();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Daniel José Anderone',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            Text('Gestor', style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
        SizedBox(width: 8),
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white, size: 18),
        ),
      ],
    );
  }
}

/* ====== COMPONENTES REUTILIZADOS ====== */
class _FilterInline extends StatelessWidget {
  final String label, placeholder;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final double? width;

  const _FilterInline({
    super.key,
    required this.label,
    required this.placeholder,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _T.card,
        border: Border.all(color: _T.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 0,
            child: Text('$label: ',
              overflow: TextOverflow.ellipsis, softWrap: false,
              style: const TextStyle(color: _T.subtle, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: (value != null && items.contains(value)) ? value : null,
                isDense: true, isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                style: const TextStyle(fontSize: 13, color: _T.text, fontWeight: FontWeight.w600),
                menuMaxHeight: 280, borderRadius: BorderRadius.circular(10),
                hint: Text(placeholder,
                  overflow: TextOverflow.ellipsis, softWrap: false,
                  style: const TextStyle(fontSize: 13, color: _T.subtle, fontWeight: FontWeight.w600),
                ),
                selectedItemBuilder: (context) => items.map((e) =>
                  Align(alignment: Alignment.centerLeft, child: Text(e, overflow: TextOverflow.ellipsis, softWrap: false))
                ).toList(),
                items: items.map((e) =>
                  DropdownMenuItem<String>(value: e, child: Text(e, overflow: TextOverflow.ellipsis, softWrap: false))
                ).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
    return width != null ? SizedBox(width: width, child: inner) : inner;
  }
}

class _SelectRounded extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final double width;
  const _SelectRounded({
    super.key, required this.label, required this.value,
    required this.items, required this.onChanged, required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: _T.border),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isDense: true, isExpanded: true,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class _InputRounded extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final int lines;
  final String? Function(String?)? validator;

  const _InputRounded({
    super.key,
    required this.controller, required this.label, required this.hint,
    this.lines = 1, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: lines, maxLines: lines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label, hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _T.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _T.blue2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

/* ===================== MODELO ===================== */
class _Entry {
  final String id;
  final DateTime data;
  final String tipo;        // Reclamação, Feedback, Sugestão
  final String curso;
  final String disciplina;
  final String severidade;  // Baixa, Média, Alta
  final String assunto;
  final String mensagem;
  final bool anonimo;
  String status;            // Aberta, Em análise, Resolvida

  _Entry({
    required this.id,
    required this.data,
    required this.tipo,
    required this.curso,
    required this.disciplina,
    required this.severidade,
    required this.assunto,
    required this.mensagem,
    required this.anonimo,
    required this.status,
  });
}
