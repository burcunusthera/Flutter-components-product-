// Uygulama açılış testi. Bu dosya, `flutter create .` komutunun varsayılan
// (MyApp tabanlı) testi oluşturmasını da engeller.
import 'package:flutter_components_product/anasayfa_togg_components/anasayfa_togg_components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Uygulama galeriyle açılır', (tester) async {
    await tester.pumpWidget(const AnasayfaToggGalleryApp());
    expect(find.text('Anasayfa Togg Components'), findsOneWidget);
  });
}
