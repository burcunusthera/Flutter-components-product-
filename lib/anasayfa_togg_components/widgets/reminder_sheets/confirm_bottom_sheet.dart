import 'package:flutter/widgets.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_button.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';
import '../common/r06.dart';

/// DS BottomSheet (onay) — hatırlatıcı silme. Padding 24, aralık 24, üst radius 36.
/// Görsel: R06 Kompakt 120 (silme onayında `silinsin-mi`, DS 30.10.2026 kuralı).
/// Başlık 24/30/600, açıklama 16/20 Greyscale/500, ortalı. Butonlar: yıkıcı birincil + ikincil.
class ConfirmBottomSheet extends StatelessWidget {
  const ConfirmBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.primaryAction,
    this.secondaryAction = 'Vazgeç',
    this.destructive = true,
    this.r06 = R06State.silinsinMi,
    this.onPrimary,
    this.onSecondary,
    this.onClose,
  });

  final String title;
  final String description;
  final String primaryAction;
  final String secondaryAction;
  final bool destructive;
  final R06State r06;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final kids = <Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 24),
        child: Align(
          alignment: Alignment.centerRight,
          child: Pressable(
            onTap: onClose,
            semanticLabel: 'Kapat',
            excludeChildSemantics: true,
            builder: (context, _) => const NdsIcon('Atoms/x', size: 24, color: NdsColors.grey900),
          ),
        ),
      ),
      Center(child: R06(r06, size: 120)),
      Column(children: [
        Text(title, textAlign: TextAlign.center, style: ndsText(24, 30, 600, NdsColors.grey900)),
        const SizedBox(height: 16),
        Text(description, textAlign: TextAlign.center, style: ndsText(16, 20, 400, NdsColors.grey500)),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        NdsButton(label: primaryAction, type: destructive ? NdsButtonType.destructive : NdsButtonType.primary, onTap: onPrimary),
        const SizedBox(height: 16),
        NdsButton(label: secondaryAction, type: NdsButtonType.secondary, onTap: onSecondary),
      ]),
    ];
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: title,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: NdsColors.grey0,
          borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var i = 0; i < kids.length; i++) ...[if (i > 0) const SizedBox(height: 24), kids[i]],
        ]),
      ),
    );
  }
}
