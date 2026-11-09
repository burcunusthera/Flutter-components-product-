import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';

/// DS OverallScore (Figma "Genel Sağlık Skoru", 295×116, 21 dilim).
/// Geometri bundle.js GAUGE sabitlerinden birebir alınmıştır.
abstract final class _G {
  static const n = 21;
  static const w = 295.0;
  static const h = 116.0;
  static const cx = 147.5;
  static const cy = 119.68564;
  static const bigR = 117.60134;
  static const smallR = 82.28217;
  static const sweep = 0.0992264748; // radyan
  static const step = 8.103947050214927; // derece

  static double angleDeg(int i) {
    const a0 = -(n - 1) / 2 * step;
    const a1 = (n - 1) / 2 * step;
    return a0 + i * (a1 - a0) / (n - 1);
  }

  /// seg: 'M5.543 -111.6292C5.7025 -114.8476 3.2225 -117.6013 0 -117.6013C-3.2225 -117.6013 -5.7025 -114.8476 -5.543 -111.6292
  ///       L-4.283 -86.2579C-4.1715 -84.0061 -2.2545 -82.2819 0 -82.2819C2.2545 -82.2819 4.1715 -84.0061 4.283 -86.2579Z'
  static final Path seg = Path()
    ..moveTo(5.543, -111.6292)
    ..cubicTo(5.7025, -114.8476, 3.2225, -117.6013, 0, -117.6013)
    ..cubicTo(-3.2225, -117.6013, -5.7025, -114.8476, -5.543, -111.6292)
    ..lineTo(-4.283, -86.2579)
    ..cubicTo(-4.1715, -84.0061, -2.2545, -82.2819, 0, -82.2819)
    ..cubicTo(2.2545, -82.2819, 4.1715, -84.0061, 4.283, -86.2579)
    ..close();

  /// gaugeSliver(f): segmentin başlangıç kenarından f oranında açısal dilim.
  static Path sliver(double f) {
    final al = f * sweep / 2;
    final be = -sweep / 2 + al;
    final sn = math.sin(al);
    final ro = bigR * sn / (1 + sn);
    final dO = (bigR - ro) * math.cos(al);
    final ri = smallR * sn / (1 - sn);
    final dI = (smallR + ri) * math.cos(al);
    Offset p(double d, double t) => Offset(d * math.sin(t), -d * math.cos(t));
    return Path()
      ..moveTo(p(dI, be - al).dx, p(dI, be - al).dy)
      ..lineTo(p(dO, be - al).dx, p(dO, be - al).dy)
      ..arcToPoint(p(dO, be + al), radius: Radius.circular(ro), largeArc: true, clockwise: true)
      ..lineTo(p(dI, be + al).dx, p(dI, be + al).dy)
      ..arcToPoint(p(dI, be - al), radius: Radius.circular(ri), largeArc: false, clockwise: true)
      ..close();
  }
}

/// DS scoreName: bant adı.
String scoreName(int? v) {
  if (v == null) return 'Veri yok';
  if (v <= 20) return 'Dinlenme zamanı';
  if (v <= 40) return 'Gelişmeye açık';
  if (v <= 60) return 'Dengede';
  if (v <= 80) return 'İyi';
  return 'Harika';
}

class _GaugePainter extends CustomPainter {
  _GaugePainter(this.value);

  final int? value;

  static final _off = Paint()..color = const Color(0x1AFFFFFF); // rgba(255,255,255,.10)
  static final _offStroke = Paint()
    ..color = const Color(0x52FFFFFF) // rgba(255,255,255,.32)
    ..style = PaintingStyle.stroke
    ..strokeWidth = .75;
  static final _on = Paint()..color = NdsColors.secondary100;

  @override
  void paint(Canvas canvas, Size size) {
    final v = value;
    final double units = v == null ? 0.0 : math.min(100, math.max(0, v)) / 100 * _G.n;
    canvas.save();
    canvas.translate(_G.cx, _G.cy);
    for (var i = 0; i < _G.n; i++) {
      final double on = math.min(1.0, math.max(0.0, units - i));
      canvas.save();
      canvas.rotate(_G.angleDeg(i) * math.pi / 180);
      canvas.drawPath(_G.seg, _off);
      canvas.drawPath(_G.seg, _offStroke);
      if (on >= 1) {
        canvas.drawPath(_G.seg, _on);
      } else if (on > 0.001) {
        canvas.save();
        canvas.clipPath(_G.seg);
        canvas.drawPath(_G.sliver(on), _on);
        canvas.restore();
      }
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.value != value;
}

/// 295×116 gösterge + değer + bant adı.
/// [name] verilmezse bant adı skordan hesaplanır. [busy] → değer %60 opak (yükleniyor).
/// Değer yokken dilimler %55 opak (.m-tgauge.is-empty).
class OverallScoreGauge extends StatelessWidget {
  const OverallScoreGauge({super.key, required this.value, this.name, this.busy = false});

  final int? value;
  final String? name;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final v = value;
    final label = name ?? scoreName(v);
    return Semantics(
      label: 'Genel sağlık skoru ${v == null ? 'yok' : '$v / 100, $label'}',
      excludeSemantics: true,
      child: SizedBox(
        width: _G.w,
        height: _G.h,
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned.fill(
            child: Opacity(
              opacity: v == null ? .55 : 1,
              child: CustomPaint(painter: _GaugePainter(v)),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Opacity(
                opacity: busy ? .6 : 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(v == null ? '—' : '$v', style: ndsText(24, 30, 700, NdsColors.grey0)),
                    const SizedBox(width: 4),
                    Text('/100', style: ndsText(16, 20, 400, NdsColors.grey100)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: ndsText(12, 15, 500, NdsColors.grey0)),
            ]),
          ),
        ]),
      ),
    );
  }
}
