import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex; // -1 para nada selecionado
  final void Function(int index, String label) onSelect;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  static const _sideBorder = Color(0xFFE2E8F0);
  static const _text = Color(0xFF0F172A);
  static const _hover = Color(0xFFF3F6FF);
  static const _blue1 = Color(0xFF1E3A8A);
  static const _blue2 = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    final items = _menuItems;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: _sideBorder)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo (alinhada com o topbar)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: _blue2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.power_settings_new, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'EstudaMOZ\nUnizambeze',
                      style: TextStyle(
                        color: _text,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: _sideBorder),
            const SizedBox(height: 8),

            // Itens
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.only(bottom: 16),
                itemBuilder: (_, i) {
                  final item = items[i];
                  final selected = selectedIndex == i;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Material(
                      color: selected ? _blue2.withOpacity(.10) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => onSelect(i, item.label),
                        child: Stack(
                          children: [
                            // Indicador azul colado na borda
                            Positioned.fill(
                              left: 6,
                              right: null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutCubic,
                                width: selected ? 3 : 0,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: selected ? _blue2 : Colors.transparent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                              child: Row(
                                children: [
                                  Icon(item.icon, size: 18,
                                      color: selected ? _blue2 : _text),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modelo local do item da sidebar (sem importar rotas aqui)
class _Item {
  final String label;
  final IconData icon;
  const _Item(this.label, this.icon);
}

/// Ordem fixa do menu (índices usados pelo shell)
const List<_Item> _menuItems = [
  _Item('Dashboard', Icons.dashboard_rounded),        // index 0
  _Item('Aulas', Icons.menu_book_rounded),            // index 1
  _Item('Feedbacks', Icons.reviews_rounded),          // index 2
  _Item('Relatórios', Icons.insert_chart_outlined_rounded),
  _Item('Notificações', Icons.notifications_none_rounded),
  _Item('Conta', Icons.person_outline_rounded),
  _Item('Configurações', Icons.settings_outlined),
  _Item('Reclamações', Icons.support_agent_rounded),
  _Item('Sair', Icons.logout_rounded),                // index 8
];
  