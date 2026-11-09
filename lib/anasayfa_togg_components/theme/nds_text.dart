import 'dart:ui' show FontVariation;

import 'package:flutter/widgets.dart';

/// Outfit metin stili. CSS `font-size/line-height/weight` → TextStyle.
/// Satır yüksekliği CSS gibi üst/alta eşit dağıtılır.
TextStyle ndsText(double size, double lineHeight, int weight, Color color) {
  return TextStyle(
    fontFamily: 'Outfit',
    fontSize: size,
    height: lineHeight / size,
    leadingDistribution: TextLeadingDistribution.even,
    fontWeight: _weight(weight),
    fontVariations: [FontVariation('wght', weight.toDouble())],
    color: color,
    decoration: TextDecoration.none,
  );
}

FontWeight _weight(int w) => switch (w) {
      <= 100 => FontWeight.w100,
      <= 200 => FontWeight.w200,
      <= 300 => FontWeight.w300,
      <= 400 => FontWeight.w400,
      <= 500 => FontWeight.w500,
      <= 600 => FontWeight.w600,
      <= 700 => FontWeight.w700,
      <= 800 => FontWeight.w800,
      _ => FontWeight.w900,
    };
