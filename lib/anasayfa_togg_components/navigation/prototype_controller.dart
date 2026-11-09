import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/home_mapper.dart';
import '../data/home_state.dart';
import '../models/common.dart';
import '../models/device.dart';
import '../models/nutrition.dart';
import '../models/reminder.dart';
import '../models/stress.dart';
import '../models/sub_score.dart';
import '../utils/time_utils.dart';
import '../widgets/navigation_bar/home_bottom_nav.dart';
import '../widgets/reminder_sheets/reminder_action_sheet.dart';
import '../widgets/reminder_sheets/reminder_postpone_sheet.dart';
import 'prototype_states.dart';
import 'scenarios.dart';

/// Ekran geçiş türü (App anim: push, back, none).
enum ProtoAnim { push, back, none }

/// Modül dışı bir hedef veya “Tasarım yok” bildirimi (App `c.cross`, `c.note`).
class ProtoNotice {
  const ProtoNotice(this.title, this.detail);

  final String title;
  final String detail;
}

/// Ana Sayfa Togg prototip denetleyicisi (App.dc.html `Component` + davranış fonksiyonları:
/// go, back, retry, retryMetric, refresh, write, permission, openScore, openPremium,
/// hatırlatıcı ⋮ menüsü, Hızlı Aksiyonlar). Zamanlayıcılar ekran değişince iptal edilir.
class PrototypeController extends ChangeNotifier {
  PrototypeController({String start = '6738:105182', this.scenario = const PrototypeScenario(), this.onNotice}) {
    final s = kProtoScreenById[start] ?? kProtoScreens.first;
    _cur = s.id;
    _state = s.seed(const HomeState());
    scheduleMicrotask(_enter);
  }

  PrototypeScenario scenario;
  final ValueChanged<ProtoNotice>? onNotice;

  late String _cur;
  late HomeState _state;
  final List<(String, HomeState)> _history = [];
  final List<Timer> _timers = [];
  ProtoAnim _anim = ProtoAnim.none;
  int _n = 0;
  bool _disposed = false;

  String get currentId => _cur;
  ProtoScreen get current => kProtoScreenById[_cur]!;
  HomeState get state => _state;
  ProtoAnim get anim => _anim;

  /// Her gezinmede artar (geçiş animasyonu anahtarı).
  int get navCount => _n;
  bool get canGoBack => _history.isNotEmpty;

  // ── Çekirdek (App api) ──────────────────────────────────────────────────

  void go(String id, {HomeState Function(HomeState d)? patch, ProtoAnim anim = ProtoAnim.push}) {
    final s = kProtoScreenById[id];
    if (s == null) return;
    _clearTimers();
    _history.add((_cur, _state));
    if (_history.length > 40) _history.removeAt(0);
    HomeState next;
    if (s.isHome) {
      // reset: BASE + kayıtlar (taken, rdel, rtime) korunur
      next = s.seed(HomeState(taken: _state.taken, deleted: _state.deleted, rescheduled: _state.rescheduled));
    } else {
      next = _state.copyWith(toastTop: null, premiumSheet: false);
    }
    if (patch != null) next = patch(next);
    _cur = id;
    _state = next;
    _anim = anim;
    _n++;
    notifyListeners();
    _enter();
  }

  void back() {
    if (_history.isEmpty) return;
    _clearTimers();
    final (id, snap) = _history.removeLast();
    _cur = id;
    _state = snap.copyWith(
      taken: _state.taken,
      deleted: _state.deleted,
      rescheduled: _state.rescheduled,
      toastTop: null,
      premiumSheet: false,
    );
    _anim = ProtoAnim.back;
    _n++;
    notifyListeners();
  }

  void set(HomeState Function(HomeState d) fn) {
    _state = fn(_state);
    notifyListeners();
  }

  void after(Duration d, VoidCallback fn) {
    _timers.add(Timer(d, () {
      if (!_disposed) fn();
    }));
  }

  void cross(String module, String action) => onNotice?.call(ProtoNotice(module, action));

  void note(String text) => onNotice?.call(ProtoNotice('Not', text));

  void restart([String? id]) {
    _clearTimers();
    _history.clear();
    final s = kProtoScreenById[id ?? _cur] ?? kProtoScreens.first;
    _cur = s.id;
    _state = s.seed(const HomeState());
    _anim = ProtoAnim.none;
    _n++;
    notifyListeners();
    _enter();
  }

  void _enter() {
    if (_disposed) return;
    current.enter?.call(this);
  }

  void _clearTimers() {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
  }

  @override
  void dispose() {
    _disposed = true;
    _clearTimers();
    super.dispose();
  }

  // ── Davranışlar ─────────────────────────────────────────────────────────

