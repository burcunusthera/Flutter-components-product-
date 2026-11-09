import 'package:flutter/widgets.dart';

import '../../models/stress.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';

/// DS StressTag: 23 yükseklik, padding 0 16, radius 20, 12/15/500.
class StressTag extends StatelessWidget {
  const StressTag({super.key, required this.mood});

  final StressMood mood;

  @override
  Widget build(BuildContext context) => Container(
        height: 23,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: NdsColors.stressTag[mood.label],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(mood.label, style: ndsText(12, 15, 500, NdsColors.grey900)),
      );
}
