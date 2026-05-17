import 'package:app_settings/app_settings.dart';
import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/data/icon/mc_icons.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:counter_spell/widgets/components/common/expandable_section.dart';
import 'package:counter_spell/widgets/components/common/extra_note.dart';
import 'package:counter_spell/widgets/expanded_panel/game_page/expanded_page_list.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sid_base/sid_base.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandedPageList(
      bottom: CallToAction(
        action: () => launchUrl(
          Uri.parse('https://discord.gg/EGYDrrHQdd'),
          mode: LaunchMode.externalApplication,
        ),
        label: const Text('Contact the dev'),
        icon: const Icon(McIcons.discord),
      ),
      children: [
        const SectionTitle(
          title: Text('About CounterSpell'),
          leading: Icon(Icons.info_outline),
        ),
        const GroupedCard.single(lastPadding: 0, child: SupportTile()),
        const BeggingForMoneyDisclaimer(),

        // LATER: implement tutorial
        // LATER: changelog
        ExpandableSection(
          title: const Text('Development'),
          icon: MdiIcons.codeTags,
          subtitle: const Text('Source code and resources'),
          children: [
            const DeveloperTile(),
            const SourceCodeTile(),
            const ScryfallTile(),
            const IconsFontsTile(),
            const FlutterTile(),
            const MaterialDesignTile(),
          ],
        ),

        ExpandableSection(
          title: const Text('Legal stuff'),
          icon: MdiIcons.fileDocumentOutline,
          subtitle: const Text('Licenses and privacy policy'),
          children: [
            const AppInfoTile(),
            const LicensesTile(),
            const PrivacyPolicyTile(),
          ],
        ),
      ],
    );
  }
}

class PrivacyPolicyTile extends StatelessWidget {
  const PrivacyPolicyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      title: Text('Privacy policy'.todo),
      subtitle: const Text(
        'The app does not collect any personal data, but the full privacy policy documentation is provided',
      ),
      leading: Icon(MdiIcons.security),
      trailing: const Icon(Icons.open_in_browser),
      onTap: () => launchUrl(
        Uri.parse(
          'https://gist.github.com/MasiaVittorio/6ca8d3dc230a91b5d6052a27999e9bd3',
        ),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}

class LicensesTile extends StatelessWidget {
  const LicensesTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      title: Text('Licenses'.todo),
      leading: Icon(MdiIcons.license),
      trailing: const Icon(Icons.keyboard_arrow_right),
      containTrailing: false,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LicensePage(
            applicationName: 'CounterSpell',
            applicationLegalese:
                '''CounterSpell is unofficial Fan Content permitted under the Fan Content Policy. Not approved/endorsed by Wizards. Portions of the materials used are property of Wizards of the Coast. ©Wizards of the Coast LLC.''',
          ),
        ),
      ),
    );
  }
}

class AppInfoTile extends StatelessWidget {
  const AppInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppInfoBuilder(
      builder: (context, name, version, buildNumber, package) => ColoredTile(
        leading: const Icon(Icons.info_outline),
        title: Text(name.capitalizeFirst),
        subtitle: Text(package),
        trailing: Text('$version+$buildNumber'),
        onTap: () => AppSettings.openAppSettings(),
        containTrailing: false,
      ),
    );
  }
}

class BeggingForMoneyDisclaimer extends StatelessWidget {
  const BeggingForMoneyDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExtraNote(
      note:
          'This app was made in the free time of a single developer, out of sheer love for MtG and Material Design. It is is unofficial Fan Content provided for free to the community and will always stay free.',
      skipIcon: true,
    );
  }
}

class SupportTile extends StatelessWidget {
  const SupportTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      leading: Icon(MdiIcons.handCoinOutline),
      title: const Text('Support the development'),
      subtitle: const Text(
        'Help me keep working on this app by donating or starring the repo!',
      ),
      onTap: () {
        // TODO: donate
      },
    );
  }
}

class FlutterTile extends StatelessWidget {
  const FlutterTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      title: Text('Technology'.todo),
      subtitle: const Text('Flutter, Dart'),
      leading: const Pad(right: 4, child: FlutterLogo()),
      lowLeading: true,
      trailing: const Icon(Icons.open_in_browser),
      onTap: () => launchUrl(
        Uri.parse('https://flutter.dev/'),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}

class MaterialDesignTile extends StatelessWidget {
  const MaterialDesignTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      title: Text('Design language'.todo),
      subtitle: const Text('Material Design'),
      leading: Icon(MdiIcons.materialDesign),
      trailing: const Icon(Icons.open_in_browser),
      onTap: () => launchUrl(
        Uri.parse('https://m3.material.io/'),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}

class ScryfallTile extends StatelessWidget {
  const ScryfallTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      title: Text('Back-end data source'.todo),
      subtitle: const Text('Scryfall'),
      leading: Icon(MdiIcons.databaseOutline),
      trailing: const Icon(Icons.open_in_browser),
      onTap: () => launchUrl(
        Uri.parse('https://scryfall.com/'),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}

class IconsFontsTile extends StatelessWidget {
  const IconsFontsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      title: Text('Mana icons and set symbols'.todo),
      subtitle: const Text('By andrew Gioia, available on GitHub'),
      leading: Icon(MdiIcons.formatFont),
      trailing: const Icon(Icons.open_in_browser),
      onTap: () => launchUrl(
        Uri.parse('https://keyrune.andrewgioia.com/'),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}

class SourceCodeTile extends StatelessWidget {
  const SourceCodeTile({super.key});

  static const String githubLink =
      'https://github.com/MasiaVittorio/counterspell';

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      title: Text('Source code'.todo),
      subtitle: const Text(
        'The app is open source! You can check it out on GitHub',
      ),
      leading: Icon(MdiIcons.github),
      trailing: const Icon(Icons.open_in_browser),
      onTap: () => launchUrl(
        Uri.parse(githubLink),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}

class DeveloperTile extends StatelessWidget {
  const DeveloperTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      title: Text('Developer'.todo),
      containTrailing: false,
      subtitle: const Text('Vittorio, but you can call me Vi!'),
      trailing: const Text('(vee)'),
      leading: const Icon(Icons.person_outline),
      // LATER: my venom drawing propic
      onTap: () => launchUrl(
        Uri.parse('https://github.com/MasiaVittorio'),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}

class AppInfoBuilder extends StatefulWidget {
  const AppInfoBuilder({super.key, required this.builder});

  final Widget Function(
    BuildContext context,
    String appName,
    String version,
    String buildNumber,
    String packageName,
  )
  builder;

  @override
  State<AppInfoBuilder> createState() => _AppInfoBuilderState();
}

class _AppInfoBuilderState extends State<AppInfoBuilder> {
  String appName = 'Pikalculator';
  String version = '1.0.0';
  String buildNumber = '1';
  String packageName = 'com.example.pikalculator';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      appName = packageInfo.appName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      packageName = packageInfo.packageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, appName, version, buildNumber, packageName);
  }
}