  /// Kart bazlı tekrar deneme (B4 onaylandı, D-16). Çevrimdışında istek atılmaz (C1b).
  void retry(HomeCard card) {
    if (_state.offline) {
      go('6738:106649');
      return;
    }
    final prev = _state;
    final ok = scenario.retry == 'Başarılı';
    set((d) => cardLoading(d, card).copyWith(toastTop: null));
    after(const Duration(milliseconds: 1400), () {
      if (_cur == '6738:105326') {
        final rest = HomeCard.values.any((k) => k != card && _state.isCardError(k));
        if (!ok) {
          go('6738:106599', anim: ProtoAnim.none);
          return;
        }
        if (!rest) {
          go('6738:105374', anim: ProtoAnim.none);
          return;
        }
      }
      set((d) {
        var q = ok
            ? cardOk(d, card)
            : cardRestore(d, card, prev).copyWith(toastTop: const ToastData(ToastType.error, kRetryFailMessage), band: null);
        if (d.band?.type == ToastType.error && !q.allError) q = q.copyWith(band: null);
        return q;
      });
    });
  }

  void retryMetric(DeviceMetric m) {
    if (_state.offline) {
      go('6738:106649');
      return;
    }
    final ok = scenario.retry == 'Başarılı';
    set((d) => d.copyWith(metricOverrides: {...d.metricOverrides, m: MetricState.loading}));
    after(const Duration(milliseconds: 1400), () {
      set((d) {
        final ov = {...d.metricOverrides};
        if (ok) {
          ov[m] = MetricState.ready;
          return d.copyWith(metricOverrides: ov);
        }
        ov.remove(m);
        return d.copyWith(metricOverrides: ov, band: null, toastTop: const ToastData(ToastType.error, kRetryFailMessage));
      });
    });
  }

  /// Aşağı çekerek yenileme (D-18).
  void refresh() {
    if (_state.band?.type == ToastType.progress) return;
    if (_state.offline) {
      go(_state.isFree ? '6738:106525' : '6738:106700');
      return;
    }
    if (_state.anyError && !_state.isFree) {
      go('6738:105350');
      return;
    }
    go(_state.isFree ? '6738:106550' : '6738:105623');
  }

  /// Aldım / Atla kaydı. Çevrimdışında pasif (C3); istek sırasında kopma C3b.
  void write(int i, TakenKind kind) {
    if (_state.offline) return;
    if (scenario.record == 'Bağlantı koptu') {
      go('6738:106675');
      return;
    }
    set((d) => d.copyWith(taken: {...d.taken, i: kind}));
  }

  /// K-38: İzinleri yönet → işletim sisteminin izin ekranı; dönüşte izin verildiyse A1.
  void permission() {
    final ok = scenario.permission == 'İzin verildi';
    cross('Sistem · Sağlık verisi izinleri',
        'İzinleri yönet → işletim sisteminin sağlık verisi izin ekranı (Apple Sağlık / Health Connect). Dönüş: ${ok ? 'izin verildi → A1.' : 'izin verilmedi → izin durumu kalır.'}');
    after(const Duration(milliseconds: 1200), () {
      if (ok) {
        go('6738:105182');
        note('İzin ekranından dönüş: izin verildi → A1 (K-38)');
      } else {
        note('İzin ekranından dönüş: izin verilmedi; durum değişmedi (K-38)');
      }
    });
  }

  void connectDevice() => cross('06 · Cihaz bağlama', 'Cihaz bağla');

  void openScore(SubScoreKind k) => go(kScorePage[k]!);

  void openPremium(String from) => go('6738:106868', patch: (d) => d.copyWith(premiumBack: _cur));

  void closePremium() => go(_state.premiumBack ?? '6738:105737', anim: ProtoAnim.none);

  /// Premium’u şimdi keşfet → satın alma akışı sonucu.
  void explorePremium() {
    final r = scenario.purchase;
    note('Satın alma akışı (Ayarlar › Paket ve abonelikler, 5425:58553) — sonuç: $r');
    go(switch (r) {
      'Başarısız' => '6738:106311',
      'İptal' => '6738:105737',
      'Doğrulama hatası' => '6738:106575',
      _ => '6738:105762',
    });
  }

  // ── Üst ve alt bar ──────────────────────────────────────────────────────

  void openSettings() => cross('06 · Ayarlar', 'Ayarlar (5530:95039)');

  void openNotifications() => cross('07 · Bildirimler', 'Bildirimler (5530:96750)');

  void onTab(HomeTab t) {
    if (t == HomeTab.therus) cross('05 · Therus AI', 'Therus AI sekmesi');
    if (t == HomeTab.saglik) cross('04 · Sağlığım', 'Sağlığım sekmesi');
  }

  void onPlus() {
    if (_state.isFree) {
      openPremium('plus');
    } else {
      go(_state.offline ? '6738:106336' : '6738:106239');
    }
  }

  void closePanel() => go(
        _state.isFree ? '6738:105737' : (_state.offline ? '6738:105497' : '6738:106065'),
        anim: ProtoAnim.none,
      );

  void quickAction(String target) => cross('04 · Hızlı Aksiyonlar', target);

  // ── Kartlar ─────────────────────────────────────────────────────────────

  void stressDetails() => cross('Tasarım yok · Stres detay',
      'Figma 3.1 Stres Detay sayfasında (5565:160636) detay ekranı yok; yalnız Ana Sayfa keşif kareleri var');

