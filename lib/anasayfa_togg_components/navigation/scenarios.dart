/// Oynat panelindeki senaryo seçimleri (App `sc(c, key, default)`).
/// Akışların sonucunu belirler; varsayılanlar prototiptekilerle aynıdır.
class PrototypeScenario {
  const PrototypeScenario({
    this.opening = 'Veriler var',
    this.retry = 'Başarılı',
    this.refresh = 'Başarılı',
    this.reconnect = '7 sn sonra gelir',
    this.record = 'Başarılı',
    this.permission = 'İzin verilmedi',
    this.purchase = 'Başarılı',
  });

  /// A1 açılış sonucu (OPEN tablosu).
  final String opening;

  /// Kart “Tekrar dene”: Başarılı / Tekrar hata.
  final String retry;

  /// Aşağı çekerek yenileme: Başarılı / Başarısız.
  final String refresh;

  /// Bağlantı: 7 sn sonra gelir / Gelmez.
  final String reconnect;

  /// Aldım / Atla kaydı: Başarılı / Bağlantı koptu.
  final String record;

  /// İzin ekranından dönüş: İzin verilmedi / İzin verildi.
  final String permission;

  /// Premium satın alma: Başarılı / Başarısız / İptal / Doğrulama hatası.
  final String purchase;

  static const options = <String, List<String>>{
    'Açılış': [
      'Veriler var',
      'Cihaz bağlı değil',
      'Kısmi veri',
      'Henüz veri yok',
      'Yetersiz veri',
      'İzin yok',
      'Kart hatası',
      'Tüm kaynaklar hata',
      'Çevrimdışı (cache yok)',
      'Çevrimdışı (cache var)',
    ],
    'Tekrar dene': ['Başarılı', 'Tekrar hata'],
    'Yenileme': ['Başarılı', 'Başarısız'],
    'Bağlantı': ['7 sn sonra gelir', 'Gelmez'],
    'Kayıt': ['Başarılı', 'Bağlantı koptu'],
    'İzin': ['İzin verilmedi', 'İzin verildi'],
    'Satın alma': ['Başarılı', 'Başarısız', 'İptal', 'Doğrulama hatası'],
  };

  String valueOf(String group) => switch (group) {
        'Açılış' => opening,
        'Tekrar dene' => retry,
        'Yenileme' => refresh,
        'Bağlantı' => reconnect,
        'Kayıt' => record,
        'İzin' => permission,
        _ => purchase,
      };

  PrototypeScenario withValue(String group, String v) => PrototypeScenario(
        opening: group == 'Açılış' ? v : opening,
        retry: group == 'Tekrar dene' ? v : retry,
        refresh: group == 'Yenileme' ? v : refresh,
        reconnect: group == 'Bağlantı' ? v : reconnect,
        record: group == 'Kayıt' ? v : record,
        permission: group == 'İzin' ? v : permission,
        purchase: group == 'Satın alma' ? v : purchase,
      );
}
