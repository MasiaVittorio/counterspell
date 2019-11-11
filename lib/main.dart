import 'package:counter_spell_new/widgets/homepage.dart';

import 'core.dart';

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
      child: StageProvider<CSPage,SettingsPage>(
        data: bloc.stageBloc.controller,
        child: const _MaterialApp(),
      ),
    );
  }
    
}

class _MaterialApp extends StatelessWidget {
  const _MaterialApp();
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of<CSPage,SettingsPage>(context);
    return stage.themeController.currentThemeData.build((_,theme)
      => MaterialApp(
        theme: theme,
        title: 'CounterSpell',
        home: const CSHomePage(key: KEY_HOME_PAGE),
      ),
    );
      
  }
}