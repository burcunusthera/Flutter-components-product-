import 'package:flutter/widgets.dart';

/// Prototipteki giriş animasyonları (App CSS):
/// push  — mPush: translateX(40%) + opaklık .4 → 0, .32 s cubic-bezier(.2,.8,.2,1)
/// back  — mBack: translateX(−30%) + opaklık .4 → 0, .32 s
/// fade  — mFade: opaklık 0 → 1, .25–.28 s ease
/// rise  — mUp:   translateY(100%) → 0, .34 s cubic-bezier(.2,.8,.2,1)
enum EnterKind { none, push, back, fade, rise }

class EnterAnimation extends StatefulWidget {
  const EnterAnimation({super.key, required this.kind, required this.child});

  final EnterKind kind;
  final Widget child;

  @override
  State<EnterAnimation> createState() => _EnterAnimationState();
}

class _EnterAnimationState extends State<EnterAnimation> with SingleTickerProviderStateMixin {
  static const _curve = Cubic(.2, .8, .2, 1);

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: switch (widget.kind) {
        EnterKind.rise => 340,
        EnterKind.fade => 250,
        _ => 320,
      },
    ),
  );

  @override
  void initState() {
    super.initState();
    if (widget.kind == EnterKind.none) {
      _c.value = 1;
    } else {
      _c.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) _c.value = 1;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final k = widget.kind;
    if (k == EnterKind.none) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (context, child) {
        final t = k == EnterKind.fade ? Curves.ease.transform(_c.value) : _curve.transform(_c.value);
        final from = k == EnterKind.push ? .4 : -.3;
        return switch (k) {
          EnterKind.push || EnterKind.back => FractionalTranslation(
              translation: Offset(from * (1 - t), 0),
              child: Opacity(opacity: .4 + .6 * t, child: child),
            ),
          EnterKind.fade => Opacity(opacity: t, child: child),
          EnterKind.rise => FractionalTranslation(translation: Offset(0, 1 - t), child: child),
          EnterKind.none => child!,
        };
      },
    );
  }
}
