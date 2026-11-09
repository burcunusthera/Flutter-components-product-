import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_skel.dart';
import '../common/r06.dart';
import 'stress_stats.dart';

/// Yükleniyor iskeleti (.m-ssk): çizgi 130×12, R06 “yukleniyor” 80, istatistik iskeletleri 28×18.
class StressSkeleton extends StatelessWidget {
  const StressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    Widget stat(String l) => Column(mainAxisSize: MainAxisSize.min, children: [
          const NdsSkel(width: 28, height: 18, radius: 6, color: NdsColors.grey100),
          const SizedBox(height: 4),
          Text(l, style: ndsText(12, 15, 400, NdsColors.grey300)),
        ]);
    return Semantics(
      label: 'Stres verisi yükleniyor',
      excludeSemantics: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: NdsSkel(width: 130, height: 12, radius: 8, color: NdsColors.grey100),
          ),
        ),
        const SizedBox(height: 12),
        const SizedBox(
          height: 80,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Align(alignment: Alignment.bottomCenter, child: R06(R06State.yukleniyor, size: 80)),
          ),
        ),
        const SizedBox(height: 12 + 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: IntrinsicHeight(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              stat('En yüksek'),
              const StressStatSeparator(),
              stat('Ortalama'),
              const StressStatSeparator(),
              stat('En düşük'),
            ]),
          ),
        ),
      ]),
    );
  }
}
