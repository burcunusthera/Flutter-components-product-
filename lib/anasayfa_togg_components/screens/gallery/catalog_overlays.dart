import 'package:flutter/material.dart';

import '../../anasayfa_togg_components.dart';

/// Galeri · alt gezinme, panel, toast ve alt sayfalar.
final List<ComponentEntry> kOverlayEntries = [
  ComponentEntry(
    name: 'HomeBottomNav',
    source: 'DS BottomNav + HomeIndicator',
    file: 'widgets/navigation_bar/home_bottom_nav.dart',
    fullWidth: true,
    variants: [
      ComponentVariant('Premium', (context, n) => _nav(false, n)),
      ComponentVariant('Free · artı kilitli', (context, n) => _nav(true, n)),
    ],
  ),
  ComponentEntry(
    name: 'QuickActionsPanel',
    source: 'DS QuickActionsPanel (G2-4 / G2-5)',
    file: 'widgets/navigation_bar/quick_actions_panel.dart',
    variants: [
      ComponentVariant(
        'Çevrimiçi',
        (context, n) => _panelBg(QuickActionsPanel(
          items: defaultQuickActions(
            onMeal: () => n('Öğün ekle'),
            onMedicine: () => n('İlaç ekle'),
            onLabResult: () => n('Tahlil yorumlat'),
            onRecords: () => n('Sağlık kayıtlarım'),
          ),
          onClose: () => n('Kapat'),
        )),
      ),
      ComponentVariant(
        'Çevrimdışı (pasif)',
        (context, n) => _panelBg(QuickActionsPanel(items: defaultQuickActions(offline: true), onClose: () => n('Kapat'))),
      ),
    ],
  ),
  ComponentEntry(
    name: 'NdsToast',
    source: 'DS Toast + otomatik kapanma (4 sn, süre çizgisi) · durum bantları (D-20)',
    file: 'widgets/feedback/nds_toast.dart',
    variants: [
      for (final (t, text) in const [
        (ToastType.error, 'Veriler şu anda alınamıyor. Lütfen daha sonra tekrar deneyin.'),
        (ToastType.warning, 'İnternet bağlantısı yok. Kayıt işlemleri yapılamıyor.'),
        (ToastType.progress, 'Güncelleniyor…'),
        (ToastType.success, 'Kayıt tamamlandı.'),
        (ToastType.info, 'Bilgi mesajı.'),
      ])
        ComponentVariant(t.name, (context, n) => _ReplayToast(data: ToastData(t, text), notify: n)),
      ComponentVariant(
        'Alt toast (çizgisiz)',
        (context, n) => _ReplayToast(data: const ToastData(ToastType.error, 'Kayıt yapılamadı.'), notify: n, bar: false),
      ),
    ],
  ),
  ComponentEntry(
    name: 'ReminderActionSheet',
    source: 'DS Reminder/ActionSheet (Pending · Recorded)',
    file: 'widgets/reminder_sheets/reminder_action_sheet.dart',
    dark: true,
    variants: [
      ComponentVariant(
        'Bekleyen kayıt',
        (context, n) => ReminderActionSheet(title: 'B12 vitamini', recorded: false, onSelect: (o) => n(o.name), onClose: () => n('Kapat'), showHomeIndicator: true),
      ),
      ComponentVariant(
        'Kaydedilmiş',
        (context, n) => ReminderActionSheet(title: 'D vitamini', recorded: true, onSelect: (o) => n(o.name), onClose: () => n('Kapat'), showHomeIndicator: true),
      ),
    ],
  ),
  ComponentEntry(
    name: 'ReminderPostponeSheet · TileSelection',
    source: 'DS Reminder/PostponeSheet',
    file: 'widgets/reminder_sheets/reminder_postpone_sheet.dart',
    dark: true,
    variants: [
      ComponentVariant('Seçim yok · Ertele pasif', (context, n) => _PostponeDemo(notify: n)),
      ComponentVariant('15 dakika seçili', (context, n) => _PostponeDemo(notify: n, initial: '15 dakika')),
    ],
  ),
  ComponentEntry(
    name: 'ReminderEditRecordSheet · NdsInput',
    source: 'DS Reminder/EditRecordSheet',
    file: 'widgets/reminder_sheets/reminder_edit_record_sheet.dart',
    dark: true,
    variants: [
      ComponentVariant(
        'Kaydı düzenle',
        (context, n) => ReminderEditRecordSheet(
          name: 'D vitamini',
          meta: '1 adet · 08:00',
          statusText: 'Alındı · 08:03',
          time: '08:03',
          onSave: () => n('Kaydet'),
          onClose: () => n('Vazgeç'),
          showHomeIndicator: true,
        ),
      ),
    ],
  ),
  ComponentEntry(
    name: 'ConfirmBottomSheet',
    source: 'DS BottomSheet (silme onayı, R06 silinsin-mi 120)',
    file: 'widgets/reminder_sheets/confirm_bottom_sheet.dart',
    dark: true,
    variants: [
      ComponentVariant(
        'Hatırlatıcıyı sil',
        (context, n) => ConfirmBottomSheet(
          title: 'Hatırlatıcıyı silmek istediğinize emin misiniz?',
          description: 'Bu günlük hatırlatıcı programınızdan kaldırılacaktır. Silinen hatırlatıcı geri alınamaz.',
          primaryAction: 'Hatırlatıcıyı sil',
          onPrimary: () => n('Hatırlatıcıyı sil'),
          onSecondary: () => n('Vazgeç'),
          onClose: () => n('Kapat'),
        ),
      ),
    ],
  ),
  ComponentEntry(
    name: 'PremiumSheet',
    source: 'E2 · Premium Bottom Sheet (6738:106868)',
    file: 'widgets/premium/premium_sheet.dart',
    fullWidth: true,
    dark: true,
    variants: [
      ComponentVariant('Premium ile tam deneyim', (context, n) => PremiumSheet(onClose: () => n('Kapat'), onExplore: () => n('Premium’u şimdi keşfet'))),
    ],
  ),
  ComponentEntry(
    name: 'ScoreTargetScreen',
    source: 'App CodedTarget — 03 · Skor sayfaları (kapsam dışı modülün görüntüsü)',
    file: 'screens/score_target_screen.dart',
    fullWidth: true,
    variants: [
      for (final k in SubScoreKind.values)
        ComponentVariant(
          '${k.title} skorum',
          (context, n) => SizedBox(height: 812, child: ScoreTargetScreen(kind: k, onBack: () => n('Geri → Ana Sayfa'))),
        ),
    ],
  ),
];

