import 'package:flutter/widgets.dart';

/// Basma geri bildirimi (CSS :active) ve erişilebilir buton semantiği.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.builder,
    this.onTap,
    this.pressedScale = 1,
    this.semanticLabel,
    this.excludeChildSemantics = false,
  });

  final Widget Function(BuildContext context, bool pressed) builder;
  final VoidCallback? onTap;
  final double pressedScale;
  final String? semanticLabel;
  final bool excludeChildSemantics;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap == null || _down == v) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.builder(context, _down);
    if (widget.pressedScale != 1) {
      child = AnimatedScale(
        scale: _down ? widget.pressedScale : 1,
        duration: const Duration(milliseconds: 100),
        child: child,
      );
    }
    return Semantics(
      button: true,
      enabled: widget.onTap != null,
      label: widget.semanticLabel,
      excludeSemantics: widget.excludeChildSemantics,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        onTap: widget.onTap,
        child: child,
      ),
    );
  }
}
