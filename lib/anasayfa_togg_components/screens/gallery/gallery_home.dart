import 'package:flutter/material.dart';

import '../../navigation/prototype_states.dart';
import '../../theme/nds_colors.dart';
import 'component_catalog.dart';
import 'component_preview_page.dart';
import 'out_of_scope.dart';
import 'prototype_player_page.dart';

/// Galeri uygulaması kökü.
class AnasayfaToggGalleryApp extends StatelessWidget {
  const AnasayfaToggGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anasayfa Togg Components',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: NdsColors.primary500, useMaterial3: true),
      home: const GalleryHome(),
    );
  }
}

/// “Anasayfa Togg Components” galerisi: prototip, tüm ekran durumları (akışlara göre),
/// tüm bileşenler ve kapsam dışı board'lar.
class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  void _open(BuildContext context, Widget page) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    Widget header(String s) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(s, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        );
    final componentCount = kComponentGroups.fold<int>(0, (a, g) => a + g.entries.length);
    return Scaffold(
      appBar: AppBar(title: const Text('Anasayfa Togg Components')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          header('Prototip'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: const Text('02 — Ana Sayfa Togg · oynat'),
              subtitle: const Text('A1 açılıştan başlar; tüm etkileşimler ve akışlar çalışır'),
              onTap: () => _open(context, const PrototypePlayerPage(startId: '6738:105182')),
            ),
          ),
          header('Ekran durumları (${kProtoScreens.length} kare)'),
          for (final f in ProtoFlow.values)
            ExpansionTile(
              title: Text(f.title),
              subtitle: Text('${kProtoScreens.where((s) => s.flow == f).length} kare'),
              children: [
                for (final s in kProtoScreens.where((s) => s.flow == f))
                  ListTile(
                    dense: true,
                    title: Text('${s.code} · ${s.title}'),
                    subtitle: Text(s.id),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(context, PrototypePlayerPage(startId: s.id)),
                  ),
              ],
            ),
          header('Bileşenler ($componentCount)'),
          for (final g in kComponentGroups)
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(g.title),
              children: [
                for (final e in g.entries)
                  ListTile(
                    dense: true,
                    title: Text(e.name),
                    subtitle: Text('${e.variants.length} durum · ${e.source}', maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(context, ComponentPreviewPage(entry: e)),
                  ),
              ],
            ),
          header('Kapsam dışı'),
          for (final (name, why) in kOutOfScope)
            ListTile(dense: true, leading: const Icon(Icons.info_outline), title: Text(name), subtitle: Text(why)),
        ],
      ),
    );
  }
}
