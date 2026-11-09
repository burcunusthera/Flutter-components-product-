import 'package:fake_async/fake_async.dart';
import 'package:flutter_components_product/anasayfa_togg_components/anasayfa_togg_components.dart';
import 'package:flutter_test/flutter_test.dart';

// Prototip akışları (App.dc.html davranışları) için birim testleri.

void main() {
  test('Kare kimlikleri tekil ve tüm akışlarda kare var', () {
    final ids = kProtoScreens.map((s) => s.id).toSet();
    expect(ids.length, kProtoScreens.length);
    for (final f in ProtoFlow.values) {
      expect(kProtoScreens.where((s) => s.flow == f), isNotEmpty, reason: f.title);
    }
  });

  test('A1 → 1.4 sn sonra A2 (varsayılan açılış)', () {
    fakeAsync((fa) {
      final c = PrototypeController();
      fa.flushMicrotasks();
      expect(c.current.code, 'A1');
      fa.elapse(const Duration(milliseconds: 1400));
      expect(c.current.code, 'A2');
      c.dispose();
    });
  });

  test('B1 kart tekrar dene: başarılı ama diğer kartlar hatalı → kart veriye döner', () {
    fakeAsync((fa) {
      final c = PrototypeController(start: '6738:105326');
      fa.flushMicrotasks();
      c.retry(HomeCard.today);
      expect(c.state.today, SubScoreState.loading);
      fa.elapse(const Duration(milliseconds: 1400));
      expect(c.current.code, 'B1');
      expect(c.state.today, SubScoreState.data);
      expect(c.state.stress, StressState.error);
      c.dispose();
    });
  });

  test('B1 tekrar dene, senaryo “Tekrar hata” → B5', () {
    fakeAsync((fa) {
      final c = PrototypeController(start: '6738:105326', scenario: const PrototypeScenario(retry: 'Tekrar hata'));
      fa.flushMicrotasks();
      c.retry(HomeCard.stress);
      fa.elapse(const Duration(milliseconds: 1400));
      expect(c.current.code, 'B5');
      expect(c.state.toastTop?.text, kRetryFailMessage);
      c.dispose();
    });
  });

  test('Çevrimdışında tekrar dene → C1b (istek atılmaz)', () {
    fakeAsync((fa) {
      final c = PrototypeController(start: '6738:105447');
      fa.flushMicrotasks();
      c.retry(HomeCard.today);
      expect(c.current.code, 'C1b');
      c.dispose();
    });
  });

  test('Yenileme: D2 → D3; Free → E10 → E1', () {
    fakeAsync((fa) {
      final c = PrototypeController(start: '6738:105206');
      fa.flushMicrotasks();
      c.refresh();
      expect(c.current.code, 'D2');
      fa.elapse(const Duration(milliseconds: 1600));
      expect(c.current.code, 'D3');
      c.go('6738:105737');
      c.refresh();
      expect(c.current.code, 'E10');
      fa.elapse(const Duration(milliseconds: 1600));
      expect(c.current.code, 'E1');
      c.dispose();
    });
  });

  test('Aldım kaydı: B12 alındı olur; Bağlantı koptu → C3b', () {
    final c = PrototypeController(start: '6738:105206');
    final b12 = MockData.reminders[2];
    c.reminderConfirm(b12);
    final items = c.reminderData.items;
    expect(items[2].state, ReminderItemState.taken);
    expect(items[2].statusText, 'Alındı · 09:02');
    c.scenario = const PrototypeScenario(record: 'Bağlantı koptu');
    c.reminderSkip(MockData.reminders[2]);
    expect(c.current.code, 'C3b');
    c.dispose();
  });

  test('⋮ Ertele 15 dakika → 09:15 ve saati gelen durum “upcoming” olur', () {
    final c = PrototypeController(start: '6738:105206');
    c.openReminderMenu(MockData.reminders[2]);
    expect(c.state.remMenu?.mode, ReminderSheetMode.menu);
    c.reminderMenuSelect(ReminderMenuOption.postpone);
    c.selectPostpone('15 dakika');
    c.confirmPostpone();
    final it = c.reminderData.items[2];
    expect(it.meta, '1 tablet · 09:15');
    expect(it.state, ReminderItemState.upcoming);
    expect(c.state.remMenu, isNull);
    c.dispose();
  });

  test('⋮ Sil → kayıt listeden kalkar', () {
    final c = PrototypeController(start: '6738:105206');
    c.openReminderMenu(MockData.reminders[0]);
    c.reminderMenuSelect(ReminderMenuOption.delete);
    expect(c.state.remMenu?.mode, ReminderSheetMode.delete);
    c.confirmDelete();
    expect(c.reminderData.items.any((r) => r.id == 'r0'), isFalse);
    c.dispose();
  });

  test('Aktivite ⋮ menüsü açılmaz (Tasarım yok)', () {
    final notes = <ProtoNotice>[];
    final c = PrototypeController(start: '6738:105206', onNotice: notes.add);
    c.openReminderMenu(MockData.reminders[3]);
    expect(c.state.remMenu, isNull);
    expect(notes, isNotEmpty);
    c.dispose();
  });

  test('Kart → skor sayfası → geri', () {
    final c = PrototypeController(start: '6738:105206');
    c.openScore(SubScoreKind.sleep);
    expect(c.current.id, '4711:87555');
    c.back();
    expect(c.current.code, 'A2');
    c.dispose();
  });

  test('Free: artı → Premium sayfası; satın alma başarılı → E3', () {
    final c = PrototypeController(start: '6738:105737');
    c.onPlus();
    expect(c.current.code, 'E2');
    expect(c.state.premiumSheet, isTrue);
    c.explorePremium();
    expect(c.current.code, 'E3');
    c.dispose();
  });
}
