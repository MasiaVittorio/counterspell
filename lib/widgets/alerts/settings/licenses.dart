import 'package:counter_spell_new/core.dart';

class AlertLicenses extends StatelessWidget {
  const AlertLicenses();

  @override
  Widget build(BuildContext context) {

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
          const Section([
            const SectionTitle("Flutter Packages"),
            ListTile(
              title: Text('cached_network_image'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('division'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('flutter_reorderable_list'),
              subtitle: Text('Used under: BSD License'),
            ),
            ListTile(
              title: Text('hive'),
              subtitle: Text('Used under: Apache 2.0 License'),
            ),
            ListTile(
              title: Text('http'),
              subtitle: Text('Used under: BSD License'),
            ),
            ListTile(
              title: Text('in_app_purchase'),
              subtitle: Text('Used under: BSD License'),
            ),
            ListTile(
              title: Text('path_provider'),
              subtitle: Text('Used under: BSD License'),
            ),
            ListTile(
              title: Text('rxdart'),
              subtitle: Text('Used under: Apache 2.0 License'),
            ),
            ListTile(
              title: Text('screen'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('sqflite'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('tinycolor'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('url_launcher'),
              subtitle: Text('Used under: BSD License'),
            ),
            ListTile(
              title: Text('vibrate'),
              subtitle: Text('Used under: MIT License'),
            ),
          ]),
        ],),
      ),
    );
  }
}


