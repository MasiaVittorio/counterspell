import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/alerts/specifics/menu/settings/backups/preferences/generate.dart';
import 'package:counter_spell/widgets/alerts/specifics/menu/settings/backups/preferences/restore.dart';

class PreferencesBackups extends StatelessWidget {
  const PreferencesBackups({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Space.vertical(PanelTitle.height + 10),
        const Expanded(
          flex: 10,
          child: GeneratePreferencesBackupCard(),
        ),
        const Space.vertical(10),
        const Expanded(
          flex: 6,
          child: RestorePreferencesCard(),
        ),
        const Space.vertical(10),
      ],
    );
  }
}
