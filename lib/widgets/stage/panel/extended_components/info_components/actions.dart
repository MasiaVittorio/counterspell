import 'dart:io';

import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/backups.dart';
// import 'package:counter_spell_new/widgets/other_routes/data_backup/backup_route.dart';


class CounterSpellActions extends StatelessWidget {

  const CounterSpellActions();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    
    return Section([
      const SectionTitle("Data"),
      ButtonTilesRow(children: <Widget>[
        ButtonTile(
          text: "Cache manager",
          icon: McIcons.memory,
          onTap: () => stage!.showAlert(const CacheAlert(), size: CacheAlert.height),
        ),
        if(Platform.isAndroid)
          ButtonTile(
            text: "Backup & restore",
            icon: McIcons.content_save_outline,
            onTap: () => stage!.showAlert(const BackupsAlertNew(), size: 500),
          )
        else
          const ButtonTile(
            text: "Rate app",
            icon: Icons.star_border,
            onTap: CSActions.review,
          ),
      ],),

      SubSection(<Widget>[
        ButtonTilesRow(
          margin: EdgeInsets.zero,
          children: <Widget>[
            ButtonTile.transparent(
              text: "Feedback",
              icon: Icons.favorite_border,
              onTap: () => stage!.showAlert(const FeedbackAlert(), size: FeedbackAlert.height),
            ),
            ButtonTile.transparent(
              text: "Support",
              icon: Icons.attach_money,
              onTap: () => stage!.showAlert(const SupportAlert(), size: SupportAlert.height),
            ),
            ButtonTile.transparent(
              text: "Contacts",
              icon: McIcons.message_text_outline,
              onTap: () => stage!.showAlert(const ContactsAlert(), size: ContactsAlert.height),
            ),
          ],
        ),
      ],margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),),

    ]);


  }
}