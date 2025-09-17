import 'package:flutter/material.dart';

class AulasPage extends StatefulWidget {
  const AulasPage({super.key});
  @override
  State<AulasPage> createState() => _AulasPageState();
}

/* ====================== TOKENS ====================== */

class _T {
  static const blue1 = Color(0xFF1E3A8A);
  static const blue2 = Color(0xFF2563EB);
  static const text = Color(0xFF0F172A);
  static const subtle = Color(0xFF64748B);
  static const bg = Color(0xFFF8FAFC);
  static const divider = Color(0xFFE2E8F0);
  static const radius = 12.0;

  // Sidebar claro (caso exista)
  static const sideBg = Colors.white;
  static const sideBorder = divider;
}

/* ======================= PAGE ======================= */

class _AulasPageState extends State<AulasPage> {
  // filtros (sem Disciplina)
  String facul = 'Faculdade Ciência e Tecnologia';
  String curso = 'Engenharia Informática';

  final faculdades = const [
    'Faculdade Ciência e Tecnologia',
    'Faculdade de Engenharia',
    'Faculdade de Gestão',
  ];
  final cursos = const [
    'Engenharia Informática',
    'Engenharia Civil',
    'Gestão',
  ];

  // mock de aulas
  late List<_Aula> aulas;

  @override
  void initState() {
    super.initState();
    aulas = [
      _Aula('2025-03-01', 'Sistemas Operativos', 'Prof. Carlos Lima', 'B1', 'Processos e Threads', 88, 'Muito bom', 'Lab 3'),
      _Aula('2025-03-03', 'Algoritmos', 'Profa. Ana Cruz', 'A2', 'Busca Binária', 92, 'Excelente', 'Sala 201'),
      _Aula('2025-03-05', 'Redes', 'Prof. Mauro Dias', 'C1', 'Modelo TCP/IP', 76, 'Regular', 'Lab 1'),
      _Aula('2025-03-07', 'Engenharia de Software', 'Prof. Telmo Rocha', 'B2', 'Casos de Uso', 84, 'Bom', 'Sala 105'),
      _Aula('2025-03-08', 'Sistemas Operativos', 'Prof. Carlos Lima', 'B1', 'Escalonamento', 81, 'Bom', 'Lab 4'),
      _Aula('2025-03-10', 'Redes', 'Prof. Mauro Dias', 'C1', 'ARP e DHCP', 73, 'Regular', 'Lab 2'),
      _Aula('2025-03-11', 'Algoritmos', 'Profa. Ana Cruz', 'A2', 'Ordenação Rápida', 89, 'Muito bom', 'Sala 203'),
      _Aula('2025-03-12', 'Engenharia de Software', 'Prof. Telmo Rocha', 'B2', 'Diagrama de Classes', 86, 'Muito bom', 'Sala 106'),
      _Aula('2025-03-13', 'Sistemas Operativos', 'Prof. Carlos Lima', 'B1', 'Memória Virtual', 83, 'Bom', 'Lab 5'),
      _Aula('2025-03-15', 'Redes', 'Prof. Mauro Dias', 'C1', 'Roteamento', 78, 'Regular', 'Lab 2'),
      _Aula('2025-03-16', 'Algoritmos', 'Profa. Ana Cruz', 'A2', 'Programação Dinâmica', 91, 'Excelente', 'Sala 204'),
      _Aula('2025-03-18', 'Engenharia de Software', 'Prof. Telmo Rocha', 'B2', 'User Stories', 82, 'Bom', 'Sala 107'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _T.bg,
      body: Row(
        children: [
          // Se usar sidebar fixa, ela viria aqui (200 px) com a mesma borda:
          // Container(width: 200, decoration: const BoxDecoration(
          //   color: _T.sideBg, border: Border(right: BorderSide(color: _T.sideBorder))
          // )),
          Expanded(
            child: Column(
              children: [
                const _TopbarAulas(),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: const _NoGlow(),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(0, 14, 16, 22), // 0 à esquerda: alinha no “risco”
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _FiltersRow(
                            facul: facul,
                            curso: curso,
                            faculdades: faculdades,
                            cursos: cursos,
                            onChanged: (f, c) => setState(() { facul = f; curso = c; }),
                          ),
                          const SizedBox(height: 12),
                          _LessonsTableFullWidth(rows: _applyFilters(aulas)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_Aula> _applyFilters(List<_Aula> src) {
    // aqui você pode filtrar por curso/faculdade se tiver esses campos no seu modelo
    // por enquanto retornamos tudo (só ordenado por data desc)
    final sorted = [...src]..sort((a, b) => b.data.compareTo(a.data));
    return sorted;
  }
}

/* ====================== TOPBAR ====================== */

class _TopbarAulas extends StatelessWidget {
  const _TopbarAulas();

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
            Text('Aulas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
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
            Text('João José Sitole', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            Text('Gestor', style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
        SizedBox(width: 8),
        CircleAvatar(radius: 16, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 18)),
      ],
    );
  }
}

/* ====================== FILTROS ====================== */

class _FiltersRow extends StatelessWidget {
  final String facul, curso;
  final List<String> faculdades, cursos;
  final void Function(String f, String c) onChanged;

  const _FiltersRow({
    super.key,
    required this.facul,
    required this.curso,
    required this.faculdades,
    required this.cursos,
    required this.onChanged,
  });

  Widget _label(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(s, style: const TextStyle(color: _T.subtle, fontSize: 12, fontWeight: FontWeight.w600)),
      );

  Widget _pill(String value, List<String> items, void Function(String) onChange) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _T.divider),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButton<String>(
          value: value,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => onChange(v!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Faculdade'),
              _pill(facul, faculdades, (v) => onChanged(v, curso)),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Curso'),
              _pill(curso, cursos, (v) => onChanged(facul, v)),
            ],
          ),
        ],
      ),
    );
  }
}

/* ====================== TABELA ====================== */

class _LessonsTableFullWidth extends StatelessWidget {
  final List<_Aula> rows;
  const _LessonsTableFullWidth({super.key, required this.rows});

  Color _levelColor(int p) {
    if (p >= 90) return const Color(0xFF16A34A); // verde forte
    if (p >= 80) return const Color(0xFF22C55E);
    if (p >= 70) return const Color(0xFFF59E0B); // âmbar
    return const Color(0xFFEF4444); // vermelho
  }

  Color _feedbackColor(String f) {
    switch (f) {
      case 'Excelente':
        return const Color(0xFF16A34A);
      case 'Muito bom':
      case 'Bom':
        return const Color(0xFF22C55E);
      case 'Regular':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: DataTable(
            headingRowColor: const MaterialStatePropertyAll(Colors.white),
            headingTextStyle: const TextStyle(fontWeight: FontWeight.w800, color: _T.text),
            dataTextStyle: const TextStyle(color: _T.text),
            columnSpacing: 28,
            headingRowHeight: 38,
            dataRowMinHeight: 34,
            dataRowMaxHeight: 38,
            columns: const [
              DataColumn(label: Text('Data')),
              // Disciplina removida
              DataColumn(label: Text('Docente')),
              DataColumn(label: Text('Turma')),
              DataColumn(label: Text('Tema / Assunto')),
              DataColumn(label: Text('Participação')),
              DataColumn(label: Text('Feedback')),
              DataColumn(label: Text('Sala')),
            ],
            rows: List<DataRow>.generate(rows.length, (i) {
              final a = rows[i];
              return DataRow(
                color: MaterialStatePropertyAll(i.isEven ? const Color(0xFFF8FAFC) : Colors.white),
                cells: [
                  DataCell(Text(a.data)),
                  DataCell(Text(a.docente)),
                  DataCell(Text(a.turma)),
                  DataCell(Text(a.tema)),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: a.participacao / 100,
                            color: _levelColor(a.participacao),
                            backgroundColor: const Color(0xFFE5E7EB),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${a.participacao}%'),
                    ],
                  )),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _feedbackColor(a.feedback).withOpacity(.10),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: _feedbackColor(a.feedback).withOpacity(.25)),
                    ),
                    child: Text(
                      a.feedback,
                      style: TextStyle(
                        color: _feedbackColor(a.feedback),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  )),
                  DataCell(Text(a.sala)),
                ],
              );
            }),
          ),
        ),
      );
    });
  }
}

/* ====================== MODELO ====================== */

class _Aula {
  final String data;
  final String cadeira; // mantido no modelo, mas não exibido
  final String docente;
  final String turma;
  final String tema;
  final int participacao; // %
  final String feedback;  // rótulo textual
  final String sala;

  _Aula(this.data, this.cadeira, this.docente, this.turma, this.tema, this.participacao, this.feedback, this.sala);
}

/* ======================= MISC ======================= */

class _NoGlow extends ScrollBehavior {
  const _NoGlow();
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}
