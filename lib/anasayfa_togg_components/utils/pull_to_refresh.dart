import 'package:flutter/widgets.dart';

/// Prototipteki aşağı çekerek yenileme (D-18): sayfa en üstteyken başlayan ve en az
/// [threshold] (64 px) aşağı çekilen hareket bırakıldığında [onRefresh] çağrılır.
/// Prototipte ayrı bir yenileme göstergesi yok; sonuç üstteki “Güncelleniyor…” toast'ıdır.
class PullToRefreshDetector extends StatefulWidget {
  const PullToRefreshDetector({
    super.key,
    required this.controller,
    required this.child,
    this.onRefresh,
    this.threshold = 64,
  });

  final ScrollController controller;
  final Widget child;
  final VoidCallback? onRefresh;
  final double threshold;

  @override
  State<PullToRefreshDetector> createState() => _PullToRefreshDetectorState();
}

class _PullToRefreshDetectorState extends State<PullToRefreshDetector> {
  double? _startY;

  bool get _atTop => !widget.controller.hasClients || widget.controller.offset <= 0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => _startY = _atTop ? e.position.dy : null,
      onPointerUp: (e) {
        final s = _startY;
        _startY = null;
        if (s != null && e.position.dy - s >= widget.threshold) widget.onRefresh?.call();
      },
      onPointerCancel: (_) => _startY = null,
      child: widget.child,
    );
  }
}
