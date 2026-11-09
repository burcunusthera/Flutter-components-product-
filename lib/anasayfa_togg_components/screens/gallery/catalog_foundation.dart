import 'package:flutter/material.dart';

import '../../anasayfa_togg_components.dart';

/// Galeri · temel bileşenler, ikonlar, R06 ve token'lar.
final List<ComponentEntry> kFoundationEntries = [
  ComponentEntry(
    name: 'NdsButton',
    source: 'DS Button (large: primary, secondary, error)',
    file: 'widgets/common/nds_button.dart',
    variants: [
      ComponentVariant('Primary', (context, n) => NdsButton(label: 'Premium’u şimdi keşfet', onTap: () => n('Primary'))),
      ComponentVariant('Secondary', (context, n) => NdsButton(label: 'Tekrar dene', type: NdsButtonType.secondary, onTap: () => n('Secondary'))),
      ComponentVariant('Destructive', (context, n) => NdsButton(label: 'Hatırlatıcıyı sil', type: NdsButtonType.destructive, onTap: () => n('Destructive'))),
      ComponentVariant('Disabled', (context, n) => const NdsButton(label: 'Ertele')),
      ComponentVariant('Secondary disabled', (context, n) => const NdsButton(label: 'Vazgeç', type: NdsButtonType.secondary)),
    ],
  ),
  ComponentEntry(
    name: 'NdsOutlineButton',
    source: 'DS .nds-outline-btn (48) ve .is-small (40)',
    file: 'widgets/common/nds_outline_button.dart',
    variants: [
      ComponentVariant('Normal', (context, n) => NdsOutlineButton(label: 'Öğün ekle', onTap: () => n('Öğün ekle'))),
      ComponentVariant('Small', (context, n) => NdsOutlineButton(label: 'Hatırlatıcı oluştur', small: true, onTap: () => n('Hatırlatıcı oluştur'))),
    ],
  ),
  ComponentEntry(
    name: 'TileSelection · NdsInput',
    source: 'DS TileSelection (radio) · DS Input',
    file: 'widgets/common/tile_selection.dart, nds_input.dart',
    variants: [
      ComponentVariant('Tile · seçili değil', (context, n) => TileSelection(label: '10 dakika', selected: false, onTap: () => n('10 dakika'))),
      ComponentVariant('Tile · seçili', (context, n) => TileSelection(label: '15 dakika', selected: true, onTap: () => n('15 dakika'))),
      ComponentVariant('Input', (context, n) => const NdsInput(label: 'Gerçekleşen saat', initialValue: '08:03')),
    ],
  ),
  ComponentEntry(
    name: 'CardHeader · CategoryIcon · ActionLink · PremiumChip',
    source: 'DS CardHeader, CategoryIcon, ActionLink, PremiumChip',
    file: 'widgets/common/card_header.dart …',
    variants: [
      ComponentVariant('Beslenme', (context, n) => CardHeader(icon: 'Shopping&Ecommerce/tableware', title: 'Beslenme', action: ActionLink(label: 'Detaylar', onTap: () => n('Detaylar')))),
      ComponentVariant('Alt başlıklı', (context, n) => CardHeader(icon: 'Shopping&Ecommerce/tableware', title: 'Beslenme', subtitle: 'Bugün alınan / günlük hedef', action: ActionLink(label: 'Detaylar', onTap: () => n('Detaylar')))),
      ComponentVariant('Kilitli (Premium chip)', (context, n) => const CardHeader(icon: 'Date & Time/alarm', title: 'Günlük planım', badge: PremiumChip())),
      ComponentVariant('Yükleniyor', (context, n) => const CardHeader(title: '', loading: true)),
      ComponentVariant('ActionLink pasif', (context, n) => const ActionLink(label: 'Hepsini gör', enabled: false)),
    ],
  ),
  ComponentEntry(
    name: 'PremiumLock',
    source: 'DS PremiumLock (LockGold)',
    file: 'widgets/common/premium_lock.dart',
    variants: [
      ComponentVariant('Beslenme', (context, n) => PremiumLock(title: 'Kişiselleştirilmiş beslenme içgörülerine erişin', onAction: () => n('Planınızı yükseltin'))),
      ComponentVariant('Hatırlatıcılar', (context, n) => PremiumLock(title: 'İlaç, vitamin ve aktivite hatırlatıcılarına erişin', onAction: () => n('Planınızı yükseltin'))),
    ],
  ),
  ComponentEntry(
    name: 'NdsPager · NdsSkel · NdsSpinner · NdsHomeIndicator',
    source: 'DS Slider, .nds-skel, .m-spin, HomeIndicator',
    file: 'widgets/common/*.dart',
    variants: [
      ComponentVariant('Pager', (context, n) => const _PagerDemo()),
      ComponentVariant('İskelet', (context, n) => const Wrap(spacing: 8, runSpacing: 8, children: [NdsSkel(width: 96, height: 14), NdsSkel(width: 140, height: 16, radius: 6), NdsSkel(width: 56, height: 24, radius: 100)])),
      ComponentVariant('Spinner', (context, n) => const Center(child: NdsSpinner())),
      ComponentVariant('Ana gösterge', (context, n) => const NdsHomeIndicator()),
    ],
  ),
  ComponentEntry(
    name: 'R06 (Therus Kompakt)',
    source: 'DS R06K — Lottie (assets/anasayfa_togg_components/animations)',
    file: 'widgets/common/r06.dart',
    variants: [
      ComponentVariant(
        'Tüm durumlar',
        (context, n) => Wrap(spacing: 12, runSpacing: 16, children: [
          for (final s in R06State.values)
            SizedBox(
              width: 96,
              child: Column(children: [
                R06(s, size: 74, dropShadow: s.index >= 2 && s.index <= 6),
                const SizedBox(height: 4),
                Text(s.file, textAlign: TextAlign.center, style: ndsText(12, 15, 400, NdsColors.grey500)),
              ]),
            ),
        ]),
      ),
    ],
  ),
  ComponentEntry(
    name: 'NdsIcon',
    source: 'DS ikonları (bu ekranda kullanılan 48 ikon, currentColor)',
    file: 'widgets/common/nds_icon.dart · theme/nds_icons.dart',
    variants: [
      ComponentVariant(
        'Tüm ikonlar',
        (context, n) => Wrap(spacing: 8, runSpacing: 12, children: [
          for (final name in kNdsIcons.keys)
            SizedBox(
              width: 104,
              child: Column(children: [
                NdsIcon(name, size: 24, color: NdsColors.grey900),
                const SizedBox(height: 4),
                Text(name, textAlign: TextAlign.center, maxLines: 2, style: ndsText(10, 13, 400, NdsColors.grey500)),
              ]),
            ),
        ]),
      ),
    ],
  ),
  ComponentEntry(
    name: 'Token’lar',
    source: 'NustheraDS v1.4.12 tokens.css (renk, gölge, Outfit)',
    file: 'theme/*.dart',
    variants: [
      ComponentVariant('Renkler', (context, n) => const _Swatches()),
      ComponentVariant(
        'Tipografi',
        (context, n) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (final (s, lh, w) in const [(24.0, 30.0, 700), (18.0, 23.0, 600), (16.0, 20.0, 600), (14.0, 18.0, 500), (14.0, 18.0, 400), (12.0, 15.0, 500), (12.0, 15.0, 400)])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Outfit ${s.toInt()}/${lh.toInt()}/$w · Günlük planım', style: ndsText(s, lh, w, NdsColors.grey900)),
            ),
        ]),
      ),
      ComponentVariant(
        'Gölgeler',
        (context, n) => Row(children: [
          for (final (l, sh) in const [('shadow-200', NdsShadows.s200), ('shadow-400', NdsShadows.s400), ('toast', NdsShadows.toast)])
            Expanded(
              child: Container(
                height: 80,
                margin: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: NdsColors.grey0, borderRadius: BorderRadius.circular(16), boxShadow: sh),
                child: Text(l, style: ndsText(12, 15, 400, NdsColors.grey500)),
              ),
            ),
        ]),
      ),
    ],
  ),
];

