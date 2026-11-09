import 'package:flutter/material.dart';

import '../../theme/nds_colors.dart';
import '../../theme/nds_text.dart';

/// DS Input (varsayılan): etiket 14/18 Greyscale/600, aralık 4; kutu 48 yükseklik,
/// padding 13 16, zemin Greyscale/25, radius 12, odakta 1 px Greyscale/600 kenar; metin 14/20.
class NdsInput extends StatefulWidget {
  const NdsInput({super.key, required this.label, this.initialValue, this.onChanged, this.keyboardType});

  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  @override
  State<NdsInput> createState() => _NdsInputState();
}

class _NdsInputState extends State<NdsInput> {
  late final TextEditingController _c = TextEditingController(text: widget.initialValue);
  final FocusNode _f = FocusNode();

  @override
  void initState() {
    super.initState();
    _f.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _c.dispose();
    _f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(widget.label, style: ndsText(14, 18, 400, NdsColors.grey600)),
      const SizedBox(height: 4),
      Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: NdsColors.grey25,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _f.hasFocus ? NdsColors.grey600 : const Color(0x00000000)),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: TextField(
            controller: _c,
            focusNode: _f,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            cursorColor: NdsColors.grey900,
            style: ndsText(14, 20, 400, NdsColors.grey900),
            decoration: const InputDecoration.collapsed(hintText: null),
          ),
        ),
      ),
    ]);
  }
}
