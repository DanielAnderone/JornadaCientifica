import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../routes.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

/* ===================== TOKENS ===================== */

class _Tokens {
  static const blue1 = Color(0xFF1E3A8A);
  static const blue2 = Color(0xFF2563EB);
  static const text = Color(0xFF0F172A);
  static const subtle = Color(0xFF64748B);
  static const bg = Color(0xFFF8FAFC);
  static const divider = Color(0xFFE2E8F0);
  static const radius = 12.0;
}

/* ===================== DATA ===================== */

class _Subject {
  final String cadeira;
  final String docente;
  final int estudantes;
  final double perc;   // assimilação (%)
  final double rating; // 0–5
  final bool destaque;
  _Subject({
    required this.cadeira,
    required this.docente,
    required this.estudantes,
    required this.perc,
    required this.rating,
    required this.destaque,
  });
}

/* ===================== PAGE ===================== */

class _DashboardPageState extends State<DashboardPage> {
  late List<_Subject> data;

  @override
  void initState() {
    super.initState();
    data = [
      _Subject(cadeira: 'Algoritmos', docente: 'Prof. Ana Cruz', estudantes: 120, perc: 92, rating: 4.6, destaque: true),
      _Subject(cadeira: 'Estruturas de Dados', docente: 'Prof. Rui Matos', estudantes: 110, perc: 88, rating: 4.4, destaque: true),
      _Subject(cadeira: 'BD I', docente: 'Profa. Lídia Passos', estudantes: 98, perc: 79, rating: 4.1, destaque: false),
      _Subject(cadeira: 'Redes', docente: 'Prof. Carlos Lima', estudantes: 105, perc: 73, rating: 3.9, destaque: false),
      _Subject(cadeira: 'Sistemas Operacionais', docente: 'Profa. Júlia Nunes', estudantes: 102, perc: 65, destaque: false, rating: 3.7),
      _Subject(cadeira: 'Probabilidade', docente: 'Prof. Daniel Pires', estudantes: 95, perc: 54, rating: 3.4, destaque: false),
      _Subject(cadeira: 'Cálculo I', docente: 'Prof. Mário Gomes', estudantes: 130, perc: 83, rating: 4.0, destaque: false),
      _Subject(cadeira: 'Arquitetura de Computadores', docente: 'Profa. Inês Vidal', estudantes: 87, perc: 76, rating: 3.8, destaque: false),
      _Subject(cadeira: 'Engenharia de Software', docente: 'Prof. Telmo Rocha', estudantes: 112, perc: 86, rating: 4.3, destaque: true),
      _Subject(cadeira: 'Interação Humano-Computador', docente: 'Profa. Carla Melo', estudantes: 90, perc: 82, rating: 4.1, destaque: false),
      _Subject(cadeira: 'Redes Avançadas', docente: 'Prof. Mauro Dias', estudantes: 78, perc: 71, rating: 3.7, destaque: false),
      _Subject(cadeira: 'Mineração de Dados', docente: 'Profa. Rita Silva', estudantes: 69, perc: 89, rating: 4.5, destaque: true),
    ];
  }

  // KPIs
  double get participacaoMedia => 82;
  double get satisfacaoMedia => 4.2;
  int get totalEstudantes => data.fold(0, (a, b) => a + b.estudantes);
  int get totalDocentes => data.map((e) => e.docente).toSet().length;

  static const double _maxContentWidth = 1200; // bloco central

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Tokens.bg,
      body: Column(
        children: [
          const _Topbar(),
          Expanded(
            child: ScrollConfiguration(
              behavior: _NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ======= BLOCO CENTRAL (cards + gráfico + pizza) =======
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _KpiRow(
                              items: [
                                MetricData('Participação', '${participacaoMedia.toStringAsFixed(0)} %', Icons.group),
                                MetricData('Satisfação', '${satisfacaoMedia.toStringAsFixed(1)} / 5', Icons.sentiment_satisfied_alt_rounded),
                                MetricData('Estudantes', '$totalEstudantes', Icons.people_alt_rounded),
                                MetricData('Docentes', '$totalDocentes', Icons.person_pin_rounded),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Divider(color: _Tokens.divider, height: 24),
                            _ChartAndPieRow(data: data),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: _Tokens.divider, height: 24),

                    // ======= TABELA DE RESUMO (100% largura) =======
                    _SubjectsTableFullWidth(data: data),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== TOPBAR ===================== */

class _Topbar extends StatelessWidget {
  const _Topbar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_Tokens.blue1, _Tokens.blue2],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: const [
            Text('Bem-vindo, Anderone',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
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
            Text('Daniel José Anderone', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            Text('Gestor', style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
        SizedBox(width: 8),
        CircleAvatar(radius: 16, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 18)),
      ],
    );
  }
}

/* ===================== KPIs — LINHA, SEM SCROLL, HOVER AZUL ===================== */

class MetricData {
  final String title;
  final String big;
  final IconData icon;
  MetricData(this.title, this.big, this.icon);
}

class _KpiRow extends StatelessWidget {
  final List<MetricData> items;
  const _KpiRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final m in items)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _KpiCard(data: m),
            ),
          ),
      ],
    );
  }
}

