import 'package:counter_spell_new/core.dart';

class ConfirmEmail extends StatelessWidget {

  const ConfirmEmail();

  static const double height =  ConfirmAlert.height;

  @override
  Widget build(BuildContext context) {
    return ConfirmAlert(
      action: CSActions.mailMe,
      confirmColor: CSColors.delete,
      confirmIcon: Icons.mail_outline,
      confirmText: "Ok, open the e-mail app",
      cancelText: "Nope, go back",
      warningText: "You will be redirected to your email app.",
      autoCloseAfterConfirm: false,
    );
  }
}