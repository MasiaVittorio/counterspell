import 'package:counter_spell_new/core.dart';

class CacheCards extends StatelessWidget {

  const CacheCards();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final stage = Stage.of(context);

    return bloc.game!.gameGroup.savedCards.build((_, map) {
      final Set<MtgCard> cardsSet = <MtgCard>{};
      final Map<MtgCard, Set<String>> players = <MtgCard,Set<String>>{};
      for(final playerEntry in map.entries){
        for(final card in playerEntry.value!){
          cardsSet.add(card);
          players[card] = (players[card] ?? <String>{})..add(playerEntry.key);
        }
      }
      final List<MtgCard> cards = <MtgCard>[...cardsSet]
        ..sort((a,b) => a.name.compareTo(b.name));

      return ListView.builder(
        padding: const EdgeInsets.only(top: PanelTitle.height),
        physics: stage!.panelController.panelScrollPhysics(),
        itemCount: cards.length,
        itemBuilder: (_, index){
          final MtgCard card = cards[index];
          return CardTile(
            card,
            callback: null,
            trailing: IconButton(
              icon: CSWidgets.deleteIcon,
              onPressed: (){
                for(final String player in players[card]!){
                  bloc.game!.gameGroup.savedCards.value[player]!.removeWhere((c) => card == c);
                  bloc.game!.gameGroup.savedCards.refresh(key: player);
                }
              }, 
            ),
          );
        },
      );
    },);
  }
}
