import 'package:counter_spell_new/core.dart';

class DetailsUtils {

  static void insertLife(StageData stage, String name, CSBloc bloc, PlayerState playerState, List<String> names) 
    => stage.showAlert(InsertAlert(
      inputType: TextInputType.number,
      labelText: "Insert $name's life",
      onConfirm: (string){
        final int val = int.tryParse(string);
        if(val != null){
          bloc.game.gameState.applyAction(GALife(
            val - playerState.life,
            selected: {
              for(final n in names)
                if(n == name) n: true
                else n: false,
            },
            minVal: bloc.settings.minValue.value,
            maxVal: bloc.settings.maxValue.value,
          ));
        }
      }
    ),size: InsertAlert.height);

  static void insertCounter(Counter counter, StageData stage, String name, CSBloc bloc, PlayerState playerState, List<String> names) 
    => stage.showAlert(InsertAlert(
      inputType: TextInputType.number,
      labelText: "Insert $name's ${counter.shortName}",
      onConfirm: (string){
        final int val = int.tryParse(string);
        if(val != null){
          bloc.game.gameState.applyAction(GACounter(
            val - playerState.counters[counter.longName],
            counter,
            selected: {
              for(final n in names)
                if(n == name) n: true
                else n: false,
            },
            minVal: bloc.settings.minValue.value,
            maxVal: bloc.settings.maxValue.value,
          ));
        }
      }
    ),size: InsertAlert.height);

  static void insertCast(bool havePartner, bool partnerB, StageData stage, String name, CSBloc bloc, PlayerState playerState, List<String> names) 
    => stage.showAlert(InsertAlert(
      inputType: TextInputType.number,
      labelText: havePartner??false 
        ? partnerB
          ? "Times $name has cast their SECOND partner (B)"
          : "Times $name has cast their FIRST partner (A)"
        : "Times $name has cast their commander",
      onConfirm: (string){
        final int val = int.tryParse(string);
        if(val != null){
          bloc.game.gameState.applyAction(GACast(
            val - playerState.cast.fromPartner(!partnerB),
            selected: {
              for(final n in names)
                if(n == name) n: true
                else n: false,
            },
            usingPartnerB: {
              for(final n in names)
                if(n == name) n: partnerB
                else n: false,
            },
            maxVal: bloc.settings.maxValue.value,
          ));
        }
      }
    ),size: InsertAlert.height);

  static void insertDamage(
    bool havePartner, bool partnerB, 
    StageData stage, 
    String attacker, String defender, 
    CSBloc bloc, 
    PlayerState defenderState,
    {bool replace = false}
  ) 
    => stage.showAlert(InsertAlert(
      inputType: TextInputType.number,
      twoLinesLabel: true,
      labelText: havePartner??false 
        ? partnerB
          ? "Damage dealt to $defender by $attacker's SECOND partner (B)"
          : "Damage dealt to $defender by $attacker's FIRST partner (A)"
        : "Damage dealt to $defender by $attacker's commander",
      onConfirm: (string){
        final int val = int.tryParse(string);
        if(val != null){
          bloc.game.gameState.applyAction(GADamage(
            val - defenderState.damages[attacker].fromPartner(!partnerB),
            defender: defender,
            attacker: attacker,
            usingPartnerB: partnerB,
            maxVal: bloc.settings.maxValue.value,
            minLife: bloc.settings.minValue.value,
            applyToLife: bloc.settings.applyDamageToLife.value,
          ));
        }
      }
    ),size: InsertAlert.twoLinesHeight, replace: replace ?? false);

  static void partnerDamage(StageData stage, String attacker, String defender, CSBloc bloc, PlayerState defenderState) 
    => stage.showAlert(
      AlternativesAlert(
        label: "Which one of the two $attacker's partners is attacking?",
        alternatives: <Alternative>[
          Alternative(
            title: "First partner (A)",
            icon: CSTypesUI.attackIconOne,
            action: () {
              insertDamage(true, false, stage, attacker, defender, bloc, defenderState, replace: true);
            }
          ),
          Alternative(
            title: "Second partner (B)",
            icon: CSTypesUI.attackIconTwo,
            action: () {
              insertDamage(true, true, stage, attacker, defender, bloc, defenderState, replace: true);
            }
          ),
        ],
      ),
      size: AlternativesAlert.heightCalc(2),
    );


  static void renamePlayer(StageData stage, String name, CSBloc bloc, List<String> names) 
    => stage.showAlert(InsertAlert(
      inputType: TextInputType.text,
      labelText: "Rename $name",
      onConfirm: (string){
        if(string == null) return;
        if(string == "") return;
        if(names.contains(string)) return;
        bloc.game.gameState.renamePlayer(name, string);
      },
      checkErrors: (string){
        if(string == null) return "Error: null string";
        if(string == "") return "Error: empty string";
        if(names.contains(string)) return "This name is already Taken";
        return null;
      },
    ),size: InsertAlert.height);

  static void deletePlayer(StageData stage, String name, CSBloc bloc, List<String> names) 
    => stage.showAlert(ConfirmAlert(
      warningText: "This action cannot be undone, are you sure?",
      confirmColor: CSColors.delete,
      confirmIcon: Icons.delete_forever,
      confirmText: "Yes, delete $name",
      action: () => bloc.game.gameState.deletePlayer(name),
      completelyCloseAfterConfirm: true,
    ),size: ConfirmAlert.height);

}



class PlayerBuilder extends StatelessWidget {
  final int index;
  final Widget Function(GameState, List<String>, String, PlayerState, Player) builder;
  const PlayerBuilder(this.index, this.builder);

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = bloc.stage;
    final gameBloc = bloc.game;
    final groupBloc = gameBloc.gameGroup;
    final stateBloc = gameBloc.gameState;
    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: stage.panelScrollPhysics(),
        child: groupBloc.names.build((_, names){
          final name = names[index];
          return stateBloc.gameState.build((_, state){
            final player = state.players[name];
            return this.builder(state, names, name, player.states.last, player);
          },);
        },),
      ),
    );

  }


}
