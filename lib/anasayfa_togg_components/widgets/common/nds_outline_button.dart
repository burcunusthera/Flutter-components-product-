import 'package:flutter/material.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import 'pressable.dart';

/// DS .nds-outline-btn (48) ve .is-small (40).
class NdsOutlineButton extends StatelessWidget {
  const NdsOutlineButton({super.key, required this.label, this.small = false, this.onTap});

  final String label;
  final bool small;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      excludeChildSemantics: true,
      builder: (context, _) => Container(
        height: small ? 40 : 48,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: small ? 0 : 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: small ? NdsColors.grey0 : Colors.transparent,
          border: Border.all(color: NdsColors.primary500),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: small ? ndsText(14, 18, 600, NdsColors.primary500) : ndsText(14, 18, 500, NdsColors.grey900),
        ),
      ),
    );
  }
}