class _KpiCard extends StatefulWidget {
  final MetricData data;
  const _KpiCard({super.key, required this.data});
  @override
  State<_KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<_KpiCard> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final bg = _hover ? _Tokens.blue2.withOpacity(.08) : Colors.white;
    final border = _hover ? _Tokens.blue2.withOpacity(.30) : _Tokens.divider;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: Matrix4.identity()..scale(_hover ? 1.02 : 1.0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(_Tokens.radius),
          boxShadow: _hover
              ? [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10, offset: const Offset(0, 4))]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_Tokens.blue2, _Tokens.blue1]),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(widget.data.icon, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
                  const SizedBox(height: 2),
                  Text(widget.data.big, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== GRÁFICO (LINHAS ELEGANTE) + PIZZA ===================== */

class _ChartAndPieRow extends StatelessWidget {
  final List<_Subject> data;
  const _ChartAndPieRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 980;

    final rightCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Desempenho por Faculdade', style: TextStyle(color: _Tokens.subtle)),
        SizedBox(height: 6),
        _FacultyPieProxy(), // chama o gráfico de pizza usando Inherited para obter dados
      ],
    );

    return wide
        ? _InheritedSubjects(
            data: data,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Evolução de Satisfação (semanas)', style: TextStyle(color: _Tokens.subtle)),
                      SizedBox(height: 6),
                      SizedBox(height: 230, child: _LineChart()),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(child: _RightColOnlyPie()),
              ],
            ),
          )
        : _InheritedSubjects(
            data: data,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Evolução de Satisfação (semanas)', style: TextStyle(color: _Tokens.subtle)),
                SizedBox(height: 6),
                SizedBox(height: 230, child: _LineChart()),
                SizedBox(height: 14),
                Text('Desempenho por Faculdade', style: TextStyle(color: _Tokens.subtle)),
                SizedBox(height: 6),
                _FacultyPieProxy(),
              ],
            ),
          );
  }
}

class _RightColOnlyPie extends StatelessWidget {
  const _RightColOnlyPie();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Desempenho por Faculdade', style: TextStyle(color: _Tokens.subtle)),
        SizedBox(height: 6),
        _FacultyPieProxy(),
      ],
    );
  }
}

/* ============== Line Chart (melhorado, elegante e com tooltip) ============== */

