/// Alt skor kartları veri modelleri. Bileşenler veri üretmez (R-04);
/// değerler dışarıdan gelir.
library;

enum SubScoreKind { activity, sleep, recovery }

extension SubScoreKindX on SubScoreKind {
  String get title => switch (this) {
        SubScoreKind.activity => 'Aktivite',
        SubScoreKind.sleep => 'Uyku',
        SubScoreKind.recovery => 'Toparlanma',
      };
}

/// Prototipteki kaynak durumları (state haritası S, `c.d.today`).
enum SubScoreState {
  /// Veri var (A2, E1)
  data,

  /// Güncel değil (C2): son skor + başlıkta “Güncel değil · <tarih>”
  stale,

  /// Yükleniyor (A1, B2)
  loading,

  /// Kısmi veri (A4): yalnız Uyku eksik. Ürün onayı bekliyor (TG-11).
  partial,

  /// Yetersiz veri (A6, F3)
  insufficient,

  /// Henüz veri yok (A5)
  noData,

  /// Cihaz bağlı değil (A3)
  noDevice,

  /// Hata (B1)
  error,

  /// İnternet yok, önbellek yok (C1)
  offline,

  /// Sağlık verisi izni yok (A7)
  permission,
}

class SubScores {
  const SubScores({this.activity, this.sleep, this.recovery});

  final int? activity;
  final int? sleep;
  final int? recovery;

  int? of(SubScoreKind k) => switch (k) {
        SubScoreKind.activity => activity,
        SubScoreKind.sleep => sleep,
        SubScoreKind.recovery => recovery,
      };
}
