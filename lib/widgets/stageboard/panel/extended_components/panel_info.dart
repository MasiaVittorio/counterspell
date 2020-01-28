
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/info/changelog.dart';

class PanelInfo extends StatelessWidget {

  const PanelInfo();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Section([
            const AlertTitle("About CounterSpell", centered: false,),
            ListTile(
              title: const Text("The developer"),
              leading: const Icon(Icons.person_outline),
              onTap: () => stage.showAlert(const Developer(), size: Developer.height),
            ),
            ListTile(
              title: const Text("Licenses & source code"),
              leading: const Icon(Icons.info_outline),
              onTap: () => stage.showAlert(const AlertLicenses(), size: DamageInfo.height),
            ),
            ListTile(
              title: const Text("Tutorial"),
              leading: const Icon(Icons.help_outline),
              onTap: () => stage.showAlert(const TutorialAlert(), size: TutorialAlert.height),
            ),
            ListTile(
              title: const Text("Changelog"),
              leading: const Icon(Icons.change_history),
              onTap: () => stage.showAlert(const Changelog(), size: Changelog.height),
            ),
          ]),
          Section([
            const SectionTitle("Actions"),
            ListTile(
              title: const Text("Feedback"),
              leading: const Icon(Icons.favorite_border),
              onTap: () => stage.showAlert(const FeedbackAlert(), size: FeedbackAlert.height),
            ),
            ListTile(
              title: const Text("Rate CounterSpell"),
              leading: const Icon(Icons.star_border),
              onTap: CSActions.review,
            ),
            ListTile(
              title: const Text("Support the development"),
              leading: const Icon(McIcons.thumb_up_outline),
              onTap: () => stage.showAlert(const Support(), size: Support.height),
            ),
            ListTile(
              title: const Text("Contacts"),
              leading: const Icon(McIcons.message_text_outline),
              onTap: () => stage.showAlert(const ContactsAlert(), size: AlternativesAlert.heightCalc(2)),
            ),
          ], last: true,),

          const QuoteTile(),
        ],
      ),
    );
  }
}