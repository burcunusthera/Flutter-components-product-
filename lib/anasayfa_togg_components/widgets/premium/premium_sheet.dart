import 'package:flutter/material.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/nds_button.dart';
import '../common/nds_icon.dart';
import '../common/pressable.dart';

/// Premium alt sayfası (E2 · 6738:106868): 375×656, üst radius 36.
class PremiumSheet extends StatelessWidget {
  const PremiumSheet({super.key, this.onClose, this.onExplore});

  final VoidCallback? onClose;
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
      child: Container(
        height: 656,
        color: NdsColors.grey0,
        child: Stack(children: [
          Positioned(
            right: 24,
            top: 24,
            child: Pressable(
              onTap: onClose,
              semanticLabel: 'Kapat',
              excludeChildSemantics: true,
              builder: (context, _) => const NdsIcon('Atoms/x', size: 24, color: NdsColors.grey900),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 72,
            child: Text('Premium ile tam deneyim', textAlign: TextAlign.center, style: ndsText(24, 30, 700, NdsColors.grey900)),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 106,
            child: Center(
              child: Image.asset('$kAssetRoot/images/premium_art.png', width: 375, height: 278, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 392,
            child: Column(children: [
              Text('Sağlığınızı bütünsel takip edin', textAlign: TextAlign.center, style: ndsText(24, 30, 500, NdsColors.grey900)),
              const SizedBox(height: 16),
              Text(
                'Premium ile beslenme ve ilaç takibinden kişisel sağlık skorlarınıza kadar farklı sağlık alanlarını tek bir deneyimde takip edin.',
                textAlign: TextAlign.center,
                style: ndsText(16, 20, 400, NdsColors.grey700),
              ),
            ]),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 522,
            child: NdsButton(label: 'Premium’u şimdi keşfet', onTap: onExplore),
          ),
        ]),
      ),
    );
  }
}

/// Premium sayfasını örtü (rgba(13,13,18,.6)) ile açar.
Future<void> showPremiumSheet(BuildContext context, {VoidCallback? onExplore}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: NdsColors.scrim,
    builder: (ctx) => PremiumSheet(onClose: () => Navigator.of(ctx).pop(), onExplore: onExplore),
  );
}