Widget _nav(bool free, PreviewNotify n) => Column(mainAxisSize: MainAxisSize.min, children: [
      HomeBottomNav(plusLocked: free, onChanged: (t) => n('Sekme: ${t.name}'), onPlus: () => n(free ? 'Premium' : 'Hızlı Aksiyonlar')),
      const NdsHomeIndicator(),
    ]);

Widget _panelBg(Widget panel) => Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: NdsColors.grey50, borderRadius: BorderRadius.circular(24)),
      child: panel,
    );

class _ReplayToast extends StatefulWidget {
  const _ReplayToast({required this.data, required this.notify, this.bar = true});

  final ToastData data;
  final PreviewNotify notify;
  final bool bar;

  @override
  State<_ReplayToast> createState() => _ReplayToastState();
}

class _ReplayToastState extends State<_ReplayToast> {
  int _n = 0;
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SizedBox(
        height: 90,
        child: _visible
            ? NdsToast(
                key: ValueKey(_n),
                data: widget.data,
                bar: widget.bar,
                onClose: () => setState(() => _visible = false),
              )
            : const SizedBox.shrink(),
      ),
      TextButton(
        onPressed: () => setState(() {
          _n++;
          _visible = true;
        }),
        child: const Text('Yeniden göster'),
      ),
    ]);
  }
}

class _PostponeDemo extends StatefulWidget {
  const _PostponeDemo({required this.notify, this.initial});

  final PreviewNotify notify;
  final String? initial;

  @override
  State<_PostponeDemo> createState() => _PostponeDemoState();
}

class _PostponeDemoState extends State<_PostponeDemo> {
  late String? _sel = widget.initial;

  @override
  Widget build(BuildContext context) => ReminderPostponeSheet(
        name: 'B12 vitamini',
        plannedText: 'Planlanan saat 09:00',
        selected: _sel,
        onSelect: (o) => setState(() => _sel = o),
        onConfirm: () {
          final min = postponeMinutes(_sel ?? '');
          widget.notify(min == null ? 'Saat seç → işletim sistemi saat seçicisi' : 'Yeni saat: ${addMinutes('09:00', min)}');
        },
        onClose: () => widget.notify('Vazgeç'),
        showHomeIndicator: true,
      );
}
