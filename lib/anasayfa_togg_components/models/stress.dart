/// Stres Monitörü veri modelleri. Bileşenler veri üretmez (R-04);
/// değerler dışarıdan gelir.
library;

enum StressMood { rahatlamis, sakin, dengeli, stresli, cokStresli }

extension StressMoodX on StressMood {
  String get label => switch (this) {
        StressMood.rahatlamis => 'Rahatlamış',
        StressMood.sakin => 'Sakin',
        StressMood.dengeli => 'Dengeli',
        StressMood.stresli => 'Stresli',
        StressMood.cokStresli => 'Çok stresli',
      };
}

enum StressState { data, stale, insufficient, loading, todayNone, noDevice, permission, firstWait, error, offline }

class StressData {
  const StressData({
    required this.state,
    this.mood = StressMood.dengeli,
    this.max,
    this.avg,
    this.min,
    this.updatedText,
    this.staleWarning,
  });

  final StressState state;
  final StressMood mood;

  /// En yüksek / Ortalama / En düşük. null → “—”.
  final int? max;
  final int? avg;
  final int? min;

  /// “Son güncelleme: 11:30” gibi; null ise satır gösterilmez.
  final String? updatedText;

  /// stale durumunda uyarı metni (“Son veri 2 gün önce alındı. …”).
  final String? staleWarning;
}
