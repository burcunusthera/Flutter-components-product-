import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import 'pressable.dart';

const _lockGoldSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32">'
    '<defs><linearGradient id="g" gradientUnits="objectBoundingBox" x1="0" y1="0" x2="1.17777" y2="0.29844">'
    '<stop offset="0" stop-color="#BF953F"/><stop offset="0.45" stop-color="#FCF6BA"/>'
    '<stop offset="0.7" stop-color="#B38728"/><stop offset="1" stop-color="#FBF5B7"/></linearGradient></defs>'
    '<path transform="translate(4.33333 13)" fill="url(#g)" fill-rule="evenodd" d="M0 1C0 .447715.447715 0 1 0L22.3333 0C22.8856 0 23.3333.447715 23.3333 1L23.3333 2.97219C23.3333 3.52448 22.8856 3.97219 22.3333 3.97219 21.781 3.97219 21.3333 3.52448 21.3333 2.97219L21.3333 2 2 2 2 14 21.3333 14 21.3333 8.15429C21.3333 7.602 21.781 7.15428 22.3333 7.15428 22.8856 7.15428 23.3333 7.602 23.3333 8.15429L23.3333 15C23.3333 15.5523 22.8856 16 22.3333 16L1 16C.447715 16 0 15.5523 0 15L0 1Z"/>'
    '<path transform="translate(8.33333 1.66667)" fill="url(#g)" fill-rule="evenodd" d="M0 6.33333C0 2.83553 2.83553 0 6.33333 0L9 0C12.4978 0 15.3333 2.83553 15.3333 6.33333L15.3333 12.3333C15.3333 12.8856 14.8856 13.3333 14.3333 13.3333L1 13.3333C.447715 13.3333 0 12.8856 0 12.3333L0 6.33333ZM6.33333 2C3.9401 2 2 3.9401 2 6.33333L2 11.3333 13.3333 11.3333 13.3333 6.33333C13.3333 3.9401 11.3932 2 9 2L6.33333 2Z"/>'
    '</svg>';

/// DS PremiumLock: altın kilit diski + başlık + “Planınızı yükseltin”.
class PremiumLock extends StatelessWidget {
  const PremiumLock({super.key, required this.title, this.action = 'Planınızı yükseltin', this.onAction});

  final String title;
  final String action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x0A27D5E8), // rgba(39,213,232,.04)
          ),
          foregroundDecoration: null,
          child: Stack(alignment: Alignment.center, children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0x80F7D976), Color(0x80DB8C40)]),
              ),
            ),
            SvgPicture.string(_lockGoldSvg, width: 32, height: 32),
          ]),
        ),
        const SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center, style: ndsText(16, 20, 600, NdsColors.grey900)),
      ]),
      const SizedBox(height: 12),
      Pressable(
        onTap: onAction,
        semanticLabel: action,
        excludeChildSemantics: true,
        builder: (context, _) => Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(colors: [Color(0xFFF7D976), Color(0xFFDB8C40)]),
          ),
          child: Text(action, style: ndsText(14, 18, 500, NdsColors.grey900)),
        ),
      ),
    ]);
  }
}