  void nutritionDetails() =>
      _state.isFree ? openPremium('nutri') : cross('04 · Beslenme', 'Beslenme (5080:111818)');

  void addMeal() => cross('04 · Beslenme', 'Öğün ekle (6460:474)');

  void remindersSeeAll() => cross('04 · İlaçlarım', 'Tümünü gör (5080:101213)');

  void reminderCreate() => cross('04 · İlaçlarım', 'Hatırlatıcı oluştur');

  void devicesSeeAll() => cross('Tasarım yok · Cihaz verilerim',
      'Figma 4.3 sayfasında yalnız Sağlığım listesi (5092:10468) ve benchmark var; Cihaz verilerim detay ekranı yok');

  void deviceAction() {
    switch (_state.dev) {
      case DevKey.permissionMissing:
        permission();
      case DevKey.error:
      case DevKey.offlineError:
        retry(HomeCard.dev);
      default:
        connectDevice();
    }
  }

  void toggleReminders() => set((d) => d.copyWith(remExpanded: !d.remExpanded));

  void closeToastTop() => set((d) => d.copyWith(toastTop: null));

  void closeBand() => set((d) => d.copyWith(band: null));

  void closeToastBottom() => set((d) => d.copyWith(toastBottom: null));

  // ── Hatırlatıcı ⋮ menüsü (02.11.2026 · R1) ──────────────────────────────

  void openReminderMenu(ReminderItemData it) {
    final i = HomeMapper.indexOf(it);
    if (i < 0) return;
    final base = HomeMapper.reminderItems(const HomeState()).firstWhere((r) => r.id == it.id);
    if (base.state.name.startsWith('activity') && _state.taken[i] == null) {
      note('Tasarım yok · Aktivite hatırlatıcısı ⋮ menüsü: Figma Reminder/ActionSheet açıklaması “Aktivite menüsü tanımlı değil.” '
          'Menü açılmadı; seçenek uydurulmadı.');
      return;
    }
    set((d) => d.copyWith(remMenu: ReminderMenuState(i, ReminderSheetMode.menu), postponeSelection: null));
  }

  void closeReminderSheet() => set((d) => d.copyWith(remMenu: null, postponeSelection: null));

  void reminderMenuSelect(ReminderMenuOption k) {
    final m = _state.remMenu;
    if (m == null) return;
    final i = m.index;
    switch (k) {
      case ReminderMenuOption.confirm:
        closeReminderSheet();
        write(i, TakenKind.ok);
      case ReminderMenuOption.skip:
        closeReminderSheet();
        write(i, TakenKind.skip);
      case ReminderMenuOption.postpone:
        set((d) => d.copyWith(remMenu: ReminderMenuState(i, ReminderSheetMode.postpone), postponeSelection: null));
      case ReminderMenuOption.editRecord:
        set((d) => d.copyWith(remMenu: ReminderMenuState(i, ReminderSheetMode.record)));
      case ReminderMenuOption.delete:
        set((d) => d.copyWith(remMenu: ReminderMenuState(i, ReminderSheetMode.delete)));
      case ReminderMenuOption.edit:
        closeReminderSheet();
        cross('04 · İlaçlarım', 'Hatırlatıcıyı düzenle → ilaç kullanım bilgileri (04 · 5080:101717, düzenleme)');
    }
  }

  void selectPostpone(String option) => set((d) => d.copyWith(postponeSelection: option));

  void confirmPostpone() {
    final m = _state.remMenu;
    final sel = _state.postponeSelection;
    if (m == null || sel == null) return;
    final min = postponeMinutes(sel);
    if (min == null) {
      cross('Sistem · Saat seçici', 'Ertele › Saat seç: işletim sistemi saat seçicisi açılır (Reminder/PostponeSheet açıklaması); prototipte çizilmedi');
      return;
    }
    final planned = HomeMapper.plannedTime(_state, m.index);
    set((d) => d.copyWith(
          rescheduled: {...d.rescheduled, m.index: addMinutes(planned, min)},
          remMenu: null,
          postponeSelection: null,
        ));
  }

  void confirmDelete() {
    final m = _state.remMenu;
    if (m == null) return;
    set((d) => d.copyWith(deleted: {...d.deleted, m.index}, remMenu: null));
  }

  /// Aldım / Atla (yalnız saati gelen kayıtta).
  void reminderConfirm(ReminderItemData it) => _write(it, TakenKind.ok);

  void reminderSkip(ReminderItemData it) => _write(it, TakenKind.skip);

  void _write(ReminderItemData it, TakenKind k) {
    final i = HomeMapper.indexOf(it);
    if (i >= 0) write(i, k);
  }

  // ── Görünüm verileri ────────────────────────────────────────────────────

  StressData get stressData => HomeMapper.stress(_state);
  NutritionData get nutritionData => HomeMapper.nutrition(_state);
  ReminderData get reminderData => HomeMapper.reminders(_state);
  DeviceData get deviceData => HomeMapper.devices(_state);
}
