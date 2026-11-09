import 'package:flutter/widgets.dart';

import '../../models/reminder.dart';
import '../../theme/nds_colors.dart';
import '../common/nds_icon.dart';

/// DS ReminderThumbnail: 64×64, radius 12, Greyscale/50 zemin, görsel cover.
class ReminderThumbnail extends StatelessWidget {
  const ReminderThumbnail(this.type, {super.key});

  final ReminderThumb? type; // null = yükleniyor

  @override
  Widget build(BuildContext context) {
    final t = type;
    Widget? child;
    if (t == ReminderThumb.fallback) {
      child = const Center(child: NdsIcon('Medical/pills', size: 32, color: NdsColors.grey900));
    } else if (t != null) {
      final file = switch (t) {
        ReminderThumb.tablet => 'tablet',
        ReminderThumb.softgel => 'softgel',
        ReminderThumb.blister => 'blister',
        ReminderThumb.vitaminTablet => 'vitamin_tablet',
        ReminderThumb.activity => 'activity',
        ReminderThumb.fallback => 'tablet',
      };
      child = Image.asset('$kAssetRoot/images/reminders/$file.png', fit: BoxFit.cover, width: 64, height: 64);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 64,
        height: 64,
        color: t == null ? NdsColors.grey100 : NdsColors.grey50,
        child: child,
      ),
    );
  }
}
