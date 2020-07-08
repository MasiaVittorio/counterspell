import 'package:counter_spell_new/core.dart';

class TheRoller extends StatelessWidget {

  const TheRoller();

  @override
  Widget build(BuildContext context) {
    return Stage<CSPage,SettingsPage>(
      body: _Body(), 
      collapsedPanel: const _Collapsed(), 
      extendedPanel: _Extended(), 
      topBarData: StageTopBarData(
        title: StageBuild.offOpenNonAlert((_, open) => AnimatedText(
          open ? "That's nice" : "< Open Menu",
        )),
      ),
      mainPages: StagePagesData.nullable(
        defaultPage: CSPage.counters,
        orderedPages: const [
          CSPage.history, 
          CSPage.counters, 
          CSPage.commanderCast,
        ],
      ),
      wholeScreen: false,
    );
  }
}




class _Body extends StatelessWidget {
  const _Body();
  @override
  Widget build(BuildContext context) {
    return StageBuild.offMainPage((_, page) => Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: AnimatedText(
        page == CSPage.history 
          ? "Remember that the Arena shortcut is not available in the History page"
          : "You can find random generators in the MAIN MENU, or in ARENA MODE.",
        textAlign: TextAlign.center,
      ),
    ));
  }
}




class _Extended extends StatelessWidget {
  const _Extended();
  @override
  Widget build(BuildContext context) {
    return StageExtendedPanel(children: const <SettingsPage,Widget>{
      SettingsPage.game: _RightPage(),
      SettingsPage.info: _WrongPage(),
      SettingsPage.settings: _WrongPage(),
      SettingsPage.theme: _WrongPage(),
    });
  }
}





class _RightPage extends StatelessWidget {

  const _RightPage();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    return ListView(
      physics: stage.panelScrollPhysics,
      primary: false,
      children: <Widget>[
        const Section(<Widget>[
          PanelTitle("Right page!"),
          SubSection(<Widget>[
            ListTile(title: Text("Stuff"), dense: true,),
          ]),
          CSWidgets.height10,
        ]),

        Section(<Widget>[
          Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: ExtraButton(
                  icon: McIcons.dice_multiple, 
                  text: "Random", 
                  onTap: () => stage.showAlert(
                    _RandomAlert(),
                    size: _RandomAlert.height,
                  ),
                ),
              ),
              for(final _ in [0,1])
                Expanded(child: ExtraButton(
                  icon: Icons.remove_circle_outline, 
                  text: "///", 
                  onTap: (){},
                ),),
          ].separateWith(CSWidgets.extraButtonsDivider),),
        ], last: true,),

        ListTile(subtitle: Text(
          "(^ Press the button up here)", 
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),)
      ],
    );
  }
}

class _RandomAlert extends StatelessWidget {

  const _RandomAlert();

  static const double height = 900;

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      "Dice & Coins Mockup",
      child: ListTile(
        title: Text("Random generators"),
        subtitle: Text("You'll be able to flip coins, pick random names from the current playgroup, and throw dice (switch between d20 and d6 by long pressing on the dice button)"),
      ),
      bottom: SizedBox(
        height: 56,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for(final s in ["coins", "names", "dice"])
              Expanded(child: InkWell(
                onTap: (){},
                child: Center(child: Text(s),
              ),),),
          ],
        ),
      ),
    );
  }
}




class _WrongPage extends StatelessWidget {

  const _WrongPage();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    return ListView(
      physics: stage.panelScrollPhysics,
      primary: false,
      children: <Widget>[
        const Section(<Widget>[
          PanelTitle("Wrong page"),
          ListTile(
            title: Text('Go to the "Game" tab!'),
            leading: Icon(Icons.menu),
          )
        ]),
      ],
    );
  }
}




class _Collapsed extends StatelessWidget {

  const _Collapsed();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return StageBuild.offMainPage((_, page) => Row(children: <Widget>[
        if(page == CSPage.history) 
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_right),
            onPressed: () => stage.mainPagesController.goToPage(CSPage.counters),
          )
        else 
          IconButton(
            icon: const Icon(
              CSIcons.counterSpell, 
              size: CSIcons.ideal_counterspell_size,
            ),
            onPressed: () => stage.showAlert(
              const _ArenaMockup(), 
              size: _ArenaMockup.height,
            ),
          ),

        Expanded(child: Center(
          child: AnimatedText( page == CSPage.history 
            ? "another page (or menu)"
            : "< open Arena mode"
          ),
        ),),

      ],)
    );
  }
}

class _ArenaMockup extends StatelessWidget {

  const _ArenaMockup();

  static const double height = 900;
  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      "Arena Mockup",
      canvasBackground: true,
      alreadyScrollableChild: true,
      child: Padding(
        padding: const EdgeInsets.only(top: PanelTitle.height),
        child: Stack(children: <Widget>[
          Positioned.fill(
            child: Column(children: <Widget>[
              for(final list in [
                ["You will", "find it"],
                ["in the","quick menu"],
              ]) Expanded(
                child: Row(children: <Widget>[
                  for(final string in list)
                    Expanded(child: SubSection(
                      <Widget>[
                        Expanded(child: Center(
                          child: Text(string),
                        ),
                      )],
                      margin: const EdgeInsets.all(8),
                    ),),
                ],),
              ),
            ],),
          ),

          Center(child: FloatingActionButton(
            onPressed: null, 
            child: Icon(Icons.menu),
          ),),

        ],),
      ),
    );
  }
}

