import 'package:counter_spell/core.dart';

class ContactsAlert extends StatelessWidget {
  const ContactsAlert({super.key});

  static const double height =
      AlternativesAlert.tileSize * 2 + PanelTitle.height;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return AlternativesAlert(
      label: "Contact me the way you want",
      alternatives: <Alternative>[
        Alternative(
          title: "Telegram",
          icon: McIcons.telegram,
          action: () => stage!
              .showAlert(const ConfirmTelegram(), size: ConfirmTelegram.height),
        ),
        Alternative(
          title: "E-mail",
          icon: Icons.mail_outline,
          action: () =>
              stage!.showAlert(const ConfirmEmail(), size: ConfirmEmail.height),
        ),
      ],
    );
  }
}
