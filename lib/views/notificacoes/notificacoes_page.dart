import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});
  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  // filtros
  String? facul;
  String? curso;
  String? disc;
  String? ano = '2025';
  String? semestre = '1';

  final _faculdades = const [
    'Faculdade Ciência e Tecnologia',
    'Faculdade de Engenharia',
    'Faculdade de Gestão',
  ];
  final _cursos = const ['Eng. Informática', 'Eng. Civil', 'Gestão'];
  final _disciplinas = const [
    'Algoritmos',
    'Estruturas de Dados',
    'Redes',
    'Sistemas Operacionais',
    'Banco de dados',
    'Gestão ágil',
    'Estruturas complexas',
    'Workshop',
  ];
  final _anos = const ['2023', '2024', '2025'];
  final _semestres = const ['1', '2'];

  // dados mockados
  late final List<_Notif> _todas;

  @override
void initState() {
  super.initState();

  // Mantém os filtros padrão da sua UI:
  // ano = '2025'; semestre = '1';

  final y = 2025; // Se quiser dinâmico: DateTime.now().year;

  _todas = [
    // ===== Excelente =====
    _Notif(DateTime(y, 1, 15, 10, 20), 'Excelente', 'Eng. Informática', 'Algoritmos',
        'Aula muito clara, os exemplos ajudaram bastante.'),
    _Notif(DateTime(y, 2, 5,  9, 10),  'Excelente', 'Gestão', 'Workshop',
        'Dinâmica de grupo excelente, aprendizagem prática.'),
    _Notif(DateTime(y, 3, 22, 16, 40), 'Excelente', 'Eng. Civil', 'Estruturas complexas',
        'Professor explicou com calma e trouxe casos reais.'),
    _Notif(DateTime(y, 5, 12, 14, 15), 'Excelente', 'Eng. Informática', 'Redes',
        'Laboratório impecável, roteiros bem escritos.'),

    // ===== Bom =====
    _Notif(DateTime(y, 1, 28, 18, 30), 'Bom', 'Eng. Informática', 'Banco de dados',
        'Bom ritmo, seria ótimo disponibilizar os slides antes.'),
    _Notif(DateTime(y, 3, 8,  11, 55), 'Bom', 'Gestão', 'Gestão ágil',
        'Conteúdo relevante; sugerir leitura prévia.'),
    _Notif(DateTime(y, 6, 3,  8,  5),  'Bom', 'Eng. Civil', 'Sistemas Operacionais',
        'Aula interessante, porém muitas siglas novas.'),
    _Notif(DateTime(y, 4, 17, 9,  35), 'Bom', 'Eng. Informática', 'Algoritmos',
        'Listas de exercícios ajudaram a fixar.'),

    // ===== Mediano =====
    _Notif(DateTime(y, 2, 14, 15, 10), 'Mediano', 'Gestão', 'Gestão ágil',
        'Conteúdo bom, mas faltou tempo para perguntas.'),
    _Notif(DateTime(y, 3, 2,  10,  0), 'Mediano', 'Eng. Informática', 'Algoritmos',
        'Velocidade um pouco alta; rever a parte de recursão.'),
    _Notif(DateTime(y, 4, 25, 19, 20), 'Mediano', 'Eng. Civil', 'Estruturas complexas',
        'Muitos tópicos em pouco tempo, poderia dividir.'),
    _Notif(DateTime(y, 6, 6,  13, 45), 'Mediano', 'Eng. Informática', 'Sistemas Operacionais',
        'Teoria ok, senti falta de exemplos práticos.'),

    // ===== Baixo =====
    _Notif(DateTime(y, 1, 9,  7,  50), 'Baixo', 'Eng. Civil', 'Estruturas complexas',
        'Dificuldade para acompanhar os cálculos desta semana.'),
    _Notif(DateTime(y, 5, 20, 17, 25), 'Baixo', 'Gestão', 'Gestão ágil',
        'Materiais de apoio insuficientes para estudo.'),
    _Notif(DateTime(y, 6, 28, 12, 10), 'Baixo', 'Eng. Informática', 'Redes',
        'Atividades sem orientação clara; confuso no início.'),
    _Notif(DateTime(y, 2, 26, 16,  0), 'Baixo', 'Eng. Informática', 'Banco de dados',
        'Faltou revisar conceitos antes do exercício prático.'),
  ];
}

  List<_Notif> get _filtradas {
    return _todas.where((n) {
      if (disc != null && disc!.isNotEmpty && n.disciplina != disc) return false;
      if (curso != null && curso!.isNotEmpty && n.curso != curso) return false;
      if (ano != null && ano!.isNotEmpty) {
        final a = n.data.year.toString();
        if (a != ano) return false;
      }
      if (semestre != null && semestre!.isNotEmpty) {
        final s = n.data.month <= 6 ? '1' : '2';
        if (s != semestre) return false;
      }
      // facul mock ignorado
      return true;
    }).toList()
      ..sort((a, b) => b.data.compareTo(a.data)); // recentes primeiro
  }

  // contadores por classificação
  Map<String, int> get _contagemPorClasse {
    final map = <String, int>{'Excelente': 0, 'Bom': 0, 'Mediano': 0, 'Baixo': 0};
    for (final n in _filtradas) {
      map[n.classificacao] = (map[n.classificacao] ?? 0) + 1;
    }
    return map;
  }

  // barras para gráfico
  List<BarChartGroupData> get _barGroups {
    final order = ['Excelente', 'Bom', 'Mediano', 'Baixo'];
    final map = _contagemPorClasse;
    return List.generate(order.length, (i) {
      final key = order[i];
      final v = (map[key] ?? 0).toDouble();
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: v,
            width: 18,
            borderRadius: BorderRadius.circular(6),
            color: _clsColor(key),
          ),
        ],
      );
    });
  }

  Color _clsColor(String c) {
    switch (c) {
      case 'Excelente':
        return const Color(0xFF2563EB);
      case 'Bom':
        return const Color(0xFF22C55E);
      case 'Mediano':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFFEF4444);
    }
  }

  @override
  Widget build(BuildContext context) {
    final counts = _contagemPorClasse;

    return Column(
      children: [
        const _Topbar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: ListView(
              children: [
                // ====== filtros ======
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _FilterInline(
                      label: 'Faculdade',
                      placeholder: 'Faculdade',
                      value: facul,
                      items: _faculdades,
                      onChanged: (v) => setState(() => facul = v),
                      width: 240,
                    ),
                    _FilterInline(
                      label: 'Disciplina',
                      placeholder: 'Disciplina',
                      value: disc,
                      items: _disciplinas,
                      onChanged: (v) => setState(() => disc = v),
                      width: 220,
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
                      label: 'Semestre',
                      placeholder: 'Semestre',
                      value: semestre,
                      items: _semestres,
                      onChanged: (v) => setState(() => semestre = v),
                      width: 150,
                    ),
                    _FilterInline(
                      label: 'Ano',
                      placeholder: 'Ano',
                      value: ano,
                      items: _anos,
                      onChanged: (v) => setState(() => ano = v),
                      width: 120,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ====== KPIs ======
                Row(
                  children: [
                    Expanded(child: _KpiCardSimple(title: 'Excelente', value: counts['Excelente'] ?? 0, color: _clsColor('Excelente'))),
                    const SizedBox(width: 12),
                    Expanded(child: _KpiCardSimple(title: 'Bom', value: counts['Bom'] ?? 0, color: _clsColor('Bom'))),
                    const SizedBox(width: 12),
                    Expanded(child: _KpiCardSimple(title: 'Mediano', value: counts['Mediano'] ?? 0, color: _clsColor('Mediano'))),
                    const SizedBox(width: 12),
                    Expanded(child: _KpiCardSimple(title: 'Baixo', value: counts['Baixo'] ?? 0, color: _clsColor('Baixo'))),
                  ],
                ),

                const SizedBox(height: 12),

                // ====== Gráfico de Nível de Feedbacks ======
                SizedBox(
                  height: 220,
                  child: _BarCard(groups: _barGroups),
                ),

                const SizedBox(height: 16),

                // ====== Listas de feedbacks relevantes (por classificação) ======
                _GrupoFeedbacks(title: 'Excelente', color: _clsColor('Excelente'), itens: _filtradas.where((n) => n.classificacao == 'Excelente').toList()),
                const SizedBox(height: 12),
                _GrupoFeedbacks(title: 'Bom', color: _clsColor('Bom'), itens: _filtradas.where((n) => n.classificacao == 'Bom').toList()),
                const SizedBox(height: 12),
                _GrupoFeedbacks(title: 'Mediano', color: _clsColor('Mediano'), itens: _filtradas.where((n) => n.classificacao == 'Mediano').toList()),
                const SizedBox(height: 12),
                _GrupoFeedbacks(title: 'Baixo', color: _clsColor('Baixo'), itens: _filtradas.where((n) => n.classificacao == 'Baixo').toList()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/* ===================== TOPBAR ===================== */

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
            Text('Notificações',
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

/* ===================== COMPONENTES ===================== */

class _KpiCardSimple extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  const _KpiCardSimple({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _T.card,
        border: Border.all(color: _T.border),
        borderRadius: BorderRadius.circular(_T.radius),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.notifications_active_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: _T.subtle, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('$value', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _BarCard extends StatelessWidget {
  final List<BarChartGroupData> groups;
  const _BarCard({required this.groups});

  @override
  Widget build(BuildContext context) {
    const labels = ['Exc', 'Bom', 'Med', 'Bai'];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _T.card,
        border: Border.all(color: _T.border),
        borderRadius: BorderRadius.circular(_T.radius),
      ),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: true,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (_) => FlLine(color: _T.border, strokeWidth: 1),
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 26)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                  return Text(labels[i], style: const TextStyle(fontSize: 11, color: _T.subtle));
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: groups,
        ),
      ),
    );
  }
}

class _GrupoFeedbacks extends StatelessWidget {
  final String title;
  final Color color;
  final List<_Notif> itens;
  const _GrupoFeedbacks({required this.title, required this.color, required this.itens});

  @override
  Widget build(BuildContext context) {
    final dfDate = DateFormat('dd/MM/yyyy');
    final dfTime = DateFormat('HH:mm');

    return Container(
      decoration: BoxDecoration(
        color: _T.card,
        border: Border.all(color: _T.border),
        borderRadius: BorderRadius.circular(_T.radius),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        leading: Container(
          width: 12, height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                border: Border.all(color: color.withOpacity(.30)),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('${itens.length}', style: TextStyle(color: color, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
        children: itens.isEmpty
            ? [const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Sem feedbacks para este nível.', style: TextStyle(color: _T.subtle)),
              )]
            : itens.map((n) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(10),
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
                            color: color.withOpacity(.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.forum_rounded, color: color, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8, runSpacing: 6,
                                children: [
                                  _chip('Curso', n.curso),
                                  _chip('Disciplina', n.disciplina),
                                  _chip('Data', dfDate.format(n.data)),
                                  _chip('Hora', dfTime.format(n.data)),
                                  _chip('Autor', 'Anônimo'), // sigilo
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                n.mensagem,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // ação mock
                        IconButton(
                          tooltip: 'Marcar como lido (mock)',
                          icon: const Icon(Icons.mark_email_read_outlined, size: 18),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
      ),
    );
  }

  Widget _chip(String k, String v) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _T.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('$k: ', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        Text(v, style: const TextStyle(fontSize: 12)),
      ]),
    );
  }
}

/* ===================== FILTRO INLINE ===================== */

class _FilterInline extends StatelessWidget {
  final String label;
  final String placeholder;
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
            child: Text(
              '$label: ',
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(color: _T.subtle, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: (value != null && items.contains(value)) ? value : null,
                isDense: true,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                style: const TextStyle(fontSize: 13, color: _T.text, fontWeight: FontWeight.w600),
                menuMaxHeight: 280,
                borderRadius: BorderRadius.circular(10),
                hint: Text(
                  placeholder,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(fontSize: 13, color: _T.subtle, fontWeight: FontWeight.w600),
                ),
                selectedItemBuilder: (context) => items
                    .map((e) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(e, overflow: TextOverflow.ellipsis, softWrap: false),
                        ))
                    .toList(),
                items: items
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e, overflow: TextOverflow.ellipsis, softWrap: false),
                        ))
                    .toList(),
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

/* ===================== MODELO ===================== */

class _Notif {
  final DateTime data;
  final String classificacao; // Excelente, Bom, Mediano, Baixo
  final String curso;
  final String disciplina;
  final String mensagem; // anonimizada

  _Notif(this.data, this.classificacao, this.curso, this.disciplina, this.mensagem);
}
