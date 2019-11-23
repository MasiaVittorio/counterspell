import 'package:counter_spell_new/core.dart';

class AlertLicenses extends StatelessWidget {
  const AlertLicenses();

  static showText(StageData stage, String text, String title)=> stage.showAlert(TextAlert(text, title: '"$title" Package'), size: 400.0);

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
              onTap: () => showText(stage, CSLicenses.mit, "cached_network_image"),
            ),
            ListTile(
              title: const Text('division'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showText(stage, CSLicenses.mit, "division"),
            ),
            ListTile(
              title: const Text('flutter_reorderable_list'),
              subtitle: const Text('Used under: BSD License'),
              onTap: () => showText(stage, CSLicenses.bsd, "flutter_reorderable_list"),
            ),
            ListTile(
              title: const Text('hive'),
              subtitle: const Text('Used under: Apache 2.0 License'),
              onTap: () => showText(stage, CSLicenses.apache2, "hive"),
            ),
            ListTile(
              title: const Text('http'),
              subtitle: const Text('Used under: BSD License'),
              onTap: () => showText(stage, CSLicenses.bsd, "http"),
            ),
            ListTile(
              title: const Text('in_app_purchase'),
              subtitle: const Text('Used under: BSD License'),
              onTap: () => showText(stage, CSLicenses.bsd, "in_app_purchase"),
            ),
            ListTile(
              title: const Text('path_provider'),
              subtitle: const Text('Used under: BSD License'),
              onTap: () => showText(stage, CSLicenses.bsd, "path_provider"),
            ),
            ListTile(
              title: const Text('rxdart'),
              subtitle: const Text('Used under: Apache 2.0 License'),
              onTap: () => showText(stage, CSLicenses.apache2, "rxdart"),
            ),
            ListTile(
              title: const Text('screen'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showText(stage, CSLicenses.mit, "screen"),
            ),
            ListTile(
              title: const Text('sqflite'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showText(stage, CSLicenses.mit, "sqflite"),
            ),
            ListTile(
              title: const Text('tinycolor'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showText(stage, CSLicenses.mit, "tinycolor"),
            ),
            ListTile(
              title: const Text('url_launcher'),
              subtitle: const Text('Used under: BSD License'),
              onTap: () => showText(stage, CSLicenses.bsd, "url_launcher"),
            ),
            ListTile(
              title: const Text('vibrate'),
              subtitle: const Text('Used under: MIT License'),
              onTap: () => showText(stage, CSLicenses.mit, "vibrate"),
            ),
          ]),
        ],),
      ),
    );
  }
}


