import 'package:counter_spell_new/core.dart';

class AlertLicenses extends StatelessWidget {
  const AlertLicenses();

  static showText(StageData stage, String text)=> stage.showAlert(TextAlert(text), size: 400.0);

  static showBSD(StageData stage) => showText(stage, CSLicenses.bsd);
  static showApache2(StageData stage) => showText(stage, CSLicenses.apache2);
  static showMIT(StageData stage) => showText(stage, CSLicenses.mit);

  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context);

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: Stage.of(context).panelScrollPhysics(),
        child: Column(children: <Widget>[
          const Section([
            const AlertTitle("Licenses", centered: false,),
            const Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(CSLicenses.wizardFanContentPolicy),
            ),
          ]),
          const Section([
            const SectionTitle("Images"),
            const Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(CSLicenses.scryfallImagePolicy),
            ),
          ]),
          Section([
            const SectionTitle("Flutter Packages"),
            ListTile(
              title: const Text('cached_network_image'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showMIT(stage),
            ),
            ListTile(
              title: const Text('division'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showMIT(stage),
            ),
            ListTile(
              title: const Text('flutter_reorderable_list'),
              subtitle: const Text('Used under: BSD License'),
              onTap: () => showBSD(stage),
            ),
            ListTile(
              title: const Text('hive'),
              subtitle: const Text('Used under: Apache 2.0 License'),
              onTap: () => showApache2(stage),
            ),
            ListTile(
              title: const Text('http'),
              subtitle: const Text('Used under: BSD License'),
              onTap: () => showBSD(stage),
            ),
            ListTile(
              title: const Text('in_app_purchase'),
              subtitle: const Text('Used under: BSD License'),
              onTap: () => showBSD(stage),
            ),
            ListTile(
              title: const Text('path_provider'),
              subtitle: const Text('Used under: BSD License'),
              onTap: () => showBSD(stage),
            ),
            ListTile(
              title: const Text('rxdart'),
              subtitle: const Text('Used under: Apache 2.0 License'),
              onTap: () => showApache2(stage),
            ),
            ListTile(
              title: const Text('screen'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showMIT(stage),
            ),
            ListTile(
              title: const Text('sqflite'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showMIT(stage),
            ),
            ListTile(
              title: const Text('tinycolor'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showMIT(stage),
            ),
            ListTile(
              title: const Text('url_launcher'),
              subtitle: const Text('Used under: BSD License'),
              onTap: () => showBSD(stage),
            ),
            ListTile(
              title: const Text('vibrate'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showMIT(stage),
            ),
          ]),
        ],),
      ),
    );
  }
}


