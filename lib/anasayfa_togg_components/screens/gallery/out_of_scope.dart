/// Kanvastaki board'lardan bu Flutter aktarımına alınmayanlar ve nedenleri.
/// Galeride “Kapsam dışı” bölümünde listelenir.
const kOutOfScope = <(String, String)>[
  ('Main.dc.html · GENEL BAKIŞ / DURUM', 'Belgeleme board’u (durum tablosu). İçeriği bu galeri ve README karşılar.'),
  ('Oynat.dc.html · OYNAT · tüm akışlar', 'Kanvas oynatıcısı. Flutter karşılığı: galerideki “Prototip” ve “Ekran durumları” bölümleri.'),
  ('F1–F9 · Akış board’ları', 'Akışların açıklama board’ları. Her akışın kareleri galeride aynı adla listelenir ve oynatılabilir. Board açıklama metinleri hala eski Bugün kartını anlatıyor (TG-21).'),
  ('Arsiv.dc.html · BAĞLANTI HEDEFLERİ', 'Diğer modüllerin (Ayarlar, Bildirimler, Beslenme, İlaçlarım…) Figma görüntüleri. Ana Sayfa Togg bileşeni değildir; prototipte olduğu gibi “Modül dışı hedef” bildirimi gösterilir.'),
  ('R0–R4, B1–B4, OynatR06, AppR06', 'R06 maskot önerileri (02 Ana Sayfa’dan taşındı). Togg’da olmayan Bugün kartı üzerinde; benimsenmiş ürün UI’ı değil.'),
  ('Deneme, DenemeR2, AppDeneme', 'İkincil ikon / rozet denemeleri; benimsenmiş ürün UI’ı değil.'),
  ('img/coded/ (45 görüntü)', '02’nin eski Bugün kartını gösteren durağan görüntüler (TG-22). Kullanılmadı; ekranlar canlı Flutter bileşenleriyle çizilir.'),
  ('03 · Skor sayfaları', 'Ayrı modül. Prototip gibi kodlanmış ekran görüntüsü + Geri olarak gösterilir (ScoreTargetScreen).'),
];
