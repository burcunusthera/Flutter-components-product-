import 'package:flutter/material.dart';

import '../../models/device.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/action_link.dart';
import '../common/card_header.dart';
import '../common/nds_button.dart';
import '../common/r06.dart';
import 'device_metric_card.dart';

/// Cihaz verileri (DS DeviceDataSection + App `DevView`): başlık + 2 sütunlu 3 satır, aralık 8.
class DeviceDataSection extends StatelessWidget {
  const DeviceDataSection({super.key, required this.data, this.onSeeAll, this.onAction, this.onRetryMetric});

  final DeviceData data;
  final VoidCallback? onSeeAll;

  /// Boş durum butonu: Cihaz bağla / İzinleri yönet / Tekrar dene.
  final VoidCallback? onAction;
  final ValueChanged<DeviceMetric>? onRetryMetric;

  static const _empty = <DeviceSectionState, (String, String, String, NdsButtonType, R06State)>{
    DeviceSectionState.deviceNotConnected: (
      'Cihazınız bağlı değil',
      'Akıllı saatinizi veya bilekliğinizi bağladığınızda adım, kalp atışı ve uyku verileriniz burada görünür.',
      'Cihaz bağla',
      NdsButtonType.primary,
      R06State.cihazYok,
    ),
    DeviceSectionState.permissionMissing: (
      'Veri erişim izni gerekli',
      'Verilerinizi burada gösterebilmemiz için okuma izni vermeniz yeterli.',
      'İzinleri yönet',
      NdsButtonType.primary,
      R06State.izinGerekli,
    ),
    DeviceSectionState.error: (
      'Cihaz verileri yüklenemedi',
      'Verileriniz şu an alınamadı. Tekrar deneyebilirsiniz.',
      'Tekrar dene',
      NdsButtonType.secondary,
      R06State.hata,
    ),
    DeviceSectionState.offlineError: (
      'Cihaz verileri yüklenemedi',
      'İnternet bağlantısı yok. Bağlantınızı kontrol edip tekrar deneyin.',
      'Tekrar dene',
      NdsButtonType.secondary,
      R06State.internetYok,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final empty = _empty[data.state];
    final header = CardHeader(
      icon: 'Medical/heart care 1',
      title: 'Cihaz verileri',
      action: empty != null ? null : ActionLink(label: 'Hepsini gör', onTap: onSeeAll),
    );
    Widget body;
    if (empty != null) {
      body = Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
        decoration: BoxDecoration(
          color: NdsColors.grey0,
          border: Border.all(color: NdsColors.grey100),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(children: [
          R06(empty.$5, size: 72),
          const SizedBox(height: 24),
          Text(empty.$1, textAlign: TextAlign.center, style: ndsText(18, 23, 600, NdsColors.grey900)),
          const SizedBox(height: 8),
          Text(empty.$2, textAlign: TextAlign.center, style: ndsText(14, 18, 400, NdsColors.grey500)),
          const SizedBox(height: 24),
          NdsButton(label: empty.$3, type: empty.$4, onTap: onAction),
        ]),
      );
    } else {
      final items = data.state == DeviceSectionState.loading && data.items.isEmpty
          ? [for (final m in DeviceMetric.values) DeviceMetricData(metric: m, state: MetricState.loading)]
          : data.items;
      final rows = <Widget>[];
      for (var i = 0; i < items.length; i += 2) {
        final a = items[i];
        final b = i + 1 < items.length ? items[i + 1] : null;
        rows.add(Row(children: [
          Expanded(child: DeviceMetricCard(data: a, onRetry: onRetryMetric == null ? null : () => onRetryMetric!(a.metric))),
          const SizedBox(width: 8),
          Expanded(
            child: b == null
                ? const SizedBox.shrink()
                : DeviceMetricCard(data: b, onRetry: onRetryMetric == null ? null : () => onRetryMetric!(b.metric)),
          ),
        ]));
      }
      body = Column(children: [
        for (var i = 0; i < rows.length; i++) ...[if (i > 0) const SizedBox(height: 8), rows[i]],
      ]);
    }
    return Semantics(
      container: true,
      label: 'Cihaz verileri',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [header, const SizedBox(height: 12), body]),
    );
  }
}
