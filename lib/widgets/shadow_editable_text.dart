import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ShadowEditableText extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final ValueChanged<String>? onSubmitted;
  final Pattern textFilter;
  final int? maxTextLength;

  const ShadowEditableText(
      {super.key,
      required this.textEditingController,
      required this.focusNode,
      required this.onSubmitted,
      required this.textFilter,
      this.maxTextLength});

  @override
  Widget build(BuildContext context) {
    const noColor = Color(0x00000000);

    return SizedBox(
        width: 0,
        height: 0,
        child: EditableText(
            onSubmitted: onSubmitted,
            inputFormatters: [
              FilteringTextInputFormatter.allow(textFilter),
              LengthLimitingTextInputFormatter(maxTextLength)
            ],
            autocorrect: false,
            enableSuggestions: false,
            controller: textEditingController,
            focusNode: focusNode,
            style: const TextStyle(color: noColor, fontSize: 0),
            showCursor: false,
            cursorColor: noColor,
            backgroundCursorColor: noColor));
  }
}
