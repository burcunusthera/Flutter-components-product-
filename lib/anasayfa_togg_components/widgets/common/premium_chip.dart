import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import 'nds_icon.dart';

/// DS PremiumChip.
class PremiumChip extends StatelessWidget {
  const PremiumChip({super.key, this.label = 'Premium'});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: NdsColors.premiumChipBg,
          border: Border.all(color: NdsColors.premiumChipBorder),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const NdsIcon('User Interface/lock 2', size: 12, color: NdsColors.premiumChipText),
          const SizedBox(width: 4),
          Text(label, style: ndsText(12, 15, 500, NdsColors.premiumChipText)),
        ]),
      );
}
