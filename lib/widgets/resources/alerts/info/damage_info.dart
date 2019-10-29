import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/ui_model/ui_model.dart';
import 'package:counter_spell_new/widgets/resources/alerts/info/info_basics.dart';
import 'package:flutter/material.dart';
import 'package:stage/stage.dart';


const String _attackerTitle = "Select the attacker";
const String _attacker1 = "tap on a player to set it as the one dealing the damage";
const String _attacker2 = "the other players will become blue, as possible defenders";
const String _partnerTitle = "Select the right partner";
const String _partner1 = "tap on the sword icon to split the commander into two partners";
const String _partner2 = "tap again on the attacker to switch between partners A and B";
const String _defenderTitle = "Scroll on the defender";
const String _defender1 = "increment the damage taken by a player from the selected commander";
const String _defender2 = "this will lower the defender's life unless you disable this setting";

class DamageInfo extends StatelessWidget {
  const DamageInfo();
  static const double height = 3 * InfoTitle.height + 6 * PieceOfInfo.height + 2 * divider;
  static const double divider = 8.0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: Stage.of(context).panelScrollPhysics(),
      primary: true,
      child: Container(
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _AttackerSection(),
            const Divider(height: divider,),
            const InfoSection(
              icon: const Icon(McIcons.account_multiple_outline),
              title: _partnerTitle,
              info: [
                _partner1,
                _partner2,
              ],
            ),
            const Divider(height: divider,),
            const _DefenderSection(),
          ],
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
      child: CSBloc.of(context).themer.theme.build((_,theme)=>InfoSection(
        icon: Icon(
          CSTypesUI.defenceIconFilled,
          color: theme.commanderDefence,
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
      child: stage.themeController.primaryColorsMap.build((_,map)
        => InfoSection(
          icon: Icon(
            CSTypesUI.attackIconOne,
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