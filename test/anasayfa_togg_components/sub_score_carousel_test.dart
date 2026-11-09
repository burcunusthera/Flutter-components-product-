import 'package:flutter_components_product/anasayfa_togg_components/anasayfa_togg_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Kabul kriterleri (GELISTIRICI_TESLIM.md §6) için temel widget testleri.
// NOT: Bu dosya yazıldığı ortamda Flutter SDK'ya erişim yoktu; testler henüz çalıştırılmadı.

Widget _host(Widget child) => MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 335, child: child)),
      ),
    );

void main() {
  for (final st in SubScoreState.values) {
    testWidgets('$st: 3 kart, her biri 269 px, 3 nokta', (tester) async {
      await tester.pumpWidget(_host(SubScoreCarousel(
        state: st,
        scores: const SubScores(activity: 40, sleep: 73, recovery: 93),
        staleLabel: 'Güncel değil · 11 Ekim',
        onOpenScore: (_) {},
        onRetry: () {},
        onConnectDevice: () {},
        onManagePermissions: () {},
      )));
      await tester.pump(const Duration(milliseconds: 300));

      for (final t in ['Aktivite', 'Uyku', 'Toparlanma']) {
        expect(find.text(t), findsOneWidget);
      }
      expect(find.text('Bugün'), findsNothing);
      final card = find.ancestor(of: find.text('Aktivite'), matching: find.byType(ClipRRect)).first;
      expect(tester.getSize(card).height, 269);
      expect(find.byType(NdsPager), findsOneWidget);
    });
  }

  testWidgets('Veri varken Detayları gör kendi skor sayfasını açar', (tester) async {
    SubScoreKind? opened;
    await tester.pumpWidget(_host(SubScoreCarousel(
      state: SubScoreState.data,
      scores: const SubScores(activity: 40, sleep: 73, recovery: 93),
      onOpenScore: (k) => opened = k,
    )));
    await tester.tap(find.text('Detayları gör').first);
    expect(opened, SubScoreKind.activity);
  });

  testWidgets('Yükleniyorken dokunulabilir eleman yok', (tester) async {
    await tester.pumpWidget(_host(const SubScoreCarousel(state: SubScoreState.loading, scores: SubScores())));
    expect(find.byType(GlassActionButton), findsNothing);
    expect(find.text('Hesaplanıyor…'), findsNWidgets(3));
  });

  testWidgets('Kartlar kendiliğinden kaymaz', (tester) async {
    await tester.pumpWidget(_host(const SubScoreCarousel(state: SubScoreState.data, scores: SubScores(activity: 1, sleep: 2, recovery: 3))));
    final before = tester.getTopLeft(find.text('Aktivite'));
    await tester.pump(const Duration(seconds: 10));
    expect(tester.getTopLeft(find.text('Aktivite')), before);
  });
}
