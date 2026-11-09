import 'package:flutter/material.dart';

import '../models/sub_score.dart';
import '../theme/nds_colors.dart';

/// Togg kartlarının detay hedefi (App `CodedTarget`): 03 · Skor modülünün kodlanmış ekran
/// görüntüsü, 375×812. Geri (20,66 · 44×44) Ana Sayfa'ya döner.
///
/// NOT: 03 · Skor sayfaları bu özelliğin (Ana Sayfa Togg) kapsamı dışındadır; prototip de
/// bu hedefleri görüntü olarak gösterir. Gerçek uygulamada 03 modülündeki ekran açılır.
class ScoreTargetScreen extends StatelessWidget {
  const ScoreTargetScreen({super.key, required this.kind, this.onBack});

  final SubScoreKind kind;
  final VoidCallback? onBack;

  static String asset(SubScoreKind k) => switch (k) {
        SubScoreKind.activity => '$kAssetRoot/images/score_targets/aktivite_skorum_4711-88881.webp',
        SubScoreKind.sleep => '$kAssetRoot/images/score_targets/uyku_skorum_4711-87555.webp',
        SubScoreKind.recovery => '$kAssetRoot/images/score_targets/toparlanma_skorum_4711-89318.webp',
      };

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: NdsColors.grey0,
      child: Stack(children: [
        Positioned.fill(
          child: Semantics(
            label: '${kind.title} skorum (03 · Skor modülü)',
            image: true,
            child: Image.asset(asset(kind), fit: BoxFit.cover, alignment: Alignment.topCenter),
          ),
        ),
        Positioned(
          left: 20,
          top: 66,
          width: 44,
          height: 44,
          child: Semantics(
            button: true,
            label: 'Geri',
            child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onBack),
          ),
        ),
      ]),
    );
  }
}
