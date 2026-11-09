import '../models/common.dart';
import '../models/device.dart';
import '../models/reminder.dart';
import '../models/stress.dart';
import '../models/sub_score.dart';

/// Prototipteki Beslenme kartı durum anahtarları (App `c.d.nutri`).
enum NutriKey { normal, progress, zero, noTarget, partial, goalReached, empty, loading, locked, error, offlineError, entError }

/// Prototipteki Cihaz verileri durum anahtarları (App `c.d.dev`).
enum DevKey { normal, loading, partialData, noData, deviceNotConnected, permissionMissing, error, offlineError }

/// Hatırlatıcı ⋮ sayfalarının modu (App `c.d.rmenu.mode`).
enum ReminderSheetMode { menu, postpone, record, delete }

class ReminderMenuState {
  const ReminderMenuState(this.index, this.mode);

  final int index;
  final ReminderSheetMode mode;
}

/// Kayıt türü (App `c.d.taken[i]`): Aldım veya Atla.
enum TakenKind { ok, skip }

const Object _keep = Object();

/// Prototip ekran durumu (App.dc.html `BASE` + seed alanları).
/// Ana sayfa bileşenlerinin hangi durumda çizileceğini belirler.
class HomeState {
  const HomeState({
    this.plan = PlanType.premium,
    this.today = SubScoreState.data,
    this.stress = StressState.data,
    this.mood = StressMood.rahatlamis,
    this.nutri = NutriKey.normal,
    this.rem = ReminderCardState.collapsed,
    this.dev = DevKey.normal,
    this.devItemsF3 = false,
    this.band,
    this.toastTop,
    this.toastBottom,
    this.premiumSheet = false,
    this.panel = false,
    this.offline = false,
    this.badge = 0,
    this.remExpanded = false,
    this.taken = const {},
    this.remMenu,
    this.postponeSelection,
    this.deleted = const {},
    this.rescheduled = const {},
    this.metricOverrides = const {},
    this.compactHeader = false,
    this.premiumBack,
  });

  final PlanType plan;
  final SubScoreState today;
  final StressState stress;
  final StressMood mood;
  final NutriKey nutri;
  final ReminderCardState rem;
  final DevKey dev;

  /// F3 · yeni gün metrik listesi.
  final bool devItemsF3;

  /// Durum bandı (D-20: üstte toast olarak).
  final ToastData? band;

  /// Sonuç toast'u (bandın yerini alır; tek toast kuralı).
  final ToastData? toastTop;
  final ToastData? toastBottom;
  final bool premiumSheet;
  final bool panel;
  final bool offline;
  final int badge;
  final bool remExpanded;
  final Map<int, TakenKind> taken;
  final ReminderMenuState? remMenu;
  final String? postponeSelection;
  final Set<int> deleted;
  final Map<int, String> rescheduled;
  final Map<DeviceMetric, MetricState> metricOverrides;

  /// ANA SAYFA V1.2 temel kareleri (`top130`): başlık cam butonları 40×40.
  final bool compactHeader;

  /// Premium sayfası kapanınca dönülecek ekran.
  final String? premiumBack;

  bool get isFree => plan == PlanType.free;

  HomeState copyWith({
    PlanType? plan,
    SubScoreState? today,
    StressState? stress,
    StressMood? mood,
    NutriKey? nutri,
    ReminderCardState? rem,
    DevKey? dev,
    bool? devItemsF3,
    Object? band = _keep,
    Object? toastTop = _keep,
    Object? toastBottom = _keep,
    bool? premiumSheet,
    bool? panel,
    bool? offline,
    int? badge,
    bool? remExpanded,
    Map<int, TakenKind>? taken,
    Object? remMenu = _keep,
    Object? postponeSelection = _keep,
    Set<int>? deleted,
    Map<int, String>? rescheduled,
    Map<DeviceMetric, MetricState>? metricOverrides,
    bool? compactHeader,
    Object? premiumBack = _keep,
  }) {
    return HomeState(
      plan: plan ?? this.plan,
      today: today ?? this.today,
      stress: stress ?? this.stress,
      mood: mood ?? this.mood,
      nutri: nutri ?? this.nutri,
      rem: rem ?? this.rem,
      dev: dev ?? this.dev,
      devItemsF3: devItemsF3 ?? this.devItemsF3,
      band: identical(band, _keep) ? this.band : band as ToastData?,
      toastTop: identical(toastTop, _keep) ? this.toastTop : toastTop as ToastData?,
      toastBottom: identical(toastBottom, _keep) ? this.toastBottom : toastBottom as ToastData?,
      premiumSheet: premiumSheet ?? this.premiumSheet,
      panel: panel ?? this.panel,
      offline: offline ?? this.offline,
      badge: badge ?? this.badge,
      remExpanded: remExpanded ?? this.remExpanded,
      taken: taken ?? this.taken,
      remMenu: identical(remMenu, _keep) ? this.remMenu : remMenu as ReminderMenuState?,
      postponeSelection: identical(postponeSelection, _keep) ? this.postponeSelection : postponeSelection as String?,
      deleted: deleted ?? this.deleted,
      rescheduled: rescheduled ?? this.rescheduled,
      metricOverrides: metricOverrides ?? this.metricOverrides,
      compactHeader: compactHeader ?? this.compactHeader,
      premiumBack: identical(premiumBack, _keep) ? this.premiumBack : premiumBack as String?,
    );
  }

  // ── App: anyError / allError ───────────────────────────────────────────
  static const cardError = {
    HomeCard.today: 'error',
    HomeCard.stress: 'error',
    HomeCard.nutri: 'error',
    HomeCard.rem: 'loadError',
    HomeCard.dev: 'error',
  };

  String keyOf(HomeCard c) => switch (c) {
        HomeCard.today => today.name,
        HomeCard.stress => stress.name,
        HomeCard.nutri => nutri.name,
        HomeCard.rem => rem.name,
        HomeCard.dev => dev.name,
      };

  bool isCardError(HomeCard c) => keyOf(c) == cardError[c];

  bool get anyError => HomeCard.values.any((c) => isCardError(c) || keyOf(c).endsWith('Error'));

  bool get allError => HomeCard.values.every(isCardError);
}

/// Ana sayfadaki kartlar (kart bazlı tekrar deneme için).
enum HomeCard { today, stress, nutri, rem, dev }
