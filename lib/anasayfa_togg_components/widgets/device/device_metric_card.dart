import 'package:flutter/material.dart';

import '../../models/device.dart';
import '../../theme/nds_shadows.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_icon.dart';
import '../common/nds_skel.dart';
import '../common/pressable.dart';
import 'metric_status_badge.dart';
import 'vertical_metric_indicator.dart';

/// DS DeviceMetricCard: 119 yükseklik, padding 12 16, radius 20, shadow-400, beyaz.
class DeviceMetricCard extends StatelessWidget {
  const DeviceMetricCard({super.key, required this.data, this.onRetry});

  final DeviceMetricData data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final d = data;
    final m = d.metric;
    final st = d.state;
    final isSleep = m == DeviceMetric.sleep;
    final valueColor = st == MetricState.stale ? NdsColors.grey500 : NdsColors.grey900;

    Widget value() {
      TextStyle b() => ndsText(24, 30, 700, valueColor);
      final small = ndsText(14, 18, 500, NdsColors.grey500);
      final parts = <Widget>[];
      if (st == MetricState.empty) {
        parts.add(Text('–', style: b()));
      } else if (isSleep && d.value == null) {
        parts
          ..add(Text(d.hours ?? '–', style: b()))
          ..add(Text('sa', style: small))
          ..add(Text(d.minutes ?? '–', style: b()))
          ..add(Text('dk', style: small));
      } else {
        parts
          ..add(Text(d.value ?? '–', style: b()))
          ..add(Text(m.unit, style: small));
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [for (var i = 0; i < parts.length; i++) ...[if (i > 0) const SizedBox(width: 8), parts[i]]],
      );
    }

    Widget msg(Widget? icon, String text) => SizedBox(
          height: 24,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[icon, const SizedBox(width: 4)],
            Flexible(
              child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false,
                  style: ndsText(14, 18, 500, NdsColors.grey500)),
            ),
          ]),
        );

    final List<Widget> body = switch (st) {
      MetricState.loading => [
          NdsSkel(width: isSleep ? 96 : 72, height: 30, radius: 6),
          const NdsSkel(width: 56, height: 24, radius: 100),
        ],
      MetricState.ready => [value(), MetricStatusBadge(tone: d.tone, label: d.badge)],
      MetricState.empty => [value(), msg(null, d.message ?? 'Henüz veri yok')],
      MetricState.stale => [
          value(),
          msg(const NdsIcon('Date & Time/clock four', size: 16, color: NdsColors.grey500), d.staleText ?? ''),
        ],
      MetricState.error => [
          msg(null, d.message ?? 'Veri alınamadı'),
          Pressable(
            onTap: onRetry,
            semanticLabel: '${m.title} için tekrar dene',
            excludeChildSemantics: true,
            builder: (context, _) => SizedBox(
              height: 24,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const NdsIcon('User Interface/refresh', size: 16, color: NdsColors.primary500),
                const SizedBox(width: 4),
                Text('Tekrar dene', style: ndsText(14, 18, 600, NdsColors.primary500)),
              ]),
            ),
          ),
        ],
    };

    return Semantics(
      container: true,
      label: m.title,
      child: Container(
        height: 119,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: NdsColors.grey0, borderRadius: BorderRadius.circular(20), boxShadow: NdsShadows.s400),
        child: Row(children: [
          Expanded(
            child: ClipRect(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 18,
                  child: Row(children: [
                    NdsIcon(m.icon, size: 16, color: NdsColors.grey400),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(m.title, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false,
                          style: ndsText(14, 18, 500, NdsColors.grey500)),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < body.length; i++) ...[if (i > 0) const SizedBox(height: 8), body[i]],
              ]),
            ),
          ),
          const SizedBox(width: 8),
          VerticalMetricIndicator(tone: st == MetricState.ready ? d.tone : null, level: d.level),
        ]),
      ),
    );
  }
}
