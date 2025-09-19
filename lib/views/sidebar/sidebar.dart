import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex; // -1 para nada selecionado
  final void Function(int index, String label) onSelect;

  /// Altura da topbar da página atual (ex.: Dashboard ≈ 76).
  final double topbarHeight;

  /// Branco suave (não muito aceso)
  final Color background;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    this.topbarHeight = 76.0,                         // alinhar com a topbar
    this.background = const Color(0xFFFAFBFC),        // branco suave
  });

  static const _sideBorder = Color(0xFFE2E8F0);
  static const _text = Color(0xFF0F172A);
  static const _blue1 = Color(0xFF1E3A8A);
  static const _blue2 = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    final items = _menuItems;

    return Container(
      decoration: BoxDecoration(
        color: background,
        border: const Border(right: BorderSide(color: _sideBorder)), // mantém o risco externo
      ),
      child: Column(
        children: [
          // Cabeçalho com mesma altura da topbar e ícone de chapéu
          SizedBox(
            height: topbarHeight,
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [_blue2, _blue1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 22),
              ),
            ),
          ),

          // ❌ Divider REMOVIDO (sem linha de divisão interna)

          // Itens
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.only(bottom: 16),
              itemBuilder: (_, i) {
                final item = items[i];
                final selected = selectedIndex == i;

                final tile = Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Material(
                    color: selected ? _blue2.withOpacity(.10) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onSelect(i, item.label),
                      child: Stack(
                        children: [
                          // Indicador azul colado à borda esquerda
                          Positioned(
                            left: 6,
                            top: 6,
                            bottom: 6,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutCubic,
                              width: selected ? 3 : 0,
                              decoration: BoxDecoration(
                                color: _blue2,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                            child: Row(
                              children: [
                                Icon(item.icon, size: 18, color: selected ? _blue2 : _text),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: _text,
                                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                // Quebras de linha após Notificações e Configurações
                final needsGapAfter =
                    item.label == 'Notificações' || item.label == 'Configurações';

                return Column(
                  children: [
                    tile,
                    if (needsGapAfter) const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Modelo local do item da sidebar
class _Item {
  final String label;
  final IconData icon;
  const _Item(this.label, this.icon);
}

/// Ordem fixa do menu (índices usados pelo shell)
const List<_Item> _menuItems = [
  _Item('Dashboard', Icons.dashboard_rounded),        // 0
  _Item('Aulas', Icons.menu_book_rounded),            // 1
  _Item('Feedbacks', Icons.reviews_rounded),          // 2
  _Item('Relatórios', Icons.insert_chart_outlined_rounded),
  _Item('Notificações', Icons.notifications_none_rounded),
  _Item('Conta', Icons.person_outline_rounded),
  _Item('Configurações', Icons.settings_outlined),
  _Item('Reclamações', Icons.support_agent_rounded),
  _Item('Sair', Icons.logout_rounded),                // 8
];
