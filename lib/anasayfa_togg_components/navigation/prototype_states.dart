import '../data/home_state.dart';
import '../models/common.dart';
import '../models/reminder.dart';
import '../models/stress.dart';
import '../models/sub_score.dart';
import 'prototype_controller.dart';

/// Prototipteki tek bir kare (App.dc.html `S[id]`): Figma kimliği, kod, başlık, akış,
/// tohum (seed) ve girişte çalışan zamanlayıcı.
class ProtoScreen {
  const ProtoScreen({
    required this.id,
    required this.code,
    required this.title,
    required this.flow,
    this.seed = _none,
    this.enter,
    this.scoreTarget,
  });

  final String id;
  final String code;
  final String title;

  /// Akış board'u (F1…F9).
  final ProtoFlow flow;
  final HomeState Function(HomeState base) seed;
  final void Function(PrototypeController c)? enter;

  /// Skor sayfası hedefi (03 · Skor modülü); null → Ana Sayfa.
  final SubScoreKind? scoreTarget;

  bool get isHome => scoreTarget == null;

  static HomeState _none(HomeState b) => b;
}

/// Kanvastaki akış board'ları (F1–F9).
enum ProtoFlow {
  f1('AKIŞ 1 · Açılış ve veri durumları'),
  f2('AKIŞ 2 · Kart hatası ve tekrar deneme'),
  f3('AKIŞ 3 · Çevrimdışı ve bağlantının geri gelmesi'),
  f4('AKIŞ 4 · Pull-to-refresh ve güncelleme'),
  f5('AKIŞ 5 · Free / Premium erişimi'),
  f6('AKIŞ 6 · Gün değişimi'),
  f7('AKIŞ 7 · Kart → detay → geri'),
  f8('AKIŞ 8 · Üst bar, alt bar ve Hızlı Aksiyonlar'),
  f9('AKIŞ 9 · Temel Ana Sayfa kareleri (ANA SAYFA V1.2)');

  const ProtoFlow(this.title);
  final String title;
}

// ── Ortak tohumlar (App FREE, CACHE_OFF, LOADING, ERRORS, OFF_NOCACHE) ─────

HomeState _free(HomeState b) =>
    b.copyWith(plan: PlanType.free, mood: StressMood.stresli, nutri: NutriKey.locked, rem: ReminderCardState.locked);

HomeState _cacheOff(HomeState b) => b.copyWith(
      offline: true,
      stress: StressState.stale,
      mood: StressMood.sakin,
      band: const ToastData(ToastType.warning,
          'İnternet bağlantısı yok. Veriler en son 11 Ekim, 21:40’ta güncellendi. Kayıt işlemleri yapılamıyor.'),
    );

HomeState _loading(HomeState b) => b.copyWith(
      today: SubScoreState.loading,
      stress: StressState.loading,
      nutri: NutriKey.loading,
      rem: ReminderCardState.loading,
      dev: DevKey.loading,
    );

HomeState _errors(HomeState b) => b.copyWith(
      today: SubScoreState.error,
      stress: StressState.error,
      nutri: NutriKey.error,
      rem: ReminderCardState.loadError,
      dev: DevKey.error,
    );

HomeState _offNoCache(HomeState b) => b.copyWith(
      offline: true,
      today: SubScoreState.offline,
      stress: StressState.offline,
      nutri: NutriKey.offlineError,
      rem: ReminderCardState.offlineError,
      dev: DevKey.offlineError,
      band: const ToastData(ToastType.warning, 'İnternet bağlantısı yok. Yeni veriler yüklenemiyor ve kayıt işlemleri yapılamıyor.'),
    );

const kRetryFailMessage = 'Veriler şu anda alınamıyor. Lütfen daha sonra tekrar deneyin.';

