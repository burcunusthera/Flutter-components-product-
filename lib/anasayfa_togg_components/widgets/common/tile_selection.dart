import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import 'pressable.dart';

/// DS TileSelection (type=radio): en az 60 yükseklik, padding 20 16, radius 12,
/// kenar 1 Greyscale/50 (seçili Primary/500), zemin Greyscale/25 (seçili beyaz),
/// etiket 16/20 Primary/500, sağda 16 px radyo.
class TileSelection extends StatelessWidget {
  const TileSelection({super.key, required this.label, required this.selected, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: Pressable(
        onTap: onTap,
        semanticLabel: label,
        excludeChildSemantics: true,
        builder: (context, _) => Container(
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: selected ? NdsColors.grey0 : NdsColors.grey25,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? NdsColors.primary500 : NdsColors.grey50),
          ),
          child: Row(children: [
            Expanded(child: Text(label, style: ndsText(16, 20, 400, NdsColors.primary500))),
            const SizedBox(width: 4),
            _Radio(on: selected),
          ]),
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) => Container(
        width: 16,
        height: 16,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: on ? NdsColors.primary500 : NdsColors.grey0,
          border: Border.all(color: on ? NdsColors.primary500 : NdsColors.grey200),
        ),
        child: on
            ? Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: NdsColors.grey0))
            : null,
      );
}
