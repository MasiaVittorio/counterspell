import 'package:counter_spell_new/core.dart';
import 'utils.dart';

class PlayerDetailsCommanderSettings extends StatelessWidget {
  final int index;
  final double aspectRatio;
  const PlayerDetailsCommanderSettings(this.index, {@required this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return PlayerBuilder(index, (gameState, names, name, playerState, player){

      final bool partner = player.havePartnerB ?? false;

      return Column(
        mainAxisSize: MainAxisSize.min, 
        children: <Widget>[
          ListTile(
            title: Text(partner ? "Two partners" : "One commander"),
            leading: Icon(partner ? McIcons.account_multiple_outline :McIcons.account_outline),
            trailing: FlatButton.icon(
              label: Text(partner ? "Merge" : "Split"),
              icon: Icon(Icons.exit_to_app),
              onPressed: ()=> bloc.game.gameState.toggleHavePartner(name),
            ),
          ),



          if(partner)
            ...[
              _Section(this.index, partnerA: true, havePartner: true, aspectRatio: aspectRatio),
              _Section(this.index, partnerA: false, havePartner: true, aspectRatio: aspectRatio),
            ]
          else 
            _Section(this.index, partnerA: true, havePartner: false, aspectRatio: aspectRatio),

          Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text("WARNING: Lifelink and infect get disabled every time you start a new game"),
          ),

        ],
      );
    },);
  }
}

class _Section extends StatelessWidget {
  final bool partnerA;
  final bool havePartner;
  final int index;
  final double aspectRatio;

  const _Section(this.index, {@required this.partnerA, @required this.havePartner, @required this.aspectRatio}); 

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return PlayerBuilder(index, (gameState, names, name, playerState, player){
      return Section([
        if(havePartner) SectionTitle(partnerA ? "First partner" : "Second partner"),
        _CommanderTile(this.index, 
          partnerA: partnerA, 
          havePartner: havePartner, 
          aspectRatio: aspectRatio,
        ),
        const Padding(
          padding: const EdgeInsets.only(left: 56+8.0),
          child: const Divider(height: 2,),
        ),
        SwitchListTile(
          value: player.damageDefendersLife(partnerA), 
          onChanged: (lifelink){
            bloc.game.gameState.gameState.value.players[name].toggleDamageDefendersLife(partnerA);
            bloc.game.gameState.gameState.refresh();
          },
          title: const Text("Damage to life"),
          secondary: const Icon(Icons.favorite_border),
        ),
        SwitchListTile(
          value: player.infect(partnerA), 
          onChanged: (lifelink){
            bloc.game.gameState.gameState.value.players[name].toggleInfect(partnerA);
            bloc.game.gameState.gameState.refresh();
          },
          title: const Text("Infect"),
          secondary: Icon(Counter.poison.icon),
        ),
        SwitchListTile(
          value: player.lifelink(partnerA), 
          onChanged: (lifelink){
            bloc.game.gameState.gameState.value.players[name].toggleLifelink(partnerA);
            bloc.game.gameState.gameState.refresh();
          },
          title: const Text("Lifelink"),
          secondary: const Icon(McIcons.needle),
        ),
      ]);
    },);
  }
}

class _CommanderTile extends StatelessWidget {
  final bool partnerA;
  final bool havePartner;
  final int index;
  final double aspectRatio;

  const _CommanderTile(this.index, {@required this.partnerA, @required this.havePartner, @required this.aspectRatio}); 

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;


    return group.names.build((_, names){
      final name = names[index];
        
      final VoidCallback callback = () => Stage.of(context).showAlert(ImageSearch(
        (found){
          group.cards(partnerA).value[name] = found;
          group.cards(partnerA).refresh();
          group.savedCards.privateValue[name] = (group.savedCards.privateValue[name] ?? <MtgCard>{})..add(found);
          group.savedCards.forceWrite();
        }, 
        searchableCache: <MtgCard>{
          for(final single in group.savedCards.value.values)
            ...single,
        },
        readyCache: group.savedCards.value[name],
      ), size: ImageSearch.height);

      return group.cards(partnerA).build((_,cards) {
        final card = cards[name];
        if(card == null) {
          return ListTile(
            title: const Text("Commander image"),
            leading: const Icon(McIcons.cards_outline),
            subtitle: const Text("None"),
            onTap: callback,
          );
        } else {
          return CardTile(
            card,
            autoClose: false,
            callback: (_) => callback(),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: ()=>Stage.of(context).showAlert(
                    ImageAlign(card.imageUrl(), aspectRatio: aspectRatio,),
                    size: ImageAlign.height,
                  ),
                  icon: const Icon(Icons.vertical_align_center),
                ),
                IconButton(
                  onPressed: () {
                    group.cards(partnerA).value.remove(name);
                    group.cards(partnerA).refresh();
                  },
                  icon: const Icon(Icons.delete_outline, color: CSColors.delete,),
                ),
              ],
            ),
          );
        }
      });
    });
  }
}