/// Beslenme veri modelleri. Bileşenler veri üretmez (R-04);
/// değerler dışarıdan gelir.
library;

enum NutritionState { normal, progress, zero, noTarget, partial, goalReached, empty, loading, locked, error }

class MacroValue {
  const MacroValue({this.consumed, this.target, this.progress, this.caption});

  final String? consumed;
  final String? target;

  /// 0–100
  final int? progress;
  final String? caption;
}

class NutritionData {
  const NutritionData({
    required this.state,
    this.fat = const MacroValue(),
    this.carbs = const MacroValue(),
    this.protein = const MacroValue(),
    this.errorTitle,
    this.errorText,
  });

  final NutritionState state;
  final MacroValue fat;
  final MacroValue carbs;
  final MacroValue protein;
  final String? errorTitle;
  final String? errorText;
}
