import 'package:flutter/widgets.dart';

import '../../models/device.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_shadows.dart';
import 'metric_tone.dart';

/// DS VerticalMetricIndicator: 10×80 iz (Greyscale/25), çubuk 7 + 0.66 × seviye, 14 px işaretçi (3 px ton kenarı).
class VerticalMetricIndicator extends StatelessWidget {
  const VerticalMetricIndicator({super.key, required this.tone, required this.level});

  /// null → ton yok (çubuk çizilmez).
  final MetricTone? tone;
  final int level;

  @override
  Widget build(BuildContext context) {
    final t = tone;
    final lv = t == null ? 0 : level.clamp(1, 100);
    final bar = 7 + 0.66 * lv;
    return SizedBox(
      width: 10,
      height: 80,
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned.fill(
          child: DecoratedBox(decoration: BoxDecoration(color: NdsColors.grey25, borderRadius: BorderRadius.circular(9999))),
        ),
        if (t != null && lv > 0) ...[
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: bar,
            child: DecoratedBox(decoration: BoxDecoration(color: metricToneColor(t), borderRadius: BorderRadius.circular(9999))),
          ),
          Positioned(
            left: -2,
            bottom: bar - 7,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: NdsColors.grey0,
                shape: BoxShape.circle,
                border: Border.all(color: metricToneColor(t), width: 3),
                boxShadow: NdsShadows.vmiMarker,
              ),
            ),
          ),
        ],
      ]),
    );
  }
}
