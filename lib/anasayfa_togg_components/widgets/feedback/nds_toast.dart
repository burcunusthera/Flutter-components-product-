import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/common.dart';
import '../../theme/nds_shadows.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';
import 'nds_spinner.dart';

/// DS Toast + 03.11.2026 otomatik kapanma (4 sn, alt çizgi süreyi gösterir). progress toast'ı süreçle kapanır.
class NdsToast extends StatefulWidget {
  const NdsToast({
    super.key,
    required this.data,
    this.onClose,
    this.bar = true,
    this.duration = const Duration(seconds: 4),
    this.autoDismiss = true,
  });

  final ToastData data;
  final VoidCallback? onClose;

  /// Üst toast'ta çizgili; alt toast'ta çizgisiz (DS bar={false}).
  final bool bar;
  final Duration duration;
  final bool autoDismiss;

  @override
  State<NdsToast> createState() => _NdsToastState();
}

class _NdsToastState extends State<NdsToast> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duration);
  Timer? _t;

  bool get _live => widget.autoDismiss && widget.onClose != null && widget.data.type != ToastType.progress;

  @override
  void initState() {
    super.initState();
    if (_live) {
      _c.forward();
      _t = Timer(widget.duration, () => widget.onClose?.call());
    }
  }

  @override
  void dispose() {
    _t?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.data.type;
    final color = switch (type) {
      ToastType.error => NdsColors.danger500,
      ToastType.success => NdsColors.success500,
      ToastType.info => NdsColors.info500,
      ToastType.warning => NdsColors.warning500,
      ToastType.progress => NdsColors.primary500,
    };
    final Widget icon = switch (type) {
      ToastType.error => NdsIcon('Shopping&Ecommerce/warning', size: 20, color: color),
      ToastType.success => NdsIcon('User Interface/check', size: 20, color: color),
      ToastType.info => NdsIcon('Toast alert/Shopping&Ecommerce/Property 26', size: 20, color: color),
      ToastType.warning => NdsIcon('Shipping and Delivery/exclamation mark', size: 20, color: color),
      ToastType.progress => const NdsSpinner(),
    };
    final showBar = widget.bar && type != ToastType.progress && type != ToastType.warning;
    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: NdsColors.grey0,
          border: Border.all(color: NdsColors.grey100),
          borderRadius: BorderRadius.circular(8),
          boxShadow: NdsShadows.toast,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 54),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 12, 15),
                  child: Row(children: [
                    SizedBox(width: 24, height: 24, child: Center(child: icon)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(widget.data.text, style: ndsText(14, 18, 600, NdsColors.grey900))),
                  ]),
                ),
              ),
            ),
            if (widget.onClose != null)
              Positioned(
                top: -1,
                right: -1,
                child: Pressable(
                  onTap: widget.onClose,
                  semanticLabel: 'Kapat',
                  excludeChildSemantics: true,
                  builder: (context, _) => const SizedBox(
                    width: 44,
                    height: 44,
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: NdsIcon('User Interface/cross', size: 14, color: NdsColors.grey500),
                      ),
                    ),
                  ),
                ),
              ),
            if (showBar)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _live ? 1 - _c.value : .75,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
