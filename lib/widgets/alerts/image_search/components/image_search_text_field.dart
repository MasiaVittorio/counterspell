import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ImageSearchTextField extends StatelessWidget {
  const ImageSearchTextField({
    super.key,
    required this.onSubmitSearch,
    required this.controller,
  });

  final ValueChanged<String> onSubmitSearch;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Pad(
      horizontal: theme.layout.margin.medium,
      child: TextField(
        cursorColor: theme.colorScheme.onSurface,
        keyboardType: TextInputType.text,
        autofocus: true,
        onSubmitted: onSubmitSearch,
        textAlign: TextAlign.center,
        controller: controller,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(inherit: true, fontSize: 18.0),
        decoration: const InputDecoration(labelText: 'Card name'),
      ),
    );
  }
}
