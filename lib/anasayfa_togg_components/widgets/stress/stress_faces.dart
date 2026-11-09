import 'package:flutter/widgets.dart';

import '../../models/stress.dart';
import '../common/r06.dart';
import 'stress_tag.dart';

/// Beş R06 yüz (279×102): seçili ruh hali ortada (74) + etiket; yanlarda 49 ve 33.
/// Sıra: MOOD_CYCLE[(i+3)%5], [(i+4)%5], seçili, [(i+1)%5], [(i+2)%5].
class StressFaces extends StatelessWidget {
  const StressFaces({super.key, required this.mood});

  final StressMood mood;

  static const _cycle = StressMood.values; // rahatlamis, sakin, dengeli, stresli, cokStresli

  static R06State r06Of(StressMood m) => switch (m) {
        StressMood.rahatlamis => R06State.rahatlamis,
        StressMood.sakin => R06State.sakin,
        StressMood.dengeli => R06State.dengeli,
        StressMood.stresli => R06State.stresli,
        StressMood.cokStresli => R06State.cokStresli,
      };

  @override
  Widget build(BuildContext context) {
    final mi = _cycle.indexOf(mood);
    StressMood at(int k) => _cycle[(mi + k) % 5];
    return Semantics(
      label: 'Stres durumu: ${mood.label}',
      excludeSemantics: true,
      child: SizedBox(
        width: 279,
        height: 102,
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(left: 0, top: 69, child: R06(r06Of(at(3)), size: 33, dropShadow: true)),
          Positioned(left: 45, top: 31, child: R06(r06Of(at(4)), size: 49, dropShadow: true)),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              R06(r06Of(mood), size: 74, dropShadow: true),
              const SizedBox(height: 5),
              StressTag(mood: mood),
            ]),
          ),
          Positioned(left: 186, top: 31, child: R06(r06Of(at(1)), size: 49, dropShadow: true)),
          Positioned(left: 247, top: 69, child: R06(r06Of(at(2)), size: 33, dropShadow: true)),
        ]),
      ),
    );
  }
}
