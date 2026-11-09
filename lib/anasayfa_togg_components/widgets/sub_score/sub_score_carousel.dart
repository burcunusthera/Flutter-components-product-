import 'package:flutter/material.dart';

import '../../models/sub_score.dart';
import '../common/nds_pager.dart';
import 'sub_score_card.dart';

/// Togg alt skor kartları (App.dc.html `TodayCarousel`, `todaySlides`).
/// Her durumda Aktivite · Uyku · Toparlanma; kart yüksekliği her durumda 269.
/// Otomatik kayma yok; yatay sürükleme > 40 px veya noktaya dokunma ile geçiş.
class SubScoreCarousel extends StatefulWidget {
  const SubScoreCarousel({
    super.key,
    required this.state,
    required this.scores,
    this.staleLabel,
    this.onOpenScore,
    this.onRetry,
    this.onConnectDevice,
    this.onManagePermissions,
  });

  final SubScoreState state;
  final SubScores scores;

  /// stale: “Güncel değil · 11 Ekim” (tarih dışarıdan).
  final String? staleLabel;

  /// Detayları gör / karta dokunma → Aktivite skorum (4711:88881), Uyku skorum (4711:87555), Toparlanma skorum (4711:89318).
  final ValueChanged<SubScoreKind>? onOpenScore;

  /// Hata / internet yok → yalnız skor kaynağını yeniden ister.
  final VoidCallback? onRetry;

  /// Cihaz bağlı değil → 06 cihaz bağlama.
  final VoidCallback? onConnectDevice;

  /// İzin yok → işletim sisteminin sağlık verisi izin ekranı.
  final VoidCallback? onManagePermissions;

  @override
  State<SubScoreCarousel> createState() => _SubScoreCarouselState();
}


class _SubScoreCarouselState extends State<SubScoreCarousel> {
  static const _gap = 12.0;
  static const _cardH = 269.0;
  int _index = 0;
  double? _dragStart;
  double _dragDx = 0;

  List<SubScoreSlide> _slides() {
    final w = widget;
    return SubScoreKind.values.map((k) {
      return switch (w.state) {
        SubScoreState.error =>
          SubScoreSlide(kind: k, name: 'Skor yüklenemedi', btnLabel: 'Tekrar dene', btnIcon: 'User Interface/refresh', onBtn: w.onRetry),
        SubScoreState.offline =>
          SubScoreSlide(kind: k, name: 'İnternet bağlantısı yok', btnLabel: 'Tekrar dene', btnIcon: 'User Interface/refresh', onBtn: w.onRetry),
        SubScoreState.permission => SubScoreSlide(
            kind: k,
            name: 'Sağlık verisi izni gerekli',
            btnLabel: 'İzinleri yönet',
            btnIcon: 'User Interface/shield',
            onBtn: w.onManagePermissions),
        SubScoreState.noDevice =>
          SubScoreSlide(kind: k, name: 'Cihaz bağlı değil', btnLabel: 'Cihaz bağla', btnIcon: 'User Interface/smartwatch', onBtn: w.onConnectDevice),
        SubScoreState.noData =>
          SubScoreSlide(kind: k, name: 'Henüz veri yok', info: 'Cihazınız bağlı. İlk veriler gelince skorunuz burada oluşur.'),
        SubScoreState.loading => SubScoreSlide(kind: k, name: 'Hesaplanıyor…', busy: true),
        SubScoreState.insufficient => _insufficient(k),
        // Kısmi: yalnız Uyku eksik (dün gece uyku kaydı yok), diğerleri normal.
        SubScoreState.partial => k == SubScoreKind.sleep ? _insufficient(k) : _data(k),
        SubScoreState.data || SubScoreState.stale => _data(k),
      };
    }).toList();
  }

  SubScoreSlide _insufficient(SubScoreKind k) =>
      SubScoreSlide(kind: k, name: 'Veri yetersiz', info: '${k.title} skorunuz, gereken veri oluştuğunda hesaplanır.');

  SubScoreSlide _data(SubScoreKind k) {
    final v = widget.scores.of(k);
    // Veri gelmediyse sahte değer üretilmez (R-04): kart “Veri yok” bandıyla boş gösterge gösterir.
    if (v == null) return SubScoreSlide(kind: k, name: 'Veri yok');
    return SubScoreSlide(
      kind: k,
      value: v,
      btnLabel: 'Detayları gör',
      chevron: true,
      link: true,
      onBtn: widget.onOpenScore == null ? null : () => widget.onOpenScore!(k),
    );
  }

  void _go(int i, int n) => setState(() => _index = i.clamp(0, n - 1));

  @override
  Widget build(BuildContext context) {
    final slides = _slides();
    final n = slides.length;
    final cur = _index.clamp(0, n - 1);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Semantics(
        container: true,
        label: 'Bugün skorları',
        child: LayoutBuilder(builder: (context, c) {
          final w = c.maxWidth;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: (d) {
              _dragStart = d.globalPosition.dx;
              _dragDx = 0;
            },
            onHorizontalDragUpdate: (d) {
              if (_dragStart != null) _dragDx = d.globalPosition.dx - _dragStart!;
            },
            onHorizontalDragEnd: (_) {
              final dx = _dragDx;
              _dragStart = null;
              if (dx.abs() > 40) _go(cur + (dx < 0 ? 1 : -1), n);
            },
            child: SizedBox(
              height: _cardH,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  minWidth: 0,
                  maxWidth: double.infinity,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: -cur * (w + _gap)),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.ease,
                    builder: (context, x, child) => Transform.translate(offset: Offset(x, 0), child: child),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      for (var k = 0; k < n; k++) ...[
                        if (k > 0) const SizedBox(width: _gap),
                        SizedBox(
                          width: w,
                          height: _cardH,
                          child: ExcludeSemantics(
                            excluding: k != cur,
                            child: Semantics(
                              container: true,
                              label: '${k + 1} / $n · ${slides[k].kind.title}',
                              child: SubScoreCard(
                                slide: slides[k],
                                stale: widget.state == SubScoreState.stale ? widget.staleLabel : null,
                                focusable: k == cur,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ]),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
      const SizedBox(height: 12),
      NdsPager(count: n, active: cur, onChanged: (i) => _go(i, n), semanticLabel: 'Skor kartları'),
    ]);
  }
}
