// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/alerts/specifics/game/image_search/image_search_alert.dart';

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

    return Container(
      height: ImageSearchAlert.insertHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide.none),
          labelText: "Card name",
          labelStyle: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}
