import '../models/device.dart';
import '../models/nutrition.dart';
import '../models/reminder.dart';
import '../models/stress.dart';
import 'home_state.dart';
import 'mock_data.dart';

/// Prototip durumunu ([HomeState]) kart verilerine çevirir (App `StressView`, `NutriView`,
/// `RemView` / `remItems`, `DevView` eşlemesi). Değerler [MockData]'dan gelir.
abstract final class HomeMapper {
  static const offlineText = 'İnternet bağlantısı yok. Bağlantınızı kontrol edip tekrar deneyin.';

  // ── Stres ──────────────────────────────────────────────────────────────
  static StressData stress(HomeState d) {
    final v = MockData.stressByMood[d.mood] ?? MockData.stressByMood[StressMood.rahatlamis]!;
    switch (d.stress) {
      case StressState.data:
        final upd = d.mood == StressMood.sakin ? 'Son güncelleme: 11:30' : v.$4;
        return StressData(state: d.stress, mood: d.mood, max: v.$1, avg: v.$2, min: v.$3, updatedText: upd);
      case StressState.stale:
        return StressData(
          state: d.stress,
          mood: d.mood,
          max: v.$1,
          avg: v.$2,
          min: v.$3,
          updatedText: MockData.stressStaleUpdated,
          staleWarning: MockData.stressStaleWarning,
        );
      case StressState.insufficient:
        return const StressData(
          state: StressState.insufficient,
          mood: StressMood.sakin,
          avg: MockData.stressInsufficientAvg,
          updatedText: MockData.stressInsufficientUpdated,
        );
      case StressState.todayNone:
        return const StressData(state: StressState.todayNone, updatedText: MockData.stressTodayNoneUpdated);
      default:
        return StressData(state: d.stress);
    }
  }

  // ── Beslenme ───────────────────────────────────────────────────────────
  static NutritionData nutrition(HomeState d) {
    const f = MockData.fat, c = MockData.carbs, p = MockData.protein;
    return switch (d.nutri) {
      NutriKey.normal => const NutritionData(state: NutritionState.normal, fat: f, carbs: c, protein: p),
      NutriKey.locked => const NutritionData(state: NutritionState.locked, fat: f, carbs: c, protein: p),
      NutriKey.progress => NutritionData(
          state: NutritionState.progress,
          fat: f,
          carbs: _p(c, 65),
          protein: _p(p, 65),
        ),
      NutriKey.zero => const NutritionData(
          state: NutritionState.zero,
          fat: MacroValue(consumed: '0', target: '70', progress: 0),
          carbs: MacroValue(consumed: '0', target: '200', progress: 0),
          protein: MacroValue(consumed: '0', target: '200', progress: 0),
        ),
      NutriKey.noTarget => const NutritionData(
          state: NutritionState.noTarget,
          fat: MacroValue(consumed: '52'),
          carbs: MacroValue(consumed: '130'),
          protein: MacroValue(consumed: '130'),
        ),
      NutriKey.partial => NutritionData(state: NutritionState.partial, fat: f, carbs: _p(c, 65), protein: p),
      NutriKey.goalReached => const NutritionData(
          state: NutritionState.goalReached,
          fat: MacroValue(consumed: '70', target: '70', progress: 100),
          carbs: MacroValue(consumed: '236', target: '200', progress: 100, caption: 'Hedefin 36 g üzerinde'),
          protein: MacroValue(consumed: '130', target: '200', progress: 65),
        ),
      NutriKey.empty => const NutritionData(state: NutritionState.empty),
      NutriKey.loading => const NutritionData(state: NutritionState.loading),
      NutriKey.error => const NutritionData(state: NutritionState.error),
      NutriKey.offlineError => const NutritionData(state: NutritionState.error, errorText: '$offlineText Kayıtlarınız silinmedi.'),
      NutriKey.entError => const NutritionData(
          state: NutritionState.error,
          errorTitle: 'Abonelik doğrulanırken bir sorun oluştu',
          errorText: 'Lütfen daha sonra tekrar deneyiniz.',
        ),
    };
  }

