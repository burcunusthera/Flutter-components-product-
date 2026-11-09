import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../models/nutrition.dart';
import '../../theme/nds_shadows.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/action_link.dart';
import '../common/card_header.dart';
import '../common/nds_outline_button.dart';
import '../common/premium_chip.dart';
import '../common/premium_lock.dart';
import 'macro_metric.dart';

/// Beslenme (DS NutritionSummaryCard): padding 16 20, radius 16, aralık 24, shadow-200.
class NutritionCard extends StatelessWidget {
  const NutritionCard({super.key, required this.data, this.onDetails, this.onUpgrade, this.onRetry, this.onAddMeal});

  final NutritionData data;
  final VoidCallback? onDetails;
  final VoidCallback? onUpgrade;
  final VoidCallback? onRetry;
  final VoidCallback? onAddMeal;

  @override
  Widget build(BuildContext context) {
    final st = data.state;
    final subtitle = switch (st) {
      NutritionState.noTarget => 'Günlük hedef belirlenmedi',
      NutritionState.empty => 'Bugün için henüz kayıt yok',
      NutritionState.progress || NutritionState.zero || NutritionState.partial || NutritionState.goalReached =>
        'Bugün alınan / günlük hedef',
      _ => null,
    };
    final header = st == NutritionState.loading
        ? const CardHeader(title: '', loading: true)
        : CardHeader(
            icon: 'Shopping&Ecommerce/tableware',
            title: 'Beslenme',
            subtitle: subtitle,
            badge: st == NutritionState.locked ? const PremiumChip() : null,
            action: st == NutritionState.empty || st == NutritionState.error
                ? null
                : ActionLink(label: 'Detaylar', onTap: onDetails),
          );

    final fat = data.fat, carbs = data.carbs, protein = data.protein;
    List<Widget>? macros;
    switch (st) {
      case NutritionState.normal:
      case NutritionState.locked:
        macros = [
          MacroMetric(macro: MacroKind.fat, state: MacroMetricState.normal, v: fat),
          MacroMetric(macro: MacroKind.carbs, state: MacroMetricState.normal, v: carbs),
          MacroMetric(macro: MacroKind.protein, state: MacroMetricState.normal, v: protein),
        ];
      case NutritionState.progress:
        macros = [
          MacroMetric(macro: MacroKind.fat, state: MacroMetricState.progress, v: fat),
          MacroMetric(macro: MacroKind.carbs, state: MacroMetricState.progress, v: carbs),
          MacroMetric(macro: MacroKind.protein, state: MacroMetricState.progress, v: protein),
        ];
      case NutritionState.zero:
        macros = [
          MacroMetric(macro: MacroKind.fat, state: MacroMetricState.zero, v: fat),
          MacroMetric(macro: MacroKind.carbs, state: MacroMetricState.zero, v: carbs),
          MacroMetric(macro: MacroKind.protein, state: MacroMetricState.zero, v: protein),
        ];
      case NutritionState.noTarget:
        macros = [
          MacroMetric(macro: MacroKind.fat, state: MacroMetricState.noTarget, v: fat),
          MacroMetric(macro: MacroKind.carbs, state: MacroMetricState.noTarget, v: carbs),
          MacroMetric(macro: MacroKind.protein, state: MacroMetricState.noTarget, v: protein),
        ];
      case NutritionState.partial:
        macros = [
          MacroMetric(macro: MacroKind.fat, state: MacroMetricState.progress, v: fat),
          MacroMetric(macro: MacroKind.carbs, state: MacroMetricState.progress, v: carbs),
          MacroMetric(macro: MacroKind.protein, state: MacroMetricState.empty, v: protein),
        ];
      case NutritionState.goalReached:
        macros = [
          MacroMetric(macro: MacroKind.fat, state: MacroMetricState.reached, v: fat),
          MacroMetric(macro: MacroKind.carbs, state: MacroMetricState.over, v: carbs),
          MacroMetric(macro: MacroKind.protein, state: MacroMetricState.progress, v: protein),
        ];
      case NutritionState.empty:
        macros = [
          MacroMetric(macro: MacroKind.fat, state: MacroMetricState.empty, v: fat),
          MacroMetric(macro: MacroKind.carbs, state: MacroMetricState.empty, v: carbs),
          MacroMetric(macro: MacroKind.protein, state: MacroMetricState.empty, v: protein),
        ];
      case NutritionState.loading:
        macros = const [
          MacroMetric(macro: MacroKind.fat, state: MacroMetricState.loading),
          MacroMetric(macro: MacroKind.carbs, state: MacroMetricState.loading),
          MacroMetric(macro: MacroKind.protein, state: MacroMetricState.loading),
        ];
      case NutritionState.error:
        macros = null;
    }

    final children = <Widget>[header];
    if (macros != null) {
      Widget row = Row(crossAxisAlignment: CrossAxisAlignment.start, children: [for (final m in macros) Expanded(child: m)]);
      if (st == NutritionState.locked) {
        row = ExcludeSemantics(child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), child: row));
      }
      children.add(row);
    }
    if (st == NutritionState.empty) {
      children.add(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Yediklerinizi eklediğinizde yağ, karbonhidrat ve protein dağılımınız burada görünür.',
            style: ndsText(14, 18, 400, NdsColors.grey500)),
        const SizedBox(height: 16),
        NdsOutlineButton(label: 'Öğün ekle', onTap: onAddMeal),
      ]));
    }
    if (st == NutritionState.error) {
      children.add(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(data.errorTitle ?? 'Beslenme verileri şu an alınamadı', style: ndsText(14, 18, 600, NdsColors.grey900)),
        const SizedBox(height: 8),
        Text(data.errorText ?? 'Birazdan tekrar deneyebilirsiniz. Kayıtlarınız silinmedi.',
            style: ndsText(14, 18, 400, NdsColors.grey500)),
        const SizedBox(height: 8),
        NdsOutlineButton(label: 'Tekrar dene', onTap: onRetry),
      ]));
    }

    Widget card = Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: st == NutritionState.locked ? 249 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: NdsColors.grey0, borderRadius: BorderRadius.circular(16), boxShadow: NdsShadows.s200),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (var i = 0; i < children.length; i++) ...[if (i > 0) const SizedBox(height: 24), children[i]],
      ]),
    );
    if (st == NutritionState.locked) {
      // .nds-plock: kartın üstünden 70, tam genişlik, ortalı.
      card = Stack(children: [
        card,
        Positioned(
          left: 0,
          right: 0,
          top: 70,
          child: PremiumLock(title: 'Kişiselleştirilmiş beslenme içgörülerine erişin', onAction: onUpgrade),
        ),
      ]);
    }
    return Semantics(container: true, label: 'Beslenme', child: card);
  }
}
