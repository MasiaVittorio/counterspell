import 'package:counter_spell_new/core.dart';
import 'all.dart';

class CachePlayers extends StatelessWidget {

  const CachePlayers();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final stage = Stage.of(context);

    return bloc.game.gameGroup.savedCards.build((_, cards) {
      final List<String> players = cards.keys.toList()
        ..sort((a,b) => cards[b]!.length - cards[a]!.length);

      return ListView.builder(
        padding: const EdgeInsets.only(top: PanelTitle.height),
        physics: stage!.panelController.panelScrollPhysics(),
        itemBuilder: (_, index){
          final player = players[index];
          return ListTile(
            title: Text(player),
            subtitle: Text("${cards[player]!.length} cards"),
            leading: const Icon(McIcons.account_outline),
            trailing: IconButton(
              icon: CSWidgets.deleteIcon,
              onPressed: () => stage.showAlert(
                ConfirmAlert(
                  confirmText: "Clear $player's cache",
                  confirmColor: CSColors.delete,
                  confirmIcon: Icons.delete_forever,
                  action: () => bloc.game.gameGroup.savedCards.removeKey(player),
                ),
                size: ConfirmAlert.height,
              ),
            ),
            onTap: () => stage.showAlert(CachePlayer(player), size: CachePlayer.height),
          );
        },
        itemCount: cards.length,
      );
    },);
  }
}
