import 'dart:io';

import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/alerts/specifics/menu/settings/backups/backups.dart';

class SettingsData extends StatelessWidget {
  const SettingsData({super.key});

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return SubSection(
      [
        const SectionTitle("Data"),
        ButtonTilesRow(
          children: <Widget>[
            ButtonTile.transparent(
              text: "Cache manager",
              icon: McIcons.memory,
              onTap: () =>
                  stage!.showAlert(const CacheAlert(), size: CacheAlert.height),
            ),
            if (Platform.isAndroid)
              ButtonTile.transparent(
                text: "Backup & restore",
                icon: McIcons.content_save_outline,
                onTap: () =>
                    stage!.showAlert(const BackupsAlertNew(), size: 500),
              )
            else
              const ButtonTile.transparent(
                text: "Rate app",
                icon: Icons.star_border,
                onTap: CSActions.review,
              ),
          ],
        ),
      ],
    );
  }
}
