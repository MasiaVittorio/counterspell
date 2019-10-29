import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/ui_model/ui_model.dart';
import 'package:counter_spell_new/widgets/resources/alerts/playgroup/playgroup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sidereus/reusable_widgets/reordable_list_simple_reverse.dart';



class CurrentPlayer extends StatefulWidget {
  final String name;
  final CSBloc bloc;
  final UnFocuser unFocuser;
  const CurrentPlayer(this.name,this.bloc, this.unFocuser);
  @override
  _CurrentPlayerState createState() => _CurrentPlayerState();
}

class _CurrentPlayerState extends State<CurrentPlayer> {
  TextEditingController controller;
  bool editing = false;
  FocusNode node;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    node = FocusNode();
    this.widget.unFocuser.listeners[this.widget.name] = this.endEditing;
    editing = false;
  }
  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  void startEditing(){
    this.setState((){
      this.editing = true;
      // this.focusNode.requestFocus();
    });
    this.widget.unFocuser.unFocusExceptFor(widget.name);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(mounted){
        node.requestFocus();
      }
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
  void endEditing() {
    if(!mounted) return;
    this.setState((){
      // this.node.unfocus();
      this.controller.clear();
      this.editing = false;
    });
  }


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
    child: SizedBox(
      width: 56,
      child: editing 
        ? buildLeadingEditing() 
        : buildLeadingDisplay()
    ),
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
    focusNode: node,
    // autofocus: true,
    decoration: InputDecoration(
      isDense: true,
      hintText: "Rename ${widget.name}",
    ),
  );
  Widget buildTitleDisplay() => Text(widget.name);



}