import 'package:counter_spell_new/core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as rl;
// TODO: check flutter native reorderable list

class PlayGroupEditor extends StatefulWidget {
  final CSBloc bloc;
  final bool fromClosedPanel;
  const PlayGroupEditor(this.bloc,{
    required this.fromClosedPanel,
  });

  static const double playerTileSize = 56.0;
  static const double titleSize = PanelTitle.height;
  static const double hintSize = 44;
  static const double newPlayerSize = playerTileSize + hintSize;
  static double sizeCalc(int howMany) => (howMany.clamp(1, 5.5)) * playerTileSize + titleSize + newPlayerSize;

  @override
  _PlayGroupEditorState createState() => _PlayGroupEditorState();
}

class _PlayGroupEditorState extends State<PlayGroupEditor> {
  TextEditingController? controller;
  FocusNode? focusNode;
  String? edited;
  //"" => newPlayer
  bool newGrouping = false;

  @override
  void initState() {
    super.initState();
    this.controller = TextEditingController();
    this.focusNode = FocusNode();
    widget.bloc.achievements.playGroupEdited(widget.fromClosedPanel);
  }
  @override
  void dispose() {
    this.focusNode!.dispose();
    this.controller!.dispose();
    super.dispose();
  }

  CSBloc get bloc => widget.bloc;
  CSGame? get game => bloc.game;
  CSGameState? get state => game!.gameState;
  CSGameGroup? get group => game!.gameGroup;

  void _reCalcSize(){
    final int howMany = state!.gameState.value.players.length;
    final stage = Stage.of(context)!;
    stage.panelController.alertController.recalcAlertSize(PlayGroupEditor.sizeCalc(howMany));
  }

  void startEditing(String who){
    this.setState((){
      this.edited = who;
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      this.focusNode!.requestFocus();
    });
  }
  void _endEditing(){
    this.controller!.clear();
    this.setState((){
      this.edited = null;
      this.focusNode!.unfocus();
    });
  }
  void confirm(){
    if(edited == ""){
      state!.addNewPlayer(controller!.text);
    } else {
      state!.renamePlayer(edited, controller!.text);
    }
    this._endEditing();
    this._reCalcSize();
  }
  void cancel(){
    this._endEditing();
  }

