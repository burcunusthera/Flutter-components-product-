import 'package:flutter/material.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_home_indicator.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';

/// DS SheetFrame (Reminder sayfalarının ortak çerçevesi).
/// Panel: beyaz, üst radius 36, padding 24 ve aralık 24; [compact] (ActionSheet) padding 24 12 8, aralık 8.
/// Başlık 18/23/500 + 24 px kapat (Atoms/x). Altta beyaz ana gösterge alanı.
class SheetFrame extends StatelessWidget {
  const SheetFrame({
    super.key,
    required this.title,
    required this.children,
    this.onClose,
    this.compact = false,
    this.showHomeIndicator = false,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback? onClose;
  final bool compact;

  /// Tasarım önizlemesi: 34 px ana gösterge. false → cihazın alt güvenli alanı (beyaz).
  final bool showHomeIndicator;

  @override
  Widget build(BuildContext context) {
    final gap = compact ? 8.0 : 24.0;
    final all = <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 24),
          child: Row(children: [
            Expanded(child: Semantics(header: true, child: Text(title, style: ndsText(18, 23, 500, NdsColors.grey900)))),
            const SizedBox(width: 12),
            Pressable(
              onTap: onClose,
              semanticLabel: 'Kapat',
              excludeChildSemantics: true,
              builder: (context, pressed) => Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(shape: BoxShape.circle, color: pressed ? NdsColors.grey50 : null),
                child: const NdsIcon('Atoms/x', size: 24, color: NdsColors.grey900),
              ),
            ),
          ]),
        ),
      ),
      ...children,
    ];
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: title,
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: compact ? const EdgeInsets.fromLTRB(12, 24, 12, 8) : const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: NdsColors.grey0,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            for (var i = 0; i < all.length; i++) ...[if (i > 0) SizedBox(height: gap), all[i]],
          ]),
        ),
        ColoredBox(
          color: NdsColors.grey0,
          child: showHomeIndicator ? const NdsHomeIndicator() : SizedBox(height: bottom),
        ),
      ]),
    );
  }
}

/// Sayfa başlığı altındaki özet (ad 16/20/600 + satırlar 14/18 Greyscale/500, aralık 4).
class SheetSummary extends StatelessWidget {
  const SheetSummary({super.key, required this.name, this.lines = const [], this.status});

  final String name;
  final List<String> lines;

  /// ReminderStatusLabel (varsayılan ton, 14/18 Greyscale/500).
  final String? status;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      Text(name, style: ndsText(16, 20, 600, NdsColors.grey900)),
      for (final l in lines) Text(l, style: ndsText(14, 18, 400, NdsColors.grey500)),
      if (status != null) Text(status!, style: ndsText(14, 18, 400, NdsColors.grey500)),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var i = 0; i < rows.length; i++) ...[if (i > 0) const SizedBox(height: 4), rows[i]],
    ]);
  }
}
