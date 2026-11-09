import 'package:flutter/material.dart';

import '../models/common.dart';
import '../models/device.dart';
import '../models/nutrition.dart';
import '../models/reminder.dart';
import '../models/stress.dart';
import '../models/sub_score.dart';
import '../theme/nds_colors.dart';
import '../utils/pull_to_refresh.dart';
import '../widgets/common/nds_home_indicator.dart';
import '../widgets/device/device_data_section.dart';
import '../widgets/feedback/nds_toast.dart';
import '../widgets/navigation_bar/home_bottom_nav.dart';
import '../widgets/navigation_bar/quick_actions_panel.dart';
import '../widgets/nutrition/nutrition_card.dart';
import '../widgets/reminder/reminder_card.dart';
import '../widgets/stress/stress_monitor_card.dart';
import '../widgets/sub_score/sub_score_carousel.dart';
import '../widgets/top_bar/home_top_bar.dart';

/// Ekran düzeyindeki yönlendirmeler. Verilmeyen eylem pasif kalır.
class AnaSayfaToggActions {
  const AnaSayfaToggActions({
    this.onSettings,
    this.onNotifications,
    this.onOpenScore,
    this.onRetryScores,
    this.onConnectDevice,
    this.onManagePermissions,
    this.onStressDetails,
    this.onRetryStress,
    this.onNutritionDetails,
    this.onUpgrade,
    this.onRetryNutrition,
    this.onAddMeal,
    this.onRemindersToggle,
    this.onRemindersSeeAll,
    this.onReminderCreate,
    this.onRetryReminders,
    this.onReminderSkip,
    this.onReminderConfirm,
    this.onReminderStart,
    this.onReminderMenu,
    this.onDevicesSeeAll,
    this.onDeviceAction,
    this.onRetryMetric,
    this.onTab,
    this.onPlus,
    this.onPanelClose,
    this.onRefresh,
    this.onToastTopClose,
    this.onToastBottomClose,
  });

  final VoidCallback? onSettings;
  final VoidCallback? onNotifications;
  final ValueChanged<SubScoreKind>? onOpenScore;
  final VoidCallback? onRetryScores;
  final VoidCallback? onConnectDevice;
  final VoidCallback? onManagePermissions;
  final VoidCallback? onStressDetails;
  final VoidCallback? onRetryStress;
  final VoidCallback? onNutritionDetails;
  final VoidCallback? onUpgrade;
  final VoidCallback? onRetryNutrition;
  final VoidCallback? onAddMeal;
  final VoidCallback? onRemindersToggle;
  final VoidCallback? onRemindersSeeAll;
  final VoidCallback? onReminderCreate;
  final VoidCallback? onRetryReminders;
  final ValueChanged<ReminderItemData>? onReminderSkip;
  final ValueChanged<ReminderItemData>? onReminderConfirm;
  final ValueChanged<ReminderItemData>? onReminderStart;
  final ValueChanged<ReminderItemData>? onReminderMenu;
  final VoidCallback? onDevicesSeeAll;
  final VoidCallback? onDeviceAction;
  final ValueChanged<DeviceMetric>? onRetryMetric;
  final ValueChanged<HomeTab>? onTab;
  final VoidCallback? onPlus;
  final VoidCallback? onPanelClose;

  /// Aşağı çekerek yenileme (eşik 64 px, yalnız sayfa en üstteyken).
  final VoidCallback? onRefresh;
  final VoidCallback? onToastTopClose;
  final VoidCallback? onToastBottomClose;
}

/// 02 — Ana Sayfa Togg (App `Home`): üst bar, alt skor kartları, Stres Monitörü, Beslenme,
/// Günlük planım, Cihaz verileri, alt gezinme; üstte tek toast, Hızlı Aksiyonlar paneli.
/// Kartlar arası 20; içerik padding 16 20; alt boşluk 126 (72 gezinme + 34 ana gösterge + 20).
class AnaSayfaToggScreen extends StatefulWidget {
  const AnaSayfaToggScreen({
    super.key,
    required this.userGreeting,
    required this.plan,
    required this.subScoreState,
    required this.subScores,
    this.subScoreStaleLabel,
    required this.stress,
    required this.nutrition,
    required this.reminders,
    required this.devices,
    this.reminderTitle = 'Günlük planım',
    this.remindersExpanded = false,
    this.notificationCount = 0,
    this.compactHeader = false,
    this.topToast,
    this.bottomToast,
    this.panelOpen = false,
    this.quickActions,
    this.actions = const AnaSayfaToggActions(),
    this.statusBarHeight,
    this.showHomeIndicator = false,
  });

  /// “Merhaba Melis”
  final String userGreeting;
  final PlanType plan;
  final SubScoreState subScoreState;
  final SubScores subScores;
  final String? subScoreStaleLabel;
  final StressData stress;
  final NutritionData nutrition;
  final ReminderData reminders;
  final DeviceData devices;
  final String reminderTitle;
  final bool remindersExpanded;
  final int notificationCount;
  final bool compactHeader;

