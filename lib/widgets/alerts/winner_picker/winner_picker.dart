import 'package:flutter/cupertino.dart';
import 'package:panel_frame/panel_frame.dart';

class WinnerPicker extends StatelessWidget {
  const WinnerPicker({
    super.key,
    required this.names,
    required this.initialIndex,
    required this.includeDontSaveOption,
    this.onSubmit,
  });

  final List<String> names;
  final int? initialIndex;
  final bool includeDontSaveOption;
  final void Function(int? winnerIndex)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return AlternativesPanelAlert<int>.grouped(
      initialValue: initialIndex,
      confirmationMode: AlternativeConfirmationMode.selectAndConfirm(),
      shrinkWrap: true,
      title: const Text('Pick a winner'),
      onSubmit: onSubmit,
      alternatives: [
        [
          for (int i = 0; i < names.length; i++)
            PanelAlternative(value: i, label: Text(names[i])),
        ],
        [const PanelAlternative(value: -1, label: Text('Draw'))],
        if (includeDontSaveOption)
          [
            const PanelAlternative(
              value: -2,
              label: Text("Don't save this game"),
            ),
          ],
      ],
    );
  }
}
