import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../common/nds_icon.dart';
import 'macro_metric.dart';

/// Halka göstergesi türü.
enum MacroRingKind { progress, ring, zero, empty, loading }

/// DS MacroProgress: 48×48, r 22.75, çizgi 2.5, −90°'den başlar; ikon 20.
class MacroRing extends StatelessWidget {
  const MacroRing({super.key, required this.macro, required this.kind, required this.progress});
  const MacroRing.loading({super.key})
      : macro = MacroKind.fat,
        kind = MacroRingKind.loading,
        progress = 0;

  final MacroKind macro;
  final MacroRingKind kind;
  final int progress;

  @override
  Widget build(BuildContext context) {
    if (kind == MacroRingKind.loading) {
      return Container(width: 48, height: 48, decoration: const BoxDecoration(color: NdsColors.grey100, shape: BoxShape.circle));
    }
    final p = switch (kind) {
      MacroRingKind.ring => 100,
      MacroRingKind.progress => math.max(1, math.min(100, progress)),
      _ => 0,
    };
    final empty = kind == MacroRingKind.empty;
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(
          child: CustomPaint(painter: _RingPainter(track: empty ? NdsColors.grey100 : NdsColors.grey50, arc: macro.color, p: p)),
        ),
        NdsIcon(macro.icon, size: 20, color: empty ? NdsColors.grey400 : macro.color),
      ]),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.track, required this.arc, required this.p});

  final Color track;
  final Color arc;
  final int p;

  @override
  void paint(Canvas canvas, Size size) {
    const r = 22.75;
    const c = Offset(24, 24);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(c, r, stroke..color = track);
    if (p > 0) {
      // stroke-dasharray, uçlar düz (butt) — SVG varsayılanı
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), -math.pi / 2, 2 * math.pi * p / 100, false, stroke..color = arc);
    }
  }

  @override
  bool shouldRepaint(_RingPainter o) => o.p != p || o.arc != arc || o.track != track;
}
