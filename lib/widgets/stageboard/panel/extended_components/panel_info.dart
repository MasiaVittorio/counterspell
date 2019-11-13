
import 'package:counter_spell_new/core.dart';

class PanelInfo extends StatelessWidget {

  const PanelInfo();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          Section([
            const AlertTitle("About CounterSpell", centered: false,),
            ListTile(
              title: const Text("Licenses"),
              leading: const Icon(Icons.info_outline),
              onTap: () => stage.showAlert(AlertLicenses(), size: DamageInfo.height),
            ),
            ListTile(
              title: const Text("Rate CounterSpell"),
              leading: const Icon(Icons.star_border),
              onTap: CSActions.review,
            ),
            ListTile(
              title: const Text("Support the development"),
              leading: const Icon(McIcons.thumb_up_outline),
              //LOW PRIORITY: ABOUT ME
              onTap: (){},
            ),
          ]),
          Section([
            const SectionTitle("Contacts"),
            ListTile(
              title: const Text("The developer"),
              leading: const Icon(Icons.person_outline),
              //LOW PRIORITY: ABOUT ME
              onTap: (){},
            ),
            ListTile(
              title: const Text("Feedback"),
              leading: const Icon(Icons.favorite_border),
              onTap: Review.forcePrompt,
            ),
            ListTile(
              title: const Text("Contact me"),
              leading: const Icon(Icons.mail_outline),
              onTap: () => stage.showAlert(ConfirmStageAlert(
                action: CSActions.mailMe,
                confirmColor: DELETE_COLOR,
                confirmIcon: Icons.mail_outline,
                confirmText: "Ok, open the e-mail app",
                cancelText: "Nope, go back",
                warningText: "You will be redirected to your email app.",
              ), size: ConfirmStageAlert.height),
            ),
            ListTile(
              title: const Text("Chat with me"),
              leading: const Icon(McIcons.telegram),
              onTap: () => stage.showAlert(ConfirmStageAlert(
                action: CSActions.chatWithMe,
                confirmColor: Colors.blue,
                confirmIcon: McIcons.telegram,
                confirmText: "Sure, open the Telegram app",
                cancelText: "Nope, go back",
                warningText: "You'll be redirected to a group chat with the dev and other users.",
                twoLinesWarning: true,
              ), size: ConfirmStageAlert.twoLinesheight),
            ),
          ]),
        ],
      ),
    );
  }
}