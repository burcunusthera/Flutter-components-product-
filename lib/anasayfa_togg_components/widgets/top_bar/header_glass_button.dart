import 'package:flutter/material.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/glass_surface.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';

/// DS .nds-header__glass: 44×44, padding 8, kenar 1 Greyscale/300, radius 10,
/// zemin rgba(255,255,255,.1), blur 10, ikon 24 Greyscale/100.
/// Rozet (.m-bell__n): ikonun solundan 22, üstünden −14; 16 yükseklik, Danger/500, 2 px beyaz halka.
class HeaderGlassButton extends StatelessWidget {
  const HeaderGlassButton({super.key, required this.icon, required this.label, this.badge, this.onTap, this.size = 44});

  final String icon;
  final String label;
  final int? badge;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      excludeChildSemantics: true,
      builder: (context, _) => SizedBox(
        width: size,
        height: size,
        child: Stack(clipBehavior: Clip.none, children: [
          GlassSurface(
            width: size,
            height: size,
            radius: BorderRadius.circular(10),
            blur: 10,
            color: const Color(0x1AFFFFFF),
            border: Border.all(color: NdsColors.grey300),
            child: Center(child: NdsIcon(icon, size: 24, color: NdsColors.grey100)),
          ),
          if (badge != null)
            Positioned(
              // ikon kutusu (44 − 24) / 2 = 10 içeride; CSS: left 22, top −14 (ikona göre)
              left: (size - 24) / 2 + 22,
              top: (size - 24) / 2 - 14,
              child: Container(
                constraints: const BoxConstraints(minWidth: 16),
                height: 16,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: NdsColors.danger500,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [BoxShadow(color: NdsColors.grey0, spreadRadius: 2)],
                ),
                child: Text('$badge', style: ndsText(12, 16, 600, NdsColors.grey0)),
              ),
            ),
        ]),
      ),
    );
  }
}