/// A1 açılış sonucu → kare (App OPEN).
const kOpening = <String, String>{
  'Veriler var': '6738:105206',
  'Cihaz bağlı değil': '6738:105230',
  'Kısmi veri': '6738:105254',
  'Henüz veri yok': '6738:106411',
  'Yetersiz veri': '6738:106434',
  'İzin yok': '6738:106387',
  'Kart hatası': '6738:105326',
  'Tüm kaynaklar hata': '6738:106624',
  'Çevrimdışı (cache yok)': '6738:105447',
  'Çevrimdışı (cache var)': '6738:105472',
};

void Function(PrototypeController) _after(int ms, String? Function(PrototypeController c) to) =>
    (c) => c.after(Duration(milliseconds: ms), () {
          final t = to(c);
          if (t != null) c.go(t, anim: ProtoAnim.none);
        });

/// Bağlantının geri gelmesi (C4) simülasyonu.
void Function(PrototypeController) _reconnect(String to) =>
    _after(7000, (c) => c.scenario.reconnect == 'Gelmez' ? null : to);

/// Ana Sayfa Togg prototipinin tüm kareleri (App.dc.html `S`, sırasıyla).
final List<ProtoScreen> kProtoScreens = [
  // A · Açılış
  ProtoScreen(id: '6738:105182', code: 'A1', title: 'Initial Loading', flow: ProtoFlow.f1, seed: _loading,
      enter: _after(1400, (c) => kOpening[c.scenario.opening] ?? '6738:105206')),
  const ProtoScreen(id: '6738:105206', code: 'A2', title: 'Veriler var', flow: ProtoFlow.f1),
  ProtoScreen(id: '6738:105230', code: 'A3', title: 'Cihaz bağlı değil', flow: ProtoFlow.f1,
      seed: (b) => b.copyWith(today: SubScoreState.noDevice, stress: StressState.noDevice, nutri: NutriKey.noTarget, rem: ReminderCardState.empty, dev: DevKey.deviceNotConnected)),
  ProtoScreen(id: '6738:105254', code: 'A4', title: 'Kısmi veri', flow: ProtoFlow.f1,
      seed: (b) => b.copyWith(today: SubScoreState.partial, stress: StressState.insufficient, nutri: NutriKey.partial, dev: DevKey.partialData)),
  ProtoScreen(id: '6738:106411', code: 'A5', title: 'Cihaz bağlı — Henüz veri yok', flow: ProtoFlow.f1,
      seed: (b) => b.copyWith(today: SubScoreState.noData, stress: StressState.firstWait, nutri: NutriKey.empty, dev: DevKey.noData)),
  ProtoScreen(id: '6738:106434', code: 'A6', title: 'Yetersiz veri', flow: ProtoFlow.f1,
      seed: (b) => b.copyWith(today: SubScoreState.insufficient, stress: StressState.insufficient, nutri: NutriKey.partial)),
  ProtoScreen(id: '6738:106387', code: 'A7', title: 'İzin yok', flow: ProtoFlow.f1,
      seed: (b) => b.copyWith(today: SubScoreState.permission, stress: StressState.permission, nutri: NutriKey.noTarget, rem: ReminderCardState.empty, dev: DevKey.permissionMissing)),

  // B · Kart hatası ve tekrar deneme
  const ProtoScreen(id: '6738:105326', code: 'B1', title: 'Kart bazlı hata', flow: ProtoFlow.f2, seed: _errors),
  ProtoScreen(id: '6738:105350', code: 'B2', title: 'Retry → kart Loading', flow: ProtoFlow.f2, seed: _loading,
      enter: _after(1400, (c) => c.scenario.retry == 'Tekrar hata' ? '6738:106599' : '6738:105374')),
  const ProtoScreen(id: '6738:105374', code: 'B3', title: 'Retry başarılı', flow: ProtoFlow.f2),
  ProtoScreen(id: '6738:106624', code: 'B4', title: 'Tüm kaynaklar hata (onaylandı)', flow: ProtoFlow.f2,
      seed: (b) => _errors(b).copyWith(band: const ToastData(ToastType.error, 'Veriler yüklenemedi. Yenilemek için ekranı aşağı kaydırın veya kartlardan tekrar deneyin.'))),
  ProtoScreen(id: '6738:106599', code: 'B5', title: 'Retry tekrar başarısız', flow: ProtoFlow.f2,
      seed: (b) => _errors(b).copyWith(toastTop: const ToastData(ToastType.error, kRetryFailMessage))),

  // C · Çevrimdışı
  ProtoScreen(id: '6738:105447', code: 'C1', title: 'Offline, cache yok', flow: ProtoFlow.f3, seed: _offNoCache, enter: _reconnect('6738:105182')),
  ProtoScreen(id: '6738:106649', code: 'C1b', title: 'Offline iken Tekrar dene', flow: ProtoFlow.f3, seed: _offNoCache, enter: _reconnect('6738:105182')),
  ProtoScreen(id: '6738:105472', code: 'C2', title: 'Offline, cache var (eski veri)', flow: ProtoFlow.f3, seed: _cacheOff, enter: _reconnect('6738:105522')),
  ProtoScreen(id: '6738:105497', code: 'C3', title: 'Offline iken yazma denemesi', flow: ProtoFlow.f3,
      seed: (b) => b.copyWith(offline: true, band: const ToastData(ToastType.warning, 'İnternet bağlantısı yok. Veriler en son 11:30’da güncellendi. Kayıt işlemleri yapılamıyor.')),
      enter: _reconnect('6738:105522')),
  ProtoScreen(id: '6738:106675', code: 'C3b', title: 'Kayıt sırasında bağlantı koptu', flow: ProtoFlow.f3,
      seed: (b) => b.copyWith(toastTop: const ToastData(ToastType.error, 'Kayıt yapılamadı. İnternet bağlantınızı kontrol edin.'))),
  ProtoScreen(id: '6738:105522', code: 'C4', title: 'Bağlantı geri geldi', flow: ProtoFlow.f3,
      seed: (b) => b.copyWith(band: const ToastData(ToastType.progress, 'Bağlantı geri geldi. Veriler güncelleniyor.')),
      enter: _after(1800, (c) => '6738:105206')),

  // D · Pull-to-refresh
  const ProtoScreen(id: '6738:105599', code: 'D1', title: 'Veriler var (en üstte)', flow: ProtoFlow.f4),
  ProtoScreen(id: '6738:105623', code: 'D2', title: 'Yenileniyor (Updating)', flow: ProtoFlow.f4,
      seed: (b) => b.copyWith(band: const ToastData(ToastType.progress, 'Güncelleniyor…')),
      enter: _after(1600, (c) => c.scenario.refresh == 'Başarısız' ? '6738:105672' : '6738:105648')),
  ProtoScreen(id: '6738:105648', code: 'D3', title: 'Güncellendi', flow: ProtoFlow.f4, seed: (b) => b.copyWith(mood: StressMood.dengeli)),
  ProtoScreen(id: '6738:105672', code: 'D4', title: 'Yenileme başarısız', flow: ProtoFlow.f4,
      seed: (b) => b.copyWith(toastTop: const ToastData(ToastType.error, 'Yenileme başarısız. Tekrar denemek için aşağı çekin.'))),
  ProtoScreen(id: '6738:106700', code: 'D5', title: 'Offline iken yenileme', flow: ProtoFlow.f4, seed: _cacheOff, enter: _reconnect('6738:105522')),

  // E · Free / Premium
  const ProtoScreen(id: '6738:105737', code: 'E1', title: 'Free (kilitli)', flow: ProtoFlow.f5, seed: _free),
  ProtoScreen(id: '6738:106868', code: 'E2', title: 'Premium Bottom Sheet', flow: ProtoFlow.f5, seed: (b) => _free(b).copyWith(premiumSheet: true)),
  const ProtoScreen(id: '6738:105762', code: 'E3', title: 'Premium (veriler korunur)', flow: ProtoFlow.f5),
  const ProtoScreen(id: '6738:105786', code: 'E4', title: 'Premium sona erdi → Free', flow: ProtoFlow.f5, seed: _free),
  ProtoScreen(id: '6738:106311', code: 'E5', title: 'Satın alma iptal / başarısız', flow: ProtoFlow.f5,
      seed: (b) => _free(b).copyWith(toastTop: const ToastData(ToastType.error, 'Satın alma tamamlanamadı. Planınız değişmedi.'))),
  ProtoScreen(id: '6738:106731', code: 'E6', title: 'Free · Initial loading', flow: ProtoFlow.f5,
      seed: (b) => _free(b).copyWith(today: SubScoreState.loading, stress: StressState.loading, dev: DevKey.loading),
      enter: _after(1300, (c) => '6738:106755')),
  ProtoScreen(id: '6738:106755', code: 'E7', title: 'Free · Kısmi yükleme', flow: ProtoFlow.f5,
      seed: (b) => _free(b).copyWith(stress: StressState.loading, dev: DevKey.loading),
      enter: _after(1300, (c) => c.scenario.opening == 'Kart hatası' ? '6738:106779' : '6738:105737')),
  ProtoScreen(id: '6738:106779', code: 'E8', title: 'Free · Kart hatası', flow: ProtoFlow.f5,
      seed: (b) => _free(b).copyWith(today: SubScoreState.error, stress: StressState.error, dev: DevKey.error)),
  ProtoScreen(id: '6738:106525', code: 'E9', title: 'Free · Offline, cache var', flow: ProtoFlow.f5, seed: (b) => _cacheOff(_free(b))),
  ProtoScreen(id: '6738:106550', code: 'E10', title: 'Free · Yenileniyor', flow: ProtoFlow.f5,
      seed: (b) => _free(b).copyWith(mood: StressMood.rahatlamis, band: const ToastData(ToastType.progress, 'Güncelleniyor…')),
      enter: _after(1600, (c) => '6738:105737')),
  ProtoScreen(id: '6738:106575', code: 'E11', title: 'Entitlement doğrulanamadı (ÖNERİ)', flow: ProtoFlow.f5,
      seed: (b) => b.copyWith(plan: PlanType.free, nutri: NutriKey.entError, rem: ReminderCardState.entError)),

  // F · Gün değişimi
  ProtoScreen(id: '6738:105861', code: 'F1', title: '23:58 (dünün verisi)', flow: ProtoFlow.f6, enter: _after(4000, (c) => '6738:105885')),
  ProtoScreen(id: '6738:105885', code: 'F2', title: '00:00 (gün değişti, yenileniyor)', flow: ProtoFlow.f6, seed: _loading,
      enter: _after(1600, (c) => '6738:105909')),
  ProtoScreen(id: '6738:105909', code: 'F3', title: 'Yeni gün', flow: ProtoFlow.f6,
      seed: (b) => b.copyWith(today: SubScoreState.insufficient, stress: StressState.todayNone, nutri: NutriKey.zero, rem: ReminderCardState.noneToday, devItemsF3: true)),

  // G · Navigasyon
  const ProtoScreen(id: '6738:105968', code: 'G1-0', title: 'Ana sayfa', flow: ProtoFlow.f7),
  const ProtoScreen(id: '4711:88881', code: 'G1 → Aktivite', title: 'Hedef · Aktivite skorum (03 · Skor)', flow: ProtoFlow.f7, scoreTarget: SubScoreKind.activity),
  const ProtoScreen(id: '4711:87555', code: 'G1 → Uyku', title: 'Hedef · Uyku skorum (03 · Skor)', flow: ProtoFlow.f7, scoreTarget: SubScoreKind.sleep),
  const ProtoScreen(id: '4711:89318', code: 'G1 → Toparlanma', title: 'Hedef · Toparlanma skorum (03 · Skor)', flow: ProtoFlow.f7, scoreTarget: SubScoreKind.recovery),
  ProtoScreen(id: '6738:106065', code: 'G2-0', title: 'Ana sayfa (bildirim rozeti)', flow: ProtoFlow.f8, seed: (b) => b.copyWith(badge: 3)),
  ProtoScreen(id: '6738:106239', code: 'G2-4', title: 'Hızlı Aksiyonlar paneli açık', flow: ProtoFlow.f8, seed: (b) => b.copyWith(panel: true)),
  ProtoScreen(id: '6738:106336', code: 'G2-5', title: 'Hızlı Aksiyonlar paneli, offline (onaylandı)', flow: ProtoFlow.f8,
      seed: (b) => b.copyWith(panel: true, offline: true, band: const ToastData(ToastType.warning, 'İnternet bağlantısı yok. Kayıt işlemleri yapılamıyor.'))),

  // Temel kareler (ANA SAYFA V1.2, 4711:81486)
  ProtoScreen(id: '4711:81488', code: 'Ana sayfa -1', title: 'Temel kare', flow: ProtoFlow.f9, seed: (b) => b.copyWith(compactHeader: true)),
  ProtoScreen(id: '4711:82115', code: 'Ana sayfa -2', title: 'Veri yok', flow: ProtoFlow.f9,
      seed: (b) => b.copyWith(compactHeader: true, plan: PlanType.free, today: SubScoreState.noDevice, stress: StressState.noDevice, nutri: NutriKey.empty, rem: ReminderCardState.emptyToday, dev: DevKey.noData)),
  ProtoScreen(id: '4711:81653', code: 'Ana sayfa -3', title: 'Free', flow: ProtoFlow.f9, seed: (b) => _free(b).copyWith(compactHeader: true)),
  ProtoScreen(id: '6449:7628', code: 'Ana sayfa -5', title: 'Free (812)', flow: ProtoFlow.f9, seed: (b) => _free(b).copyWith(compactHeader: true)),
  ProtoScreen(id: '6452:9461', code: 'Ana sayfa -7', title: 'Hızlı Aksiyonlar', flow: ProtoFlow.f9,
      seed: (b) => _free(b).copyWith(compactHeader: true, panel: true)),
];

