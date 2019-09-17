import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/counterspell_widget_keys.dart';
import 'package:counter_spell_new/widgets/scaffold/homepage.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/bloc/bloc_provider.dart';

void main() => runApp(ScryWalker());

class ScryWalker extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _ScryWalkerState createState() => _ScryWalkerState();
}

class _ScryWalkerState extends State<ScryWalker> {
  CSBloc bloc;

  @override
  void initState() {
    bloc = CSBloc();
    super.initState();
  }


  @override
  Widget build(context) {
    return BlocProvider<CSBloc>(
      bloc: bloc,
      child: bloc.themer.currentWidget(
        builder: (context, theme)
          => MaterialApp(
            theme: theme.data, //so all the sheets under the navigator get the new theme
            title: 'ScryWalker',
            home: LayoutBuilder( builder: (context, constraints) {

              bloc.context = context;

              bloc.scaffold.updateDimensions(context, constraints);
              // bloc.themer.updateBrightness();

              return const CSHomePage(key: KEY_HOME_PAGE);
            }),
          )
      ),
    );
  }
    
}
