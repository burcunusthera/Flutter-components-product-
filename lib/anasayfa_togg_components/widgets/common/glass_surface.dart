import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

/// Cam yüzey (CSS backdrop-filter: blur(N) → sigma N).
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    required this.radius,
    required this.blur,
    required this.color,
    this.border,
    this.boxShadow,
    this.width,
    this.height,
    this.padding,
  });

  final Widget child;
  final BorderRadius radius;
  final double blur; // CSS blur(Npx) → sigma N
  final Color color;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(color: color, borderRadius: radius, border: border, boxShadow: boxShadow),
          child: child,
        ),
      ),
    );
  }
}
