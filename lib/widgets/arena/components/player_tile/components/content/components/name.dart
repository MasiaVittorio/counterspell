import 'package:counter_spell_new/core.dart';


class AptName extends StatelessWidget {

  AptName({
    @required this.bloc,
    @required this.gameState,
    @required this.name,
    @required this.whoIsAttacking,
    @required this.whoIsDefending,
  });

  final CSBloc bloc;
  final GameState gameState;
  final String name;
  final String whoIsAttacking;
  final String whoIsDefending;

  @override
  Widget build(BuildContext context) {
    return bloc.settings.arenaHideNameWhenImages.build((_, hideNameWithImage){
      if(hideNameWithImage){
        final bool thereIsCard = bloc.game.gameGroup.cards(
          !this.gameState.players[name].usePartnerB,
        ).value[name] != null;
        
        if(thereIsCard) return SizedBox();
      }

      String text = "$name";
      if(whoIsAttacking != null && whoIsAttacking != ""){
        if(whoIsAttacking == name) text += " (attacking)";
        else text += " (dmg taken)";
      }
      return AnimatedText("$text", style: const TextStyle(fontSize: 16),);
    },);
  }
}