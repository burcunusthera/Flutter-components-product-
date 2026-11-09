import 'package:flutter/widgets.dart';

/// DS gölgeleri. CSS box-shadow → BoxShadow (blur ve spread aynı değer).
abstract final class NdsShadows {
  static const s200 = [
    BoxShadow(offset: Offset(0, 8), blurRadius: 8, spreadRadius: -4, color: Color(0x1418274B)),
    BoxShadow(offset: Offset(0, 4), blurRadius: 6, spreadRadius: -4, color: Color(0x1F18274B)),
  ];
  static const s400 = [
    BoxShadow(offset: Offset(0, 8), blurRadius: 24, spreadRadius: -4, color: Color(0x1418274B)),
    BoxShadow(offset: Offset(0, 6), blurRadius: 12, spreadRadius: -6, color: Color(0x1F18274B)),
  ];
  static const toast = [
    BoxShadow(offset: Offset(0, 12), blurRadius: 20, spreadRadius: -4, color: Color(0x14101828)),
  ];
  static const qaItem = [
    BoxShadow(offset: Offset(0, 4), blurRadius: 12, color: Color(0x141B1B4D)),
  ];
  static const vmiMarker = [
    BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x0F0F1A1C)),
  ];
}
