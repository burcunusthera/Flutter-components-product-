# Flutter-components-product-

NusThera ürün bileşenlerinin Flutter uygulaması.

## Anasayfa Togg Components

“02 — Ana Sayfa Togg” tasarımının Flutter'a aktarımı ve bileşen galerisi. Bu bir yeniden tasarım değil; mevcut tasarımın birebir uygulamasıdır.

- **Kaynak:** Claude Design yapıtı “02 — Ana Sayfa Togg” (sürüm `1794038488-dc06`), NustheraDS v1.4.12.
- **Ölçü ve renk:** Tarayıcıda 375 px'te ölçülen değerlerden ve DS kaynak kodundan alındı.
- **Varlıklar:** DS'teki dosyaların kendisi: 48 ikon (SVG), R06 Kompakt Lottie animasyonları, kart dekoru, hatırlatıcı görselleri, Premium görseli ve Outfit yazı tipi.
- **Kapsam:** Prototipin 49 karesi, tüm akışları (A–G), bileşenleri ve bileşen durumları.

> **Doğrulama durumu:** Bu kod Flutter SDK'nın indirilemediği bir ortamda yazıldı (storage.googleapis.com ve pub.dev erişime kapalıydı).
>
> - `flutter pub get`, `dart format`, `flutter analyze`, `flutter test` ve derleme **çalıştırılmadı**.
> - Yapılan kontroller: 95 Dart dosyasında Dart 3 dilbilgisiyle sözdizimi taraması (hatasız), import yollarının ve proje içi sembollerin çözümlenmesi (eksik yok), SVG dosyalarının XML geçerliliği, varlık yollarının `pubspec.yaml` ile eşleşmesi.
> - Tip hataları ancak SDK'lı bir makinede görülebilir. İlk iş aşağıdaki komutları çalıştırıp çıkan hataları düzeltmek olmalı.

## Kurulum ve çalıştırma

Gereken: Flutter 3.19 veya üstü (Dart 3.3+).

```bash
git checkout feature/anasayfa-togg-components

# Android ve iOS platform klasörlerini oluşturur. Mevcut dosyaların üzerine yazmaz;
# test/widget_test.dart zaten var, bu yüzden varsayılan test oluşturulmaz.
flutter create . --platforms=android,ios --org com.nusthera --project-name flutter_components_product

flutter pub get
dart format .
flutter analyze
flutter test
flutter run            # bağlı cihaz veya simülatörde galeri açılır
```

## Galeri: “Anasayfa Togg Components”

Uygulama galeriyle açılır. Galeride dört bölüm var:

| Bölüm | İçerik |
| --- | --- |
| **Prototip** | A1 açılıştan başlayan oynatılabilir Ana Sayfa. Kartlar, ⋮ menüleri, Premium, Hızlı Aksiyonlar, aşağı çekerek yenileme ve skor sayfalarına gidiş çalışır. |
| **Ekran durumları** | Prototipin 49 karesi, 9 akışa göre gruplu (F1–F9). Her kare kendi zamanlayıcı ve geçişleriyle oynatılır. |
| **Bileşenler** | 34 bileşen kaydı, her biri tüm durumlarıyla (ör. alt skor kartı 10 durum, hatırlatıcı öğesi 18 durum). Dokunulabilir elemanlar SnackBar ile ne yaptığını söyler. |
| **Kapsam dışı** | Aktarılmayan board'lar ve nedenleri. |

Oynatıcının üst çubuğunda üç kontrol var:

- **Senaryo:** Akışların sonucunu seçer. Seçenekler: açılış sonucu, tekrar dene başarılı/hatalı, yenileme, bağlantının geri gelmesi, kayıt, izin, satın alma.
- **Yeniden başlat**
- **Kareye git**

Başka modüllere giden eylemler bildirim olarak gösterilir. Örnekler: Ayarlar, Bildirimler, 04 · İlaçlarım ve tasarımı olmayan hedefler (“Tasarım yok”). Prototipte de böyle davranıyorlar.

## Klasör yapısı

