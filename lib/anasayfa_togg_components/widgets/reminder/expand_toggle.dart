import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';

/// DS ExpandToggle: 44 yükseklik, 14/18/500 Primary/500, sayı 16/20, ok 20.
class ExpandToggle extends StatelessWidget {
  const ExpandToggle({super.key, required this.expanded, required this.hiddenCount, this.onTap});

  final bool expanded;
  final int hiddenCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        expanded: expanded,
        child: Pressable(
          onTap: onTap,
          builder: (context, _) => SizedBox(
            height: 44,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(expanded ? 'Daha az göster' : 'Daha fazla göster', style: ndsText(14, 18, 500, NdsColors.primary500)),
              if (!expanded && hiddenCount > 0) ...[
                const SizedBox(width: 4),
                Text('($hiddenCount)', style: ndsText(16, 20, 500, NdsColors.primary500)),
              ],
              const SizedBox(width: 4),
              NdsIcon(expanded ? 'User Interface/chevron up' : 'User Interface/chevron down', size: 20, color: NdsColors.primary500),
            ]),
          ),
        ),
      );
}
