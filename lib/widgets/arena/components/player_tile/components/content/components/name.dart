import 'package:counter_spell_new/core.dart';


class AptName extends StatelessWidget {

  AptName({
    required this.bloc,
    required this.gameState,
    required this.name,
    required this.whoIsAttacking,
    required this.whoIsDefending,
  });

  final CSBloc? bloc;
  final GameState? gameState;
  final String name;
  final String? whoIsAttacking;
  final String? whoIsDefending;

  bool get usingPartnerB => gameState!.players[name]?.usePartnerB ?? false;

  @override
  Widget build(BuildContext context) {
    return bloc!.settings.arenaSettings.hideNameWhenImages.build((_, hideNameWithImage){
      bool hideName = hideNameWithImage && (bloc!.game.gameGroup.cards(!usingPartnerB).value[name] != null);
      /// check if an image is there for this player

      String text = hideName ? "" : "$name ";
      if(whoIsAttacking != null && whoIsAttacking != ""){
        if(whoIsAttacking == name) text += "(attacking)";
        else text += "(dmg taken)";
      }
      return AnimatedText("$text", style: const TextStyle(fontSize: 16),);
    },);
  }
}