final Map<String, ProtoScreen> kProtoScreenById = {for (final s in kProtoScreens) s.id: s};

/// Skor sayfaları (App SCORE_PAGE).
const kScorePage = <SubScoreKind, String>{
  SubScoreKind.activity: '4711:88881',
  SubScoreKind.sleep: '4711:87555',
  SubScoreKind.recovery: '4711:89318',
};

/// Kart bazlı başarı durumu (App CARD_OK).
HomeState cardOk(HomeState d, HomeCard card) => switch (card) {
      HomeCard.today => d.copyWith(today: SubScoreState.data),
      HomeCard.stress => d.copyWith(stress: StressState.data),
      HomeCard.nutri => d.copyWith(nutri: d.isFree ? NutriKey.locked : NutriKey.normal),
      HomeCard.rem => d.copyWith(rem: d.isFree ? ReminderCardState.locked : ReminderCardState.collapsed),
      HomeCard.dev => d.copyWith(dev: DevKey.normal),
    };

/// Kartı yükleniyor durumuna alır.
HomeState cardLoading(HomeState d, HomeCard card) => switch (card) {
      HomeCard.today => d.copyWith(today: SubScoreState.loading),
      HomeCard.stress => d.copyWith(stress: StressState.loading),
      HomeCard.nutri => d.copyWith(nutri: NutriKey.loading),
      HomeCard.rem => d.copyWith(rem: ReminderCardState.loading),
      HomeCard.dev => d.copyWith(dev: DevKey.loading),
    };

/// Kartın önceki durumunu geri yükler.
HomeState cardRestore(HomeState d, HomeCard card, HomeState prev) => switch (card) {
      HomeCard.today => d.copyWith(today: prev.today),
      HomeCard.stress => d.copyWith(stress: prev.stress),
      HomeCard.nutri => d.copyWith(nutri: prev.nutri),
      HomeCard.rem => d.copyWith(rem: prev.rem),
      HomeCard.dev => d.copyWith(dev: prev.dev),
    };
