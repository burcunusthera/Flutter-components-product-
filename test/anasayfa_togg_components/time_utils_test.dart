import 'package:flutter_components_product/anasayfa_togg_components/anasayfa_togg_components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('addMinutes App addMin ile aynı', () {
    expect(addMinutes('09:00', 15), '09:15');
    expect(addMinutes('23:50', 30), '00:20');
    expect(addMinutes('00:10', -30), '23:40');
  });

  test('scoreName bantları DS ile aynı', () {
    expect(scoreName(null), 'Veri yok');
    expect(scoreName(20), 'Dinlenme zamanı');
    expect(scoreName(40), 'Gelişmeye açık');
    expect(scoreName(60), 'Dengede');
    expect(scoreName(80), 'İyi');
    expect(scoreName(93), 'Harika');
  });

  test('postponeMinutes', () {
    expect(postponeMinutes('10 dakika'), 10);
    expect(postponeMinutes('1 saat'), 60);
    expect(postponeMinutes('Saat seç'), isNull);
  });
}
