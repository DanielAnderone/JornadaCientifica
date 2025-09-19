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

  // Tabela (cores suaves como no print)
  static const tableBorder = Color(0xFFBFD3FF);
  static const tableHeader = Color(0xFFE8F0FF);

  static const radius = 12.0;
}

/* ======================= PAGE ======================= */

class _AulasPageState extends State<AulasPage> {
  // filtros
  String facul = 'Faculdade Ciência e Tecnologia';
  String curso = 'Engenharia Informática';
  String disciplina = 'Sistemas Operativos';

  final faculdades = const [
    'Faculdade Ciência e Tecnologia',
    'Faculdade de Engenharia',
    'Faculdade de Gestão',
  ];
  final cursos = const ['Engenharia Informática', 'Engenharia Civil', 'Gestão'];
  final disciplinas = const [
    'Sistemas Operativos',
    'Algoritmos',
    'Redes',
    'Engenharia de Software',
  ];

  // disciplina -> docente
  final Map<String, String> _docentePorDisciplina = const {
    'Sistemas Operativos': 'Prof. Carlos Lima',
    'Algoritmos': 'Profa. Ana Cruz',
    'Redes': 'Prof. Mauro Dias',
    'Engenharia de Software': 'Prof. Telmo Rocha',
  };

  // mock: aulas
  late final List<_Aula> aulas;

  @override
  void initState() {
    super.initState();
    aulas = [
      _Aula(
        disciplina: 'Sistemas Operativos',
        disponibilizado: '17/09/2025',
        resumo: 'Ficha 1: Conceitos básicos da Programação',
        estudantes: [
          _EstudanteFeedback(curso: 'Engenharia Informática', perc: 92, comentario: 'Compreensão excelente.'),
          _EstudanteFeedback(curso: 'Engenharia Informática', perc: 78, comentario: 'Dúvidas em escalonamento.'),
          _EstudanteFeedback(curso: 'Engenharia Informática', perc: 65, comentario: 'Precisa rever processos.'),
        ],
      ),
      _Aula(
        disciplina: 'Sistemas Operativos',
        disponibilizado: '13/09/2025',
        resumo: 'Pixer: Dimensionamento',
        estudantes: [
          _EstudanteFeedback(curso: 'Engenharia Informática', perc: 81, comentario: 'Bom ritmo.'),
          _EstudanteFeedback(curso: 'Engenharia Informática', perc: 74, comentario: 'Algumas lacunas.'),
          _EstudanteFeedback(curso: 'Engenharia Informática', perc: 59, comentario: 'Revisão recomendada.'),
        ],
      ),
      _Aula(
        disciplina: 'Sistemas Operativos',
        disponibilizado: '11/09/2025',
        resumo: 'Kenet: Lei de Newton',
        estudantes: [
          _EstudanteFeedback(curso: 'Engenharia Informática', perc: 87, comentario: 'Muito bom entendimento.'),
          _EstudanteFeedback(curso: 'Engenharia Informática', perc: 70, comentario: 'Médio; refazer exercícios.'),
          _EstudanteFeedback(curso: 'Engenharia Informática', perc: 45, comentario: 'Baixa assimilação.'),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final docenteSel = _docentePorDisciplina[disciplina] ?? '—';

    return Scaffold(
      backgroundColor: _T.bg,
      body: Row(
        children: [
          // (se tiver sidebar fixa, ela fica aqui)
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
                            disciplina: disciplina,
                            docente: docenteSel,
                            faculdades: faculdades,
                            cursos: cursos,
                            disciplinas: disciplinas,
                            onChanged: (f, c, d) => setState(() {
                              facul = f;
                              curso = c;
                              disciplina = d;
                            }),
                          ),
                          const SizedBox(height: 16), // desce a tabela um pouco
                          _LessonsTableExact(
                            rows: aulas.where((a) => a.disciplina == disciplina).toList(),
                            onVer: _openRecepcaoEstudantes,
                            onEditar: (aula) {},
                          ),
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

  void _openRecepcaoEstudantes(_Aula aula) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .7,
        minChildSize: .5,
        maxChildSize: .9,
        builder: (context, scroll) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.visibility_outlined, color: _T.blue2),
                    const SizedBox(width: 8),
                    Text(
                      'Recepção — ${aula.disciplina} (${aula.disponibilizado})',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(aula.resumo, style: const TextStyle(color: _T.subtle)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    controller: scroll,
                    itemCount: aula.estudantes.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final e = aula.estudantes[i];
                      final label = _classificacao(e.perc);
                      final color = _classColor(e.perc);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            SizedBox(width: 220, child: Text(e.curso, style: const TextStyle(fontWeight: FontWeight.w700))),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(999),
                                      child: LinearProgressIndicator(
                                        value: e.perc / 100,
                                        minHeight: 8,
                                        backgroundColor: const Color(0xFFE5E7EB),
                                        color: color,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(width: 40, child: Text('${e.perc.toStringAsFixed(0)}%')),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: color.withOpacity(.10),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: color.withOpacity(.25)),
                              ),
                              child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _classificacao(double p) {
    if (p >= 85) return 'Excelente';
    if (p >= 70) return 'Bom';
    if (p >= 50) return 'Mediano';
    return 'Baixo';
  }

  static Color _classColor(double p) {
    if (p >= 85) return const Color(0xFF16A34A);
    if (p >= 70) return const Color(0xFF22C55E);
    if (p >= 50) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
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

/* ====================== FILTROS (compactos + docente) ====================== */

class _FiltersRow extends StatelessWidget {
  final String facul, curso, disciplina, docente;
  final List<String> faculdades, cursos, disciplinas;
  final void Function(String f, String c, String d) onChanged;

  const _FiltersRow({
    super.key,
    required this.facul,
    required this.curso,
    required this.disciplina,
    required this.docente,
    required this.faculdades,
    required this.cursos,
    required this.disciplinas,
    required this.onChanged,
  });

  Widget _label(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(s, style: const TextStyle(color: _T.subtle, fontSize: 12, fontWeight: FontWeight.w600)),
      );

  Widget _pillDropdown({
    required String value,
    required List<String> items,
    required void Function(String) onChange,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _T.text),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          items: items
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e, overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: (v) => onChange(v!),
        ),
      ),
    );
  }

  Widget _docenteBadge(String docente) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, size: 16, color: _T.blue2),
          const SizedBox(width: 6),
          Text('Docente: $docente',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _T.blue2)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16, right: 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Faculdade'),
              _pillDropdown(
                value: facul,
                items: faculdades,
                onChange: (v) => onChanged(v, curso, disciplina),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Curso'),
              _pillDropdown(
                value: curso,
                items: cursos,
                onChange: (v) => onChanged(facul, v, disciplina),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Disciplina'),
              _pillDropdown(
                value: disciplina,
                items: disciplinas,
                onChange: (v) => onChanged(facul, curso, v),
              ),
            ],
          ),
          const SizedBox(width: 16),
          _docenteBadge(docente),
        ],
      ),
    );
  }
}

