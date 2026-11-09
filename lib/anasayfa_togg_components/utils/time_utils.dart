/// “HH:mm” saatine dakika ekler, gün sınırında sarar (App `addMin`).
String addMinutes(String hm, int minutes) {
  final p = hm.split(':');
  if (p.length != 2) return hm;
  final h = int.tryParse(p[0]);
  final m = int.tryParse(p[1]);
  if (h == null || m == null) return hm;
  final t = ((h * 60 + m + minutes) % 1440 + 1440) % 1440;
  return '${(t ~/ 60).toString().padLeft(2, '0')}:${(t % 60).toString().padLeft(2, '0')}';
}
