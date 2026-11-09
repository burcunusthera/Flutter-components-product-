import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';

/// `.m-spin`: 20 px daire, 2 px Greyscale/200 kenar, üst kenar Primary/500, 1 sn doğrusal dönüş.
class NdsSpinner extends StatefulWidget {
  const NdsSpinner({super.key, this.size = 20});

  final double size;

  @override
  State<NdsSpinner> createState() => _NdsSpinnerState();
}

class _NdsSpinnerState extends State<NdsSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 1));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RotationTransition(
        turns: _c,
        child: CustomPaint(size: Size.square(widget.size), painter: _SpinPainter()),
      );
}

class _SpinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawOval(r, p..color = NdsColors.grey200);
    // border-top: üst çeyrek (−135° … −45°)
    canvas.drawArc(r, -3 * math.pi / 4, math.pi / 2, false, p..color = NdsColors.primary500);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
