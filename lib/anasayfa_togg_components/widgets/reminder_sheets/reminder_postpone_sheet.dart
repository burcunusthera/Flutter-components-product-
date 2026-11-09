import 'package:flutter/widgets.dart';

import '../common/nds_button.dart';
import '../common/tile_selection.dart';
import 'sheet_frame.dart';

/// Ertele seçenekleri (DS sırası).
const kPostponeOptions = ['10 dakika', '15 dakika', '30 dakika', '1 saat', 'Saat seç'];

/// Seçeneğin dakika karşılığı; “Saat seç” işletim sistemi saat seçicisini açar (null).
int? postponeMinutes(String option) => const {'10 dakika': 10, '15 dakika': 15, '30 dakika': 30, '1 saat': 60}[option];

/// DS ReminderPostponeSheet (Figma 4882:10118). Seçim yokken “Ertele” pasif.
class ReminderPostponeSheet extends StatelessWidget {
  const ReminderPostponeSheet({
    super.key,
    required this.name,
    required this.plannedText,
    this.selected,
    this.onSelect,
    this.onConfirm,
    this.onClose,
    this.showHomeIndicator = false,
  });

  final String name;

  /// “Planlanan saat 09:00”
  final String plannedText;
  final String? selected;
  final ValueChanged<String>? onSelect;
  final VoidCallback? onConfirm;
  final VoidCallback? onClose;
  final bool showHomeIndicator;

  @override
  Widget build(BuildContext context) {
    return SheetFrame(
      title: 'Ertele',
      onClose: onClose,
      showHomeIndicator: showHomeIndicator,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SheetSummary(name: name, lines: [plannedText]),
          const SizedBox(height: 16),
          for (var i = 0; i < kPostponeOptions.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            TileSelection(
              label: kPostponeOptions[i],
              selected: selected == kPostponeOptions[i],
              onTap: onSelect == null ? null : () => onSelect!(kPostponeOptions[i]),
            ),
          ],
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          NdsButton(label: 'Ertele', onTap: selected == null ? null : onConfirm),
          const SizedBox(height: 16),
          NdsButton(label: 'Vazgeç', type: NdsButtonType.secondary, onTap: onClose),
        ]),
      ],
    );
  }
}
