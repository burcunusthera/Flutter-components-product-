import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';

/// DS Slider (.nds-pager): 8×8 nokta, seçili 24×8 Primary/500.
class NdsPager extends StatelessWidget {
  const NdsPager({super.key, required this.count, required this.active, this.onChanged, this.semanticLabel = 'Sayfalar'});

  final int count;
  final int active;
  final ValueChanged<int>? onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          Semantics(
            button: true,
            selected: i == active,
            label: '${i + 1}. sayfa',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onChanged == null ? null : () => onChanged!(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: i == active ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == active ? NdsColors.primary500 : NdsColors.grey200,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}
