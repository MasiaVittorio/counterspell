import 'package:counter_spell_new/core.dart';
import 'utils.dart';

class PlayerDetailsCommanderSettings extends StatelessWidget {
  final int index;
  final double aspectRatio;
  const PlayerDetailsCommanderSettings(this.index, {required this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return PlayerBuilder(index, (gameState, names, name, playerState, player){

      final bool partner = player.havePartnerB ?? false;

      return Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          RadioSliderOf<bool>(
            selectedItem: partner, 
            items: <bool,RadioSliderItem>{
              false: RadioSliderItem(
                icon: Icon(McIcons.account_outline),
                title: Text("Single"),
              ),
              true: RadioSliderItem(
                icon: Icon(McIcons.account_multiple_outline),
                title: Text("Partners"),
              ),
            }, 
            onSelect: (val) => bloc!.game!.gameState.setHavePartner(name, val),
          ),



          if(partner)
            ...[
              _Section(this.index, partnerA: true, havePartner: true, aspectRatio: aspectRatio),
              _Section(this.index, partnerA: false, havePartner: true, aspectRatio: aspectRatio),
            ]
          else 
            _Section(this.index, partnerA: true, havePartner: false, aspectRatio: aspectRatio),
          
          CSWidgets.height5,
          const _KeepSettings(),

        ],
      );
    },);
  }
}

class _KeepSettings extends StatelessWidget {
  const _KeepSettings();
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final settings = bloc.settings!.gameSettings;
    
    return settings.keepCommanderSettingsBetweenGames.build((context, keep) 
      => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SwitchListTile(
            value: keep!,
            title: const Text("Keep settings between games"),
            subtitle: const Text("(Lifelink, infect...)", style: TextStyle(fontStyle: FontStyle.italic),),
            onChanged: settings.keepCommanderSettingsBetweenGames.set,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: AnimatedText(keep 
              ? "(Don't forget to reset them manually then)"
              : "(Reset for each game is recommended)",
              style: TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}


class _Section extends StatelessWidget {
  final bool partnerA;
  final bool havePartner;
  final int index;
  final double aspectRatio;

  const _Section(this.index, {required this.partnerA, required this.havePartner, required this.aspectRatio}); 

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return PlayerBuilder(index, (gameState, names, name, playerState, player)
      => Section(<Widget>[
        if(havePartner) SectionTitle(partnerA ? "First partner" : "Second partner"),
        _CommanderTile(this.index, 
          partnerA: partnerA, 
          havePartner: havePartner, 
          aspectRatio: aspectRatio,
        ),
        SubSection([
          SwitchListTile(
            value: player.damageDefendersLife(partnerA), 
            onChanged: (lifelink){
              bloc!.game!.gameState.gameState.value.players[name]!.toggleDamageDefendersLife(partnerA);
              bloc.game!.gameState.gameState.refresh();
            },
            title: const Text("Damage to life"),
            secondary: const Icon(Icons.favorite_border),
          ),
          SwitchListTile(
            value: player.infect(partnerA), 
            onChanged: (lifelink){
              bloc!.game!.gameState.gameState.value.players[name]!.toggleInfect(partnerA);
              bloc.game!.gameState.gameState.refresh();
            },
            title: const Text("Infect"),
            secondary: Icon(Counter.poison.icon),
          ),
          SwitchListTile(
            value: player.lifelink(partnerA), 
            onChanged: (lifelink){
              bloc!.game!.gameState.gameState.value.players[name]!.toggleLifelink(partnerA);
              bloc.game!.gameState.gameState.refresh();
            },
            title: const Text("Lifelink"),
            secondary: const Icon(McIcons.needle),
          ),
        ]),
        CSWidgets.height10,
      ],last: !havePartner || !partnerA,),
    );
  }
}

class _CommanderTile extends StatelessWidget {
  final bool partnerA;
  final bool havePartner;
  final int index;
  final double aspectRatio;

  const _CommanderTile(this.index, {required this.partnerA, required this.havePartner, required this.aspectRatio}); 

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context)!;
    final group = bloc.game!.gameGroup;
    final stage = Stage.of(context);
    final state = bloc.game!.gameState;


    return group.names.build((_, names){
      final name = names[index];
        
      final VoidCallback callback = () => stage!.showAlert(ImageSearch(
        (found){
          group.cards(partnerA).value[name] = found;
          group.cards(partnerA).refresh();
          group.savedCards.setKey(name, (group.savedCards.value[name] ?? <MtgCard>{})..add(found));
          
          //Will always reset commander settings on a new card
          if(partnerA) state.gameState.value.players[name]!.commanderSettingsA = CommanderSettings.defaultSettings;
          else state.gameState.value.players[name]!.commanderSettingsB = CommanderSettings.defaultSettings;
          state.gameState.refresh();
        }, 
        searchableCache: <MtgCard>{
          for(final single in group.savedCards.value.values)
            ...single!,
        },
        readyCache: group.savedCards.value[name],
        readyCacheDeleter: (cardToDelete){
          group.savedCards.value[name]!.removeWhere((c) => c.id == cardToDelete.id);
          group.savedCards.refresh(key: name);
        },
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
                  onPressed: ()=>stage!.showAlert(
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