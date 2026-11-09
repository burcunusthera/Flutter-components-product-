import 'package:flutter/material.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import 'pressable.dart';

/// primary: Primary/500 · secondary: 1 px Primary/500 kenar · destructive: DS state=error (Danger/500).
enum NdsButtonType { primary, secondary, destructive }

/// DS Button, size large: 52 yükseklik, radius 12, 14/18/500.
class NdsButton extends StatelessWidget {
  const NdsButton({super.key, required this.label, this.type = NdsButtonType.primary, this.onTap});

  final String label;
  final NdsButtonType type;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    final primary = type != NdsButtonType.secondary;
    final danger = type == NdsButtonType.destructive;
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      excludeChildSemantics: true,
      builder: (context, pressed) {
        Color bg;
        Color fg;
        Color? border;
        if (primary) {
          bg = disabled
              ? NdsColors.primary100
              : danger
                  ? NdsColors.danger500
                  : (pressed ? const Color(0xFF081020) : NdsColors.primary500);
          fg = NdsColors.grey0;
        } else {
          bg = pressed ? NdsColors.grey25 : Colors.transparent;
          fg = disabled ? NdsColors.grey300 : NdsColors.grey900;
          border = disabled ? NdsColors.primary100 : NdsColors.primary500;
        }
        return Container(
          height: 52,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border ?? Colors.transparent),
          ),
          child: Text(label, maxLines: 1, style: ndsText(14, 18, 500, fg)),
        );
      },
    );
  }
}
