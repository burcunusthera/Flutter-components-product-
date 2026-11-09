import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../common/nds_icon.dart';

/// DS ReminderStatusMark türleri.
enum ReminderMarkType { taken, skipped, saving }

/// DS ReminderStatusMark: 32 daire. Alındı: Success/100 + Success/800 tik (24).
class ReminderStatusMark extends StatelessWidget {
  const ReminderStatusMark(this.type, {super.key});

  final ReminderMarkType type;

  @override
  Widget build(BuildContext context) {
    final taken = type == ReminderMarkType.taken;
    return Semantics(
      label: switch (type) { ReminderMarkType.taken => 'Alındı', ReminderMarkType.skipped => 'Atlandı', ReminderMarkType.saving => 'Kaydediliyor' },
      excludeSemantics: true,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle, color: taken ? NdsColors.success100 : NdsColors.grey100),
        child: taken
            ? const NdsIcon('Reminder/Icon · Check', size: 24, color: NdsColors.success800)
            : NdsIcon(type == ReminderMarkType.skipped ? 'User Interface/cross' : 'User Interface/refresh', size: 18, color: NdsColors.grey900),
      ),
    );
  }
}
