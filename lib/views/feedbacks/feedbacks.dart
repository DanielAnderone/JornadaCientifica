import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

/* ===================== PAGE (STATEFUL) ===================== */

class FeedbacksReportPage extends StatefulWidget {
  const FeedbacksReportPage({super.key});
  @override
  State<FeedbacksReportPage> createState() => _FeedbacksReportPageState();
}

class _FeedbacksReportPageState extends State<FeedbacksReportPage> {
  // ------- filtros controlados -------
  String? facul;
  String? curso;
  String? disc;
  String? ano;
  String? semestre;

  final _faculdades = const [
    'Faculdade Ciência e Tecnologia',
    'Faculdade de Engenharia',
    'Faculdade de Gestão',
  ];
  final _cursos = const [
    'Curso: Engenharia Informatica',
    'Curso: Engenharia Civil',
    'Curso: Gestão',
  ];
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

  // ------- dados mock com ano/semestre -------
  late final List<_Linha> _todas;

  @override
  void initState() {
    super.initState();
    _todas = [
      // data, docente, turma, tema, part%, feedback, sala, ano, sem
      _Linha('05/04/2024', 'Carios R.',   'TD01', 'Workshop',              78, 'Excelente', 'A-301', '2024', '1'),
      _Linha('04/03/2024', 'Fernanda P.', 'TD01', 'Banco de dados',        66, 'Bom',       'A-301', '2024', '1'),
      _Linha('03/06/2024', 'Carios R.',   'EAB3', 'Gestão ágil',           59, 'Mediano',   'A-201', '2024', '2'),
      _Linha('28/08/2024', 'Fernanda P.', 'EA93', 'Estruturas complexas',  52, 'Mediano',   'C-104', '2024', '2'),
      _Linha('10/05/2023', 'Ana C.',      'A2',   'Algoritmos',            88, 'Excelente', 'B-201', '2023', '1'),
      _Linha('22/06/2023', 'Rui M.',      'B1',   'Estruturas de Dados',   74, 'Bom',       'B-101', '2023', '2'),
      _Linha('12/04/2025', 'Mauro D.',    'C1',   'Redes',                 71, 'Mediano',   'C-202', '2025', '1'),
      _Linha('20/05/2025', 'Júlia N.',    'B3',   'Sistemas Operacionais', 63, 'Baixo',     'D-102', '2025', '1'),
    ];
  }

  // KPIs de cabeçalho (mock)
  int get _assimilacao => 72;
  String get _satisfTxt => 'Bom';
  double get _assimDelta => 3.4;
  double get _satisDelta => 1.9;

  // série do gráfico de linha (mock)
  List<FlSpot> get _serie {
    final v = <double>[15, 28, 55, 48, 78, 72, 98];
    return List.generate(v.length, (i) => FlSpot(i.toDouble(), v[i]));
  }

  List<_Linha> _aplicarFiltros() {
    return _todas.where((l) {
      if (facul != null && facul!.isNotEmpty) {
        // (mock) sem campo real de faculdade no modelo
      }
      if (curso != null && curso!.isNotEmpty) {
        // (mock) idem
      }
      if (disc != null && disc!.isNotEmpty && l.tema != disc) return false;
      if (ano != null && ano!.isNotEmpty && l.ano != ano) return false;
      if (semestre != null && semestre!.isNotEmpty && l.semestre != semestre) return false;
      return true;
    }).toList();
  }

