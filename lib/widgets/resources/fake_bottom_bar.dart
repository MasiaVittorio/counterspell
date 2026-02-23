import 'package:counter_spell/core.dart';

class FakeBottomBar extends StatelessWidget {
  final double collapsedPanelSize;
  final CSPage page;
  final Map<CSPage, Color?>? colors;
  final void Function(CSPage) onSelect;
  final List<CSPage> orderedValues;
  final Map<CSPage, String> leftTitles;
  final Map<CSPage, String> rightTitles;
  final VoidCallback? rightCallback;
  final VoidCallback? leftCallback;

  const FakeBottomBar({super.key, 
    required this.collapsedPanelSize,
    required this.page,
    required this.colors,
    required this.onSelect,
    required this.orderedValues,
    required this.leftTitles,
    required this.rightTitles,
    this.rightCallback,
    this.leftCallback,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      height: collapsedPanelSize + RadioNavBar.defaultTileSize,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Positioned(
            top: collapsedPanelSize / 2,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: ClipRRect(
              borderRadius: SubSection.borderRadiusDefault,
              // clipBehavior: Clip.antiAlias,
              child: RadioNavBar<CSPage>(
                tileSize: RadioNavBar.defaultTileSize,
                topPadding: collapsedPanelSize / 2,
                selectedValue: page,
                orderedValues: orderedValues,
                items: <CSPage, RadioNavBarItem>{
                  CSPage.history: RadioNavBarItem(
                    title: "History",
                    icon: CSIcons.historyFilled,
                    unselectedIcon: CSIcons.historyOutlined,
                    color: colors![CSPage.history],
                  ),
                  CSPage.counters: RadioNavBarItem(
                    title: "Counters",
                    icon: CSIcons.counterFilled,
                    unselectedIcon: CSIcons.counterOutlined,
                    color: colors![CSPage.counters],
                  ),
                  CSPage.life: RadioNavBarItem(
                    title: "Life",
                    icon: CSIcons.lifeFilled,
                    unselectedIcon: CSIcons.lifeOutlined,
                    color: colors![CSPage.life],
                  ),
                  CSPage.commanderDamage: RadioNavBarItem(
                    title: "Damage",
                    icon: CSIcons.damageFilled,
                    unselectedIcon: CSIcons.damageOutlined,
                    color: colors![CSPage.commanderDamage],
                  ),
                  CSPage.commanderCast: RadioNavBarItem(
                    title: "Casts",
                    icon: CSIcons.castFilled,
                    unselectedIcon: CSIcons.castOutlined,
                    color: colors![CSPage.commanderCast],
                  ),
                },
                onSelect: onSelect,
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            height: collapsedPanelSize,
            right: 16.0,
            left: 16.0,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              child: Material(
                borderRadius: BorderRadius.circular(collapsedPanelSize / 2),
                elevation: 16,
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  height: collapsedPanelSize,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: InkResponse(
                          onTap: leftCallback,
                          child: Center(
                            child: AnimatedText(leftTitles[page]!),
                          ),
                        ),
                      ),
                      Container(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        width: 1,
                        height: collapsedPanelSize * 0.8,
                      ),
                      Expanded(
                        child: InkResponse(
                          onTap: rightCallback,
                          child: Center(
                            child: AnimatedText(rightTitles[page]!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