  void startNewGroup(){
    this.setState((){
      this.newGrouping = true;
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      this.focusNode!.requestFocus();
    });
  }
  void _endNewGrouping(){
    this.controller!.clear();
    this.setState((){
      this.newGrouping = false;
      this.focusNode!.unfocus();
    });
  }
  int? validateNumber(){
    int? result;
    try {
      final int howMany = int.parse(this.controller!.text);
      if(howMany > 0 && howMany <= maxNumberOfPlayers){
        result = howMany;
      }
    } catch (e) {
      result = null;
    }
    return result;
  }
  void confirmNewGroup(){
    final int? howMany = validateNumber();
    if(howMany != null){
      this.state!.startNew({
        for(int i=1; i<=howMany; ++i)
          "Player $i",
      });
      this._endNewGrouping();
    }
    this._reCalcSize();
  }
  void cancelNewGroup(){
    this._endNewGrouping();
  }
  void start(String? who){
    if(who != null){
      if(newGrouping){
        this._endNewGrouping();
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          this.startEditing(who);
        });
      } else if(edited != null){
        if(edited == who){
          return;
        } else {
          this._endEditing();
          SchedulerBinding.instance!.addPostFrameCallback((_) {
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
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          this.startNewGroup();
        });
      } else {
        this.startNewGroup();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final backgroundColor = themeData.scaffoldBackgroundColor;


    return IconTheme.merge(
      data: IconThemeData(opacity: 1.0),
      child: WillPopScope(
        onWillPop: ()async{
          if(edited != null){
            this._endEditing();
            return false;
          }
          if(newGrouping){
            this._endNewGrouping();
            return false;
          }
          return true;
        },
        child: Material(
          color: backgroundColor,
          child: group!.names.build((context, names) {

            final Widget textField = TextField(
              key: const ValueKey("counterspell_key_widget_textfield_groupeditor"),
              onChanged: (_){
                if(this.mounted){
                  this.setState((){});
                }
              },
              controller: this.controller,
              keyboardType: newGrouping
                ? TextInputType.number 
                : TextInputType.text,
              textCapitalization: TextCapitalization.words,
              maxLines: 1,
              // maxLength: 20,
              // autofocus: true,
              focusNode: this.focusNode,
              decoration: InputDecoration(
                isDense: true,
                hintText: edited == ""
                  ? "Player's name"
                  : edited != null 
                    ? "Rename $edited"
                    : newGrouping 
                      ? "How many players"
                      : null,
                errorText: (newGrouping && validateNumber() == null) 
                  ? "Insert a number between 2 and $maxNumberOfPlayers" 
                  : (edited == "" && names.contains(this.controller!.text))
                    ? "Name a different player"
                    : null,
              ),
            );

            return Column(
              children: <Widget>[
                const Material(child: const PanelTitle("Edit Playgroup"),),
                Expanded(
                  child: Material(
                    elevation: 2,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: rl.ReorderableList(
                        onReorder: (from,to){
                          final String name = group!.names.value
                            .firstWhere((name)=> ValueKey(name) == from);
                          final int newIndex = group!.names.value
                            .indexWhere((name)=> ValueKey(name) == to);
                          group!.moveName(name, newIndex);
                          return true;
                        },
                        child: ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: <Widget>[
                            for(final name in names)
                              rl.ReorderableItem(
                                key: ValueKey(name),
                                childBuilder: (context, state) => Material(
                                  child: Opacity(
                                    opacity: state == rl.ReorderableItemState.placeholder ? 0.0 : 1.0,
                                    child: IgnorePointer(
                                      ignoring: state == rl.ReorderableItemState.placeholder,
                                      child: currentPlayer(name, textField, themeData, names.length == 1),
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
                hints(themeData,names),
                newPlayer(textField),
              ],
            );
          },
          ),
        ),
      ),
    );
  }

  Widget hints(ThemeData themeData, List<String> currentNames){
    return SizedBox(
      height: PlayGroupEditor.hintSize,
      child: group!.savedNames.build((context, savedNames) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            for(final savedName in savedNames)
              if(
                savedName!.toLowerCase().contains(controller!.text.toLowerCase()) && 
                controller!.text != "" &&
                controller!.text != savedName &&
                !currentNames.contains(savedName)
              )
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkResponse(
                    splashColor: Colors.transparent,
                    onTap: (){
                      this.controller!.text = savedName;
                      this.confirm();
                    },
                    child: Chip(
                      onDeleted: () => group!.unSaveName(savedName),
                      backgroundColor: themeData.canvasColor,
                      elevation: 1,
                      label: Text(savedName),
                    ),
                  ),
                ),
          ],
        );
      }),
    );
  }

  Widget newPlayer(Widget textField){
    if(edited == "") return editNewPlayer(textField);
    if(newGrouping) return editNewGroup(textField);
    return promptNewPlayer();
  }
  Widget editNewPlayer(Widget textField){
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: this.cancel,
      ),
      trailing: IconButton(
        icon: Icon(Icons.check),
        onPressed: this.confirm,
      ),
      title: textField,
    );
  }
  Widget promptNewPlayer(){
    return ListTile(
      onTap: () => this.start(""),
      leading: IconButton(onPressed: () => this.start(""), icon: Icon(Icons.add)),
      title: Text("New Player"),
      trailing: IconButton(
        onPressed: () => this.start(null),
        icon: Icon(Icons.repeat),
      ),
    );
  }
  Widget editNewGroup(Widget textField){
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: this.cancelNewGroup,
      ),
      trailing: IconButton(
        icon: Icon(Icons.check),
        onPressed: this.confirmNewGroup,
      ),
      title: textField,
    );
  }

  Widget currentPlayer(String name, Widget textField, ThemeData themeData, bool last){
    Widget result;
    if(name == edited) result = editCurrentPlayer(name, textField);    
    else result = promptCurrentPlayer(name, themeData, last);
    return SizedBox(
      height: PlayGroupEditor.playerTileSize,
      child: result,
    );
  }
  Widget promptCurrentPlayer(String name, ThemeData themeData, bool last){
    return ListTile(
      onTap: () => this.start(name),
      trailing: rl.ReorderableListener(
        child: IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          icon: Icon(Icons.unfold_more, color: themeData.colorScheme.onSurface,),
          onPressed: null,
          tooltip: 'Move Player',
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.delete_forever, 
          color: CSColors.delete,
        ),
        onPressed: last ? null : () {
          widget.bloc.game!.gameState.deletePlayer(name);
          this._reCalcSize();
        },
      ),
      title: Text(name),
    );
  }
  Widget editCurrentPlayer(String name, Widget textField){
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: this.cancel,
      ),
      title: textField,
      trailing: IconButton(
        icon: Icon(Icons.check),
        onPressed: this.confirm,
      ),
    );
  }
}