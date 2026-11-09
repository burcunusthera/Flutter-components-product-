import 'package:flutter/material.dart';

import '../data/home_mapper.dart';
import '../data/home_state.dart';
import '../data/mock_data.dart';
import '../models/reminder.dart';
import '../navigation/prototype_controller.dart';
import '../theme/nds_colors.dart';
import '../widgets/common/enter_animation.dart';
import '../widgets/common/nds_home_indicator.dart';
import '../widgets/navigation_bar/quick_actions_panel.dart';
import '../widgets/premium/premium_sheet.dart';
import '../widgets/reminder_sheets/confirm_bottom_sheet.dart';
import '../widgets/reminder_sheets/reminder_action_sheet.dart';
import '../widgets/reminder_sheets/reminder_edit_record_sheet.dart';
import '../widgets/reminder_sheets/reminder_postpone_sheet.dart';
import 'ana_sayfa_togg_screen.dart';
import 'score_target_screen.dart';

/// Oynatılabilir Ana Sayfa Togg: [PrototypeController] durumunu ekrana bağlar.
/// Kart davranışları, ⋮ alt sayfaları, Premium sayfası, Hızlı Aksiyonlar ve skor hedefleri dahil.
class PrototypeHomeScreen extends StatelessWidget {
  const PrototypeHomeScreen({super.key, required this.controller, this.designFrame = true});

  final PrototypeController controller;

