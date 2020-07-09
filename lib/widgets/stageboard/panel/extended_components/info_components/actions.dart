import 'package:counter_spell_new/core.dart';


class CounterSpellActions extends StatelessWidget {

  const CounterSpellActions();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    
    return Section([
      const SectionTitle("Actions"),
      RowOfExtraButtons(children: <Widget>[
        ExtraButton(
          text: "Give feedback",
          icon: Icons.favorite_border,
          onTap: () => stage.showAlert(const FeedbackAlert(), size: FeedbackAlert.height),
        ),
        ExtraButton(
          text: "Contact me",
          icon: McIcons.message_text_outline,
          onTap: () => stage.showAlert(const ContactsAlert(), size: ContactsAlert.height),
        ),
        ExtraButton(
          text: "Manage cache",
          icon: McIcons.memory,
          onTap: () => stage.showAlert(const CacheAlert(), size: CacheAlert.height),
        ),
      ],),

      CSWidgets.divider,

      ListTile(
        title: const Text("Rate CounterSpell"),
        leading: const Icon(Icons.star_border),
        onTap: CSActions.review,
      ),
      ListTile(
        title: const Text("Support the development"),
        leading: const Icon(McIcons.thumb_up_outline),
        onTap: () => stage.showAlert(const SupportAlert(), size: SupportAlert.height),
      ),
    ], last: true,);
  }
}