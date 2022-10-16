import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/preferences/generate.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/preferences/restore.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/preferences/restore_old.dart';


class PreferencesBackups extends StatelessWidget {

  const PreferencesBackups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backups = CSBloc.of(context).backups;
    return backups.savedPreferences.build((_, list) => Column(children: [
      const Space.vertical(PanelTitle.height + 10),
      const Expanded(flex: 10,child: GeneratePreferencesBackupCard(),),
      const Space.vertical(10),
      const Expanded(flex: 6,child: RestorePreferencesCard(),),
      if(list.isNotEmpty)
        ...const [
          Space.vertical(10),
          Expanded(flex: 6,child: RestoreOldPreferencesCard(),),
        ],
      const Space.vertical(10),
    ],),);
  }
}