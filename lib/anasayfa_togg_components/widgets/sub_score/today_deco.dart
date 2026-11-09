import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/nds_colors.dart';

/// DS TodayDeco (sağ üst köşe dekoru, durağan SVG). top −42.875, right −102.677.
class TodayDeco extends StatelessWidget {
  const TodayDeco({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 185.889,
        height: 153.902,
        child: Stack(clipBehavior: Clip.none, children: [
          SvgPicture.asset('$kAssetRoot/images/deco/today_group.svg', width: 185.889, height: 153.902),
          Positioned(
            left: -19.788,
            top: 57.001,
            width: 63.55,
            height: 63.55,
            child: Center(
              child: Transform.rotate(
                angle: -0.7853981633974483, // −45°
                child: SvgPicture.asset('$kAssetRoot/images/deco/today_vector.svg', width: 44.9364, height: 44.9364),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
