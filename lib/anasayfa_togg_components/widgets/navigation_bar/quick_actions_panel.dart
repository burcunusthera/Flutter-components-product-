import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_shadows.dart';
import '../../theme/nds_text.dart';
import '../common/glass_surface.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';

/// DS QuickActionsPanel (G2-4): padding 24, kenar 1 Greyscale/25, radius 20, zemin Greyscale/25 %20, blur 16.
class QuickAction {
  const QuickAction({required this.icon, required this.label, this.onTap, this.disabled = false});

  final String icon;

  /// İki satır (“Öğün\nekle”).
  final String label;
  final VoidCallback? onTap;
  final bool disabled;
}

/// Prototipteki dört aksiyon (ikon + etiket). Yönlendirmeleri uygulama verir.
List<QuickAction> defaultQuickActions({
  VoidCallback? onMeal,
  VoidCallback? onMedicine,
  VoidCallback? onLabResult,
  VoidCallback? onRecords,
  bool offline = false,
}) =>
    [
      QuickAction(icon: 'Traveling/fork and spoon', label: 'Öğün\nekle', onTap: onMeal, disabled: offline),
      QuickAction(icon: 'Medical/pills', label: 'İlaç\nekle', onTap: onMedicine, disabled: offline),
      QuickAction(icon: 'File/upload file', label: 'Tahlil\nyorumlat', onTap: onLabResult, disabled: offline),
      QuickAction(icon: 'Medical/medic folder 1', label: 'Sağlık\nkayıtlarım', onTap: onRecords, disabled: offline),
    ];

class QuickActionsPanel extends StatelessWidget {
  const QuickActionsPanel({super.key, required this.items, this.onClose});

  final List<QuickAction> items;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: 'Hızlı aksiyonlar',
      child: GlassSurface(
        radius: BorderRadius.circular(20),
        blur: 16,
        color: const Color(0x33F9F9F9), // Greyscale/25 %20
        border: Border.all(color: NdsColors.grey25),
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(
            alignment: Alignment.centerRight,
            child: Pressable(
              onTap: onClose,
              semanticLabel: 'Kapat',
              excludeChildSemantics: true,
              builder: (context, pressed) => Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(shape: BoxShape.circle, color: pressed ? NdsColors.grey50 : null),
                child: const NdsIcon('Atoms/x', size: 24, color: NdsColors.grey900),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final it in items) _QuickActionItem(item: it),
          ]),
        ]),
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({required this.item});

  final QuickAction item;

  @override
  Widget build(BuildContext context) {
    final c = item.disabled ? NdsColors.grey300 : NdsColors.grey900;
    return Pressable(
      onTap: item.disabled ? null : item.onTap,
      semanticLabel: item.disabled
          ? '${item.label.replaceAll('\n', ' ')}, internet bağlantısı gerektiği için kullanılamıyor'
          : item.label.replaceAll('\n', ' '),
      excludeChildSemantics: true,
      builder: (context, pressed) => SizedBox(
        width: 64,
        child: Column(children: [
          GlassSurface(
            width: 48,
            height: 48,
            radius: BorderRadius.circular(9999),
            blur: 16,
            color: pressed ? const Color(0xE6ECEFF3) : const Color(0xE6FFFFFF), // %90
            border: Border.all(color: const Color(0xCCFFFFFF)), // beyaz %80
            boxShadow: NdsShadows.qaItem,
            padding: const EdgeInsets.all(12),
            child: NdsIcon(item.icon, size: 24, color: c),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(item.label, textAlign: TextAlign.center, style: ndsText(12, 15, 500, c)),
          ),
        ]),
      ),
    );
  }
}
