
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
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: Row(children: <Widget>[
                Expanded(child: ExtraButton(
                  icon: Icons.person_outline,
                  text: "The developer",
                  onTap: () => stage.showAlert(const Developer(), size: Developer.height),
                )),
                Expanded(child: ExtraButton(
                  icon: McIcons.file_document_box_check_outline,
                  text: "Licenses",
                  onTap: () => stage.showAlert(const AlertLicenses(), size: DamageInfo.height),
                )),
                Expanded(child: ExtraButton(
                  icon: McIcons.file_document_outline,
                  text: "Changelog",
                  onTap: () => stage.showAlert(const Changelog(), size: Changelog.height),
                )),
              ].separateWith(SizedBox(width: 10.0,))),
            ),
            CSWidgets.divider,
            ListTile(
              title: const Text("Tutorial"),
              leading: const Icon(Icons.help_outline),
              onTap: () => stage.showAlert(const TutorialAlert(), size: TutorialAlert.height),
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