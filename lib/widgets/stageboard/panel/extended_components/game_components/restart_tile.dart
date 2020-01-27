import 'package:counter_spell_new/core.dart';

class RestartTile extends StatelessWidget {

  const RestartTile();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return ListTile(
      title: const Text("New game"),
      leading: const Icon(McIcons.restart),
      onTap: () => stage.showAlert(const RestarterAlert(), size: ConfirmAlert.height),
    );
  }
}