import 'package:counter_spell_new/core.dart';

class UIExpert extends StatelessWidget {
  const UIExpert();

  @override
  Widget build(BuildContext context) {
    return const Stage<CSPage,SettingsPage>(
      body: _Body(), 
      collapsedPanel: _Collapsed(), 
      extendedPanel: _Extended(), 
      topBarContent: StageTopBarContent(
        title: StageTopBarTitle(panelTitle: "CounterSpell",)
      ),
      mainPages: StagePagesData.nullable(
        defaultPage: CSPage.life,
        orderedPages: [CSPage.history, CSPage.life, CSPage.commanderCast],
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            "Each page has different shortcuts on the bottom right.",
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const Text(
            "The MENU and ARENA MODE also have buttons for restarting and playgroup editing.",
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          AnimatedText(
            {
              CSPage.life: '"Life" page has an "Edit playgroup" shortcut!',
              CSPage.history: '"History" page has a "Restart" shortcut!',
            }[page] ?? 'Go to the "Life" or "History" page',
            textAlign: TextAlign.center,
          ),
        ].separateWith(CSWidgets.height10),
      ),
    ));
  }
}

class _Extended extends StatelessWidget {
  const _Extended();
  @override
  Widget build(BuildContext context) {
    return const StageExtendedPanel(children: <SettingsPage,Widget>{
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
    final stage = Stage.of(context)!;
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
        Row(children: <Widget>[
            Expanded(child: ButtonTile(
              icon: McIcons.restart, 
              text: "New game", 
              onTap: () => stage.showAlert(
                ConfirmAlert(
                  action: (){},
                  warningText: "Confirm restart?",
                ),
                size: ConfirmAlert.height,
              ),
              filled: true,
            ),),
            Expanded(child: ButtonTile(
              icon: McIcons.account_multiple_outline, 
              text: "Edit playgroup", 
              onTap: () => stage.showAlert(
                const _EditPlaygroupMockup(),
                size: _EditPlaygroupMockup.height,
              ),
              filled: true,
            ),),
        ].separateWith(CSWidgets.extraButtonsDivider),),
      ],
    );
  }
}


class _WrongPage extends StatelessWidget {
  const _WrongPage();
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    return ListView(
      physics: stage.panelScrollPhysics,
      primary: false,
      children: const <Widget>[
        Section(<Widget>[
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


    return StageBuild.offMainPage((_, dynamic page) 
      => Row(children: <Widget>[
        IconButton(
          icon: page == CSPage.history
            ? const Icon(Icons.timeline)
            : const Icon(
              CSIcons.counterSpell, 
              // size: CSIcons.ideal_counterspell_size,
            ),
          onPressed: page == CSPage.history
            ? null
            : () => stage!.showAlert(const _ArenaMockup(), size: _ArenaMockup.height),
        ),
        Expanded(child: Center(child: page != CSPage.history
          ? const Icon(Icons.keyboard_arrow_left)
          : Container(),),),
        Expanded(child: Center(child: page != CSPage.commanderCast
          ? const Icon(Icons.keyboard_arrow_right)
          : Container(),),),
        IconButton(
          icon:  Icon(
            {
              CSPage.history: McIcons.restart,
              CSPage.life: McIcons.account_multiple_outline,
              CSPage.commanderCast: Icons.info_outline,
            }[page] ?? Icons.error_outline
          ),
          onPressed: page == CSPage.commanderCast
            ? null
            : (){
              switch (page) {
                case CSPage.life:
                  stage!.showAlert(
                    const _EditPlaygroupMockup(),
                    size: _EditPlaygroupMockup.height,
                  );
                  break;
                case CSPage.history:
                  stage!.showSnackBar(
                    ConfirmSnackbar(action: (){}, label: "Confirm restart?"),
                    rightAligned: true,
                  );
                  break;
                default:
              }
            },
        ),
      ],),
    );
  }
}

class _EditPlaygroupMockup extends StatelessWidget {
  const _EditPlaygroupMockup();
  static const double height = 900.0;
  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      "Edit playgroup mockup",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          ListTile(
            leading: CSWidgets.deleteIcon,
            title: Text("Delete players"),
          ),
          ListTile(
            leading: Icon(McIcons.pencil_outline),
            title: Text("Add and rename players"),
          ),
          ListTile(
            leading: Icon(Icons.unfold_more),
            title: Text("Reorder current players"),
          ),
          ListTile(
            leading: Icon(McIcons.content_save_outline),
            title: Text("All the names will be saved and auto-prompted next time you write a name"),
          ),
        ],
      ),
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
      customBackground: (theme) => theme.canvasColor,
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

          const Center(child: FloatingActionButton(
            onPressed: null, 
            child: Icon(Icons.menu),
          ),),

        ],),
      ),
    );
  }
}

