import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/blocs/sub_blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';

class PlayGroupEditor extends StatefulWidget {
  final CSBloc bloc;
  const PlayGroupEditor(this.bloc);

  static const double playerTileSize = 56.0;
  static const double titleSize = 32;
  static const double hintSize = 32;
  static const double newPlayerSize = playerTileSize + hintSize;
  static double sizeCalc(int howMany) => (howMany) * playerTileSize + titleSize + newPlayerSize;

  @override
  _PlayGroupEditorState createState() => _PlayGroupEditorState();
}

class _PlayGroupEditorState extends State<PlayGroupEditor> {
  TextEditingController name;
  String edited;
  //"" => newPlayer
  TextEditingController number;
  bool newGrouping = false;

  @override
  void initState() {
    super.initState();
    this.name = TextEditingController();
    this.number = TextEditingController();
  }
  @override
  void dispose() {
    this.name.dispose();
    this.number.dispose();
    super.dispose();
  }

  CSBloc get bloc => widget.bloc;
  CSGame get game => bloc.game;
  CSGameState get state => game.gameState;
  CSGameGroup get group => game.gameGroup;

  void startEditing(String who){
    this.setState((){
      this.edited = who;
    });
  }
  void _endEditing(){
    this.setState((){
      this.name.clear();
      this.edited = null;
    });
  }
  void confirm(){
    if(edited == ""){
      state.addNewPlayer(name.text);
    } else {
      state.renamePlayer(edited, name.text);
    }
    this._endEditing();
  }
  void cancel(){
    this._endEditing();
  }

  void startNewGroup(){
    this.setState((){
      this.newGrouping = true;
    });
  }
  void _endNewGrouping(){
    this.number.clear();
    this.setState((){
      this.newGrouping = false;
    });
  }
  int validateNumber(){
    int result;
    try {
      final int howMany = int.parse(this.number.text);
      if(howMany > 0 && howMany <= maxNumberOfPlayers){
        result = howMany;
      }
    } catch (e) {
      result = null;
    }
    return result;
  }
  void confirmNewGroup(){
    final int howMany = validateNumber();
    if(howMany != null){
      this.state.startNew({
        for(int i=1; i<=howMany; ++i)
          "Player $i",
      });
      this._endNewGrouping();
    }
  }
  void cancelNewGroup(){
    this._endNewGrouping();
  }
  void start(String who){
    if(who != null){
      if(newGrouping){
        this._endNewGrouping();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          this.startEditing(who);
        });
      } else if(edited != null){
        if(edited == who){
          return;
        } else {
          this._endEditing();
          SchedulerBinding.instance.addPostFrameCallback((_) {
            this.startEditing(who);
          });
        }
      } else {
        this.startEditing(who);
      }
    } else {
      if(newGrouping){
        return;
      } else if(edited != null){
        this._endEditing();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          this.startNewGroup();
        });
      } else {
        this.startNewGroup();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return ListTileTheme.merge(
      contentPadding: const EdgeInsets.all(0.0),
      child: Material(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            Material(
              child: Container(
                height: 32,
                alignment: Alignment.center,
                child: Text("Edit Playgroup"),
              ),
            ),
            Expanded(
              child: group.names.build((context, names) 
                => Material(
                  elevation: 2,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ReorderableList(
                      onReorder: (from,to){
                        final String name = group.names.value
                          .firstWhere((name)=> ValueKey(name) == from);
                        final int newIndex = group.names.value
                          .indexWhere((name)=> ValueKey(name) == to);
                        group.moveName(name, newIndex);
                        return true;
                      },
                      child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        children: <Widget>[
                          for(final name in names)
                            ReorderableItem(
                              key: ValueKey(name),
                              childBuilder:(context,state) => Material(
                                child: Opacity(
                                  opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
                                  child: IgnorePointer(
                                    ignoring: state == ReorderableItemState.placeholder,
                                    // child: CurrentPlayer(bloc, name),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // NewPlayer(bloc),
          ],
        ),
      ),
    );
  }
}