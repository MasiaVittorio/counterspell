import 'package:counter_spell/core.dart';

class CenteredTile extends StatelessWidget {
  const CenteredTile({super.key, 
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.onTap,
  });

  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: CSSizes.collapsedPanelSize,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: CSSizes.collapsedPanelSize,
                width: CSSizes.collapsedPanelSize,
                alignment: Alignment.center,
                child: leading,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: theme.textTheme.titleMedium!,
                      child: title,
                    ),
                    DefaultTextStyle(
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: theme.textTheme.bodySmall!.color),
                      child: subtitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
