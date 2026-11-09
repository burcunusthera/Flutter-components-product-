import 'package:flutter/widgets.dart';

import '../../models/nutrition.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_skel.dart';
import 'macro_ring.dart';

/// Makro türü.
enum MacroKind { fat, carbs, protein }

/// DS MacroMetric durumları.
enum MacroMetricState { normal, progress, zero, noTarget, reached, over, empty, loading }

extension MacroKindX on MacroKind {
  String get label => switch (this) { MacroKind.fat => 'Yağ', MacroKind.carbs => 'Karbonhidrat', MacroKind.protein => 'Protein' };
  String get icon => switch (this) {
        MacroKind.fat => 'Nature & Ecology/oil',
        MacroKind.carbs => 'Autumn/wheat',
        MacroKind.protein => 'Food & Fruit/chicken leg',
      };
  Color get color => switch (this) {
        MacroKind.fat => NdsColors.macroFat,
        MacroKind.carbs => NdsColors.macroCarbs,
        MacroKind.protein => NdsColors.secondary500,
      };
  Color get text => switch (this) {
        MacroKind.fat => NdsColors.macroFatText,
        MacroKind.carbs => NdsColors.macroCarbsText,
        MacroKind.protein => NdsColors.secondary800,
      };
}

/// DS MacroMetric: halka 48 + etiket 14/18/500 + değer + açıklama; aralık 8.
class MacroMetric extends StatelessWidget {
  const MacroMetric({super.key, required MacroKind macro, required MacroMetricState state, MacroValue v = const MacroValue()})
      : _macro = macro,
        _state = state,
        _v = v;

  final MacroKind _macro;
  final MacroMetricState _state;
  final MacroValue _v;

  @override
  Widget build(BuildContext context) {
    final st = _state;
    if (st == MacroMetricState.loading) {
      return const Column(children: [
        MacroRing.loading(),
        SizedBox(height: 8),
        NdsSkel(width: 56, height: 12),
        SizedBox(height: 8),
        NdsSkel(width: 64, height: 12),
      ]);
    }
    final empty = st == MacroMetricState.empty;
    final indicator = switch (st) {
      MacroMetricState.empty => MacroRingKind.empty,
      MacroMetricState.zero => MacroRingKind.zero,
      MacroMetricState.noTarget => MacroRingKind.ring,
      _ => MacroRingKind.progress,
    };
    final progress = st == MacroMetricState.reached || st == MacroMetricState.over ? 100 : (_v.progress ?? 0);
    final caption = _v.caption ??
        switch (st) {
          MacroMetricState.progress => '%${_v.progress ?? 0}',
          MacroMetricState.zero => '%0',
          MacroMetricState.reached => 'Hedefe ulaşıldı',
          _ => null,
        };
    final unit = 'g';
    final valueSmall = (st == MacroMetricState.noTarget || _v.target == null) ? unit : '/ ${_v.target} $unit';
    return Semantics(
      container: true,
      child: Column(children: [
        MacroRing(macro: _macro, kind: indicator, progress: progress),
        const SizedBox(height: 8),
        Text(_macro.label, maxLines: 1, softWrap: false, style: ndsText(14, 18, 500, empty ? NdsColors.grey500 : _macro.text)),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(empty ? '—' : (st == MacroMetricState.zero ? '0' : (_v.consumed ?? '—')),
                  style: ndsText(14, 18, 700, empty ? NdsColors.grey500 : NdsColors.grey900)),
              const SizedBox(width: 4),
              Text(empty ? unit : valueSmall, style: ndsText(12, 15, 500, NdsColors.grey500)),
            ],
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: 8),
          Text(caption, textAlign: TextAlign.center, style: ndsText(12, 15, 400, NdsColors.grey500)),
        ],
      ]),
    );
  }
}
