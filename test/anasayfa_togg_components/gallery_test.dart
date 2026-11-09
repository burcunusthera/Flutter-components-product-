import 'package:flutter/material.dart';
import 'package:flutter_components_product/anasayfa_togg_components/anasayfa_togg_components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Galeri başlığı ve bölümler görünür', (tester) async {
    await tester.pumpWidget(const AnasayfaToggGalleryApp());
    await tester.pump();
    expect(find.text('Anasayfa Togg Components'), findsOneWidget);
    expect(find.text('Prototip'), findsOneWidget);
    expect(find.textContaining('Ekran durumları'), findsOneWidget);
  });

  test('Her bileşen kaydının en az bir durumu var', () {
    for (final g in kComponentGroups) {
      for (final e in g.entries) {
        expect(e.variants, isNotEmpty, reason: e.name);
      }
    }
  });

  test('Kullanılan her ikonun dosyası tanımlı', () {
    expect(kNdsIcons.length, 48);
    for (final d in kNdsIcons.values) {
      expect(d.file.endsWith('.svg'), isTrue);
    }
  });
}
