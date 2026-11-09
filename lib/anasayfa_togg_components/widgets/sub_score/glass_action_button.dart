import 'package:flutter/material.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/glass_surface.dart';
import '../common/nds_icon.dart';

/// Cam (glassmorphism) eylem butonu (.m-tglass).
/// 48 yükseklik, radius 12, zemin rgba(255,255,255,.14), blur 12, kenar 1 px .4, iç gölge 0 1 0 .35.
/// Basılıyken zemin .22 ve ölçek .98.
class GlassActionButton extends StatefulWidget {
  const GlassActionButton({
    super.key,
    required this.label,
    this.icon,
    this.chevron = false,
    this.onTap,
    this.focusable = true,
    this.semanticLabel,
  });

  final String label;
  final String? icon;
  final bool chevron;
  final VoidCallback? onTap;
  final bool focusable;
  final String? semanticLabel;

  @override
  State<GlassActionButton> createState() => _GlassActionButtonState();
}

class _GlassActionButtonState extends State<GlassActionButton> {
  bool _down = false;
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    final body = GlassSurface(
      height: 48,
      width: double.infinity,
      radius: radius,
      blur: 12,
      color: _down ? const Color(0x38FFFFFF) : const Color(0x24FFFFFF),
      border: Border.all(color: const Color(0x66FFFFFF)),
      child: Stack(children: [
        // inset 0 1px 0 rgba(255,255,255,.35)
        Positioned(left: 0, right: 0, top: 0, child: Container(height: 1, color: const Color(0x59FFFFFF))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (widget.icon != null) ...[NdsIcon(widget.icon!, size: 20, color: NdsColors.grey0), const SizedBox(width: 6)],
              Text(widget.label, style: ndsText(16, 24, 600, NdsColors.grey0)),
              if (widget.chevron) ...[const SizedBox(width: 6), const NdsIcon('User Interface/chevron right', size: 20, color: NdsColors.grey0)],
            ]),
          ),
        ),
      ]),
    );
    return Semantics(
      button: true,
      label: widget.semanticLabel ?? widget.label,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: widget.focusable && widget.onTap != null,
        onShowFocusHighlight: (v) => setState(() => _focus = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onTap?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _down = true),
          onTapUp: (_) => setState(() => _down = false),
          onTapCancel: () => setState(() => _down = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _down ? .98 : 1,
            duration: const Duration(milliseconds: 100),
            child: Container(
              // Odak: 2 px beyaz çerçeve, 2 px boşluk
              foregroundDecoration: _focus
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NdsColors.grey0, width: 2),
                    )
                  : null,
              padding: EdgeInsets.zero,
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}