  Map<String, int> _distFromRows(List<_Linha> rows) {
    final map = <String, int>{'Excelente': 0, 'Bom': 0, 'Mediano': 0, 'Baixo': 0};
    for (final r in rows) {
      if (map.containsKey(r.feedback)) {
        map[r.feedback] = map[r.feedback]! + 1;
      } else {
        map['Baixo'] = map['Baixo']! + 1;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final rows = _aplicarFiltros();
    final dist = _distFromRows(rows);
    final qtd = rows.length;

    return Column(
      children: [
        const _Topbar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: ListView(
              children: [
                // ====== Filtros (inline e compactos) ======
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
                      width: 240, // reduzido
                    ),
                    _FilterInline(
                      label: 'Disciplina',
                      placeholder: 'Disciplina',
                      value: disc,
                      items: _disciplinas,
                      onChanged: (v) => setState(() => disc = v),
                      width: 220, // reduzido
                    ),
                    _FilterInline(
                      label: 'Curso',
                      placeholder: 'Curso',
                      value: curso,
                      items: _cursos,
                      onChanged: (v) => setState(() => curso = v),
                      width: 220, // reduzido
                    ),
                    _FilterInline(
                      label: 'Semestre',
                      placeholder: 'Semestre',
                      value: semestre,
                      items: _semestres,
                      onChanged: (v) => setState(() => semestre = v),
                      width: 150, // reduzido
                    ),
                    _FilterInline(
                      label: 'Ano',
                      placeholder: 'Ano',
                      value: ano,
                      items: _anos,
                      onChanged: (v) => setState(() => ano = v),
                      width: 120, // reduzido
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ====== KPIs ======
                Row(
                  children: [
                    Expanded(
                      child: _KpiCard(
                        title: 'Assimilação',
                        big: '$_assimilacao %',
                        deltaPositive: true,
                        deltaText: '+${_assimDelta.toStringAsFixed(1)}%',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _KpiCard(
                        title: 'Satisfação',
                        big: _satisfTxt,
                        deltaPositive: true,
                        deltaText: '+${_satisDelta.toStringAsFixed(1)}',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ====== EVOLUÇÃO + DISTRIBUIÇÃO LADO A LADO ======
                SizedBox(
                  height: 260,
                  child: Row(
                    children: [
                      Expanded(child: _LineChartCard(spots: _serie)),
                      const SizedBox(width: 12),
                      Expanded(child: _DonutLite(qtd: qtd, dist: dist)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ====== Tabela ======
                _TabelaFeedbacks(linhas: rows),
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
            Text('Relatórios de Feedbacks',
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

/* ===================== FILTRO INLINE (label e dropdown na MESMA linha) ===================== */

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
                isExpanded: true, // evita overflow
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

/* ===================== KPI CARD ===================== */

class _KpiCard extends StatelessWidget {
  final String title;
  final String big;
  final bool deltaPositive;
  final String deltaText;
  const _KpiCard({
    required this.title,
    required this.big,
    required this.deltaPositive,
    required this.deltaText,
  });

  @override
  Widget build(BuildContext context) {
    final deltaColor = deltaPositive ? const Color(0xFF16A34A) : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _T.card,
        border: Border.all(color: _T.border),
        borderRadius: BorderRadius.circular(_T.radius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _T.subtle, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(big, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: deltaColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: deltaColor.withOpacity(.35)),
            ),
            child: Row(
              children: [
                Icon(Icons.arrow_upward_rounded, size: 14, color: deltaColor),
                const SizedBox(width: 4),
                Text(deltaText,
                    style: TextStyle(fontSize: 12, color: deltaColor, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== GRÁFICO DE LINHA ===================== */

class _LineChartCard extends StatelessWidget {
  final List<FlSpot> spots;
  const _LineChartCard({required this.spots});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _T.card,
        border: Border.all(color: _T.border),
        borderRadius: BorderRadius.circular(_T.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Evolução de assimilação',
              style: TextStyle(color: _T.subtle, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0, maxY: 100,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (_) => FlLine(color: _T.border, strokeWidth: 1),
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 20),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const meses = ['Jan','Fev','Mar','Abr','Mai','Jun','Jul'];
                        final i = v.toInt();
                        if (i < 0 || i >= meses.length) return const SizedBox.shrink();
                        return Text(meses[i], style: const TextStyle(fontSize: 10, color: _T.subtle));
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 2.4,
                    gradient: const LinearGradient(colors: [_T.blue2, _T.blue1]),
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [_T.blue2.withOpacity(.20), _T.blue1.withOpacity(.06)],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== PIZZA (compacta) ===================== */

class _DonutLite extends StatelessWidget {
  final int qtd;
  final Map<String, int> dist;
  const _DonutLite({required this.qtd, required this.dist});

  @override
  Widget build(BuildContext context) {
    final total = dist.values.fold<int>(0, (a, b) => a + b);

    final colors = <String, Color>{
      'Excelente': const Color(0xFF2563EB),
      'Bom':       const Color(0xFF22C55E),
      'Mediano':   const Color(0xFFF59E0B),
      'Baixo':     const Color(0xFFEF4444),
    };

    final sections = dist.entries.map((e) {
      final value = e.value.toDouble();
      return PieChartSectionData(
        value: value <= 0 ? .0001 : value,
        color: colors[e.key],
        radius: 48,
        showTitle: false,
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _T.card,
        border: Border.all(color: _T.border),
        borderRadius: BorderRadius.circular(_T.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Distribuição de feedbacks',
              style: TextStyle(color: _T.subtle, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 42,
                        sections: sections,
                      )),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$total',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                          const SizedBox(height: 2),
                          const Text('registos', style: TextStyle(color: _T.subtle, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final entries = colors.entries
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: e.value,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text('${e.key} — ${dist[e.key] ?? 0}',
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ))
                          .toList();
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: entries,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== TABELA ===================== */

class _TabelaFeedbacks extends StatelessWidget {
  final List<_Linha> linhas;
  const _TabelaFeedbacks({required this.linhas});

  Color _fbColor(String f) {
    switch (f) {
      case 'Excelente':
        return const Color(0xFF22C55E);
      case 'Bom':
        return const Color(0xFF16A34A);
      case 'Mediano':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFFEF4444);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _T.card,
        border: Border.all(color: _T.border),
        borderRadius: BorderRadius.circular(_T.radius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: const MaterialStatePropertyAll(Colors.white),
                headingTextStyle:
                    const TextStyle(fontWeight: FontWeight.w800, color: _T.text),
                dataTextStyle: const TextStyle(color: _T.text),
                columnSpacing: 26,
                headingRowHeight: 40,
                dataRowMinHeight: 36,
                dataRowMaxHeight: 40,
                columns: const [
                  DataColumn(label: Text('Data')),
                  DataColumn(label: Text('Docente')),
                  DataColumn(label: Text('Turma')),
                  DataColumn(label: Text('Tema')),
                  DataColumn(label: Text('Participação')),
                  DataColumn(label: Text('Feedback')),
                  DataColumn(label: Text('Sala')),
                  DataColumn(label: Text('Ano')),
                  DataColumn(label: Text('Semestre')),
                  DataColumn(label: Text('Ações')),
                ],
                rows: List<DataRow>.generate(linhas.length, (i) {
                  final l = linhas[i];
                  final c = _fbColor(l.feedback);
                  return DataRow(
                    color: MaterialStatePropertyAll(
                        i.isEven ? const Color(0xFFF8FAFC) : Colors.white),
                    cells: [
                      DataCell(Text(l.data)),
                      DataCell(Text(l.docente)),
                      DataCell(Text(l.turma)),
                      DataCell(Text(l.tema)),
                      DataCell(Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 90,
                            height: 6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: l.participacao / 100,
                                color: const Color(0xFF2563EB),
                                backgroundColor: const Color(0xFFE5E7EB),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${l.participacao}%'),
                        ],
                      )),
                      DataCell(Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: c.withOpacity(.10),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: c.withOpacity(.30)),
                        ),
                        child: Text(l.feedback,
                            style: TextStyle(
                                color: c, fontWeight: FontWeight.w800, fontSize: 12)),
                      )),
                      DataCell(Text(l.sala)),
                      DataCell(Text(l.ano)),
                      DataCell(Text(l.semestre)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            tooltip: 'Ver',
                            icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                '/feedbacks/detail',
                                arguments: {
                                  'cadeira': l.tema,
                                  'cursoEstudante': 'Eng. Informática',
                                  'percentual': l.participacao,
                                  'mensagem': 'A aula foi clara, gostei dos exemplos.',
                                  'data': l.data,
                                },
                              );
                            },
                          ),
                          IconButton(
                            tooltip: 'Menu',
                            icon: const Icon(Icons.more_horiz, size: 18),
                            onPressed: () {},
                          ),
                        ],
                      )),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ===================== MODELO ===================== */
class _Linha {
  final String data, docente, turma, tema, feedback, sala, ano, semestre;
  final int participacao;
  const _Linha(
    this.data,
    this.docente,
    this.turma,
    this.tema,
    this.participacao,
    this.feedback,
    this.sala,
    this.ano,
    this.semestre,
  );
}

/* ===================== DETALHE (rota /feedbacks/detail) ===================== */

class FeedbackDetailPage extends StatelessWidget {
  final Map<String, dynamic> feedback;
  const FeedbackDetailPage({super.key, required this.feedback});

  String _nivel(int p) {
    if (p >= 85) return 'Excelente';
    if (p >= 75) return 'Bom';
    if (p >= 60) return 'Mediano';
    return 'Ruim';
  }

  @override
  Widget build(BuildContext context) {
    final cadeira = (feedback['cadeira'] ?? '—').toString();
    final curso = (feedback['cursoEstudante'] ?? '—').toString();
    final perc = (feedback['percentual'] ?? 0) as int;
    final msg = (feedback['mensagem'] ?? 'Sem mensagem.').toString();
    final data = (feedback['data'] ?? '—').toString();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Feedback do Estudante (Anônimo)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Curso do estudante: $curso • Data: $data',
              style: TextStyle(color: Colors.black.withOpacity(.6))),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10, runSpacing: 10,
            children: [
              _chip('Cadeira', cadeira),
              _chip('Classificação', '$perc% • ${_nivel(perc)}'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Mensagem do estudante', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: _T.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(msg),
          ),
        ],
      ),
    );
  }

  Widget _chip(String k, String v) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _T.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('$k: ', style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(v),
      ]),
    );
  }
}
