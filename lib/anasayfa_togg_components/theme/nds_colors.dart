import 'package:flutter/widgets.dart';

/// NustheraDS v1.4.12 token'ları (ds/nustherads/tokens.css, açık tema — R-01).
abstract final class NdsColors {
  // Primary Blue
  static const primary50 = Color(0xFFE8E9ED);
  static const primary100 = Color(0xFFB6BCC8);
  static const primary500 = Color(0xFF14264C);

  // Greyscale
  static const grey0 = Color(0xFFFFFFFF);
  static const grey25 = Color(0xFFF9F9F9);
  static const grey50 = Color(0xFFECEFF3);
  static const grey100 = Color(0xFFDFE1E7);
  static const grey200 = Color(0xFFC1C7D0);
  static const grey300 = Color(0xFFA4ACB9);
  static const grey400 = Color(0xFF818898);
  static const grey500 = Color(0xFF666D80);
  static const grey600 = Color(0xFF36394A);
  static const grey700 = Color(0xFF272835);
  static const grey800 = Color(0xFF1A1B25);
  static const grey900 = Color(0xFF0D0D12);

  // Secondary
  static const secondary100 = Color(0xFFC3E8F9);
  static const secondary500 = Color(0xFF3DB6EB);
  static const secondary800 = Color(0xFF226481);

  // Status
  static const warning50 = Color(0xFFFFF9ED);
  static const warning200 = Color(0xFFFFE1AD);
  static const warning500 = Color(0xFFFFBE4C);
  static const warning800 = Color(0xFF8C692A);
  static const danger500 = Color(0xFF93113A);
  static const info500 = Color(0xFF637AFF);
  static const success100 = Color(0xFFD8EBB7);
  static const success500 = Color(0xFF82BF18);
  static const success800 = Color(0xFF48690D);
  static const grey25Alpha20 = Color(0x33F9F9F9);

  // Makro
  static const macroFat = Color(0xFFA7A9E8);
  static const macroFatText = Color(0xFF65668C);
  static const macroCarbs = Color(0xFFE4B843);
  static const macroCarbsText = Color(0xFF8A6F29);

  // Premium chip
  static const premiumChipBg = Color(0xFFF7EEFF);
  static const premiumChipBorder = Color(0xFFE7CAFD);
  static const premiumChipText = Color(0xFF4B2B69);

  // Stres etiketi zeminleri (DS stressTagBg)
  static const stressTag = <String, Color>{
    'Rahatlamış': Color(0xFF7DCEF2),
    'Sakin': Color(0xFFBFF7F2),
    'Dengeli': Color(0xFFFDE7AC),
    'Stresli': Color(0xFFFFC998),
    'Çok stresli': Color(0xFFF8C2C3),
  };

  static const homeIndicator = Color(0xFF0F172A);
  /// Hatırlatıcı ve Premium sayfaları örtüsü: rgba(13,13,18,.6)
  static const scrim = Color(0x990D0D12);

  /// DS Overlay (silme onayı): rgba(13,13,13,.75)
  static const overlay = Color(0xBF0D0D0D);
}

/// Kökteki varlık klasörü.
const kAssetRoot = 'assets/anasayfa_togg_components';
