
import 'package:counter_spell_new/core.dart';

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
              title: const Text("Licenses"),
              leading: const Icon(Icons.info_outline),
              onTap: () => stage.showAlert(AlertLicenses(), size: DamageInfo.height),
            ),
            ListTile(
              title: const Text("Source code"),
              leading: const Icon(McIcons.github_circle),
              onTap: () => stage.showAlert(ConfirmAlert(
                warningText: "You'll be redirected to your browser on CounterSpell's  github page",
                twoLinesWarning: true,
                action: CSActions.githubPage,
                confirmIcon: Icons.exit_to_app,
                cancelColor: CSColors.delete,
              ), size: ConfirmAlert.twoLinesheight),
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
              onTap: () => stage.showAlert(AlternativesAlert(
                label: "Contact me the way you want",
                alternatives: <Alternative>[
                  Alternative(
                    title: "Telegram",
                    icon: McIcons.telegram,
                    action: () => stage.showAlert(const ConfirmTelegram(), size: ConfirmTelegram.height),
                  ),
                  Alternative(
                    title: "E-mail",
                    icon: Icons.mail_outline,
                    action: () => stage.showAlert(const ConfirmEmail(), size: ConfirmEmail.height),
                  ),
                ],
              ), size: AlternativesAlert.heightCalc(2)),
            ),
          ]),

          Container(
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal:16.0),
            child: Text(
              FlavorTexts.random, 
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}