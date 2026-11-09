import 'package:flutter/material.dart';

import '../../anasayfa_togg_components.dart';

/// Galeri · Ana sayfa kartları ve üst bar.
/// Önizlemelerdeki sayılar [MockData] örnekleridir.
final List<ComponentEntry> kCardEntries = [
  ComponentEntry(
    name: 'HomeTopBar',
    source: 'App TopBar · DS Header (profile) + Avatar R06',
    file: 'widgets/top_bar/home_top_bar.dart',
    fullWidth: true,
    variants: [
      for (final (label, plan, badge, compact) in const [
        ('Premium', PlanType.premium, 0, false),
        ('Free (Standard)', PlanType.free, 0, false),
        ('Bildirim rozeti (3)', PlanType.premium, 3, false),
        ('Temel kare · 40 px butonlar', PlanType.premium, 0, true),
      ])
        ComponentVariant(
          label,
          (context, n) => HomeTopBar(
            title: 'Nusthera',
            greeting: 'Merhaba Melis',
            plan: plan,
            badgeCount: badge,
            compactButtons: compact,
            statusBarHeight: 58,
            onSettings: () => n('Ayarlar → 06 · Ayarlar'),
            onNotifications: () => n('Bildirimler → 07 · Bildirimler'),
          ),
        ),
    ],
  ),
  ComponentEntry(
    name: 'SubScoreCarousel',
    source: 'App TodayCarousel / todaySlides (Togg alt skor kartları)',
    file: 'widgets/sub_score/sub_score_carousel.dart',
    variants: [
      for (final st in SubScoreState.values)
        ComponentVariant(
          st.name,
          (context, n) => SubScoreCarousel(
            key: ValueKey(st),
            state: st,
            scores: MockData.subScores,
            staleLabel: MockData.staleLabel,
            onOpenScore: (k) => n('Detay → ${k.title} skorum (03 · Skor)'),
            onRetry: () => n('Tekrar dene → yalnız skor kaynağı'),
            onConnectDevice: () => n('Cihaz bağla → 06'),
            onManagePermissions: () => n('İzinleri yönet → OS izin ekranı'),
          ),
        ),
    ],
  ),
  ComponentEntry(
    name: 'SubScoreCard',
    source: 'Tek kart: DS TodayCard zemini + TodayDeco + OverallScore + cam yuva (269 px)',
    file: 'widgets/sub_score/sub_score_card.dart',
    variants: [
      for (final (label, slide) in [
        ('Veri var · 40', SubScoreSlide(kind: SubScoreKind.activity, value: 40, btnLabel: 'Detayları gör', chevron: true, link: true, onBtn: () {})),
        ('Güncel değil', SubScoreSlide(kind: SubScoreKind.sleep, value: 73, btnLabel: 'Detayları gör', chevron: true, link: true, onBtn: () {})),
        ('Yükleniyor', const SubScoreSlide(kind: SubScoreKind.recovery, name: 'Hesaplanıyor…', busy: true)),
        ('Bilgi notu', const SubScoreSlide(kind: SubScoreKind.sleep, name: 'Veri yetersiz', info: 'Uyku skorunuz, gereken veri oluştuğunda hesaplanır.')),
      ])
        ComponentVariant(
          label,
          (context, n) => SizedBox(
            height: 269,
            child: SubScoreCard(slide: slide, stale: label == 'Güncel değil' ? MockData.staleLabel : null, focusable: true),
          ),
        ),
    ],
  ),
  ComponentEntry(
    name: 'OverallScoreGauge',
    source: 'DS OverallScore (21 dilim, 295×116) + scoreName',
    file: 'widgets/sub_score/overall_score_gauge.dart',
    variants: [
      for (final v in const [null, 0, 7, 20, 40, 60, 73, 80, 93, 100])
        ComponentVariant(
          v == null ? 'Değer yok' : '$v',
          (context, n) => _onCard(OverallScoreGauge(value: v)),
        ),
      ComponentVariant('Yükleniyor', (context, n) => _onCard(const OverallScoreGauge(value: null, name: 'Hesaplanıyor…', busy: true))),
    ],
  ),
  ComponentEntry(
    name: 'GlassActionButton',
    source: 'App .m-tglass (cam eylem butonu), bilgi notu ve iskelet',
    file: 'widgets/sub_score/glass_action_button.dart',
    variants: [
      ComponentVariant('Detayları gör ›', (context, n) => _onCard(GlassActionButton(label: 'Detayları gör', chevron: true, onTap: () => n('Detayları gör')))),
      ComponentVariant('Tekrar dene', (context, n) => _onCard(GlassActionButton(label: 'Tekrar dene', icon: 'User Interface/refresh', onTap: () => n('Tekrar dene')))),
      ComponentVariant('İzinleri yönet', (context, n) => _onCard(GlassActionButton(label: 'İzinleri yönet', icon: 'User Interface/shield', onTap: () => n('İzinleri yönet')))),
      ComponentVariant('Cihaz bağla', (context, n) => _onCard(GlassActionButton(label: 'Cihaz bağla', icon: 'User Interface/smartwatch', onTap: () => n('Cihaz bağla')))),
    ],
  ),
  ComponentEntry(
    name: 'TodayBackground · TodayDeco',
    source: 'DS TodayCard zemini (objectBoundingBox gradyan) + köşe dekoru',
    file: 'widgets/sub_score/today_background.dart, today_deco.dart',
    variants: [
      ComponentVariant(
        'Zemin + dekor',
        (context, n) => ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: const SizedBox(
            height: 269,
            child: CustomPaint(
              painter: TodayBackground(),
              child: Stack(clipBehavior: Clip.none, children: [Positioned(top: -42.875, right: -102.677, child: TodayDeco())]),
            ),
          ),
        ),
      ),
    ],
  ),
  ComponentEntry(
    name: 'StressMonitorCard',
    source: 'App StressView (Figma 6730:233991)',
    file: 'widgets/stress/stress_monitor_card.dart',
    variants: [
      for (final st in StressState.values)
        ComponentVariant(
          st.name,
          (context, n) => StressMonitorCard(
            data: HomeMapper.stress(HomeState(stress: st, mood: st == StressState.stale ? StressMood.sakin : StressMood.rahatlamis)),
            onDetails: () => n('Detaylar → Tasarım yok'),
            onConnectDevice: () => n('Cihaz bağla'),
            onManagePermissions: () => n('İzinleri yönet'),
            onRetry: () => n('Tekrar dene'),
          ),
        ),
      for (final m in StressMood.values)
        ComponentVariant(
          'data · ${m.label}',
          (context, n) => StressMonitorCard(data: HomeMapper.stress(HomeState(mood: m)), onDetails: () => n('Detaylar')),
        ),
    ],
  ),
  ComponentEntry(
    name: 'StressFaces · StressTag',
    source: 'App Faces · DS Mood (R06 Kompakt) · DS StressTag',
    file: 'widgets/stress/stress_faces.dart, stress_tag.dart',
    variants: [
      for (final m in StressMood.values) ComponentVariant(m.label, (context, n) => Center(child: StressFaces(mood: m))),
      ComponentVariant(
        'Etiketler',
        (context, n) => Wrap(spacing: 8, runSpacing: 8, children: [for (final m in StressMood.values) StressTag(mood: m)]),
      ),
    ],
  ),
  ComponentEntry(
    name: 'NutritionCard',
    source: 'DS NutritionSummaryCard + App NutriView',
    file: 'widgets/nutrition/nutrition_card.dart',
    variants: [
      for (final k in NutriKey.values)
        ComponentVariant(
          k.name,
          (context, n) => NutritionCard(
            data: HomeMapper.nutrition(HomeState(nutri: k)),
            onDetails: () => n('Detaylar → 04 · Beslenme'),
            onUpgrade: () => n('Planınızı yükseltin → Premium'),
            onRetry: () => n('Tekrar dene'),
            onAddMeal: () => n('Öğün ekle'),
          ),
        ),
    ],
  ),
  ComponentEntry(
    name: 'MacroMetric · MacroRing',
    source: 'DS MacroMetric + MacroProgress',
    file: 'widgets/nutrition/macro_metric.dart, macro_ring.dart',
    variants: [
      for (final st in MacroMetricState.values)
        ComponentVariant(
          st.name,
          (context, n) => Row(children: [
            for (final (k, v) in const [(MacroKind.fat, MockData.fat), (MacroKind.carbs, MockData.carbs), (MacroKind.protein, MockData.protein)])
              Expanded(child: MacroMetric(macro: k, state: st, v: v)),
          ]),
        ),
    ],
  ),
  ComponentEntry(
    name: 'ReminderCard',
    source: 'DS ReminderCard + App RemView (“Günlük planım”)',
    file: 'widgets/reminder/reminder_card.dart',
    variants: [
      for (final st in ReminderCardState.values)
        ComponentVariant(
          st.name,
          (context, n) => _ExpandableReminderCard(state: st, notify: n),
        ),
      ComponentVariant('collapsed · çevrimdışı', (context, n) => _ExpandableReminderCard(state: ReminderCardState.collapsed, notify: n, offline: true)),
    ],
  ),
  ComponentEntry(
    name: 'ReminderItem',
    source: 'DS ReminderItem (17 durum) + durum etiketi/işareti, aksiyon butonları, Başla',
    file: 'widgets/reminder/reminder_item.dart',
    variants: [
      for (final st in ReminderItemState.values)
        ComponentVariant(
          st.name,
          (context, n) => ReminderItem(
            data: ReminderItemData(id: 'x', title: st.name.startsWith('activity') ? 'Hafif yürüyüş' : 'B12 vitamini', meta: st.name.startsWith('activity') ? '20 dk · 09:30' : '1 tablet · 09:00', state: st),
            onSkip: () => n('Atla'),
            onConfirm: () => n('Aldım'),
            onStart: () => n('Başla'),
            onPause: () => n('Duraklat'),
            onResume: () => n('Devam'),
            onFinish: () => n('Bitir'),
            onUndo: () => n('Geri al'),
            onMenu: () => n('⋮ menüsü'),
          ),
        ),
      ComponentVariant(
        'due · çevrimdışı (pasif)',
        (context, n) => ReminderItem(
          data: MockData.reminders[2],
          disabled: true,
          onSkip: () => n('Atla'),
          onConfirm: () => n('Aldım'),
          onMenu: () => n('⋮'),
        ),
      ),
    ],
  ),
  ComponentEntry(
    name: 'ReminderThumbnail · StatusMark · ActionButton · StartButton · ExpandToggle',
    source: 'DS ReminderThumbnail, ReminderStatusMark, ReminderActionButton, ReminderStartButton, ExpandToggle',
    file: 'widgets/reminder/*.dart',
    variants: [
      ComponentVariant(
        'Görseller',
        (context, n) => Wrap(spacing: 12, runSpacing: 12, children: [
          for (final t in ReminderThumb.values) ReminderThumbnail(t),
          const ReminderThumbnail(null),
        ]),
      ),
      ComponentVariant(
        'İşaretler',
        (context, n) => Wrap(spacing: 12, children: [for (final t in ReminderMarkType.values) ReminderStatusMark(t)]),
      ),
      ComponentVariant(
        'Aksiyon butonları',
        (context, n) => Wrap(spacing: 8, runSpacing: 12, children: [
          for (final k in ReminderActionKind.values) ReminderActionButton(kind: k, onTap: () => n(k.name)),
          const ReminderActionButton(kind: ReminderActionKind.pause, dimmed: true),
          const ReminderActionButton(kind: ReminderActionKind.finish, loading: true),
          ReminderActionButton(kind: ReminderActionKind.confirm, offline: true, onTap: () {}),
        ]),
      ),
      ComponentVariant('Başla', (context, n) => Align(alignment: Alignment.centerLeft, child: ReminderStartButton(onTap: () => n('Başla')))),
      ComponentVariant(
        'Genişlet',
        (context, n) => Column(children: [
          ExpandToggle(expanded: false, hiddenCount: 8, onTap: () => n('Daha fazla göster')),
          ExpandToggle(expanded: true, hiddenCount: 8, onTap: () => n('Daha az göster')),
        ]),
      ),
    ],
  ),
  ComponentEntry(
    name: 'DeviceDataSection',
    source: 'DS DeviceDataSection + App DevView (+ R06 72 boş durumlarda)',
    file: 'widgets/device/device_data_section.dart',
    variants: [
      for (final k in DevKey.values)
        ComponentVariant(
          k.name,
          (context, n) => DeviceDataSection(
            data: HomeMapper.devices(HomeState(dev: k)),
            onSeeAll: () => n('Hepsini gör → Tasarım yok'),
            onAction: () => n('Boş durum eylemi'),
            onRetryMetric: (m) => n('Tekrar dene: ${m.title}'),
          ),
        ),
      ComponentVariant(
        'F3 · yeni gün',
        (context, n) => DeviceDataSection(data: HomeMapper.devices(const HomeState(devItemsF3: true)), onRetryMetric: (m) => n('Tekrar dene: ${m.title}')),
      ),
    ],
  ),
  ComponentEntry(
    name: 'DeviceMetricCard',
    source: 'DS DeviceMetricCard (6 metrik × 5 durum)',
    file: 'widgets/device/device_metric_card.dart',
    variants: [
      for (final st in MetricState.values)
        ComponentVariant(
          st.name,
          (context, n) => Column(children: [
            for (var i = 0; i < DeviceMetric.values.length; i += 2) ...[
              if (i > 0) const SizedBox(height: 8),
              Row(children: [
                Expanded(child: DeviceMetricCard(data: MockData.metric(DeviceMetric.values[i], st), onRetry: () => n('Tekrar dene'))),
                const SizedBox(width: 8),
                Expanded(child: DeviceMetricCard(data: MockData.metric(DeviceMetric.values[i + 1], st), onRetry: () => n('Tekrar dene'))),
              ]),
            ],
          ]),
        ),
    ],
  ),
  ComponentEntry(
    name: 'MetricStatusBadge · VerticalMetricIndicator',
    source: 'DS MetricStatusBadge + VerticalMetricIndicator',
    file: 'widgets/device/metric_status_badge.dart, vertical_metric_indicator.dart',
    variants: [
      ComponentVariant('Rozetler', (context, n) => Wrap(spacing: 8, children: [for (final t in MetricTone.values) MetricStatusBadge(tone: t)])),
      ComponentVariant(
        'Dikey gösterge',
        (context, n) => Wrap(spacing: 24, children: [
          for (final (t, l) in const [(MetricTone.success, 50), (MetricTone.primary, 89), (MetricTone.warning, 27), (null, 50)])
            VerticalMetricIndicator(tone: t, level: l),
        ]),
      ),
    ],
  ),
];

