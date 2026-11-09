import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import 'nds_icon.dart';
import 'pressable.dart';

/// DS ActionLink: 32 yükseklik, 12/15 Greyscale/500 + 16 px chevron Greyscale/400.
class ActionLink extends StatelessWidget {
  const ActionLink({super.key, required this.label, this.onTap, this.enabled = true});

  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: enabled ? onTap : null,
      semanticLabel: label,
      excludeChildSemantics: true,
      builder: (context, pressed) {
        final c = !enabled ? NdsColors.grey300 : (pressed ? NdsColors.grey900 : NdsColors.grey500);
        final ic = !enabled ? NdsColors.grey300 : NdsColors.grey400;
        return Container(
          height: 32,
          decoration: BoxDecoration(
            color: pressed ? NdsColors.grey50 : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label, style: ndsText(12, 15, 400, c)),
            const SizedBox(width: 4),
            NdsIcon('User Interface/chevron right', size: 16, color: ic),
          ]),
        );
      },
    );
  }
}
