import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stage/panel/extended_components/all.dart';


class PagePie extends StatelessWidget {
  const PagePie();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unselected = Color.alphaBlend(
      theme.colorScheme.onSurface.withOpacity(0.08), 
      theme.canvasColor,
    );

    final StageData<CSPage,SettingsPage>? stage 
      = Stage.of(context);

    return Container(
      height: 170,
      alignment: Alignment.center,
      child: StageBuild.offMainEnabledPages((_, enabled) 
        => stage!.themeController.derived.mainPageToPrimaryColor.build((_, colors)
          =>Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: pageLabel(CSPage.values.first, theme, stage, enabled as Map<CSPage, bool>),
              ),
              Expanded(
                child: CircularLayout(
                  <Widget>[
                    for(final page in CSPage.values)
                      pageButton(page, stage, colors!, enabled, unselected),
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
          ),
        ),
      ),
    );

  }

  Widget pageLabel(
    CSPage page, 
    ThemeData theme,
    StageData<CSPage,SettingsPage> stage, 
    Map<CSPage,bool> enabled,
  ) => Text(
    stage.mainPagesController.pagesData[page]!.name,
    style: TextStyle(
      fontWeight: !PanelSettings.disablablePages.contains(page)
        ? FontWeight.w700
        : null,
      color: !enabled[page]!
        ? theme.textTheme.bodyText2!.color!.withOpacity(0.5)
        : null,
    ), 
  );

  Widget pageButton(
    CSPage page, 
    StageData<CSPage,SettingsPage> stage, 
    Map<CSPage,Color?> colors, 
    Map<CSPage,bool> enabled,
    Color unselected,
  ) => Material(
    animationDuration: const Duration(milliseconds: 150),
    elevation: enabled[page]! && PanelSettings.disablablePages.contains(page) 
      ? 4
      : 0,
    borderRadius: BorderRadius.circular(50),
    color: enabled[page]! ? colors[page]! : unselected,
    child: InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: PanelSettings.disablablePages.contains(page) 
        ? ()=> stage.mainPagesController.togglePage(page) 
        : null,
      child: SizedBox.square(
        dimension: 50,
        child: Center(
          child: AnimatedCrossFade(
            firstChild: Icon(
              stage.mainPagesController.pagesData[page]!.icon,
              size: 23,
              color: colors[page]!.contrast,
            ),
            secondChild: Icon(
              stage.mainPagesController.pagesData[page]!.unselectedIcon, 
              size: 24,
            ),
            crossFadeState: enabled[page]! 
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond, 
            duration: CSAnimations.fast,
          ),
        ),
      ),
    ),
  );
}