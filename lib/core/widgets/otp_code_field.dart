import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_spacing.dart';

/// A row of digit boxes for a verification code.
///
/// One hidden input holds the whole code and the boxes only display it, so
/// digits always fill left to right: a box cannot be typed into out of
/// order, delete removes the last digit, and pasting or SMS autofill fills
/// every box at once. [onChanged] receives the code typed so far.
class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    super.key,
    required this.onChanged,
    this.length = 6,
  });

  final ValueChanged<String> onChanged;
  final int length;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  /// Boxes are at most this wide and shrink to fit narrow screens.
  static const double _maxBoxWidth = 46;
  static const double _boxHeight = 52;
  static const double _boxGap = 3;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Keeps the caret at the end, so a tap can never insert mid-code.
  void _moveCaretToEnd() {
    _controller.selection =
        TextSelection.collapsed(offset: _controller.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fitWidth =
            constraints.maxWidth / widget.length - _boxGap * 2;
        final boxWidth = fitWidth.clamp(0.0, _maxBoxWidth);
        return _buildField(boxWidth);
      },
    );
  }

  Widget _buildField(double boxWidth) {
    final rowWidth = widget.length * (boxWidth + _boxGap * 2);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          width: rowWidth,
          height: _boxHeight,
          child: Stack(
            children: [
              ListenableBuilder(
                listenable: Listenable.merge([_controller, _focusNode]),
                builder: (context, _) => Row(
                  children: List.generate(
                    widget.length,
                    (index) => _buildBox(index, boxWidth),
                  ),
                ),
              ),
              // The real input: invisible, covering the boxes so a tap on
              // any of them focuses it.
              Positioned.fill(
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    showCursor: false,
                    enableInteractiveSelection: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(widget.length),
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onTap: _moveCaretToEnd,
                    onChanged: (code) {
                      _moveCaretToEnd();
                      if (code.length == widget.length) _focusNode.unfocus();
                      widget.onChanged(code);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox(int index, double width) {
    final code = _controller.text;
    // The box the next digit goes into (the last one once complete).
    final activeIndex = code.length.clamp(0, widget.length - 1);
    final isActive = _focusNode.hasFocus && index == activeIndex;

    return Container(
      width: width,
      height: _boxHeight,
      margin: const EdgeInsets.symmetric(horizontal: _boxGap),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: Colors.black, width: isActive ? 2.5 : 1.5),
      ),
      child: Text(
        index < code.length ? code[index] : '',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }
}