  static MacroValue _p(MacroValue v, int progress) =>
      MacroValue(consumed: v.consumed, target: v.target, progress: progress, caption: v.caption);

  // ── Günlük planım ──────────────────────────────────────────────────────
  static final _timeAtEnd = RegExp(r'(\d\d:\d\d)$');

  /// App `remItems`: kayıt, erteleme ve silme sonrası liste.
  static List<ReminderItemData> reminderItems(HomeState d) {
    final out = <ReminderItemData>[];
    for (var i = 0; i < MockData.reminders.length; i++) {
      if (d.deleted.contains(i)) continue;
      final it = MockData.reminders[i];
      var state = it.state;
      var meta = it.meta;
      String? status = it.statusText;
      final tm = d.rescheduled[i];
      if (tm != null && meta != null) {
        meta = meta.replaceFirst(_timeAtEnd, tm);
        if (state == ReminderItemState.due || state == ReminderItemState.overdue) {
          state = ReminderItemState.upcoming;
          status = null;
        }
      }
      final t = d.taken[i];
      if (t != null) {
        state = t == TakenKind.skip ? ReminderItemState.skipped : ReminderItemState.taken;
        status = '${t == TakenKind.skip ? 'Atlandı' : 'Alındı'} · ${MockData.recordTime}';
      }
      out.add(ReminderItemData(id: it.id, title: it.title, meta: meta, state: state, statusText: status, thumbnail: it.thumbnail));
    }
    return out;
  }

  static ReminderData reminders(HomeState d) => ReminderData(
        state: d.rem,
        summary: MockData.reminderSummary,
        items: d.rem == ReminderCardState.locked ? MockData.lockedReminders : reminderItems(d),
        nextText: MockData.reminderNext,
        offline: d.offline,
      );

  /// Ertele: planlanan saat (ertelenmişse yeni saat).
  static String plannedTime(HomeState d, int i) =>
      d.rescheduled[i] ?? _timeAtEnd.firstMatch(MockData.reminders[i].meta ?? '')?.group(1) ?? '';

  /// Kaydedilmiş mi (menü: Kaydı düzenle seçenekleri)?
  static bool recorded(HomeState d, int i) {
    if (d.taken[i] != null) return true;
    final s = MockData.reminders[i].state;
    return s == ReminderItemState.taken || s == ReminderItemState.skipped;
  }

  static int indexOf(ReminderItemData it) => MockData.reminders.indexWhere((r) => r.id == it.id);

  // ── Cihaz verileri ─────────────────────────────────────────────────────
  static DeviceData devices(HomeState d) {
    return switch (d.dev) {
      DevKey.loading => DeviceData(state: DeviceSectionState.loading, items: MockData.metrics(MetricState.loading)),
      DevKey.deviceNotConnected => const DeviceData(state: DeviceSectionState.deviceNotConnected),
      DevKey.permissionMissing => const DeviceData(state: DeviceSectionState.permissionMissing),
      DevKey.error => const DeviceData(state: DeviceSectionState.error),
      DevKey.offlineError => const DeviceData(state: DeviceSectionState.offlineError),
      DevKey.partialData => DeviceData(state: DeviceSectionState.normal, items: MockData.partialMetrics),
      DevKey.noData => DeviceData(state: DeviceSectionState.normal, items: MockData.metrics(MetricState.empty)),
      DevKey.normal => d.devItemsF3
            ? DeviceData(state: DeviceSectionState.normal, items: [
                for (final (m, st, stale) in MockData.f3Metrics)
                  MockData.metric(m, d.metricOverrides[m] ?? st, staleText: stale),
              ])
            : DeviceData(state: DeviceSectionState.normal, items: MockData.metrics(MetricState.ready)),
    };
  }
}