/// Kart zemini üstünde gösterim (cam buton ve gösterge beyaz zeminde görünmez).
Widget _onCard(Widget child) => ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CustomPaint(
        painter: const TodayBackground(),
        child: Padding(padding: const EdgeInsets.all(20), child: Center(child: child)),
      ),
    );

class _ExpandableReminderCard extends StatefulWidget {
  const _ExpandableReminderCard({required this.state, required this.notify, this.offline = false});

  final ReminderCardState state;
  final PreviewNotify notify;
  final bool offline;

  @override
  State<_ExpandableReminderCard> createState() => _ExpandableReminderCardState();
}

class _ExpandableReminderCardState extends State<_ExpandableReminderCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.notify;
    final d = HomeMapper.reminders(HomeState(rem: widget.state, offline: widget.offline));
    return ReminderCard(
      data: d,
      expanded: _open,
      onToggle: (v) => setState(() => _open = v),
      onSeeAll: () => n('Tümünü gör → 04 · İlaçlarım'),
      onUpgrade: () => n('Planınızı yükseltin → Premium'),
      onCreate: () => n('Hatırlatıcı oluştur'),
      onRetry: () => n('Tekrar dene'),
      onSkip: (it) => n('Atla: ${it.title}'),
      onConfirm: (it) => n('Aldım: ${it.title}'),
      onStart: (it) => n('Başla: ${it.title}'),
      onMenu: (it) => n('⋮ ${it.title}'),
    );
  }
}
