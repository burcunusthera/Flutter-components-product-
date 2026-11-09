import 'package:flutter/material.dart';

import '../../models/common.dart';
import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';
import '../common/r06.dart';
import 'header_glass_button.dart';

/// Üst bar (App `TopBar`, DS Header variant=profile): zemin Primary Blue/500.
/// Durum çubuğu alanı + 76 px başlık (padding 16 20).
/// Avatar: R06 Kompakt 40 px (Free = Standard, Premium = Kompakt + taç). Diskli avatar yok.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.title,
    required this.greeting,
    required this.plan,
    this.badgeCount = 0,
    this.onSettings,
    this.onNotifications,
    this.statusBarHeight,
    this.compactButtons = false,
  });

  /// “Nusthera”
  final String title;

  /// “Merhaba <Ad>”
  final String greeting;
  final PlanType plan;
  final int badgeCount;
  final VoidCallback? onSettings;
  final VoidCallback? onNotifications;

  /// Tasarımda 58 (iPhone 13/14 çerçevesi). null → cihazın üst güvenli alanı.
  final double? statusBarHeight;

  /// Temel kareler (ANA SAYFA V1.2 · `top130`): cam butonlar 40×40.
  final bool compactButtons;

  @override
  Widget build(BuildContext context) {
    final top = statusBarHeight ?? MediaQuery.paddingOf(context).top;
    return ColoredBox(
      color: NdsColors.primary500,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(height: top),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(children: [
              Expanded(
                child: Row(children: [
                  Semantics(
                    label: '${plan == PlanType.premium ? 'Premium' : 'Standard'} plan · Therus',
                    child: R06(plan == PlanType.premium ? R06State.premiumTac : R06State.hazir, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: ndsText(16, 20, 600, NdsColors.grey0)),
                      const SizedBox(height: 4),
                      Text(greeting, maxLines: 1, overflow: TextOverflow.ellipsis, style: ndsText(12, 15, 400, NdsColors.grey300)),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(width: 16),
              HeaderGlassButton(icon: 'User Interface/setting 2', label: 'Ayarlar', size: compactButtons ? 40 : 44, onTap: onSettings),
              const SizedBox(width: 8),
              HeaderGlassButton(
                icon: 'User Interface/notification',
                label: badgeCount > 0 ? 'Bildirimler, $badgeCount yeni' : 'Bildirimler',
                badge: badgeCount > 0 ? badgeCount : null,
                size: compactButtons ? 40 : 44,
                onTap: onNotifications,
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