  /// Üstteki tek toast: sonuç toast'u veya durum bandı (D-20, T-01).
  final ToastData? topToast;

  /// Alt toast (çizgisiz). Üst toast varken gösterilmez (tek toast kuralı).
  final ToastData? bottomToast;
  final bool panelOpen;

  /// null → [defaultQuickActions].
  final List<QuickAction>? quickActions;
  final AnaSayfaToggActions actions;

  /// Tasarımda 58. null → cihazın üst güvenli alanı.
  final double? statusBarHeight;

  /// Tasarım önizlemesi: 34 px ana gösterge çizilir (gerçek cihazda sistem çizer).
  final bool showHomeIndicator;

  @override
  State<AnaSayfaToggScreen> createState() => _AnaSayfaToggScreenState();
}

class _AnaSayfaToggScreenState extends State<AnaSayfaToggScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final a = w.actions;
    final free = w.plan == PlanType.free;
    final bottomInset = w.showHomeIndicator ? 34.0 : MediaQuery.paddingOf(context).bottom;
    final top = w.statusBarHeight ?? MediaQuery.paddingOf(context).top;

    final cards = <Widget>[
      SubScoreCarousel(
        state: w.subScoreState,
        scores: w.subScores,
        staleLabel: w.subScoreStaleLabel,
        onOpenScore: a.onOpenScore,
        onRetry: a.onRetryScores,
        onConnectDevice: a.onConnectDevice,
        onManagePermissions: a.onManagePermissions,
      ),
      StressMonitorCard(
        data: w.stress,
        onDetails: a.onStressDetails,
        onConnectDevice: a.onConnectDevice,
        onManagePermissions: a.onManagePermissions,
        onRetry: a.onRetryStress,
      ),
      NutritionCard(
        data: w.nutrition,
        onDetails: a.onNutritionDetails,
        onUpgrade: a.onUpgrade,
        onRetry: a.onRetryNutrition,
        onAddMeal: a.onAddMeal,
      ),
      ReminderCard(
        data: w.reminders,
        title: w.reminderTitle,
        expanded: w.remindersExpanded,
        onToggle: a.onRemindersToggle == null ? null : (_) => a.onRemindersToggle!(),
        onSeeAll: a.onRemindersSeeAll,
        onUpgrade: a.onUpgrade,
        onCreate: a.onReminderCreate,
        onRetry: a.onRetryReminders,
        onSkip: a.onReminderSkip,
        onConfirm: a.onReminderConfirm,
        onStart: a.onReminderStart,
        onMenu: a.onReminderMenu,
      ),
      DeviceDataSection(
        data: w.devices,
        onSeeAll: a.onDevicesSeeAll,
        onAction: a.onDeviceAction,
        onRetryMetric: a.onRetryMetric,
      ),
    ];

    final scroll = PullToRefreshDetector(
      controller: _scroll,
      onRefresh: a.onRefresh,
      child: ListView(
        controller: _scroll,
        physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.fromLTRB(20, 16, 20, 92 + bottomInset),
        children: [
          for (var i = 0; i < cards.length; i++) ...[if (i > 0) const SizedBox(height: 20), cards[i]],
        ],
      ),
    );

    return ColoredBox(
      color: NdsColors.grey0,
      child: Stack(children: [
        Column(children: [
          HomeTopBar(
            title: 'Nusthera',
            greeting: w.userGreeting,
            plan: w.plan,
            badgeCount: w.notificationCount,
            onSettings: a.onSettings,
            onNotifications: a.onNotifications,
            statusBarHeight: w.statusBarHeight,
            compactButtons: w.compactHeader,
          ),
          Expanded(child: scroll),
        ]),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            HomeBottomNav(plusLocked: free, onChanged: a.onTab, onPlus: a.onPlus),
            if (w.showHomeIndicator) const NdsHomeIndicator() else SizedBox(height: bottomInset),
          ]),
        ),
        if (w.topToast != null)
          Positioned(
            left: 20,
            right: 20,
            top: top + 76 + 8, // .m-toast-top: 142 = 58 + 76 + 8
            child: NdsToast(key: ValueKey(w.topToast), data: w.topToast!, onClose: a.onToastTopClose),
          )
        else if (w.bottomToast != null)
          Positioned(
            left: 20,
            right: 20,
            bottom: 88 + bottomInset, // .m-toast-bottom: 122 = 88 + 34
            child: NdsToast(key: ValueKey(w.bottomToast), data: w.bottomToast!, bar: false, onClose: a.onToastBottomClose),
          ),
        if (w.panelOpen) ...[
          Positioned.fill(
            child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: a.onPanelClose),
          ),
          Positioned(
            left: 17,
            right: 17,
            bottom: 79 + bottomInset, // tasarım: 113 = 79 + 34
            child: QuickActionsPanel(
              items: w.quickActions ?? defaultQuickActions(),
              onClose: a.onPanelClose,
            ),
          ),
        ],
      ]),
    );
  }
}
