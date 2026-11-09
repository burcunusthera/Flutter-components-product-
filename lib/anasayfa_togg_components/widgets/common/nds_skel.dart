import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';

/// DS iskelet (.nds-skel), zemin Greyscale/50.
class NdsSkel extends StatelessWidget {
  const NdsSkel({super.key, required this.width, required this.height, this.radius = 8, this.color = NdsColors.grey50});

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius)),
      );
}
