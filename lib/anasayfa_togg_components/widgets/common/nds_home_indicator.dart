import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';

/// DS HomeIndicator — 375×34, çubuk 148×5. Gerçek cihazda sistem çizer; önizleme içindir.
class NdsHomeIndicator extends StatelessWidget {
  const NdsHomeIndicator({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 34,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              width: 148,
              height: 5,
              decoration: BoxDecoration(color: NdsColors.homeIndicator, borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ),
      );
}
