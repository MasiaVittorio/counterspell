import 'package:badges/badges.dart';
import 'package:counter_spell_new/core.dart';

class Development extends StatelessWidget {

  const Development({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {

    final logic = CSBloc.of(context);
    final stage = Stage.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        contacts(stage),
        const Space.vertical(5),
        buttons(logic, context, stage), 
        const Space.vertical(10),
        if(!compact) ...[
          SubSection([
            ListTile(
              title: const Text("Support the development"),
              leading: const Icon(Icons.monetization_on_outlined),
              onTap: () => stage.showAlert(const SupportAlert(), size: SupportAlert.height),
              trailing: const Icon(Icons.keyboard_arrow_right),
            )
          ]),
          const Space.vertical(10)
        ]
      ],
    );
  }

  SubSection contacts(StageData<dynamic, dynamic> stage) => SubSection([
    const SectionTitle("Development"),
    ButtonTilesRow(children: [
      ButtonTile.transparent(
        text: "Discord",
        icon: McIcons.discord,
        onTap: () => stage.showAlert(const ConfirmDiscord(), size: ConfirmDiscord.height),
      ),
      ButtonTile.transparent(
        text: "Telegram",
        icon: McIcons.telegram,
        onTap: () => stage.showAlert(const ConfirmTelegram(), size: ConfirmTelegram.height),
      ),
      ButtonTile.transparent(
        text: "Email",
        icon: McIcons.gmail,
        onTap: () => stage.showAlert(const ConfirmEmail(), size: ConfirmEmail.height),
      ),
    ],), 
  ]);

  ButtonTilesRow buttons(
    CSBloc logic, 
    BuildContext context, 
    StageData<dynamic, dynamic> stage,
  ) => ButtonTilesRow(children: [
    ButtonTile(
      icon: null,
      customIcon: logic.badges.versionShown.build((_, __) => Badge(
        showBadge: logic.badges.changelogBadge,
        badgeContent: null,
        toAnimate: false,
        shape: BadgeShape.circle,
        badgeColor: Theme.of(context).colorScheme.secondary,
        position: BadgePosition.topEnd(),
        ignorePointer: true,
        child: const Icon(McIcons.file_document_outline),
      ),),
      text: "Changelog",
      onTap: logic.badges.showChangelog,
    ),
    ButtonTile(
      icon: McIcons.text_box_check_outline,
      text: "Licenses",
      onTap: () => stage.showAlert(const AlertLicenses(), size: DamageInfo.height),
    ),
    if(compact)
      ButtonTile(
        text: "Support",
        icon: Icons.attach_money,
        onTap: () => stage.showAlert(const SupportAlert(), size: SupportAlert.height),
      ),
  ],);



}