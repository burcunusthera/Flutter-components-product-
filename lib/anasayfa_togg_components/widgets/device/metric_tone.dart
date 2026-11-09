import 'package:flutter/widgets.dart';

import '../../models/device.dart';
import '../../theme/nds_colors.dart';

/// Metrik tonunun DS rengi (success · primary · warning).
Color metricToneColor(MetricTone t) => switch (t) {
      MetricTone.success => NdsColors.success500,
      MetricTone.primary => NdsColors.primary500,
      MetricTone.warning => NdsColors.warning500,
    };
