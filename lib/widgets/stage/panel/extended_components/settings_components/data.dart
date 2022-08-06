import 'dart:io';
import 'package:counter_spell_new/core.dart';


class SettingsData extends StatelessWidget {

  const SettingsData();

  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context);
    
    return SubSection([
      const SectionTitle("Data"),
      ExtraButtons(children: <Widget>[
        ExtraButton(
          text: "Cache manager",
          icon: McIcons.memory,
          onTap: () => stage!.showAlert(const CacheAlert(), size: CacheAlert.height),
            customCircleColor: Colors.transparent,
        ),
        if(Platform.isAndroid)
          ExtraButton(
            text: "Backup & restore",
            icon: McIcons.content_save_outline,
            onTap: () => stage!.showAlert(const BackupsAlert(), size: 500),
            customCircleColor: Colors.transparent,
          )
        else
          const ExtraButton(
            text: "Rate app",
            icon: Icons.star_border,
            onTap: CSActions.review,
            customCircleColor: Colors.transparent,
          ),
      ],),
    ],);
  }
}