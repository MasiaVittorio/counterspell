import 'package:counter_spell_new/core.dart';

class ConfirmTelegram extends StatelessWidget {

  const ConfirmTelegram();

  static double height = ConfirmAlert.twoLinesheight;

  @override
  Widget build(BuildContext context) {
    return const ConfirmAlert(
      action: CSActions.chatWithMe,
      confirmColor: Colors.blue,
      confirmIcon: McIcons.telegram,
      confirmText: "Sure, open the Telegram app",
      cancelText: "Nope, go back",
      warningText: "You'll be redirected to a group chat with the dev and other users.",
      twoLinesWarning: true,
      autoCloseAfterConfirm: false,
    );
  }
}