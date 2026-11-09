import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/glass_surface.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';

/// DS BottomNav: padding 0 16, aralık 8. Çubuk 72, padding 8, rgba(0,0,0,.04), radius 52, blur 8.
/// Öğe 80×56, radius 60; seçili rgba(0,0,0,.1) + Primary/500 12/15/500. Artı 72×72; Free'de kilitli.
enum HomeTab { bugun, therus, saglik }

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key, this.value = HomeTab.bugun, this.plusLocked = false, this.onChanged, this.onPlus});

  final HomeTab value;
  final bool plusLocked;
  final ValueChanged<HomeTab>? onChanged;
  final VoidCallback? onPlus;

  static const _items = [
    (HomeTab.bugun, 'Bugün', 'User Interface/home'),
    (HomeTab.therus, 'Therus AI', 'Therus AI Line icon'),
    (HomeTab.saglik, 'Sağlığım', 'Medical/heart care 2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Expanded(
          child: GlassSurface(
            height: 72,
            radius: BorderRadius.circular(52),
            blur: 8,
            color: const Color(0x0A000000),
            padding: const EdgeInsets.all(8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              for (final it in _items) _NavItem(label: it.$2, icon: it.$3, on: it.$1 == value, onTap: onChanged == null ? null : () => onChanged!(it.$1)),
            ]),
          ),
        ),
        const SizedBox(width: 8),
        Pressable(
          onTap: onPlus,
          semanticLabel: plusLocked ? 'Hızlı aksiyonlar, Premium gerekli' : 'Hızlı aksiyonlar',
          excludeChildSemantics: true,
          builder: (context, _) => GlassSurface(
            width: 72,
            height: 72,
            radius: BorderRadius.circular(52),
            blur: 8,
            color: const Color(0x0A000000),
            child: Stack(children: [
              Center(child: NdsIcon('User Interface/plus', size: 24, color: plusLocked ? NdsColors.grey400 : NdsColors.grey900)),
              if (plusLocked)
                const Positioned(right: 14, top: 14, child: NdsIcon('Security/lock 2', size: 12, color: NdsColors.grey900)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.label, required this.icon, required this.on, this.onTap});

  final String label;
  final String icon;
  final bool on;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = on ? NdsColors.primary500 : NdsColors.grey900;
    return Semantics(
      selected: on,
      child: Pressable(
        onTap: onTap,
        semanticLabel: label,
        excludeChildSemantics: true,
        builder: (context, _) => Container(
          width: 80,
          height: 56,
          decoration: BoxDecoration(
            color: on ? const Color(0x1A000000) : null,
            borderRadius: BorderRadius.circular(60),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            NdsIcon(icon, size: 24, color: c),
            Text(label, style: ndsText(12, 15, on ? 500 : 400, c)),
          ]),
        ),
      ),
    );
  }
}
