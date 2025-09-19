import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/* ===================== TOKENS (mesmo padrão) ===================== */
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

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});
  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  // ------- filtros -------
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
  final _cursos = const [
    'Engenharia Informática',
    'Engenharia Civil',
    'Gestão',
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

  // ------- dados mock -------
  late final List<_Registro> _todos;

  @override
  void initState() {
    super.initState();
    _todos = [
      _Registro(DateTime(2025, 1, 15), 'Algoritmos', 'TD01', 24, 76, 'Bom', true),
      _Registro(DateTime(2025, 2, 10), 'Algoritmos', 'TD01', 22, 68, 'Mediano', true),
      _Registro(DateTime(2025, 3, 7),  'Banco de dados', 'A2', 27, 81, 'Excelente', true),
      _Registro(DateTime(2025, 4, 3),  'Redes', 'B1', 19, 59, 'Baixo', false),
      _Registro(DateTime(2025, 5, 5),  'Gestão ágil', 'EAB3', 31, 74, 'Bom', true),
      _Registro(DateTime(2025, 6, 2),  'Estruturas complexas', 'EA93', 26, 70, 'Mediano', true),
      _Registro(DateTime(2025, 7, 6),  'SO', 'C1', 23, 92, 'Excelente', true),
    ];
  }

  // ------- helpers métricas -------
  List<_Registro> get _filtrados {
    return _todos.where((r) {
      if (disc != null && disc!.isNotEmpty && r.disciplina != disc) return false;
      if (ano != null && ano!.isNotEmpty && r.data.year.toString() != ano) return false;
      if (semestre != null && semestre!.isNotEmpty) {
        final s = r.data.month <= 6 ? '1' : '2';
        if (s != semestre) return false;
      }
      // facul/curso mockados (sem campo dedicado) → ignorados
      return true;
    }).toList();
  }

  double get _aproveitamentoMedio {
    final rows = _filtrados;
    if (rows.isEmpty) return 0;
    return rows.map((e) => e.aproveitamento).reduce((a, b) => a + b) / rows.length;
  }

  // satisfação numérica para média simples
  double get _satisfacaoMedia {
    if (_filtrados.isEmpty) return 0;
    double score(String s) => switch (s) {
          'Excelente' => 1.0,
          'Bom' => .75,
          'Mediano' => .5,
          _ => .25,
        };
    final media = _filtrados.map((e) => score(e.satisfacao)).reduce((a, b) => a + b) / _filtrados.length;
    return (media * 100);
  }

  String get _satisfacaoTexto {
    final v = _satisfacaoMedia;
    if (v >= 85) return 'Excelente';
    if (v >= 70) return 'Bom';
    if (v >= 50) return 'Mediano';
    return 'Baixo';
  }

  // afluência = % de turmas que entregaram feedback no período
  double get _afluencia {
    final rows = _filtrados;
    if (rows.isEmpty) return 0;
    final entregues = rows.where((e) => e.entregouFeedback).length;
    return 100 * entregues / rows.length;
  }

  // série evolução do aproveitamento (por mês)
  List<FlSpot> get _serieAproveitamento {
    // meses 1..12 - para os meses presentes, média do mês
    final byMonth = <int, List<int>>{};
    for (final r in _filtrados) {
      byMonth.putIfAbsent(r.data.month, () => []).add(r.aproveitamento);
    }
    final mesesOrdenados = List<int>.generate(12, (i) => i + 1);
    final values = <double>[];
    for (final m in mesesOrdenados) {
      final arr = byMonth[m];
      if (arr == null || arr.isEmpty) {
        values.add(0);
      } else {
        values.add(arr.reduce((a, b) => a + b) / arr.length);
      }
    }
    // mostra só até o último mês com dado
    int lastIdx = max(0, values.lastIndexWhere((v) => v > 0));
    if (lastIdx == -1) lastIdx = 0;
    final slice = values.take(lastIdx + 1).toList();
    return List.generate(slice.length, (i) => FlSpot(i.toDouble(), slice[i]));
  }

  // barras de afluência mensal (% que entregou feedback)
  List<BarChartGroupData> get _barrasAfluencia {
    final byMonth = <int, List<_Registro>>{};
    for (final r in _filtrados) {
      byMonth.putIfAbsent(r.data.month, () => []).add(r);
    }
    final meses = List<int>.generate(12, (i) => i + 1);
    final groups = <BarChartGroupData>[];
    int last = 0;
    for (int i = 0; i < meses.length; i++) {
      final arr = byMonth[meses[i]] ?? [];
      double v = 0;
      if (arr.isNotEmpty) {
        final ok = arr.where((e) => e.entregouFeedback).length;
        v = 100 * ok / arr.length;
        last = i;
      }
      groups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: v, width: 10, borderRadius: BorderRadius.circular(4), color: _T.blue2),
        ],
      ));
    }
    // corta zeros finais
    return groups.take(last + 1).toList();
  }

  Map<String, int> get _distSatisfacao {
    final map = <String, int>{'Excelente': 0, 'Bom': 0, 'Mediano': 0, 'Baixo': 0};
    for (final r in _filtrados) {
      map[r.satisfacao] = (map[r.satisfacao] ?? 0) + 1;
    }
    return map;
  }

  // responsável mock
  final String _responsavel = 'Daniel José Anderone (Gestor)';

  // ------- PDF -------
  Future<void> _baixarPdf() async {
    final now = DateTime.now();
    final df = DateFormat('dd/MM/yyyy HH:mm');
    final doc = pw.Document();

    // estilos
    final h1 = pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold);
    final small = pw.TextStyle(fontSize: 10, color: PdfColors.grey600);
    final bold = pw.TextStyle(fontWeight: pw.FontWeight.bold);

    final kpi = [
      ['Aproveitamento médio', '${_aproveitamentoMedio.toStringAsFixed(1)} %'],
      ['Satisfação média', '$_satisfacaoTexto (${_satisfacaoMedia.toStringAsFixed(0)} %)'],
      ['Afluência de feedbacks', '${_afluencia.toStringAsFixed(1)} %'],
    ];

    // tabela
    final headers = ['Data', 'Disciplina', 'Turma', 'Alunos', 'Aproveit.', 'Satisfação', 'Entregou?'];
    final rows = _filtrados
        .map((r) => [
              DateFormat('dd/MM/yyyy').format(r.data),
              r.disciplina,
              r.turma,
              r.alunos.toString(),
              '${r.aproveitamento}%',
              r.satisfacao,
              r.entregouFeedback ? 'Sim' : 'Não',
            ])
        .toList();

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(24),
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.openSansRegular(),
            bold: await PdfGoogleFonts.openSansBold(),
          ),
        ),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Relatórios de Desempenho e Feedbacks', style: h1),
                    pw.SizedBox(height: 6),
                    pw.Text('Gerado em: ${df.format(now)}', style: small),
                    pw.Text('Responsável: $_responsavel', style: small),
                  ],
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue300,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Text('Protótipo • Dados mock', style: pw.TextStyle(color: PdfColors.white)),
              ),
            ],
          ),
          pw.SizedBox(height: 16),

          // KPIs
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            padding: const pw.EdgeInsets.all(10),
            child: pw.Row(
              children: kpi
                  .map((e) => pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(e.first, style: small),
                              pw.SizedBox(height: 4),
                              pw.Text(e.last, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          pw.SizedBox(height: 14),

          // Dist. satisfação (mini barras simples)
          pw.Text('Distribuição de satisfação', style: bold),
          pw.SizedBox(height: 6),
          _miniBars(_distSatisfacao),

          pw.SizedBox(height: 14),
          pw.Text('Registos', style: bold),
          pw.SizedBox(height: 6),

          pw.Table.fromTextArray(
            headers: headers,
            data: rows,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {
              0: const pw.FixedColumnWidth(60),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FixedColumnWidth(40),
              3: const pw.FixedColumnWidth(40),
              4: const pw.FixedColumnWidth(60),
              5: const pw.FlexColumnWidth(1.2),
              6: const pw.FixedColumnWidth(55),
            },
            border: pw.TableBorder.all(color: PdfColors.grey300, width: .5),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
      name: 'relatorio_feedbacks_${DateFormat('yyyyMMdd_HHmm').format(now)}.pdf',
    );
  }

  pw.Widget _miniBars(Map<String, int> dist) {
    final total = dist.values.fold<int>(0, (a, b) => a + b);
    List<pw.Widget> bars = [];
    final colors = {
      'Excelente': PdfColors.blue400,
      'Bom': PdfColors.green400,
      'Mediano': PdfColors.orange400,
      'Baixo': PdfColors.red400,
    };
    dist.forEach((k, v) {
      final pct = total == 0 ? 0.0 : v / total;
      bars.add(
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Row(
            children: [
              pw.SizedBox(width: 70, child: pw.Text(k, style: const pw.TextStyle(fontSize: 10))),
              pw.Expanded(
                child: pw.Container(
                  height: 10,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Container(
                      height: 10,
                      width: pct * 300,
                      decoration: pw.BoxDecoration(
                        color: colors[k]!,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 6),
              pw.Text('${v.toString()} (${(pct * 100).toStringAsFixed(0)}%)', style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
        ),
      );
    });
    return pw.Column(children: bars);
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy');

    return Column(
      children: [
        const _Topbar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: ListView(
              children: [
                // ====== Filtros + botão PDF ======
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
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
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _baixarPdf,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _T.blue2,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Baixar PDF', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ====== KPIs ======
                Row(
                  children: [
                    Expanded(
                      child: _KpiCard(
                        title: 'Aproveitamento médio',
                        big: '${_aproveitamentoMedio.toStringAsFixed(1)} %',
                        deltaPositive: true,
                        deltaText: 'mock',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _KpiCard(
                        title: 'Satisfação média',
                        big: '$_satisfacaoTexto',
                        deltaPositive: true,
                        deltaText: '${_satisfacaoMedia.toStringAsFixed(0)}%',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _KpiCard(
                        title: 'Afluência de feedbacks',
                        big: '${_afluencia.toStringAsFixed(1)} %',
                        deltaPositive: _afluencia >= 50,
                        deltaText: 'mock',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ====== Gráficos lado a lado ======
                SizedBox(
                  height: 280,
                  child: Row(
                    children: [
                      Expanded(child: _LineChartCard(
                        title: 'Evolução do aproveitamento',
                        spots: _serieAproveitamento,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _BarChartCard(
                        title: 'Afluência mensal (%)',
                        groups: _barrasAfluencia,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _DonutLite(
                        title: 'Distribuição de satisfação',
                        dist: _distSatisfacao,
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ====== Tabela ======
                _TabelaRegistos(
                  linhas: _filtrados
                      .map((e) => [
                            df.format(e.data),
                            e.disciplina,
                            e.turma,
                            e.alunos.toString(),
                            '${e.aproveitamento}%',
                            e.satisfacao,
                            e.entregouFeedback ? 'Sim' : 'Não',
                          ])
                      .toList(),
                ),
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
            Text('Relatórios',
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
                Icon(deltaPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                    size: 14, color: deltaColor),
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

/* ===================== GRÁFICOS ===================== */

class _LineChartCard extends StatelessWidget {
  final String title;
  final List<FlSpot> spots;
  const _LineChartCard({required this.title, required this.spots});

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
          Text(title, style: const TextStyle(color: _T.subtle, fontWeight: FontWeight.w700)),
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
                        const meses = ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'];
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

class _BarChartCard extends StatelessWidget {
  final String title;
  final List<BarChartGroupData> groups;
  const _BarChartCard({required this.title, required this.groups});

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
          Text(title, style: const TextStyle(color: _T.subtle, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: 100,
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
                        const meses = ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'];
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
                barGroups: groups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutLite extends StatelessWidget {
  final String title;
  final Map<String, int> dist;
  const _DonutLite({required this.title, required this.dist});

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
          Text(title, style: const TextStyle(color: _T.subtle, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: colors.entries
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
                                  Text('${e.key} — ${dist[e.key] ?? 0}'),
                                ],
                              ),
                            ))
                        .toList(),
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

class _TabelaRegistos extends StatelessWidget {
  final List<List<String>> linhas;
  const _TabelaRegistos({required this.linhas});

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
                headingTextStyle: const TextStyle(fontWeight: FontWeight.w800, color: _T.text),
                dataTextStyle: const TextStyle(color: _T.text),
                columnSpacing: 26,
                headingRowHeight: 40,
                dataRowMinHeight: 36,
                dataRowMaxHeight: 40,
                columns: const [
                  DataColumn(label: Text('Data')),
                  DataColumn(label: Text('Disciplina')),
                  DataColumn(label: Text('Turma')),
                  DataColumn(label: Text('Alunos')),
                  DataColumn(label: Text('Aproveitamento')),
                  DataColumn(label: Text('Satisfação')),
                  DataColumn(label: Text('Feedback entregue')),
                ],
                rows: List<DataRow>.generate(linhas.length, (i) {
                  final c = i.isEven ? const Color(0xFFF8FAFC) : Colors.white;
                  final l = linhas[i];
                  return DataRow(
                    color: MaterialStatePropertyAll(c),
                    cells: l.map((v) => DataCell(Text(v))).toList(),
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

class _Registro {
  final DateTime data;
  final String disciplina;
  final String turma;
  final int alunos;
  final int aproveitamento; // 0-100
  final String satisfacao; // Excelente, Bom, Mediano, Baixo
  final bool entregouFeedback;

  _Registro(
    this.data,
    this.disciplina,
    this.turma,
    this.alunos,
    this.aproveitamento,
    this.satisfacao,
    this.entregouFeedback,
  );
}
