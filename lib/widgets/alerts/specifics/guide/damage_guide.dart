import 'package:counter_spell_new/core.dart';


const String _attackerTitle = "Select the attacker";
const String _attacker1 = "tap on a player to set its commander as the one dealing the damage";
const String _attacker2 = "that player will become red and squared";
const String _partnerTitle = "Select the right partner";
const String _partner1 = "long press on the sword icon to split / merge partners";
const String _partner2 = "tap on the the sword icon to switch between partners A and B";
const String _defenderTitle = "Scroll on the defender";
const String _defender1 = "increment the damage taken by a player from the selected commander";
const String _defender2 = "this will lower the defender's life unless you disable this setting";

class DamageInfo extends StatelessWidget {
  const DamageInfo();
  static const double height = 3 * (InfoTitle.height + 14.0) + 6 * PieceOfInfo.height + AlertDrag.height - 14.0;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: Stage.of(context).panelController.panelScrollPhysics(),
        primary: true,
        child: Container(
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _AttackerSection(),
              const InfoSection(
                icon: const Icon(McIcons.account_multiple_outline),
                title: _partnerTitle,
                info: [
                  _partner1,
                  _partner2,
                ],
              ),
              const _DefenderSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefenderSection extends StatelessWidget {
  const _DefenderSection();
  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: IconThemeData(opacity: 1.0),
      child: CSBloc.of(context).themer.defenceColor.build((_,defenceColor)=>InfoSection(
        last: true,
        icon: Icon(
          CSIcons.defenceIconFilled,
          color: defenceColor,
        ),
        title: _defenderTitle,
        info: [
          _defender1,
          _defender2,
        ],
      )),
    );
  }
}

class _AttackerSection extends StatelessWidget {
  const _AttackerSection();
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    
    return IconTheme.merge(
      data: IconThemeData(opacity: 1.0),
      child: stage.themeController.derived.mainPageToPrimaryColor.build((_,map)
        => InfoSection(
          first: true,
          icon: Icon(
            CSIcons.attackIconOne,
            color: map[CSPage.commanderDamage],
          ),
          title: _attackerTitle,
          info: [
            _attacker1,
            _attacker2,
          ],
        ),
      ),
    );
  }
}