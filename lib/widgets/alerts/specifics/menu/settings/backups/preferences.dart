import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/preferences/generate.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/preferences/restore.dart';


class PreferencesBackups extends StatelessWidget {

  const PreferencesBackups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      Space.vertical(PanelTitle.height + 10),
      Expanded(child: GeneratePreferencesBackupCard()),
      Space.vertical(10),
      Expanded(child: RestorePreferencesCard()),
      Space.vertical(10),
    ],);  
  }
}