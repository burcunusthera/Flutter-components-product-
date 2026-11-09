import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_button.dart';
import '../common/nds_input.dart';
import 'sheet_frame.dart';

/// DS ReminderEditRecordSheet (Figma 4884:9607): özet, “Gerçekleşen saat” alanı, yardım metni, Kaydet / Vazgeç.
class ReminderEditRecordSheet extends StatelessWidget {
  const ReminderEditRecordSheet({
    super.key,
    required this.name,
    this.meta,
    this.statusText,
    this.time,
    this.onSave,
    this.onClose,
    this.showHomeIndicator = false,
  });

  final String name;
  final String? meta;
  final String? statusText;
  final String? time;
  final VoidCallback? onSave;
  final VoidCallback? onClose;
  final bool showHomeIndicator;

  @override
  Widget build(BuildContext context) {
    return SheetFrame(
      title: 'Kaydı düzenle',
      onClose: onClose,
      showHomeIndicator: showHomeIndicator,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SheetSummary(name: name, lines: [if (meta != null) meta!], status: statusText),
          const SizedBox(height: 16),
          NdsInput(label: 'Gerçekleşen saat', initialValue: time, keyboardType: TextInputType.datetime),
          const SizedBox(height: 16),
          Text('Varsayılan saat işlemin yapıldığı andır; gerekirse düzeltebilirsiniz.', style: ndsText(12, 15, 400, NdsColors.grey500)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          NdsButton(label: 'Kaydet', onTap: onSave),
          const SizedBox(height: 16),
          NdsButton(label: 'Vazgeç', type: NdsButtonType.secondary, onTap: onClose),
        ]),
      ],
    );
  }
}
