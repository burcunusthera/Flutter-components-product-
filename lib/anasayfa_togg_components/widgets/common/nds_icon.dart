import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_icons.dart';

/// DS Icon: genişlik = [size], yükseklik = size × h / w (DS ile aynı).
/// Renk SVG içindeki `currentColor` üzerinden verilir.
class NdsIcon extends StatelessWidget {
  const NdsIcon(this.name, {super.key, this.size = 24, this.color});

  final String name;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final def = kNdsIcons[name];
    assert(def != null, 'DS ikonu bulunamadı: $name');
    if (def == null) return SizedBox(width: size, height: size);
    final h = (size * def.h / def.w * 1000).round() / 1000;
    final c = color ?? DefaultTextStyle.of(context).style.color ?? NdsColors.grey900;
    return SizedBox(
      width: size,
      height: h,
      child: SvgPicture.asset(
        '$kAssetRoot/icons/${def.file}',
        width: size,
        height: h,
        theme: SvgTheme(currentColor: c),
      ),
    );
  }
}