  /// true → 375×812 tasarım çerçevesi (durum çubuğu 58, ana gösterge 34 çizilir).
  final bool designFrame;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final c = controller;
        final kind = switch (c.anim) {
          ProtoAnim.push => EnterKind.push,
          ProtoAnim.back => EnterKind.back,
          ProtoAnim.none => EnterKind.none,
        };
        final target = c.current.scoreTarget;
        final page = target != null
            ? ScoreTargetScreen(kind: target, onBack: c.back)
            : _home(c);
        return Stack(children: [
          Positioned.fill(
            child: KeyedSubtree(key: ValueKey(c.navCount), child: EnterAnimation(kind: kind, child: page)),
          ),
          if (target == null && c.state.premiumSheet) ..._premium(c),
          if (target == null && c.state.remMenu != null) ..._reminderSheet(c, c.state.remMenu!),
        ]);
      },
    );
  }

  Widget _home(PrototypeController c) {
    final d = c.state;
    return AnaSayfaToggScreen(
      userGreeting: 'Merhaba Melis',
      plan: d.plan,
      subScoreState: d.today,
      subScores: MockData.subScores,
      subScoreStaleLabel: MockData.staleLabel,
      stress: c.stressData,
      nutrition: c.nutritionData,
      reminders: c.reminderData,
      devices: c.deviceData,
      remindersExpanded: d.remExpanded,
      notificationCount: d.badge,
      compactHeader: d.compactHeader,
      topToast: d.toastTop ?? d.band,
      bottomToast: d.toastBottom,
      panelOpen: d.panel,
      quickActions: [
        for (final q in defaultQuickActions(offline: d.offline))
          QuickAction(
            icon: q.icon,
            label: q.label,
            disabled: q.disabled,
            onTap: () => c.quickAction(switch (q.icon) {
              'Traveling/fork and spoon' => 'Öğün ekle (6460:474)',
              'Medical/pills' => 'İlaç ekle (6462:5834)',
              'File/upload file' => 'Tahlil yorumlat (6463:9055)',
              _ => 'Sağlık kayıtlarım (6464:12250)',
            }),
          ),
      ],
      statusBarHeight: designFrame ? 58 : null,
      showHomeIndicator: designFrame,
      actions: AnaSayfaToggActions(
        onSettings: c.openSettings,
        onNotifications: c.openNotifications,
        onOpenScore: c.openScore,
        onRetryScores: () => c.retry(HomeCard.today),
        onConnectDevice: c.connectDevice,
        onManagePermissions: c.permission,
        onStressDetails: c.stressDetails,
        onRetryStress: () => c.retry(HomeCard.stress),
        onNutritionDetails: c.nutritionDetails,
        onUpgrade: () => c.openPremium('card'),
        onRetryNutrition: () => c.retry(HomeCard.nutri),
        onAddMeal: c.addMeal,
        onRemindersToggle: c.toggleReminders,
        onRemindersSeeAll: c.remindersSeeAll,
        onReminderCreate: c.reminderCreate,
        onRetryReminders: () => c.retry(HomeCard.rem),
        onReminderSkip: c.reminderSkip,
        onReminderConfirm: c.reminderConfirm,
        onReminderMenu: c.openReminderMenu,
        onDevicesSeeAll: c.devicesSeeAll,
        onDeviceAction: c.deviceAction,
        onRetryMetric: c.retryMetric,
        onTab: c.onTab,
        onPlus: c.onPlus,
        onPanelClose: c.closePanel,
        onRefresh: c.refresh,
        onToastTopClose: d.toastTop != null ? c.closeToastTop : c.closeBand,
        onToastBottomClose: c.closeToastBottom,
      ),
    );
  }

  /// E2 · Premium alt sayfası: örtü rgba(13,13,18,.6), 656 yükseklik.
  List<Widget> _premium(PrototypeController c) => [
        Positioned.fill(
          child: EnterAnimation(
            kind: EnterKind.fade,
            child: GestureDetector(onTap: c.closePremium, child: const ColoredBox(color: NdsColors.scrim)),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: EnterAnimation(
            kind: EnterKind.rise,
            child: Stack(children: [
              PremiumSheet(onClose: c.closePremium, onExplore: c.explorePremium),
              if (designFrame) const Positioned(left: 0, right: 0, bottom: 0, child: NdsHomeIndicator()),
            ]),
          ),
        ),
      ];

  /// Hatırlatıcı ⋮ sayfaları (Reminder/ActionSheet, PostponeSheet, EditRecordSheet, silme onayı).
  List<Widget> _reminderSheet(PrototypeController c, ReminderMenuState m) {
    final d = c.state;
    final it = MockData.reminders[m.index];
    final tk = d.taken[m.index];
    final recordText = tk != null
        ? '${tk == TakenKind.skip ? 'Atlandı' : 'Alındı'} · ${MockData.recordTime}'
        : (it.statusText ?? '');
    final scrim = m.mode == ReminderSheetMode.delete ? NdsColors.overlay : NdsColors.scrim;
    final Widget sheet = switch (m.mode) {
      ReminderSheetMode.menu => ReminderActionSheet(
          title: it.title,
          recorded: HomeMapper.recorded(d, m.index),
          onSelect: c.reminderMenuSelect,
          onClose: c.closeReminderSheet,
          showHomeIndicator: designFrame,
        ),
      ReminderSheetMode.postpone => ReminderPostponeSheet(
          name: it.title,
          plannedText: 'Planlanan saat ${HomeMapper.plannedTime(d, m.index)}',
          selected: d.postponeSelection,
          onSelect: c.selectPostpone,
          onConfirm: c.confirmPostpone,
          onClose: c.closeReminderSheet,
          showHomeIndicator: designFrame,
        ),
      ReminderSheetMode.record => ReminderEditRecordSheet(
          name: it.title,
          meta: it.meta,
          statusText: recordText,
          time: RegExp(r'\d\d:\d\d').firstMatch(recordText)?.group(0) ?? '',
          onSave: c.closeReminderSheet,
          onClose: c.closeReminderSheet,
          showHomeIndicator: designFrame,
        ),
      ReminderSheetMode.delete => Stack(children: [
          ConfirmBottomSheet(
            title: 'Hatırlatıcıyı silmek istediğinize emin misiniz?',
            description: 'Bu günlük hatırlatıcı programınızdan kaldırılacaktır. Silinen hatırlatıcı geri alınamaz.',
            primaryAction: 'Hatırlatıcıyı sil',
            onPrimary: c.confirmDelete,
            onSecondary: c.closeReminderSheet,
            onClose: c.closeReminderSheet,
          ),
          if (designFrame) const Positioned(left: 0, right: 0, bottom: 0, child: NdsHomeIndicator()),
        ]),
    };
    return [
      Positioned.fill(
        child: EnterAnimation(
          kind: EnterKind.fade,
          child: GestureDetector(onTap: c.closeReminderSheet, child: ColoredBox(color: scrim)),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: EnterAnimation(
          key: ValueKey('${m.index}-${m.mode}'),
          kind: EnterKind.rise,
          child: Material(type: MaterialType.transparency, child: sheet),
        ),
      ),
    ];
  }
}

/// [ReminderItemData] listesinden kaydın sırasını bulmak için kısayol.
int reminderIndex(ReminderItemData it) => HomeMapper.indexOf(it);
