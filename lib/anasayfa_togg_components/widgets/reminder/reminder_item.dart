import 'package:flutter/material.dart';

import '../../models/reminder.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';
import 'reminder_action_button.dart';
import 'reminder_item_skeleton.dart';
import 'reminder_start_button.dart';
import 'reminder_status_mark.dart';
import 'reminder_thumbnail.dart';

enum _Tone { normal, attention, error, active }

const _status = <ReminderItemState, (String, _Tone)>{
  ReminderItemState.planned: ('Planlandı', _Tone.normal),
  ReminderItemState.upcoming: ('Yaklaşıyor', _Tone.normal),
  ReminderItemState.due: ('Saati geldi', _Tone.attention),
  ReminderItemState.overdue: ('Saati geçti', _Tone.attention),
  ReminderItemState.noRecord: ('Kayıt yok', _Tone.normal),
  ReminderItemState.saving: ('Alındı', _Tone.normal),
  ReminderItemState.taken: ('Alındı', _Tone.normal),
  ReminderItemState.savingSkipped: ('Atlandı', _Tone.normal),
  ReminderItemState.skippedUndo: ('Atlandı', _Tone.normal),
  ReminderItemState.skipped: ('Atlandı', _Tone.normal),
  ReminderItemState.activityNotStarted: ('Başlamadı', _Tone.normal),
  ReminderItemState.activityStarting: ('Devam ediyor', _Tone.active),
  ReminderItemState.activityInProgress: ('Devam ediyor', _Tone.active),
  ReminderItemState.activityPaused: ('Duraklatıldı', _Tone.normal),
  ReminderItemState.activitySaving: ('Tamamlandı', _Tone.normal),
  ReminderItemState.activityCompleted: ('Tamamlandı', _Tone.normal),
  ReminderItemState.activityAbandoned: ('Yarıda bırakıldı', _Tone.normal),
  ReminderItemState.loading: ('', _Tone.normal),
};

/// DS ReminderItem: padding 8, radius 16, iç kenar 1 Greyscale/50, aralık 12.
class ReminderItem extends StatelessWidget {
  const ReminderItem({
    super.key,
    required this.data,
    this.disabled = false,
    this.onSkip,
    this.onConfirm,
    this.onStart,
    this.onPause,
    this.onResume,
    this.onFinish,
    this.onUndo,
    this.onMenu,
  });

  final ReminderItemData data;

  /// Çevrimdışı: yazma aksiyonları pasif ve gri.
  final bool disabled;
  final VoidCallback? onSkip;
  final VoidCallback? onConfirm;
  final VoidCallback? onStart;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onFinish;
  final VoidCallback? onUndo;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    if (data.state == ReminderItemState.loading) return const ReminderItemSkeleton();
    final st = data.state;
    final info = _status[st]!;
    final tone = info.$2;
    final statusStyle = switch (tone) {
      _Tone.attention => ndsText(14, 18, 500, NdsColors.warning800),
      _Tone.error => ndsText(14, 18, 500, NdsColors.danger500),
      _Tone.active => ndsText(14, 18, 500, NdsColors.primary500),
      _Tone.normal => ndsText(14, 18, 400, NdsColors.grey500),
    };
    VoidCallback? w(VoidCallback? f) => disabled ? null : f;

    Widget? trailing;
    switch (st) {
      case ReminderItemState.due:
      case ReminderItemState.overdue:
        trailing = _actions([
          ReminderActionButton(kind: ReminderActionKind.skip, onTap: w(onSkip), offline: disabled),
          ReminderActionButton(kind: ReminderActionKind.confirm, onTap: w(onConfirm), offline: disabled),
        ]);
      case ReminderItemState.noRecord:
        trailing = _actions([ReminderActionButton(kind: ReminderActionKind.confirm, onTap: w(onConfirm), offline: disabled)]);
      case ReminderItemState.activityInProgress:
        trailing = _actions([
          ReminderActionButton(kind: ReminderActionKind.pause, onTap: w(onPause), offline: disabled),
          ReminderActionButton(kind: ReminderActionKind.finish, onTap: w(onFinish), offline: disabled),
        ]);
      case ReminderItemState.activityStarting:
        trailing = _actions(const [
          ReminderActionButton(kind: ReminderActionKind.pause, dimmed: true),
          ReminderActionButton(kind: ReminderActionKind.finish, loading: true),
        ]);
      case ReminderItemState.activityPaused:
        trailing = _actions([
          ReminderActionButton(kind: ReminderActionKind.resume, onTap: w(onResume), offline: disabled),
          ReminderActionButton(kind: ReminderActionKind.finish, onTap: w(onFinish), offline: disabled),
        ]);
      case ReminderItemState.activityNotStarted:
        trailing = Padding(padding: const EdgeInsets.only(top: 12), child: ReminderStartButton(onTap: onStart));
      case ReminderItemState.taken:
      case ReminderItemState.activityCompleted:
        trailing = const ReminderStatusMark(ReminderMarkType.taken);
      case ReminderItemState.saving:
      case ReminderItemState.savingSkipped:
      case ReminderItemState.activitySaving:
        trailing = const ReminderStatusMark(ReminderMarkType.saving);
      case ReminderItemState.skipped:
      case ReminderItemState.activityAbandoned:
        trailing = const ReminderStatusMark(ReminderMarkType.skipped);
      case ReminderItemState.skippedUndo:
        trailing = Pressable(
          onTap: w(onUndo),
          semanticLabel: 'Geri al',
          excludeChildSemantics: true,
          builder: (context, _) => Column(mainAxisSize: MainAxisSize.min, children: [
            const ReminderStatusMark(ReminderMarkType.skipped),
            const SizedBox(height: 4),
            Text('Geri al', style: ndsText(12, 15, 500, NdsColors.primary500)),
          ]),
        );
      case ReminderItemState.planned:
      case ReminderItemState.upcoming:
      case ReminderItemState.loading:
        trailing = null;
    }

    final isActivity = st.name.startsWith('activity');
    return Stack(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: NdsColors.grey0, borderRadius: BorderRadius.circular(16)),
        // box-shadow: inset 0 0 0 1px Greyscale/50 — yerleşimi etkilemez
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: NdsColors.grey50),
        ),
        child: Row(children: [
          ReminderThumbnail(data.thumbnail ?? (isActivity ? ReminderThumb.activity : ReminderThumb.tablet)),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1), // .m-rem .nds-ritem__text
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(data.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: ndsText(16, 20, 600, NdsColors.grey900)),
                if (data.meta != null) ...[
                  const SizedBox(height: 4),
                  Text(data.meta!, style: ndsText(14, 18, 400, NdsColors.grey500)),
                ],
                const SizedBox(height: 4),
                Text(data.statusText ?? info.$1, style: statusStyle),
              ]),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing],
        ]),
      ),
      if (onMenu != null)
        Positioned(
          top: 0,
          right: 0,
          child: Pressable(
            onTap: onMenu,
            semanticLabel: 'Seçenekler',
            excludeChildSemantics: true,
            builder: (context, _) => const SizedBox(
              width: 44,
              height: 24,
              child: Center(child: NdsIcon('User Interface/more', size: 20, color: NdsColors.grey400)),
            ),
          ),
        ),
    ]);
  }

  Widget _actions(List<Widget> b) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          for (var i = 0; i < b.length; i++) ...[if (i > 0) const SizedBox(width: 8), b[i]],
        ]),
      );
}
