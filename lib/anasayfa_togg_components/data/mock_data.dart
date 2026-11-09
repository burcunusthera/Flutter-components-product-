/// ÖRNEK (MOCK) VERİ — yalnız önizleme içindir.
///
/// Buradaki değerler 02 — Ana Sayfa Togg prototipinin (App.dc.html, NustheraDS v1.4.12
/// varsayılanları) gösterim değerleridir. Gerçek uygulamada skor, stres, beslenme,
/// hatırlatıcı ve cihaz verileri API'den gelir. Hiçbir skor formülü veya tıbbi hesap içermez.
library;

import '../models/device.dart';
import '../models/nutrition.dart';
import '../models/reminder.dart';
import '../models/stress.dart';
import '../models/sub_score.dart';

abstract final class MockData {
  // ── Alt skorlar (App TODAY_SUBS) ─────────────────────────────────────────
  static const subScores = SubScores(activity: 40, sleep: 73, recovery: 93);
  static const staleLabel = 'Güncel değil · 11 Ekim';

  // ── Stres (App STRESS) ───────────────────────────────────────────────────
  /// [en yüksek, ortalama, en düşük, güncelleme metni]
  static const stressByMood = <StressMood, (int, int, int, String)>{
    StressMood.rahatlamis: (98, 91, 82, 'Son güncelleme: 11:30'),
    StressMood.dengeli: (59, 51, 42, 'Son güncelleme: 11:30'),
    StressMood.stresli: (39, 32, 23, 'Son güncelleme: 11:30'),
    StressMood.sakin: (79, 72, 63, 'Son güncelleme: 11 Ekim, 21:40'),
  };
  static const stressStaleUpdated = 'Son güncelleme: 11 Ekim, 21:40';
  static const stressInsufficientUpdated = 'Son güncelleme: 09:15 · 1 ölçüm';
  static const stressInsufficientAvg = 72;
  static const stressTodayNoneUpdated = 'Son ölçüm: Dün, 22:40';
  static const stressStaleWarning = 'Son veri 2 gün önce alındı. Değerler güncel olmayabilir.';

  // ── Beslenme (DS nutritionDefaults) ──────────────────────────────────────
  static const fat = MacroValue(consumed: '52', target: '70', progress: 74);
  static const carbs = MacroValue(consumed: '130', target: '200', progress: 48);
  static const protein = MacroValue(consumed: '130', target: '200', progress: 82);

  // ── Günlük planım (App REM_ITEMS) ────────────────────────────────────────
  static const reminderSummary = 'Bugün 11 hatırlatıcı · 2 tamamlandı · 9 bekliyor';
  static const reminderNext = 'Sıradaki hatırlatıcı: yarın 08:00 · D vitamini';
  static const reminders = <ReminderItemData>[
    ReminderItemData(id: 'r0', title: 'D vitamini', meta: '1 adet · 08:00', state: ReminderItemState.taken, statusText: 'Alındı · 08:03', thumbnail: ReminderThumb.softgel),
    ReminderItemData(id: 'r1', title: 'Metformin 500 mg', meta: '1 tablet · 08:30', state: ReminderItemState.taken, statusText: 'Alındı · 08:32', thumbnail: ReminderThumb.blister),
    ReminderItemData(id: 'r2', title: 'B12 vitamini', meta: '1 tablet · 09:00', state: ReminderItemState.due, statusText: 'Saati geldi', thumbnail: ReminderThumb.vitaminTablet),
    ReminderItemData(id: 'r3', title: 'Hafif yürüyüş', meta: '20 dk · 09:30', state: ReminderItemState.activityNotStarted, thumbnail: ReminderThumb.activity),
    ReminderItemData(id: 'r4', title: 'Amlodipin 5 mg', meta: '1 tablet · 10:30', state: ReminderItemState.planned, thumbnail: ReminderThumb.tablet),
    ReminderItemData(id: 'r5', title: 'Magnezyum', meta: '1 kapsül · 12:00', state: ReminderItemState.planned, thumbnail: ReminderThumb.softgel),
    ReminderItemData(id: 'r6', title: 'Omega 3', meta: '1 kapsül · 13:00', state: ReminderItemState.planned, thumbnail: ReminderThumb.softgel),
    ReminderItemData(id: 'r7', title: 'Atorvastatin 20 mg', meta: '1 tablet · 15:00', state: ReminderItemState.planned, thumbnail: ReminderThumb.tablet),
    ReminderItemData(id: 'r8', title: 'Demir takviyesi', meta: '1 tablet · 18:00', state: ReminderItemState.planned, thumbnail: ReminderThumb.tablet),
    ReminderItemData(id: 'r9', title: 'C vitamini', meta: '1 adet · 20:00', state: ReminderItemState.planned, thumbnail: ReminderThumb.vitaminTablet),
    ReminderItemData(id: 'r10', title: 'Melatonin 3 mg', meta: '1 tablet · 22:00', state: ReminderItemState.planned, thumbnail: ReminderThumb.tablet),
  ];

