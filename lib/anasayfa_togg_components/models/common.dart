/// Ekran veri modelleri. Bileşenler veri üretmez (R-04);
/// değerler dışarıdan gelir.
library;

enum PlanType { free, premium }

enum ToastType { error, success, info, warning, progress }

class ToastData {
  const ToastData(this.type, this.text);

  final ToastType type;
  final String text;
}
