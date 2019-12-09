import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/panel/extended_components/all.dart';
import 'package:division/division.dart';


class PagePie extends StatelessWidget {
  const PagePie();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unselected = Color.alphaBlend(
      theme.colorScheme.onSurface.withOpacity(0.08), 
      theme.canvasColor,
    );

    final StageData<CSPage,SettingsPage> stage 
      = Stage.of<CSPage,SettingsPage>(context);

    return Container(
      height: 175,
      alignment: Alignment.center,
      child: BlocVar.build2(
        stage.pagesController.enabledPages, 
        stage.themeController.primaryColorsMap, 
        builder: (_, enabled, colors){
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: pageLabel(CSPage.values.first, theme, stage, enabled),
              ),
              Expanded(
                child: CircularLayout(
                  <Widget>[
                    for(final page in CSPage.values)
                      pageButton(page, stage, colors, enabled, unselected),
                  ],
                  labels: <Widget>[
                    for(final page in CSPage.values)
                      page == CSPage.values.first ? Container(): pageLabel(page, theme, stage, enabled),
                  ],
                  clockWise: false,
                  labelPadding: 12.0,
                ),
              ),
            ],
          );

        },
      ),
    );

  }

  Widget pageLabel(
    CSPage page, 
    ThemeData theme,
    StageData<CSPage,SettingsPage> stage, 
    Map<CSPage,bool> enabled,
  ) => Text(
    "${stage.pagesController.pagesData[page].name}",
    style: TextStyle(
      fontWeight: !PanelSettings.disablablePages.contains(page)
        ? FontWeight.w700
        : null,
      color: !enabled[page]
        ? theme.textTheme.body1.color.withOpacity(0.5)
        : null,
    ), 
  );

  Widget pageButton(
    CSPage page, 
    StageData<CSPage,SettingsPage> stage, 
    Map<CSPage,Color> colors, 
    Map<CSPage,bool> enabled,
    Color unselected,
  ) => Division(
    style: StyleClass()
      ..animate(150)
      ..width(52)
      ..height(52)
      ..borderRadius(all: 40)
      ..background.color(enabled[page] ?  colors[page] : unselected)
      ..elevation(enabled[page] && PanelSettings.disablablePages.contains(page) ? 4:0)
      ..overflow.hidden(),
    child: Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: PanelSettings.disablablePages.contains(page) 
          ? ()=> stage.pagesController.togglePage(page) 
          : null,
        child: Center(
          child: AnimatedCrossFade(
            firstChild: Icon(
              stage.pagesController.pagesData[page].icon,
              size: 24,
              color: CSColors.contrastWith(colors[page]),
            ),
            secondChild: Icon(
              stage.pagesController.pagesData[page].unselectedIcon, 
              size: 24,
            ),
            crossFadeState: enabled[page] 
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond, 
            duration: CSAnimations.fast,
          ),
        ),
      ),
    ),

  );
}