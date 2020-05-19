import 'package:counter_spell_new/core.dart';

class CachePlayer extends StatelessWidget {

  final String player;
  const CachePlayer(this.player);

  static const double height = 450.0;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);

    return HeaderedAlert(player, 
      alreadyScrollableChild: true,
      child: bloc.game.gameGroup.savedCards.build((_, map) {
        final List<MtgCard> cards = <MtgCard>[...map[this.player]];

        return ListView.builder(
          padding: const EdgeInsets.only(top: PanelTitle.height),
          physics: stage.panelController.panelScrollPhysics(),
          itemBuilder: (_, index){
            final MtgCard card = cards[index];
            return CardTile(
              card,
              callback: null,
              trailing: IconButton(
                icon: CSWidgets.deleteIcon,
                onPressed: (){
                  bloc.game.gameGroup.savedCards.value[this.player].removeWhere((c) => c.id == card.id);
                  bloc.game.gameGroup.savedCards.refresh(key: this.player);
                }, 
              ),
            );
          },
          itemCount: cards.length,
        );
      },),
    );
  }
}