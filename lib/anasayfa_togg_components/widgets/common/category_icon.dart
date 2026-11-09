import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import 'nds_icon.dart';

/// DS CategoryIcon: 32 px Greyscale/50 daire + 24 px ikon.
class CategoryIcon extends StatelessWidget {
  const CategoryIcon({super.key, this.icon, this.loading = false});

  final String? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) => Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: loading ? NdsColors.grey100 : NdsColors.grey50,
          shape: BoxShape.circle,
        ),
        child: loading || icon == null ? null : NdsIcon(icon!, size: 24, color: NdsColors.grey900),
      );
}
