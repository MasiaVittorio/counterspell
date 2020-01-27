import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/simple_view/simple_group_route.dart';


class PanelGameExtras extends StatelessWidget {

  const PanelGameExtras();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: ExtraButton(
            icon: McIcons.dice_multiple,
            text: "Random",
            onTap: () => stage.showAlert(DiceThrower(), size: DiceThrower.height),
          ),),
          Expanded(child: bloc.payments.unlocked.build((_, unlocked) => ExtraButton(
            icon: McIcons.trophy,
            text: "Leaderboards",
            onTap: () {
                if(unlocked){
                  stage.showAlert(const Leaderboards(), size: Leaderboards.height);
                } else {
                  stage.showAlert(const Support(), size: Support.height);
                }
              },
          ),),),
          Expanded(child: ExtraButton(
            icon: CSIcons.simpleViewIcon,
            iconSize: 20,
            text: "Simple screen",
            onTap: () => showSimpleGroup(context: context, bloc: bloc),
          ),),
        ].separateWith(SizedBox(width: 10,)),
      ),
    );


  }
}


