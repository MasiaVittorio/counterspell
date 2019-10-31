import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:flutter/material.dart';

class CustomStartingLife extends StatefulWidget {

  @override
  _CustomStartingLifeState createState() => _CustomStartingLifeState();
}

class _CustomStartingLifeState extends State<CustomStartingLife> {
  TextEditingController text;
  
  @override
  void initState() {
    super.initState();
    this.text = TextEditingController();
  }

  @override
  void dispose() {
    this.text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = bloc.stage;

    return Container(
      
    );
  }
}