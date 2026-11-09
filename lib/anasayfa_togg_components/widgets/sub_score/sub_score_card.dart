import 'package:flutter/material.dart';

import '../../models/sub_score.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/glass_surface.dart';
import '../common/nds_icon.dart';
import 'glass_action_button.dart';
import 'overall_score_gauge.dart';
import 'today_background.dart';
import 'today_deco.dart';

/// Tek kartın görünüm verisi (App `todaySlides` çıktısı).
class SubScoreSlide {
  const SubScoreSlide({
    required this.kind,
    this.value,
    this.name,
    this.busy = false,
    this.info,
    this.btnLabel,
    this.btnIcon,
    this.chevron = false,
    this.onBtn,
    this.link = false,
  });

  final SubScoreKind kind;
  final int? value;
  final String? name;
  final bool busy;
  final String? info;
  final String? btnLabel;
  final String? btnIcon;
  final bool chevron;
  final VoidCallback? onBtn;
  final bool link;
}

/// Tek alt skor kartı: 269 yükseklik, padding 20, radius 16.
class SubScoreCard extends StatelessWidget {
  const SubScoreCard({super.key, required this.slide, required this.stale, required this.focusable});

  final SubScoreSlide slide;
  final String? stale;
  final bool focusable;

  @override
  Widget build(BuildContext context) {
    final s = slide;
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CustomPaint(
        painter: const TodayBackground(),
        child: Stack(clipBehavior: Clip.none, children: [
          // Dekor sağdan −102.677, üstten −42.875 (kart kırpar).
          const Positioned(top: -42.875, right: -102.677, child: TodayDeco()),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // Başlık satırı: min 23, aralık 12
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 23),
                child: Row(children: [
                  Semantics(header: true, child: Text(s.kind.title, style: ndsText(18, 23, 600, NdsColors.grey0))),
                  if (stale != null && s.value != null) ...[
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const NdsIcon('User Interface/time', size: 14, color: NdsColors.grey0),
                        const SizedBox(width: 4),
                        Text(stale!, style: ndsText(12, 15, 400, NdsColors.grey0)),
                      ]),
                    ),
                  ],
                ]),
              ),
              const SizedBox(height: 16),
              // Gösterge (295×116). Prototip 375 genişlikte; daha geniş ekranda ortalanır.
              Center(child: OverallScoreGauge(value: s.value, name: s.name, busy: s.busy)),
              const SizedBox(height: 20),
              // Eylem yuvası: görünmez Therus yorumu yüksekliği (54) korunur.
              SizedBox(height: 54, child: Center(child: _slot(s))),
            ]),
          ),
        ]),
      ),
    );
    if (s.link && s.onBtn != null) {
      card = GestureDetector(behavior: HitTestBehavior.opaque, onTap: s.onBtn, child: card);
    }
    return card;
  }

  Widget? _slot(SubScoreSlide s) {
    if (s.btnLabel != null) {
      return GlassActionButton(
        label: s.btnLabel!,
        icon: s.btnIcon,
        chevron: s.chevron,
        onTap: s.onBtn,
        focusable: focusable,
        semanticLabel: s.chevron ? '${s.kind.title} skorunun detaylarını gör' : s.btnLabel,
      );
    }
    if (s.busy) {
      // İskelet: buton yerinde boş cam alan, metin yok.
      return ExcludeSemantics(
        child: GlassSurface(
          height: 48,
          width: double.infinity,
          radius: BorderRadius.circular(12),
          blur: 12,
          color: const Color(0x1AFFFFFF),
          border: Border.all(color: const Color(0x2EFFFFFF)),
          child: const SizedBox.shrink(),
        ),
      );
    }
    if (s.info != null) {
      return GlassSurface(
        width: double.infinity,
        radius: BorderRadius.circular(12),
        blur: 12,
        color: const Color(0x1AFFFFFF),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 36), // min-height 48 − dolgu 12
          child: Align(
            heightFactor: 1,
            child: Text(s.info!, textAlign: TextAlign.center, style: ndsText(14, 20, 500, NdsColors.grey0)),
          ),
        ),
      );
    }
    return null;
  }
}