class _LineChart extends StatelessWidget {
  const _LineChart({super.key});
  @override
  Widget build(BuildContext context) {
    final weeks = [3.4, 3.6, 3.8, 4.0, 4.2, 4.1, 4.3];
    final days = ['Qui','Sex','Sáb','Dom','Seg','Ter','Qua'];
    final spots = weeks.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

    return LineChart(
      LineChartData(
        minY: 0, maxY: 5,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (_) => FlLine(color: _Tokens.divider, strokeWidth: 1),
          getDrawingVerticalLine: (_) => FlLine(color: _Tokens.divider.withOpacity(.6), strokeWidth: .6),
          drawVerticalLine: true,
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (v, _) => Text(
                v.toInt().toString(),
                style: const TextStyle(fontSize: 10, color: _Tokens.subtle),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  days[v.toInt() % 7],
                  style: const TextStyle(fontSize: 10, color: _Tokens.subtle),
                ),
              ),
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        // extraLinesData: ExtraLinesData(
        //   horizontalLines: [
        //     HorizontalLine(
        //       y: 4.0,
        //       color: _Tokens.blue2.withOpacity(.55),
        //       strokeWidth: 1.4,
        //       dashArray: [6, 4],
        //       label: HorizontalLineLabel(
        //         show: true,
        //         alignment: Alignment.topRight,
        //         style: const TextStyle(color: _Tokens.subtle, fontSize: 10, fontWeight: FontWeight.w700),
        //         labelResolver: (_) => 'Meta 4.0',
        //       ),
        //     ),
        //   ],
        // ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchSpotThreshold: 18,
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipBgColor: Colors.black.withOpacity(.85),
            getTooltipItems: (touchedSpots) => touchedSpots
                .map((ts) => LineTooltipItem(
                      '${days[ts.x.toInt() % 7]} • ${ts.y.toStringAsFixed(1)}',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                    ))
                .toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3.0,
            gradient: const LinearGradient(colors: [_Tokens.blue2, _Tokens.blue1]),
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [_Tokens.blue2.withOpacity(.20), _Tokens.blue1.withOpacity(.06)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============ PIE — FACULDADES (SEM CONTAINER, COM LEGENDA) ============ */

class _Agg {
  double w = 0; // soma ponderada
  int n = 0;   // total estudantes
}

class _FacultyPieProxy extends StatelessWidget {
  const _FacultyPieProxy({super.key});
  @override
  Widget build(BuildContext context) {
    final data = _InheritedSubjects.of(context);
    return _FacultyPie(data: data);
  }
}

class _FacultyPie extends StatefulWidget {
  final List<_Subject> data;
  const _FacultyPie({super.key, required this.data});

  @override
  State<_FacultyPie> createState() => _FacultyPieState();
}

class _FacultyPieState extends State<_FacultyPie> {
  int? touched;

  // Exemplo de mapeamento de cadeira -> faculdade (ajuste conforme seus dados)
  String _facultyOf(String cadeira) {
    const fct = 'Ciências & Tecnologia';
    const fe  = 'Engenharias';
    const fg  = 'Gestão & Economia';
    switch (cadeira) {
      case 'Engenharia de Software':
      case 'Arquitetura de Computadores':
      case 'Redes':
      case 'Redes Avançadas':
        return fe;
      case 'Probabilidade':
      case 'Cálculo I':
        return fg;
      default:
        return fct;
    }
  }

  @override
  Widget build(BuildContext context) {
    final agg = <String, _Agg>{};
    for (final s in widget.data) {
      final fac = _facultyOf(s.cadeira);
      agg.putIfAbsent(fac, () => _Agg());
      agg[fac]!.w += s.perc * s.estudantes;   // média ponderada
      agg[fac]!.n += s.estudantes;
    }
    final entries = agg.entries.map((e) {
      final avg = e.value.n == 0 ? 0.0 : e.value.w / e.value.n; // média %
      return MapEntry(e.key, avg);
    }).toList();

    final total = entries.fold<double>(0, (a, b) => a + b.value);
    final colors = <Color>[
      const Color(0xFF2563EB), // azul
      const Color(0xFF10B981), // verde
      const Color(0xFFF59E0B), // laranja
      const Color(0xFF8B5CF6), // roxo
      const Color(0xFFEC4899), // rosa
    ];

    final sections = <PieChartSectionData>[];
    for (var i = 0; i < entries.length; i++) {
      final avg = entries[i].value;
      final pct = total == 0 ? 0.0 : (avg / total) * 100.0;
      final isTouched = i == touched;
      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: pct,
          title: '${pct.toStringAsFixed(0)}%',
          radius: isTouched ? 62 : 54,
          titleStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: isTouched ? 14 : 12,
          ),
        ),
      );
    }

    return Row(
      children: [
        SizedBox(
          width: 210,
          height: 210,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 28,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(
                touchCallback: (ev, resp) {
                  setState(() => touched = resp?.touchedSection?.touchedSectionIndex);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              for (var i = 0; i < entries.length; i++)
                _LegendDot(
                  color: colors[i % colors.length],
                  label:
                      '${entries[i].key} — ${(total == 0 ? 0 : (entries[i].value / total) * 100).toStringAsFixed(0)}%',
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12.5, color: _Tokens.text, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

/* ===== Inherited para repassar a lista de subjects à pizza sem recriar widgets ===== */

class _InheritedSubjects extends InheritedWidget {
  final List<_Subject> data;
  const _InheritedSubjects({super.key, required this.data, required super.child});

  static List<_Subject> of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<_InheritedSubjects>();
    return w!.data;
  }

  @override
  bool updateShouldNotify(covariant _InheritedSubjects oldWidget) => oldWidget.data != data;
}

/* ===================== TABELA — 100% LARGURA ===================== */

class _SubjectsTableFullWidth extends StatelessWidget {
  final List<_Subject> data;
  const _SubjectsTableFullWidth({super.key, required this.data});

  String _feedbackLabel(double r) {
    if (r >= 4.5) return 'Excelente';
    if (r >= 4.0) return 'Muito bom';
    if (r >= 3.5) return 'Bom';
    if (r >= 3.0) return 'Regular';
    return 'Baixo';
  }

  String _nivel(double perc) {
    if (perc >= 90) return 'Topo';
    if (perc >= 85) return 'Alto';
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...data]..sort((a, b) => b.perc.compareTo(a.perc));

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: const MaterialStatePropertyAll(Colors.white),
              headingTextStyle: const TextStyle(fontWeight: FontWeight.w800, color: _Tokens.text),
              dataTextStyle: const TextStyle(color: _Tokens.text),
              columnSpacing: 28,
              headingRowHeight: 38,
              dataRowMinHeight: 34,
              dataRowMaxHeight: 38,
              columns: const [
                DataColumn(label: Text('Cadeira')),
                DataColumn(label: Text('Docente')),
                DataColumn(label: Text('Estudantes')),
                DataColumn(label: Text('Assimilação')),
                DataColumn(label: Text('Feedback')),
                DataColumn(label: Text('Nível')),
              ],
              rows: List<DataRow>.generate(sorted.length, (i) {
                final s = sorted[i];
                return DataRow(
                  color: MaterialStatePropertyAll(i.isEven ? const Color(0xFFF8FAFC) : Colors.white),
                  cells: [
                    DataCell(Text(s.cadeira)),
                    DataCell(Text(s.docente)),
                    DataCell(Text('${s.estudantes}')),
                    DataCell(Text('${s.perc.toStringAsFixed(0)}%')),
                    DataCell(Text(_feedbackLabel(s.rating))),
                    DataCell(Text(_nivel(s.perc))),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

/* ===================== MISC ===================== */

class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}