  /// Kilitli kartın bulanık önizlemesi (Figma Reminder/Section State=Locked): üçüncüsü atlanmış.
  static const lockedReminders = <ReminderItemData>[
    ReminderItemData(id: 'r0', title: 'D vitamini', meta: '1 adet · 08:00', state: ReminderItemState.taken, statusText: 'Alındı · 08:03', thumbnail: ReminderThumb.softgel),
    ReminderItemData(id: 'r1', title: 'Metformin 500 mg', meta: '1 tablet · 08:30', state: ReminderItemState.taken, statusText: 'Alındı · 08:32', thumbnail: ReminderThumb.blister),
    ReminderItemData(id: 'r2', title: 'B12 vitamini', meta: '1 tablet · 09:00', state: ReminderItemState.skipped, statusText: 'Atlandı · 09:05', thumbnail: ReminderThumb.vitaminTablet),
  ];

  /// Kayıt sonrası durum metni saati (prototipte sabit).
  static const recordTime = '09:02';

  // ── Cihaz verileri (DS deviceMetrics varsayılanları) ──────────────────────
  static DeviceMetricData metric(DeviceMetric m, MetricState st, {String? staleText, String? message}) {
    final (value, tone, level) = switch (m) {
      DeviceMetric.heartRate => ('72', MetricTone.success, 50),
      DeviceMetric.steps => ('10.521', MetricTone.primary, 89),
      DeviceMetric.calories => ('1.200', MetricTone.warning, 27),
      DeviceMetric.spo2 => ('98', MetricTone.success, 50),
      DeviceMetric.respiratoryRate => ('19', MetricTone.success, 50),
      DeviceMetric.sleep => (null, MetricTone.success, 50),
    };
    return DeviceMetricData(
      metric: m,
      state: st,
      value: value,
      hours: m == DeviceMetric.sleep ? '4' : null,
      minutes: m == DeviceMetric.sleep ? '50' : null,
      tone: tone,
      level: level,
      staleText: staleText ?? (st == MetricState.stale ? '3 sa önce' : null),
      message: message,
    );
  }

  static List<DeviceMetricData> metrics(MetricState st) => [for (final m in DeviceMetric.values) metric(m, st)];

  /// DS sectionRows.partialData
  static List<DeviceMetricData> get partialMetrics => [
        metric(DeviceMetric.heartRate, MetricState.ready),
        metric(DeviceMetric.steps, MetricState.ready),
        metric(DeviceMetric.calories, MetricState.stale),
        metric(DeviceMetric.spo2, MetricState.empty),
        metric(DeviceMetric.respiratoryRate, MetricState.error),
        metric(DeviceMetric.sleep, MetricState.empty),
      ];

  /// App F3_ITEMS (yeni gün)
  static const f3Metrics = <(DeviceMetric, MetricState, String?)>[
    (DeviceMetric.heartRate, MetricState.stale, 'Dün, 23:54'),
    (DeviceMetric.steps, MetricState.empty, null),
    (DeviceMetric.calories, MetricState.empty, null),
    (DeviceMetric.spo2, MetricState.stale, 'Dün, 22:10'),
    (DeviceMetric.respiratoryRate, MetricState.error, null),
    (DeviceMetric.sleep, MetricState.stale, 'Dün gece'),
  ];
}
