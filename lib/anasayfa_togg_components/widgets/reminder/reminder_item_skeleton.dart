import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../common/nds_skel.dart';
import 'reminder_thumbnail.dart';

/// Yükleniyor satırı: 64 px görsel iskeleti + 140×16 ve 96×12 çizgiler.
class ReminderItemSkeleton extends StatelessWidget {
  const ReminderItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: NdsColors.grey0, borderRadius: BorderRadius.circular(16)),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: NdsColors.grey50),
        ),
        child: const Row(children: [
          ReminderThumbnail(null),
          SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            NdsSkel(width: 140, height: 16, radius: 6),
            SizedBox(height: 8),
            NdsSkel(width: 96, height: 12, radius: 6),
          ]),
        ]),
      );
}
