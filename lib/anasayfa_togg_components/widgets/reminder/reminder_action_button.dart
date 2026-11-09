import 'package:flutter/material.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';

/// DS ReminderActionButton türleri.
enum ReminderActionKind { skip, confirm, pause, finish, resume }

/// DS ReminderActionButton: 44×44, radius 12; etiket 12/15. Birincil: Primary/500 zemin.
class ReminderActionButton extends StatelessWidget {
  const ReminderActionButton({super.key, required this.kind, this.onTap, this.dimmed = false, this.loading = false, this.offline = false});

  final ReminderActionKind kind;
  final VoidCallback? onTap;
  final bool dimmed;
  final bool loading;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    final (label, icon, primary) = switch (kind) {
      ReminderActionKind.skip => ('Atla', 'User Interface/cross', false),
      ReminderActionKind.confirm => ('Aldım', 'Reminder/Icon · Check', true),
      ReminderActionKind.pause => ('Duraklat', 'User Interface/pause', false),
      ReminderActionKind.finish => ('Bitir', 'Reminder/Icon · Check', true),
      ReminderActionKind.resume => ('Devam', 'User Interface/play', false),
    };
    Color bg, border, fg, lc;
    if (offline) {
      bg = NdsColors.grey100;
      border = NdsColors.grey100;
      fg = NdsColors.grey300;
      lc = NdsColors.grey300;
    } else if (primary) {
      bg = NdsColors.primary500;
      border = NdsColors.primary500;
      fg = NdsColors.grey0;
      lc = NdsColors.primary500;
    } else {
      bg = NdsColors.grey0;
      border = NdsColors.grey100;
      fg = NdsColors.grey900;
      lc = NdsColors.grey500;
    }
    Widget w = Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary && !offline ? Colors.transparent : border),
        ),
        child: NdsIcon(loading ? 'User Interface/refresh' : icon, size: 20, color: fg),
      ),
      const SizedBox(height: 4),
      Text(label, maxLines: 1, style: ndsText(12, 15, primary && !offline ? 500 : 400, lc)),
    ]);
    if (dimmed) w = Opacity(opacity: .4, child: w);
    return Pressable(onTap: dimmed || loading ? null : onTap, semanticLabel: label, excludeChildSemantics: true, builder: (_, __) => w);
  }
}
