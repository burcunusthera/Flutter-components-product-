import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../../theme/nds_colors.dart';

/// Bu ekranda kullanılan R06 Kompakt durumları (assets/.../animations/r06_<durum>.json).
enum R06State {
  hazir('hazir'),
  premiumTac('premium_tac'),
  rahatlamis('rahatlamis'),
  sakin('sakin'),
  dengeli('dengeli'),
  stresli('stresli'),
  cokStresli('cok_stresli'),
  cihazYok('cihaz_yok'),
  veriBekleniyor('veri_bekleniyor'),
  izinGerekli('izin_gerekli'),
  hata('hata'),
  internetYok('internet_yok'),
  gunKayitYok('gun_kayit_yok'),
  veriYok('veri_yok'),
  yukleniyor('yukleniyor'),
  silinsinMi('silinsin_mi');

  const R06State(this.file);
  final String file;
}

/// DS R06K (Therus Kompakt) — DS'in dışa aktardığı Lottie dosyalarından.
/// Sistemde hareket azaltma açıkken durağan.
class R06 extends StatelessWidget {
  const R06(this.state, {super.key, required this.size, this.dropShadow = false});

  final R06State state;
  final double size;

  /// `.nds-mood` gölgesi: drop-shadow(0 6 6 rgba(24,39,75,.08)) drop-shadow(0 3 4 rgba(24,39,75,.12)).
  final bool dropShadow;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    Widget art(Color? tint) {
      final l = Lottie.asset(
        '$kAssetRoot/animations/r06_${state.file}.json',
        width: size,
        height: size,
        fit: BoxFit.contain,
        animate: !reduce,
        repeat: true,
      );
      if (tint == null) return l;
      return ColorFiltered(colorFilter: ColorFilter.mode(tint, BlendMode.srcIn), child: l);
    }

    final main = SizedBox(width: size, height: size, child: art(null));
    if (!dropShadow) return ExcludeSemantics(child: main);
    Widget shadow(double dy, double blur, Color c) => Transform.translate(
          offset: Offset(0, dy),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blur / 2, sigmaY: blur / 2),
            child: SizedBox(width: size, height: size, child: art(c)),
          ),
        );
    return ExcludeSemantics(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(clipBehavior: Clip.none, children: [
          shadow(6, 6, const Color(0x1418274B)),
          shadow(3, 4, const Color(0x1F18274B)),
          main,
        ]),
      ),
    );
  }
}
