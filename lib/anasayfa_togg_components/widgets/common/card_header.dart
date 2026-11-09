import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import 'category_icon.dart';
import 'nds_skel.dart';

/// DS CardHeader (Beslenme, Günlük planım, Cihaz verileri başlığı).
class CardHeader extends StatelessWidget {
  const CardHeader({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.badge,
    this.action,
    this.loading = false,
  });

  final String? icon;
  final String title;
  final String? subtitle;
  final Widget? badge;
  final Widget? action;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 32,
        child: Row(children: [
          CategoryIcon(loading: true),
          SizedBox(width: 8),
          NdsSkel(width: 96, height: 14),
        ]),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 32),
      child: Row(children: [
        Expanded(
          child: Row(children: [
            if (icon != null) ...[CategoryIcon(icon: icon), const SizedBox(width: 8)],
            Expanded(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(
                    child: Semantics(
                      header: true,
                      child: Text(title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ndsText(18, 23, 600, NdsColors.grey900)),
                    ),
                  ),
                  if (badge != null) ...[const SizedBox(width: 4), badge!],
                ]),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, maxLines: 2, overflow: TextOverflow.ellipsis, style: ndsText(14, 18, 400, NdsColors.grey500)),
                ],
              ]),
            ),
          ]),
        ),
        if (action != null) ...[const SizedBox(width: 8), action!],
      ]),
    );
  }
}
