import 'package:badges/badges.dart';
import 'package:counter_spell_new/core.dart';

class Development extends StatelessWidget {

  const Development();

  @override
  Widget build(BuildContext context) {

    final logic = CSBloc.of(context);
    final stage = Stage.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        SubSection([
          const SectionTitle("Development"),
          ButtonTilesRow(children: [
            ButtonTile.transparent(
              text: "Discord",
              icon: McIcons.discord,
              onTap: () => stage!.showAlert(const ConfirmDiscord(), size: ConfirmDiscord.height),
            ),
            ButtonTile.transparent(
              text: "Telegram",
              icon: McIcons.telegram,
              onTap: () => stage!.showAlert(const ConfirmTelegram(), size: ConfirmTelegram.height),
            ),
            ButtonTile.transparent(
              text: "Email",
              icon: McIcons.gmail,
              onTap: () => stage!.showAlert(const ConfirmEmail(), size: ConfirmEmail.height),
            ),
          ],), 
        ]),

        const Space.vertical(5),

        ButtonTilesRow(children: [
          ButtonTile(
            icon: null,
            customIcon: logic.badges.versionShown.build((_, __) => Badge(
              showBadge: logic.badges.changelogBadge,
              badgeContent: null,
              toAnimate: false,
              shape: BadgeShape.circle,
              // alignment: Alignment.topRight,
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
            onTap: () => stage!.showAlert(const AlertLicenses(), size: DamageInfo.height),
          ),
        ],), 
        CSWidgets.height10,
      ],
    );
  }
}