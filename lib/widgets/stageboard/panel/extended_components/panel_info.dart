import 'dart:io';

import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/info/licenses.dart';
import 'package:url_launcher/url_launcher.dart';

class PanelInfo extends StatelessWidget {

  const PanelInfo();

  static const String androidUrl = 'https://play.google.com/store/apps/details?id=com.mvsidereusart.counterspell';
  static const String iosUrl = "https://itunes.apple.com/us/app/counterspell/id1459235508?l=it&ls=1&mt=8";

  @override
  Widget build(BuildContext context) {
    // final bloc = CSBloc.of(context);
    final stage = Stage.of(context);

    return SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          Section([
            const AlertTitle("About CounterSpell", centered: false,),
            ListTile(
              title: const Text("Licenses"),
              leading: const Icon(Icons.info),
              onTap: () => stage.showAlert(AlertLicenses(), size: DamageInfo.height),
            ),
            ListTile(
              title: const Text("The developer"),
              leading: const Icon(Icons.person_outline),
              //LOW PRIORITY: ABOUT ME
              onTap: (){},
            ),
            ListTile(
              title: const Text("Support the development"),
              leading: const Icon(McIcons.thumb_up_outline),
              //LOW PRIORITY: ABOUT ME
              onTap: (){},
            ),
          ]),
          Section([
            const AlertTitle("Contacts", centered: false,),
            ListTile(
              title: const Text("Rate CounterSpell"),
              leading: const Icon(Icons.favorite_border),
              onTap: () async {
                final String url = Platform.isAndroid ? androidUrl : iosUrl;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  print('Could not launch $url');
                }
              },
            ),
          ]),
        ],
      ),
    );
  }
}