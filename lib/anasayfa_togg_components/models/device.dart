/// Cihaz verileri veri modelleri. Bileşenler veri üretmez (R-04);
/// değerler dışarıdan gelir.
library;

enum DeviceMetric { heartRate, steps, calories, spo2, respiratoryRate, sleep }

enum MetricState { ready, loading, empty, stale, error }

enum MetricTone { success, primary, warning }

class DeviceMetricData {
  const DeviceMetricData({
    required this.metric,
    required this.state,
    this.value,
    this.hours,
    this.minutes,
    this.tone = MetricTone.success,
    this.level = 50,
    this.badge,
    this.staleText,
    this.message,
  });

  final DeviceMetric metric;
  final MetricState state;
  final String? value;

  /// Uyku: saat ve dakika ayrı.
  final String? hours;
  final String? minutes;
  final MetricTone tone;

  /// 1–100, dikey göstergenin doluluğu.
  final int level;

  /// Rozet metni; null → tonun varsayılanı (Normal / Harika / Dikkat edin).
  final String? badge;
  final String? staleText;
  final String? message;
}

enum DeviceSectionState { normal, loading, deviceNotConnected, permissionMissing, error, offlineError }

class DeviceData {
  const DeviceData({required this.state, this.items = const []});

  final DeviceSectionState state;

  /// 6 metrik, 2 sütun. loading durumunda boş bırakılabilir.
  final List<DeviceMetricData> items;
}

extension DeviceMetricX on DeviceMetric {
  String get title => switch (this) {
        DeviceMetric.heartRate => 'Kalp atışı',
        DeviceMetric.steps => 'Adım',
        DeviceMetric.calories => 'Yakılan kalori',
        DeviceMetric.spo2 => 'SpO2',
        DeviceMetric.respiratoryRate => 'Solunum hızı',
        DeviceMetric.sleep => 'Uyku',
      };

  /// Kalori: kamp ateşi yerine Figma kalori alevi (03.11.2026 ürün kararı); 'Camping/campfire' anahtarı alevi çizer.
  String get icon => switch (this) {
        DeviceMetric.heartRate => 'Medical/heart care 2',
        DeviceMetric.steps => 'Sport/shoe',
        DeviceMetric.calories => 'Camping/campfire',
        DeviceMetric.spo2 => 'Medical/lungs',
        DeviceMetric.respiratoryRate => 'Weather/wind',
        DeviceMetric.sleep => 'Traveling/single bed',
      };

  String get unit => switch (this) {
        DeviceMetric.heartRate => 'bpm',
        DeviceMetric.steps => 'adım',
        DeviceMetric.calories => 'kcal',
        DeviceMetric.spo2 => '%',
        DeviceMetric.respiratoryRate => 'nefes / dk',
        DeviceMetric.sleep => 'sa',
      };
}
