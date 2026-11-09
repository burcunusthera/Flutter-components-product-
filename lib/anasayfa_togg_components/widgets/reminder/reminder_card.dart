import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../models/reminder.dart';
import '../../theme/nds_shadows.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/action_link.dart';
import '../common/card_header.dart';
import '../common/nds_outline_button.dart';
import '../common/premium_chip.dart';
import '../common/premium_lock.dart';
import 'expand_toggle.dart';
import 'reminder_item.dart';
import 'reminder_item_skeleton.dart';

/// Günlük planım (DS ReminderCard + App `RemView`). Başlık “Günlük planım” (TG-10 karar bekliyor,
/// NUSTH-157 “Günlük Hatırlatıcı” diyor) — başlık parametre olarak verilir.
/// Kart: padding 16, radius 20, aralık 12 (kilitli 16), shadow-400.
class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.data,
    this.title = 'Günlük planım',
    this.limit = 3,
    this.expanded = false,
    this.onToggle,
    this.onSeeAll,
    this.onUpgrade,
    this.onCreate,
    this.onRetry,
    this.onSkip,
    this.onConfirm,
    this.onStart,
    this.onPause,
    this.onResume,
    this.onFinish,
    this.onUndo,
    this.onMenu,
  });

  final ReminderData data;
  final String title;
  final int limit;
  final bool expanded;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onSeeAll;
  final VoidCallback? onUpgrade;
  final VoidCallback? onCreate;
  final VoidCallback? onRetry;
  final ValueChanged<ReminderItemData>? onSkip;
  final ValueChanged<ReminderItemData>? onConfirm;
  final ValueChanged<ReminderItemData>? onStart;
  final ValueChanged<ReminderItemData>? onPause;
  final ValueChanged<ReminderItemData>? onResume;
  final ValueChanged<ReminderItemData>? onFinish;
  final ValueChanged<ReminderItemData>? onUndo;
  final ValueChanged<ReminderItemData>? onMenu;

  static const _offlineText = 'İnternet bağlantısı yok. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  Widget build(BuildContext context) {
    final st = data.state;
    final locked = st == ReminderCardState.locked;
    final noAction = const {
      ReminderCardState.locked,
      ReminderCardState.loading,
      ReminderCardState.empty,
      ReminderCardState.loadError,
      ReminderCardState.offlineError,
      ReminderCardState.entError,
      ReminderCardState.emptyToday,
    }.contains(st);
    final header = CardHeader(
      icon: 'Date & Time/alarm',
      title: title,
      badge: locked ? const PremiumChip() : null,
      action: noAction ? null : ActionLink(label: 'Tümünü gör', onTap: onSeeAll),
    );

    final body = <Widget>[];
    Widget title2(String t) => Text(t, style: ndsText(16, 20, 600, NdsColors.grey900));
    Widget desc(String t, {Color color = NdsColors.grey500}) => Text(t, style: ndsText(14, 18, 400, color));

    switch (st) {
      case ReminderCardState.loading:
        body.add(_list([for (var i = 0; i < 3; i++) const ReminderItemSkeleton()]));
      case ReminderCardState.empty:
        body
          ..add(title2('Henüz hatırlatıcınız yok'))
          ..add(desc('İlaç ya da takviye eklediğinizde, belirlediğiniz saatte size hatırlatırız.'))
          ..add(NdsOutlineButton(label: 'Hatırlatıcı oluştur', small: true, onTap: onCreate));
      case ReminderCardState.noneToday:
        body
          ..add(title2('Bugün planlanan hatırlatıcı yok'))
          ..add(desc(data.nextText ?? ''));
      case ReminderCardState.loadError:
        body
          ..add(title2('Hatırlatıcılarınız yüklenemedi'))
          ..add(desc('Birazdan tekrar deneyin.'))
          ..add(NdsOutlineButton(label: 'Tekrar dene', small: true, onTap: onRetry));
      case ReminderCardState.offlineError:
        body
          ..add(title2('Hatırlatıcılarınız yüklenemedi'))
          ..add(desc(_offlineText))
          ..add(NdsOutlineButton(label: 'Tekrar dene', small: true, onTap: onRetry));
      case ReminderCardState.entError:
        body
          ..add(title2('Abonelik doğrulanırken bir sorun oluştu'))
          ..add(desc('Lütfen daha sonra tekrar deneyiniz.'))
          ..add(NdsOutlineButton(label: 'Tekrar dene', small: true, onTap: onRetry));
      case ReminderCardState.emptyToday:
        body
          ..add(desc('Bugün için hatırlatıcınız yok', color: NdsColors.grey900))
          ..add(desc('İlaç, vitamin, takviye veya aktivite ekleyerek günlük planınızı oluşturabilirsiniz.'))
          ..add(NdsOutlineButton(label: 'Hatırlatıcı ekleyin', small: true, onTap: onCreate));
      case ReminderCardState.collapsed:
      case ReminderCardState.expanded:
      case ReminderCardState.allDone:
      case ReminderCardState.locked:
        {
          final lim = st == ReminderCardState.allDone ? 99 : limit;
          final open = st == ReminderCardState.expanded || expanded;
          final items = data.items;
          final shown = open ? items : items.take(lim).toList();
          final group = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (data.summary != null) ...[desc(data.summary!), const SizedBox(height: 8)],
            _list([for (final it in shown) _item(it)]),
            if (items.length > lim) ...[
              const SizedBox(height: 12), // grup aralığı 8 + .m-rem liste → genişlet 4
              ExpandToggle(
                expanded: open,
                hiddenCount: items.length - lim,
                onTap: onToggle == null ? null : () => onToggle!(!open),
              ),
            ],
          ]);
          if (locked) {
            body.add(ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 296),
              child: Stack(clipBehavior: Clip.none, children: [
                ExcludeSemantics(
                  child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: group),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 70,
                  child: PremiumLock(title: 'İlaç, vitamin ve aktivite hatırlatıcılarına erişin', onAction: onUpgrade),
                ),
              ]),
            ));
          } else {
            body.add(group);
          }
        }
    }

    final gap = locked ? 16.0 : 12.0;
    final all = [header, ...body];
    return Semantics(
      container: true,
      label: title,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: NdsColors.grey0, borderRadius: BorderRadius.circular(20), boxShadow: NdsShadows.s400),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var i = 0; i < all.length; i++) ...[if (i > 0) SizedBox(height: gap), all[i]],
        ]),
      ),
    );
  }

  Widget _list(List<Widget> items) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (var i = 0; i < items.length; i++) ...[if (i > 0) const SizedBox(height: 12), items[i]],
      ]);

  Widget _item(ReminderItemData it) => ReminderItem(
        data: it,
        disabled: data.offline,
        onSkip: onSkip == null ? null : () => onSkip!(it),
        onConfirm: onConfirm == null ? null : () => onConfirm!(it),
        onStart: onStart == null ? null : () => onStart!(it),
        onPause: onPause == null ? null : () => onPause!(it),
        onResume: onResume == null ? null : () => onResume!(it),
        onFinish: onFinish == null ? null : () => onFinish!(it),
        onUndo: onUndo == null ? null : () => onUndo!(it),
        onMenu: onMenu == null ? null : () => onMenu!(it),
      );
}
