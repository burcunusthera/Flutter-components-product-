import 'package:flutter/widgets.dart';

import 'action_option.dart';
import 'sheet_frame.dart';

/// Reminder/ActionSheet seçenekleri.
enum ReminderMenuOption { confirm, postpone, skip, edit, delete, editRecord }

/// DS ReminderActionSheet (Figma 4869:7867).
/// Bekleyen kayıt: Aldım, Ertele, Bugünkü dozu atla, Hatırlatıcıyı düzenle, Hatırlatıcıyı sil.
/// Kaydedilmiş: Kaydı düzenle, Hatırlatıcıyı düzenle, Hatırlatıcıyı sil.
class ReminderActionSheet extends StatelessWidget {
  const ReminderActionSheet({
    super.key,
    required this.title,
    required this.recorded,
    this.onSelect,
    this.onClose,
    this.showHomeIndicator = false,
  });

  final String title;
  final bool recorded;
  final ValueChanged<ReminderMenuOption>? onSelect;
  final VoidCallback? onClose;
  final bool showHomeIndicator;

  static const _pending = [
    (ReminderMenuOption.confirm, 'Aldım', 'Reminder/Icon · Check'),
    (ReminderMenuOption.postpone, 'Ertele', 'Date & Time/time'),
    (ReminderMenuOption.skip, 'Bugünkü dozu atla', 'User Interface/cross'),
    (ReminderMenuOption.edit, 'Hatırlatıcıyı düzenle', 'User Interface/edit'),
    (ReminderMenuOption.delete, 'Hatırlatıcıyı sil', 'User Interface/trash'),
  ];
  static const _recorded = [
    (ReminderMenuOption.editRecord, 'Kaydı düzenle', 'User Interface/edit calendar'),
    (ReminderMenuOption.edit, 'Hatırlatıcıyı düzenle', 'User Interface/edit'),
    (ReminderMenuOption.delete, 'Hatırlatıcıyı sil', 'User Interface/trash'),
  ];

  @override
  Widget build(BuildContext context) {
    final opts = recorded ? _recorded : _pending;
    return SheetFrame(
      title: title,
      compact: true,
      onClose: onClose,
      showHomeIndicator: showHomeIndicator,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var i = 0; i < opts.length; i++) ...[
            if (i > 0) const ActionOptionDivider(),
            ActionOption(
              label: opts[i].$2,
              icon: opts[i].$3,
              destructive: opts[i].$1 == ReminderMenuOption.delete,
              onTap: onSelect == null ? null : () => onSelect!(opts[i].$1),
            ),
          ],
        ]),
      ],
    );
  }
}
