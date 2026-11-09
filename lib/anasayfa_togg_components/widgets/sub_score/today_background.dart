import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';

/// DS TodayCard zemini: beyaz + objectBoundingBox doğrusal gradyan (#30cfd0 → #330867,
/// x2 1.20265 / y2 0.42075) + rgba(51,8,103,.45). Gradyan birim kutuda çizilip kutuya
/// ölçeklenir (SVG preserveAspectRatio="none" ile aynı).
class TodayBackground extends CustomPainter {
  const TodayBackground();

  @override
  void paint(Canvas canvas, Size size) {
    final r = Offset.zero & size;
    canvas.drawRect(r, Paint()..color = NdsColors.grey0);
    canvas.save();
    canvas.scale(size.width, size.height);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 1, 1),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          const Offset(1.20265, 0.42075),
          const [Color(0xFF30CFD0), Color(0xFF330867)],
        ),
    );
    canvas.restore();
    canvas.drawRect(r, Paint()..color = const Color(0x73330867)); // .45
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
