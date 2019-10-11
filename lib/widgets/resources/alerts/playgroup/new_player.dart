import 'dart:math';

import 'package:counter_spell_new/blocs/bloc.dart';
import 'playgroup.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/animated_widgets/animated_widgets.dart';


class NewPlayer extends StatefulWidget {
  final CSBloc bloc;
  final UnFocuser unFocuser;
  const NewPlayer(this.bloc, this.unFocuser);
  @override
  _NewPlayerState createState() => _NewPlayerState();
}

class _NewPlayerState extends State<NewPlayer> {
  TextEditingController controller;
  bool editing = false;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    this.widget.unFocuser.listeners[""] = this.endEditing;
    editing = false;
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void startEditing(){
    this.widget.unFocuser.unFocusExceptFor("");
    this.setState((){
      this.editing = true;
      // this.focusNode.requestFocus();
    });
  }
  void confirm(){
    this.widget.bloc.game.gameState
      .addNewPlayer(this.controller.text);
    this.endEditing();
  }
  void cancel() => this.endEditing();
  void endEditing() {
    if(!mounted) return;
    this.setState((){
      this.controller.clear();
      this.editing = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: this.startEditing,
      leading: buildLeading(),
      trailing: buildTrailing(),
      title: buildTitle(),
    );
  }


  Widget buildLeading() => IconButton(
    onPressed: editing ? this.cancel : this.startEditing,
    icon: AnimatedDouble(
      duration: const Duration(milliseconds: 200),
      value: editing ? pi/4 : 0.0,
      curve: Curves.easeInBack,
      builder: (context, val) => Transform.rotate(
        angle: val,
        child: Icon(Icons.add),
      ),
    ),
  );

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
  Widget buildTrailingDisplay() => const SizedBox();


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
      hintText: "Player's name",
    ),
  );
  Widget buildTitleDisplay() => Text("New Player");


}