/* ====================== TABELA (layout do print) ====================== */

class _LessonsTableExact extends StatelessWidget {
  final List<_Aula> rows;
  final void Function(_Aula) onVer;
  final void Function(_Aula) onEditar;

  const _LessonsTableExact({
    super.key,
    required this.rows,
    required this.onVer,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontWeight: FontWeight.w800, color: _T.text, fontSize: 13);
    const cellStyle = TextStyle(color: _T.text, fontSize: 13);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: _T.tableBorder),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                // Cabeçalho
                Container(
                  decoration: BoxDecoration(
                    color: _T.tableHeader,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    border: const Border(bottom: BorderSide(color: _T.tableBorder)),
                  ),
                  child: _row(
                    isHeader: true,
                    gap: 14,
                    leading: const Text('Disciplina', style: headerStyle),
                    middle: const Text('Disponibilizado', style: headerStyle),
                    trailing: const Text('Feedback e Comentário', style: headerStyle),
                  ),
                ),
                // Linhas
                for (final a in rows)
                  _row(
                    gap: 14,
                    leading: Text(_short(a.disciplina), style: cellStyle),
                    middle: Text(a.disponibilizado, style: cellStyle),
                    trailing: Row(
                      children: [
                        Expanded(child: Text(a.resumo, style: cellStyle, overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 8),
                        _IconBtn(icon: Icons.visibility_outlined, tooltip: 'Ver', onTap: () => onVer(a)),
                        const SizedBox(width: 6),
                        _IconBtn(icon: Icons.edit_outlined, tooltip: 'Editar', onTap: () => onEditar(a)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${rows.isEmpty ? 0 : 1}/4', style: const TextStyle(color: _T.subtle, fontSize: 12)),
              const SizedBox(width: 6),
              IconButton(icon: const Icon(Icons.chevron_right), color: _T.subtle, onPressed: () {}),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }

  static String _short(String s) => s.length > 14 ? '${s.substring(0, 13)}…' : s;

  Widget _row({
    required Widget leading,
    required Widget middle,
    required Widget trailing,
    required double gap,
    bool isHeader = false,
  }) {
    final cellPad = const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    final cellBorder = BorderSide(color: _T.tableBorder);

    Widget cell(Widget child, {BorderRadius? r}) => Container(
          padding: cellPad,
          decoration: BoxDecoration(
            border: Border(right: cellBorder, bottom: isHeader ? BorderSide.none : cellBorder),
          ),
          child: child,
        );

    return Row(
      children: [
        Expanded(flex: 5, child: cell(leading)), // Disciplina
        Expanded(flex: 3, child: cell(middle)),  // Disponibilizado
        Expanded(
          flex: 10,
          child: Container(
            padding: cellPad,
            decoration: BoxDecoration(border: Border(bottom: isHeader ? BorderSide.none : cellBorder)),
            child: trailing,
          ),
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: _T.tableBorder),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Icon(icon, size: 18, color: _T.text),
        ),
      ),
    );
  }
}

/* ====================== MODELOS ====================== */

class _Aula {
  final String disciplina;
  final String disponibilizado; // dd/mm/yyyy
  final String resumo;
  final List<_EstudanteFeedback> estudantes;

  _Aula({
    required this.disciplina,
    required this.disponibilizado,
    required this.resumo,
    required this.estudantes,
  });
}

class _EstudanteFeedback {
  final String curso; // sem nome
  final double perc;  // assimilação %
  final String comentario;

  _EstudanteFeedback({
    required this.curso,
    required this.perc,
    required this.comentario,
  });
}

/* ======================= MISC ======================= */

class _NoGlow extends ScrollBehavior {
  const _NoGlow();
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}
