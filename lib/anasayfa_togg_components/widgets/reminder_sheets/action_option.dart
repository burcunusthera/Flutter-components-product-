import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';

/// DS ActionOption: en az 56 yükseklik, padding 16 12, radius 12, aralık 12, ikon 24, 16/20.
/// Yıkıcı seçenek Danger/500; basılıyken zemin Greyscale/50.
class ActionOption extends StatelessWidget {
  const ActionOption({super.key, required this.label, required this.icon, this.destructive = false, this.onTap});

  final String label;
  final String icon;
  final bool destructive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = onTap == null ? NdsColors.grey300 : (destructive ? NdsColors.danger500 : NdsColors.grey900);
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      excludeChildSemantics: true,
      builder: (context, pressed) => Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: pressed ? NdsColors.grey50 : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          NdsIcon(icon, size: 24, color: c),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: ndsText(16, 20, 400, c))),
        ]),
      ),
    );
  }
}

/// Seçenekler arası ayraç: 1 px Greyscale/50, yanlardan 12.
class ActionOptionDivider extends StatelessWidget {
  const ActionOptionDivider({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: NdsColors.grey50,
      );
}
