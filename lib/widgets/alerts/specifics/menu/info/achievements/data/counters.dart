import 'package:counter_spell_new/core.dart';

class CountersMaster extends StatelessWidget {
  const CountersMaster();

  @override
  Widget build(BuildContext context) {
    return const Stage<CSPage,SettingsPage>(
      body: _Body(), 
      collapsedPanel: _Collapsed(), 
      extendedPanel: _Extended(), 
      topBarContent: StageTopBarContent(
        title: StageTopBarTitle(panelTitle: "Close the menu!",)
      ),
      mainPages: StagePagesData.nullable(
        defaultPage: CSPage.life,
        orderedPages: [CSPage.counters, CSPage.life, CSPage.commanderCast],
      ),
      wholeScreen: false,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();
  @override
  Widget build(BuildContext context) {
    return StageBuild.offMainPage((_, dynamic page) => Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: AnimatedText(
        page == CSPage.counters 
          ? "Now tap the bottom right shortcut!"
          : 'First, go to the "Counters" page.',
        textAlign: TextAlign.center,
      ),
    ));
  }
}

class _Extended extends StatelessWidget {
  const _Extended();
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: Material(child: SizedBox.expand(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: const Text(
          "The main menu is useless for this task, close it!",
          textAlign: TextAlign.center,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ),));
  }
}


class _Collapsed extends StatelessWidget {

  const _Collapsed();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    final logic = CSBloc.of(context);

    return StageBuild.offMainPage((_, dynamic page) 
      => logic!.game.gameAction.counterSet.build((context, counter) 
        => Row(children: <Widget>[
          Expanded(child: Center(child: AnimatedText(
            page == CSPage.counters
              ? "Selected: ${counter.shortName}"
              : "page-specific stuff",
          ),),),
          IconButton(
            icon:  Icon(
              {
                CSPage.life: McIcons.account_multiple_outline,
                CSPage.counters: counter.icon,
                CSPage.commanderCast: Icons.info_outline,
              }[page] ?? Icons.error_outline
            ),
            onPressed: page == CSPage.counters 
              ? () => stage!.showSnackBar(
                const SnackCounterSelector(),
                rightAligned: true,
              )
              : null,
          ),
        ],),
      ),
    );

  }
}


