import 'catalog_cards.dart';
import 'catalog_foundation.dart';
import 'catalog_overlays.dart';
import 'component_entry.dart';

/// Galerideki tüm bileşen grupları.
final List<ComponentGroup> kComponentGroups = [
  ComponentGroup('Ana sayfa kartları ve üst bar', kCardEntries),
  ComponentGroup('Gezinme, toast ve alt sayfalar', kOverlayEntries),
  ComponentGroup('Temel bileşenler ve token’lar', kFoundationEntries),
];
