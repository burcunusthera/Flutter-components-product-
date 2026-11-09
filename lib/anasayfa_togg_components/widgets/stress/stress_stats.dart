import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';

/// Stres istatistikleri: En yüksek · Ortalama · En düşük (16/20/600 + 12/15), ayraç 1 px rgba(118,118,128,.12).
class StressStats extends StatelessWidget {
  const StressStats({super.key, this.max, this.avg, this.min, this.dim = false});

  final int? max;
  final int? avg;
  final int? min;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    Widget col(int? v, String l, bool main) {
      final c = main ? NdsColors.grey900 : NdsColors.grey500;
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Text(v == null ? '—' : '$v', style: ndsText(16, 20, 600, dim ? NdsColors.grey300 : c)),
        const SizedBox(height: 4),
        Text(l, style: ndsText(12, 15, 400, c)),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: IntrinsicHeight(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          col(max, 'En yüksek', false),
          const StressStatSeparator(),
          col(avg, 'Ortalama', true),
          const StressStatSeparator(),
          col(min, 'En düşük', false),
        ]),
      ),
    );
  }
}

/// İstatistik ayracı.
class StressStatSeparator extends StatelessWidget {
  const StressStatSeparator({super.key});

  @override
  Widget build(BuildContext context) => Container(width: 1, color: const Color(0x1F767680)); // rgba(118,118,128,.12)
}
