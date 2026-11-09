import 'package:flutter/widgets.dart';

/// Önizleme bildirimi (ör. “Aldım: B12 vitamini”). Galeride SnackBar olarak gösterilir.
typedef PreviewNotify = void Function(String message);

/// Bir bileşenin tek bir durum/varyant önizlemesi.
class ComponentVariant {
  const ComponentVariant(this.label, this.builder);

  final String label;
  final Widget Function(BuildContext context, PreviewNotify notify) builder;
}

/// Galerideki bir bileşen kaydı.
class ComponentEntry {
  const ComponentEntry({
    required this.name,
    required this.source,
    required this.file,
    required this.variants,
    this.fullWidth = false,
    this.dark = false,
  });

  /// Flutter sınıfı.
  final String name;

  /// Tasarımdaki kaynak (DS bileşeni / App fonksiyonu).
  final String source;

  /// lib/anasayfa_togg_components altındaki dosya.
  final String file;
  final List<ComponentVariant> variants;

  /// true → 375 genişlikte, kenar boşluğu olmadan (üst bar, alt gezinme, sayfalar).
  final bool fullWidth;

  /// true → önizleme zemini koyu (örtülü sayfalar).
  final bool dark;
}

/// Galeri bölümü.
class ComponentGroup {
  const ComponentGroup(this.title, this.entries);

  final String title;
  final List<ComponentEntry> entries;
}