class _PagerDemo extends StatefulWidget {
  const _PagerDemo();

  @override
  State<_PagerDemo> createState() => _PagerDemoState();
}

class _PagerDemoState extends State<_PagerDemo> {
  int _i = 0;

  @override
  Widget build(BuildContext context) => Center(child: NdsPager(count: 3, active: _i, onChanged: (i) => setState(() => _i = i)));
}

class _Swatches extends StatelessWidget {
  const _Swatches();

  static const _c = <(String, Color)>[
    ('Primary/500', NdsColors.primary500),
    ('Primary/50', NdsColors.primary50),
    ('Greyscale/900', NdsColors.grey900),
    ('Greyscale/500', NdsColors.grey500),
    ('Greyscale/400', NdsColors.grey400),
    ('Greyscale/100', NdsColors.grey100),
    ('Greyscale/50', NdsColors.grey50),
    ('Greyscale/25', NdsColors.grey25),
    ('Secondary/100', NdsColors.secondary100),
    ('Secondary/500', NdsColors.secondary500),
    ('Success/500', NdsColors.success500),
    ('Warning/500', NdsColors.warning500),
    ('Warning/800', NdsColors.warning800),
    ('Danger/500', NdsColors.danger500),
    ('Info/500', NdsColors.info500),
    ('Makro yağ', NdsColors.macroFat),
    ('Makro karbonhidrat', NdsColors.macroCarbs),
  ];

  @override
  Widget build(BuildContext context) => Wrap(spacing: 8, runSpacing: 8, children: [
        for (final (l, c) in _c)
          SizedBox(
            width: 100,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 40, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8), border: Border.all(color: NdsColors.grey100))),
              const SizedBox(height: 4),
              Text(l, style: ndsText(11, 14, 400, NdsColors.grey500)),
            ]),
          ),
      ]);
}
