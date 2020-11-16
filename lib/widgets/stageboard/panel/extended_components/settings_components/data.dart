import 'dart:io';
import 'package:counter_spell_new/core.dart';


class SettingsData extends StatelessWidget {

  const SettingsData();

  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context);
    
    return Section([
      const SectionTitle("Data"),
      ExtraButtons(children: <Widget>[
        ExtraButton(
          text: "Cache manager",
          icon: McIcons.memory,
          onTap: () => stage.showAlert(const CacheAlert(), size: CacheAlert.height),
        ),
        if(Platform.isAndroid)
          ExtraButton(
            text: "Backup & restore",
            icon: McIcons.content_save_outline,
            onTap: () => stage.showAlert(BackupsAlert(), size: 500),
          )
        else
          const ExtraButton(
            text: "Rate app",
            icon: Icons.star_border,
            onTap: CSActions.review,
          ),
      ],),
    ],);
  }
}