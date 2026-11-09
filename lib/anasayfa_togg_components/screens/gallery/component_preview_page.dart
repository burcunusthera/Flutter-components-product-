import 'package:flutter/material.dart';

import '../../theme/nds_colors.dart';
import 'component_entry.dart';

/// Tek bir bileşenin durum önizlemesi: üstte durum seçimi, altta 375 genişlikte bileşen.
class ComponentPreviewPage extends StatefulWidget {
  const ComponentPreviewPage({super.key, required this.entry});

  final ComponentEntry entry;

  @override
  State<ComponentPreviewPage> createState() => _ComponentPreviewPageState();
}

class _ComponentPreviewPageState extends State<ComponentPreviewPage> {
  int _i = 0;

  void _notify(String m) {
    final s = ScaffoldMessenger.of(context);
    s.hideCurrentSnackBar();
    s.showSnackBar(SnackBar(content: Text(m), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final v = e.variants[_i];
    final body = KeyedSubtree(key: ValueKey(_i), child: Builder(builder: (context) => v.builder(context, _notify)));
    return Scaffold(
      backgroundColor: e.dark ? const Color(0xFF6E6E73) : const Color(0xFFF2F3F5),
      appBar: AppBar(title: Text(e.name), backgroundColor: NdsColors.grey0, foregroundColor: NdsColors.grey900),
      body: Column(children: [
        Material(
          color: NdsColors.grey0,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Text('${e.source}\n${e.file}', style: Theme.of(context).textTheme.bodySmall),
            ),
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  for (var k = 0; k < e.variants.length; k++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(e.variants[k].label),
                        selected: k == _i,
                        onSelected: (_) => setState(() => _i = k),
                      ),
                    ),
                ],
              ),
            ),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(
                width: 375,
                child: e.fullWidth
                    ? body
                    : ColoredBox(
                        color: e.dark ? Colors.transparent : NdsColors.grey0,
                        child: Padding(padding: const EdgeInsets.all(20), child: body),
                      ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
