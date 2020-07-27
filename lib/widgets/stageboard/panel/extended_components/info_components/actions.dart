import 'package:counter_spell_new/core.dart';
// import 'package:counter_spell_new/widgets/other_routes/data_backup/backup_route.dart';


class CounterSpellActions extends StatelessWidget {

  const CounterSpellActions();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    
    return Section([
      const SectionTitle("Actions"),
      RowOfExtraButtons(children: <Widget>[
        ExtraButton(
          text: "Cache manager",
          icon: McIcons.memory,
          onTap: () => stage.showAlert(const CacheAlert(), size: CacheAlert.height),
        ),
        ExtraButton(
          text: "Backup & restore",
          icon: McIcons.content_save_outline,
          onTap: () => stage.showAlert(null),
          // onTap: () => Navigator
          //   .of(context, rootNavigator: true)
          //   .pushReplacement(
          //     MaterialPageRoute(builder: (_) => BackupScreen()),
          //   ),
        ),
      ],),

      SubSection(<Widget>[
        RowOfExtraButtons(
          margin: EdgeInsets.zero,
          children: <Widget>[
            ExtraButton(
              text: "Feedback",
              icon: Icons.favorite_border,
              onTap: () => stage.showAlert(const FeedbackAlert(), size: FeedbackAlert.height),
              customCircleColor: Colors.transparent,
            ),
            ExtraButton(
              text: "Support",
              icon: McIcons.thumb_up_outline,
              onTap: () => stage.showAlert(const SupportAlert(), size: SupportAlert.height),
              customCircleColor: Colors.transparent,
            ),
            ExtraButton(
              text: "Contacts",
              icon: McIcons.message_text_outline,
              onTap: () => stage.showAlert(const ContactsAlert(), size: ContactsAlert.height),
              customCircleColor: Colors.transparent,
            ),
          ],
        ),
      ],margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),),

    ]);


  }
}