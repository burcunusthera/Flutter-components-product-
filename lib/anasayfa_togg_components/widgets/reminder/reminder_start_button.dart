import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';

/// DS ReminderStartButton: 40 yükseklik, padding 0 16, radius 12, Primary/500; “Başla” 14/600.
class ReminderStartButton extends StatelessWidget {
  const ReminderStartButton({super.key, this.onTap, this.disabled = false});

  final VoidCallback? onTap;

  /// DS `disabled`: opaklık .4.
  final bool disabled;

  @override
  Widget build(BuildContext context) => Pressable(
        onTap: disabled ? null : onTap,
        semanticLabel: 'Başla',
        excludeChildSemantics: true,
        builder: (context, _) => Opacity(
          opacity: disabled ? .4 : 1,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: NdsColors.primary500, borderRadius: BorderRadius.circular(12)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const NdsIcon('User Interface/play', size: 16, color: NdsColors.grey0),
              const SizedBox(width: 8),
              Text('Başla', style: ndsText(14, 18, 600, NdsColors.grey0)),
            ]),
          ),
        ),
      );
}
