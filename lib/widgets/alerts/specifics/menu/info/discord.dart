import 'package:counter_spell_new/core.dart';

class ConfirmDiscord extends StatelessWidget {

  const ConfirmDiscord();

  static double height = ConfirmAlert.twoLinesheight;

  @override
  Widget build(BuildContext context) {
    return ConfirmAlert(
      action: CSActions.openDiscordInvite,
      confirmIcon: McIcons.discord,
      confirmText: "Sure, open the Discord app",
      cancelText: "Nope, go back",
      warningText: "You'll be redirected to the CounterSpell's discord server.",
      twoLinesWarning: true,
      autoCloseAfterConfirm: false,
    );
  }
}