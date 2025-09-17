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
      _Subject(cadeira: 'Sistemas Operacionais', docente: 'Profa. Júlia Nunes', estudantes: 102, perc: 65, rating: 3.7, destaque: false),
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
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 22), // agora com padding padrão
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ======= BLOCO CENTRAL (cards + gráfico + destaques) =======
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
                            _ChartAndHighlightsRow(data: data),
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
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 22), // padding normal sem sidebar
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

/* ===================== KPIs — UMA LINHA COM ANIMAÇÃO ===================== */

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
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _KpiCard(data: items[i]),
      ),
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 140),
        child: Container(
          width: 270,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _Tokens.divider),
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
      ),
    );
  }
}

/* ===================== GRÁFICO + DESTAQUES ===================== */

class _ChartAndHighlightsRow extends StatelessWidget {
  final List<_Subject> data;
  const _ChartAndHighlightsRow({super.key, required this.data});

  String _feedbackLabel(double r) {
    if (r >= 4.5) return 'Excelente';
    if (r >= 4.0) return 'Muito bom';
    if (r >= 3.5) return 'Bom';
    if (r >= 3.0) return 'Regular';
    return 'Baixo';
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 980;
    final destaques = data.where((e) => e.perc >= 85).toList()
      ..sort((a, b) => b.perc.compareTo(a.perc));

    final highlightsTable = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: const MaterialStatePropertyAll(Colors.white),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.w800, color: _Tokens.text),
        dataTextStyle: const TextStyle(color: _Tokens.text),
        columnSpacing: 24,
        headingRowHeight: 34,
        dataRowMinHeight: 30,
        dataRowMaxHeight: 34,
        columns: const [
          DataColumn(label: Text('Cadeira')),
          DataColumn(label: Text('Docente')),
          DataColumn(label: Text('Assimilação')),
        ],
        rows: List.generate(destaques.length, (i) {
          final s = destaques[i];
          return DataRow(
            color: MaterialStatePropertyAll(i.isEven ? const Color(0xFFF8FAFC) : Colors.white),
            cells: [
              DataCell(Text(s.cadeira)),
              DataCell(Text(s.docente)),
              DataCell(Text('${s.perc.toStringAsFixed(0)}%  •  ${_feedbackLabel(s.rating)}')),
            ],
          );
        }),
      ),
    );

    return wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gráfico
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Evolução de Satisfação (semanas)', style: TextStyle(color: _Tokens.subtle)),
                    SizedBox(height: 6),
                    SizedBox(height: 230, child: _LineChart()),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Destaques
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Destaques', style: TextStyle(color: _Tokens.subtle)),
                    const SizedBox(height: 6),
                    SizedBox(height: 230, child: highlightsTable),
                  ],
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Evolução de Satisfação (semanas)', style: TextStyle(color: _Tokens.subtle)),
              const SizedBox(height: 6),
              const SizedBox(height: 230, child: _LineChart()),
              const SizedBox(height: 12),
              const Text('Destaques', style: TextStyle(color: _Tokens.subtle)),
              const SizedBox(height: 6),
              SizedBox(height: 230, child: highlightsTable),
            ],
          );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({super.key});
  @override
  Widget build(BuildContext context) {
    final weeks = [3.4, 3.6, 3.8, 4.0, 4.2, 4.1, 4.3];
    final spots = weeks.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

    return LineChart(
      LineChartData(
        minY: 0, maxY: 5,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (_) => FlLine(color: _Tokens.divider, strokeWidth: 1),
          drawVerticalLine: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 26, interval: 1)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) => Text(
                ['Qui','Sex','Sáb','Dom','Seg','Ter','Qua'][v.toInt() % 7],
                style: const TextStyle(fontSize: 10, color: _Tokens.subtle),
              ),
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
            barWidth: 2.2,
            gradient: const LinearGradient(colors: [_Tokens.blue2, _Tokens.blue1]),
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [_Tokens.blue2.withOpacity(.16), _Tokens.blue1.withOpacity(.05)],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
