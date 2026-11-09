import 'package:flutter/material.dart';

import '../../models/stress.dart';
import '../../theme/nds_shadows.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_button.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';
import '../common/r06.dart';
import 'stress_faces.dart';
import 'stress_skeleton.dart';
import 'stress_stats.dart';

/// Stres Monitörü (App `StressView`, Figma 6730:233991).
/// Kart: padding 16 0, radius 24, aralık 12, shadow-200.
class StressMonitorCard extends StatelessWidget {
  const StressMonitorCard({
    super.key,
    required this.data,
    this.onDetails,
    this.onConnectDevice,
    this.onManagePermissions,
    this.onRetry,
  });

  final StressData data;
  final VoidCallback? onDetails;
  final VoidCallback? onConnectDevice;
  final VoidCallback? onManagePermissions;
  final VoidCallback? onRetry;

  static const _row = <StressState, ({R06State r06, String t, String d, String? note, String? btn})>{
    StressState.noDevice: (
      r06: R06State.cihazYok,
      t: 'Stres verisi henüz yok',
      d: 'Stres seviyesi, bağlı cihazınızdan gelen ölçümlerle hesaplanır. Cihazınızı bağladığınızda burada görünecek.',
      note: null,
      btn: 'Cihaz bağla',
    ),
    StressState.permission: (
      r06: R06State.izinGerekli,
      t: 'Veri erişim izni gerekli',
      d: 'Stres seviyenizi hesaplayabilmemiz için kalp ritmi verisine erişim izni vermeniz yeterli.',
      note: null,
      btn: 'İzinleri yönet',
    ),
    StressState.firstWait: (
      r06: R06State.veriBekleniyor,
      t: 'İlk ölçümleriniz bekleniyor',
      d: 'Cihazınız bağlandı. Gün içinde takılı tuttuğunuzda stres seviyeniz birkaç saat içinde burada görünecek.',
      note: 'Son senkronizasyon: henüz yok',
      btn: null,
    ),
    StressState.error: (
      r06: R06State.hata,
      t: 'Stres verisi şu an alınamadı',
      d: 'Sunucuya şu an ulaşılamıyor. Birazdan tekrar deneyebilirsiniz.',
      note: null,
      btn: 'Tekrar dene',
    ),
    StressState.offline: (
      r06: R06State.internetYok,
      t: 'İnternet bağlantısı yok',
      d: 'Stres verinizi yüklemek için bağlantı gerekiyor. Bağlantınızı kontrol edip tekrar deneyin.',
      note: null,
      btn: 'Tekrar dene',
    ),
    StressState.todayNone: (
      r06: R06State.gunKayitYok,
      t: 'Bugün henüz ölçüm yok',
      d: 'Cihazınızı taktığınızda gün içindeki ölçümleriniz burada görünecek.',
      note: null,
      btn: null,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final st = data.state;
    final details = st == StressState.data || st == StressState.stale || st == StressState.insufficient || st == StressState.todayNone;
    final kids = <Widget>[
      // Başlık satırı: padding 0 24, üstten hizalı
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Semantics(header: true, child: Text('Stres Monitörü', style: ndsText(18, 23, 600, NdsColors.grey900)))),
          if (details)
            Pressable(
              onTap: onDetails,
              semanticLabel: 'Stres detayları',
              excludeChildSemantics: true,
              builder: (context, _) => SizedBox(
                height: 16,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('Detaylar', style: ndsText(12, 15, 400, NdsColors.grey500)),
                  const SizedBox(width: 4),
                  const NdsIcon('User Interface/chevron right', size: 16, color: NdsColors.grey500),
                ]),
              ),
            ),
        ]),
      ),
    ];
    if (data.updatedText != null && (details || st == StressState.data)) {
      kids.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(data.updatedText!, style: ndsText(12, 15, 400, NdsColors.grey500)),
      ));
    }

    if (st == StressState.loading) {
      kids.add(const StressSkeleton());
    } else if (st == StressState.data || st == StressState.stale || st == StressState.insufficient) {
      if (st == StressState.stale) {
        kids.add(Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: NdsColors.warning50, borderRadius: BorderRadius.circular(14)),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: NdsColors.warning200),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const NdsIcon('User Interface/time', size: 18, color: NdsColors.warning800),
            const SizedBox(width: 8),
            Expanded(
              child: Text(data.staleWarning ?? 'Son veri 2 gün önce alındı. Değerler güncel olmayabilir.',
                  style: ndsText(12, 15, 400, NdsColors.warning800)),
            ),
          ]),
        ));
      }
      kids.add(Opacity(
        opacity: st == StressState.stale ? .55 : 1,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Center(child: StressFaces(mood: st == StressState.insufficient ? StressMood.sakin : data.mood)),
        ),
      ));
      kids.add(StressStats(max: data.max, avg: data.avg, min: data.min));
      if (st == StressState.insufficient) {
        kids.add(Container(
          margin: const EdgeInsets.fromLTRB(24, 4, 24, 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: NdsColors.grey50, borderRadius: BorderRadius.circular(12)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const NdsIcon('User Interface/info', size: 16, color: NdsColors.grey500),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Gün içinde daha fazla ölçüm geldikçe en yüksek ve en düşük değerleriniz oluşacak.',
                  style: ndsText(12, 15, 400, NdsColors.grey500)),
            ),
          ]),
        ));
      }
    } else {
      final r = _row[st]!;
      kids.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 52, height: 52, child: Center(child: R06(r.r06, size: 52))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.t, style: ndsText(16, 20, 600, NdsColors.grey900)),
              const SizedBox(height: 4),
              Text(r.d, style: ndsText(14, 18, 400, NdsColors.grey500)),
              if (r.note != null) ...[
                const SizedBox(height: 4),
                Text(r.note!, style: ndsText(12, 15, 400, NdsColors.grey500)),
              ],
            ]),
          ),
        ]),
      ));
      if (st == StressState.todayNone) {
        kids.add(const Padding(padding: EdgeInsets.only(top: 4), child: StressStats(dim: true)));
      }
      if (r.btn != null) {
        final VoidCallback? cb = switch (st) {
          StressState.permission => onManagePermissions,
          StressState.noDevice => onConnectDevice,
          _ => onRetry,
        };
        kids.add(Padding(
          padding: st == StressState.noDevice
              ? const EdgeInsets.symmetric(horizontal: 20)
              : const EdgeInsets.fromLTRB(24, 4, 24, 0),
          child: NdsButton(label: r.btn!, type: NdsButtonType.secondary, onTap: cb),
        ));
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: NdsColors.grey0,
        borderRadius: BorderRadius.circular(24),
        boxShadow: NdsShadows.s200,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (var i = 0; i < kids.length; i++) ...[if (i > 0) const SizedBox(height: 12), kids[i]],
      ]),
    );
  }
}
