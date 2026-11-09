import 'package:flutter/widgets.dart';

import '../../models/device.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import 'metric_tone.dart';

/// DS MetricStatusBadge: 29 yükseklik, padding 4 16, radius 100, Greyscale/25 zemin, 1 px ton kenarı.
class MetricStatusBadge extends StatelessWidget {
  const MetricStatusBadge({super.key, required this.tone, this.label});

  final MetricTone tone;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final text = label ?? switch (tone) { MetricTone.success => 'Normal', MetricTone.primary => 'Harika', MetricTone.warning => 'Dikkat edin' };
    final textColor = tone == MetricTone.primary ? NdsColors.primary500 : NdsColors.grey800;
    return Container(
      height: 29,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: NdsColors.grey25,
        border: Border.all(color: metricToneColor(tone)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(text, softWrap: false, style: ndsText(12, 15, 500, textColor)),
    );
  }
}
