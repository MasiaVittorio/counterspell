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
        home: const _ReviewInitializer(),
      ),
    );
      
  }
}

class _ReviewInitializer extends StatefulWidget {
  const _ReviewInitializer();
  @override
  __ReviewInitializerState createState() => __ReviewInitializerState();
}

class __ReviewInitializerState extends State<_ReviewInitializer> {

  @override
  void initState() {
    super.initState();
    Review.init(
      prompt: () => showReviewPrompt(
        context: context,
        child: ReviewPrompt(
          roundCard: true,
          buttonShape: ButtonShape.normal,
          buttonStyle: ButtonStyle.filled,

          prompt: "Seems like you've used CounterSpell a lot! How do you feel about it?",

          likeIt: "I like it!",
          thanks: "Love to hear that!",

          duration: const Duration(milliseconds: 220),

          autoPopWhenOverscroll: true,
          onReview: CSActions.review,
          alternatives: <Widget>[
            // FeedbackTile(settings),
            // TelegramTile(settings),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return const CSHomePage(key: KEY_HOME_PAGE);
  }
}