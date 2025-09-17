import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Página geral de relatórios de feedbacks (lista + gráfico).
/// NÃO usa Scaffold: ela é renderizada DENTRO do shell com sidebar.
class FeedbacksReportPage extends StatelessWidget {
  const FeedbacksReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dados = const [
      // cadeira, curso do estudante (anônimo), % (classificação)
      ['Algoritmos', 'Eng. Informática', 92],
      ['Estruturas de Dados', 'Eng. Informática', 88],
      ['BD I', 'Eng. Informática', 79],
      ['Redes', 'Eng. Informática', 73],
      ['Sistemas Operacionais', 'Eng. Informática', 65],
      ['Mineração de Dados', 'Eng. Informática', 89],
    ];

    String label(int p) {
      if (p >= 85) return 'Excelente';
      if (p >= 75) return 'Bom';
      if (p >= 60) return 'Mediano';
      return 'Ruim';
      }

    final spots = List.generate(
      dados.length,
      (i) => FlSpot(i.toDouble(), (dados[i][2] as int).toDouble()),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Relatórios de Feedbacks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Resumo agregado por cadeira (estudantes anônimos)',
            style: TextStyle(color: Colors.black.withOpacity(.6)),
          ),
          const SizedBox(height: 16),

          // Gráfico simples (linha de % por cadeira)
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: 0, maxY: 100,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (_) => FlLine(color: const Color(0xFFE2E8F0), strokeWidth: 1),
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 20),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= dados.length) return const SizedBox.shrink();
                        final name = (dados[i][0] as String);
                        final short = name.length > 8 ? '${name.substring(0, 8)}…' : name;
                        return Text(short, style: const TextStyle(fontSize: 10));
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
                    barWidth: 2.2,
                    gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)]),
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [const Color(0xFF2563EB).withOpacity(.16), const Color(0xFF1E3A8A).withOpacity(.05)],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tabela
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowColor: const MaterialStatePropertyAll(Colors.white),
                      headingTextStyle: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      dataTextStyle: const TextStyle(color: Color(0xFF0F172A)),
                      columnSpacing: 28,
                      headingRowHeight: 38,
                      dataRowMinHeight: 34,
                      dataRowMaxHeight: 38,
                      columns: const [
                        DataColumn(label: Text('Cadeira')),
                        DataColumn(label: Text('Curso do estudante')),
                        DataColumn(label: Text('Classificação (%)')),
                        DataColumn(label: Text('Nível')),
                      ],
                      rows: List<DataRow>.generate(dados.length, (i) {
                        final row = dados[i];
                        final p = row[2] as int;
                        return DataRow(
                          color: MaterialStatePropertyAll(i.isEven ? const Color(0xFFF8FAFC) : Colors.white),
                          cells: [
                            DataCell(Text(row[0] as String)),
                            DataCell(Text(row[1] as String)),
                            DataCell(Text('$p%')),
                            DataCell(Text(label(p))),
                          ],
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Detalhe de um feedback específico (de um estudante específico, ANÔNIMO)
/// Espera receber `feedback` via RouteSettings.arguments.
class FeedbackDetailPage extends StatelessWidget {
  final dynamic feedback; // você pode trocar para um modelo forte depois
  const FeedbackDetailPage({super.key, required this.feedback});

  String _nivel(int p) {
    if (p >= 85) return 'Excelente';
    if (p >= 75) return 'Bom';
    if (p >= 60) return 'Mediano';
    return 'Ruim';
  }

  @override
  Widget build(BuildContext context) {
    // Exemplo de estrutura esperada no `feedback`:
    // {
    //   'cadeira': 'Algoritmos',
    //   'cursoEstudante': 'Eng. Informática',
    //   'percentual': 82, // 0..100
    //   'mensagem': 'A aula foi clara, gostei dos exemplos.',
    //   'data': '2025-03-10'
    // }
    final map = (feedback is Map) ? feedback as Map : const {};
    final cadeira = (map['cadeira'] ?? '—').toString();
    final curso = (map['cursoEstudante'] ?? '—').toString();
    final perc = (map['percentual'] ?? 0) as int;
    final msg = (map['mensagem'] ?? 'Sem mensagem.').toString();
    final data = (map['data'] ?? '—').toString();

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

          // “Cartões” simples com info da aula
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _infoChip('Cadeira', cadeira),
              _infoChip('Classificação', '$perc% • ${_nivel(perc)}'),
            ],
          ),
          const SizedBox(height: 16),

          const Text('Mensagem do estudante',
              style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(msg),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(value),
        ],
      ),
    );
  }
}
