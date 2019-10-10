import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/themes/material_community_icons.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/reordable_list_simple_reverse.dart';



class CurrentPlayer extends StatefulWidget {
  final String name;
  final CSBloc bloc;
  const CurrentPlayer(this.name,this.bloc);
  @override
  _CurrentPlayerState createState() => _CurrentPlayerState();
}

class _CurrentPlayerState extends State<CurrentPlayer> {
  TextEditingController controller;
  bool editing = false;
  FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener((){
      if(mounted){
        if(focusNode.hasPrimaryFocus == false){
          this.endEditing();
        }
      }
    });
    editing = false;
  }
  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void startEditing(){
    this.setState((){
      this.editing = true;
      // this.focusNode.requestFocus();
    });
  }
  void confirm(){
    this.widget.bloc.game.gameState.renamePlayer(
      widget.name, 
      controller.text,
    );
    this.endEditing();
  }
  void cancel() => this.endEditing();
  void endEditing() => this.setState((){
    this.controller.clear();
    this.editing = false;
  });


  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: IconThemeData(opacity: 1.0),
      child: ListTile(
        onTap: startEditing,
        leading: buildLeading(),
        title: buildTitle(), 
        trailing: buildTrailing(),
      ),
    );
  }


  Widget buildTrailing() => IconTheme.merge(
    data: IconThemeData(opacity: 1.0),
    child: editing 
      ? buildTrailingEditing() 
      : buildTrailingDisplay()
  );
  Widget buildTrailingEditing() => IconButton(
    icon: Icon(Icons.check),
    onPressed: this.confirm,
  );
  Widget buildTrailingDisplay() => IconButton(
    icon: Icon(
      McIcons.delete_forever_outline, 
      color: DELETE_COLOR,
    ),
    onPressed: () => widget.bloc.game.gameState.deletePlayer(widget.name),
  );


  Widget buildLeading() => IconTheme.merge(
    data: IconThemeData(opacity: 1.0),
    child: editing 
      ? buildLeadingEditing() 
      : buildLeadingDisplay()
  );
  Widget buildLeadingEditing() => IconButton(
    icon: Icon(Icons.close),
    onPressed: this.cancel,
  );
  Widget buildLeadingDisplay() => ReorderableListener(
    child: const IconButton(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      icon: const Icon(Icons.unfold_more),
      onPressed: null,
      tooltip: 'Move Player',
    ),
  );
  

  Widget buildTitle() => editing 
    ? buildTitleEditing()
    : buildTitleDisplay();

  Widget buildTitleEditing() => TextField(
    controller: controller,
    keyboardType: TextInputType.text,
    textCapitalization: TextCapitalization.words,
    maxLines: 1,
    // maxLength: 20,
    autofocus: true,
    decoration: InputDecoration(
      isDense: true,
      hintText: "Rename ${widget.name}",
    ),
  );
  Widget buildTitleDisplay() => Text(widget.name);



}