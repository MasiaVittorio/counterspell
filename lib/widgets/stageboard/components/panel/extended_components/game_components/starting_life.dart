import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/material_community_icons.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage/stage.dart';


//UI for changing the default starting life total
class StartingLifeTile extends StatelessWidget {

  const StartingLifeTile();

  //function to build every radio button for 20 / 30 / 40 life totals
  Widget _buildButton(int value, int current, CSBloc bloc, Color color){
    return Expanded(
      child: InkWell(
        onTap: () => bloc.settings.startingLife.set(value),
        child: Padding(
          padding: EdgeInsets.only(right:16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RadioIcon(
                value: value == current,
                inactiveIcon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                activeColor: color,
              ),
              Text('$value'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    //names for the different default starting life totals
    final Map<int,String> _lfnm ={
      20: 'Regular',
      30: 'Two Headed Giants',
      40: 'Commander',
    };

    final bloc = CSBloc.of(context);
    final settings= bloc.settings;
    final startingLife = settings.startingLife;
    final stage = Stage.of<CSPage,SettingsPage>(context);

    //rebuild every time the default life changes
    return BlocVar.build2(
      startingLife,
      stage.themeController.primaryColorsMap,
      builder: (_, life, colorMap)
        => Column(
          children: <Widget>[

            ListTile(
              leading: const Icon(McIcons.flag_outline),
              trailing: const Icon(McIcons.pencil_outline),
              title: AnimatedText(text:'Starting Life: ' + ( _lfnm[life] ?? 'Custom ($life)')),
              onTap: (){}, //TODO: insert custom default life
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildButton(20, life, bloc, colorMap[CSPage.life]),
                _buildButton(30, life, bloc, colorMap[CSPage.life]),
                _buildButton(40, life, bloc, colorMap[CSPage.life]),
              ],
            ),
          ],
        ),
    );
  }
  
}

