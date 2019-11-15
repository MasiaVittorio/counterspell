
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
              //TODO: IN APP PURCHASES
              onTap: (){},
            ),
          ]),
          Section([
            const SectionTitle("Contacts"),
            ListTile(
              title: const Text("The developer"),
              leading: const Icon(Icons.person_outline),
              //TODO: ABOUT ME
              onTap: (){},
            ),
            ListTile(
              title: const Text("Feedback"),
              leading: const Icon(Icons.favorite_border),
              onTap: () => stage.showAlert(const FeedbackAlert(), size: FeedbackAlert.height),
            ),
            ListTile(
              title: const Text("Contact me"),
              leading: const Icon(Icons.mail_outline),
              onTap: () => stage.showAlert(const ConfirmEmail(), size: ConfirmEmail.height),
            ),
            ListTile(
              title: const Text("Chat with me"),
              leading: const Icon(McIcons.telegram),
              onTap: () => stage.showAlert(const ConfirmTelegram(), size: ConfirmTelegram.height),
            ),
          ]),
        ],
      ),
    );
  }
}