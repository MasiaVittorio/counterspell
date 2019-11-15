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
          //TODO: rivedi le licenze
          const Section([
            const SectionTitle("Flutter Packages"),
            ListTile(
              title: Text('cached_network_image'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('tinycolor'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('bubble_bottom_bar'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('path_provider'),
              subtitle: Text('Used under: BSD License'),
            ),
            ListTile(
              title: Text('Vibrate'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('RxDart'),
              subtitle: Text('Used under: Apache License 2.0'),
            ),
            ListTile(
              title: Text('flutter_reorderable_list'),
              subtitle: Text('Used under: BSD License'),
            ),
            ListTile(
              title: Text('material_design_icons_flutter'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('flutter_inapp_purchase'),
              subtitle: Text('Used under: MIT License'),
            ),
            ListTile(
              title: Text('url_launcher'),
              subtitle: Text('Used under: BSD License'),
            ),
          ]),
        ],),
      ),
    );
  }
}