```
lib/
├── main.dart                               # runApp(AnasayfaToggGalleryApp)
└── anasayfa_togg_components/
    ├── anasayfa_togg_components.dart       # tek export dosyası
    ├── theme/        nds_colors · nds_shadows · nds_text (Outfit) · nds_icons (ikon tablosu)
    ├── models/       sub_score · stress · nutrition · reminder · device · common
    ├── data/         mock_data (ÖRNEK veri) · home_state (prototip durumu) · home_mapper
    ├── navigation/   prototype_states (49 kare) · prototype_controller (akışlar) · scenarios
    ├── screens/      ana_sayfa_togg_screen · prototype_home_screen · score_target_screen
    │   └── gallery/  gallery_home · prototype_player_page · component_preview_page · catalog_*
    ├── utils/        pull_to_refresh · time_utils
    └── widgets/
        ├── common/          NdsIcon, R06, Pressable, GlassSurface, NdsButton, NdsOutlineButton,
        │                    CardHeader, CategoryIcon, ActionLink, PremiumChip, PremiumLock,
        │                    NdsPager, NdsSkel, TileSelection, NdsInput, NdsHomeIndicator, EnterAnimation
        ├── top_bar/         HomeTopBar, HeaderGlassButton
        ├── sub_score/       SubScoreCarousel, SubScoreCard, OverallScoreGauge, GlassActionButton,
        │                    TodayBackground, TodayDeco
        ├── stress/          StressMonitorCard, StressFaces, StressTag, StressStats, StressSkeleton
        ├── nutrition/       NutritionCard, MacroMetric, MacroRing
        ├── reminder/        ReminderCard, ReminderItem, ReminderThumbnail, ReminderStatusMark,
        │                    ReminderActionButton, ReminderStartButton, ExpandToggle, ReminderItemSkeleton
        ├── reminder_sheets/ SheetFrame, ActionOption, ReminderActionSheet, ReminderPostponeSheet,
        │                    ReminderEditRecordSheet, ConfirmBottomSheet
        ├── device/          DeviceDataSection, DeviceMetricCard, MetricStatusBadge, VerticalMetricIndicator
        ├── navigation_bar/  HomeBottomNav, QuickActionsPanel
        ├── feedback/        NdsToast, NdsSpinner
        └── premium/         PremiumSheet

assets/anasayfa_togg_components/
├── icons/        48 DS ikonu (SVG, currentColor)
├── animations/   16 R06 Kompakt Lottie
├── images/       premium_art.png · deco/ · reminders/ · score_targets/ (03 · Skor görüntüleri)
└── fonts/        Outfit-wght.ttf

test/
├── widget_test.dart
└── anasayfa_togg_components/   prototype_controller · sub_score_carousel · gallery · time_utils
```

## Veri

- **Örnek veri:** `data/mock_data.dart` içindeki tüm sayılar prototipteki gösterim değerleridir: skorlar 40/73/93, stres değerleri, makrolar, hatırlatıcılar ve cihaz metrikleri.
- **Hesaplama yok:** Skor formülü veya tıbbi hesap yoktur.
- **Bileşenler veri üretmez:** Değerler dışarıdan gelir; veri yokken Loading / Empty / Error durumları kullanılır.

## Bilinen farklar ve sınırlar

1. **Platform klasörleri:** `android/` ve `ios/` repoda yok. SDK olmadan üretilemedi; yukarıdaki `flutter create .` komutu oluşturur.
2. **R06 animasyonları:** Prototip R06'yı DS çalışma zamanıyla çizer (`paletteSet: tag`, avatarda rozet yok). Burada DS'in dışa aktardığı Lottie dosyaları kullanıldı; renk, gölge ve taç ayrıntıları farklı olabilir. Ruh hali yüzlerindeki drop-shadow, Lottie'nin bulanık kopyalarıyla taklit edildi.
3. **03 · Skor sayfaları:** Ayrı bir modül. Prototipte olduğu gibi kodlanmış ekran görüntüsü ve Geri ile gösterilir (`ScoreTargetScreen`).
4. **Aşağı çekerek yenileme:** Prototipteki gibi görsel gösterge yok. Sayfa en üstteyken 64 px çekip bırakmak yenilemeyi başlatır; sonuç üstteki “Güncelleniyor…” toast'ıdır.
5. **Geniş ekran:** Tasarım 375 px'tir. Geniş ekranda kartlar genişler; skor göstergesi 295 px'te sabit kalır ve ortalanır (tasarımda sola yaslı, 375'te fark yok). Tablet düzeni tasarımda yok.
6. **Durum çubuğu ve ana gösterge:** Galeri çerçevesinde tasarımdaki gibi 58 ve 34 px çizilir. Gerçek uygulamada (`designFrame: false`) cihazın güvenli alanları kullanılır.
7. **Bekleyen ürün kararları:** Kart başlığı (TG-10, NUSTH-157), kısmi veri durumu (TG-11), maskot (TG-13) ve veri yokken karta dokunma (TG-14). Bu kararlar therus-design reposundaki `PROJECT_STATUS.md` dosyasında takip ediliyor.
