import 'package:flutter/material.dart';

import '../../navigation/prototype_controller.dart';
import '../../navigation/prototype_states.dart';
import '../../navigation/scenarios.dart';
import '../../theme/nds_colors.dart';
import '../prototype_home_screen.dart';
import 'device_frame.dart';

/// Oynatıcı: prototipi seçilen kareden başlatır (Oynat board’unun Flutter karşılığı).
/// Üstte geçerli kare, senaryo seçimleri ve yeniden başlatma; modül dışı hedefler SnackBar olarak bildirilir.
class PrototypePlayerPage extends StatefulWidget {
  const PrototypePlayerPage({super.key, required this.startId});

  final String startId;

  @override
  State<PrototypePlayerPage> createState() => _PrototypePlayerPageState();
}

class _PrototypePlayerPageState extends State<PrototypePlayerPage> {
  late final PrototypeController _c = PrototypeController(start: widget.startId, onNotice: _notice);

  void _notice(ProtoNotice n) {
    if (!mounted) return;
    final s = ScaffoldMessenger.of(context);
    s.hideCurrentSnackBar();
    s.showSnackBar(SnackBar(
      content: Text('${n.title}\n${n.detail}'),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _scenarios() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            const Text('Senaryo (akışların sonucu)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            for (final g in PrototypeScenario.options.entries) ...[
              const SizedBox(height: 12),
              Text(g.key),
              Wrap(spacing: 6, children: [
                for (final o in g.value)
                  ChoiceChip(
                    label: Text(o),
                    selected: _c.scenario.valueOf(g.key) == o,
                    onSelected: (_) => setLocal(() => _c.scenario = _c.scenario.withValue(g.key, o)),
                  ),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      appBar: AppBar(
        backgroundColor: NdsColors.grey0,
        foregroundColor: NdsColors.grey900,
        title: ListenableBuilder(
          listenable: _c,
          builder: (context, _) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_c.current.code, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('${_c.current.title} · ${_c.current.id}', style: const TextStyle(fontSize: 12)),
          ]),
        ),
        actions: [
          IconButton(tooltip: 'Senaryo', icon: const Icon(Icons.tune), onPressed: _scenarios),
          IconButton(tooltip: 'Bu kareden yeniden başlat', icon: const Icon(Icons.replay), onPressed: () => _c.restart(widget.startId)),
          PopupMenuButton<String>(
            tooltip: 'Kareye git',
            icon: const Icon(Icons.list),
            onSelected: (id) => _c.go(id, anim: ProtoAnim.none),
            itemBuilder: (_) => [
              for (final s in kProtoScreens) PopupMenuItem(value: s.id, child: Text('${s.code} · ${s.title}')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: DeviceFrame(child: PrototypeHomeScreen(controller: _c)),
      ),
    );
  }
}
