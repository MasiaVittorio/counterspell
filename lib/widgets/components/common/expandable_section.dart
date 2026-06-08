import 'package:counter_spell/widgets/components/common/expand_to_collapse_icon.dart';
import 'package:counter_spell/widgets/components/common/new_animated_listed.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ExpandableSection extends StatefulWidget {
  const ExpandableSection({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.children,
  });

  final Widget title;
  final IconData icon;
  final Widget subtitle;
  final List<Widget> children;

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool expanded = false;
  void toggle() => setState(() {
    expanded = !expanded;
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final colorScheme = theme.colorScheme;
    const duration = Durations.long2;
    const curve = Easings.emphasized;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: duration,
          curve: curve,
          margin: expanded
              ? EdgeInsets.zero
              : (EdgeInsets.symmetric(horizontal: layout.margin.medium) +
                    EdgeInsets.only(bottom: layout.spacing.medium)),
          decoration: BoxDecoration(
            color: expanded
                ? colorScheme.surface
                : colorScheme.surfaceContainerHigh,
            borderRadius: expanded
                ? BorderRadius.zero
                : BorderRadius.circular(layout.endListRadius.medium),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            type: .transparency,
            child: InkResponse(
              onTap: toggle,
              child: AnimatedPadding(
                duration: duration,
                curve: curve,
                padding: expanded
                    ? EdgeInsets.symmetric(
                        horizontal: layout.margin.medium,
                        vertical: layout.spacing.medium,
                      )
                    : EdgeInsets.all(layout.margin.medium),

                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: duration,
                      curve: curve,
                      decoration: BoxDecoration(
                        color: expanded
                            ? colorScheme.surfaceContainer
                            : colorScheme.primary,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      width: layout.buttonSize.large,
                      height: layout.buttonSize.large,
                      child: Center(
                        child: AnimatedColorBuilder(
                          value: expanded
                              ? colorScheme.primary
                              : colorScheme.onPrimary,
                          builder: (context, value, child) =>
                              Icon(widget.icon, color: value),
                        ),
                      ),
                    ),
                    Space.horizontal(layout.spacing.large),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DefaultTextStyle(
                            style: DefaultTextStyle.of(context).style.merge(
                              (theme.listTileTheme.titleTextStyle ??
                                      theme.textTheme.titleMedium)!
                                  .copyWith(
                                    color: expanded
                                        ? colorScheme.primary
                                        : null,
                                  ),
                            ),
                            child: widget.title,
                          ),
                          NewAnimatedListed(
                            listed: !expanded,
                            duration: duration,
                            curve: curve,
                            fadeFirstFraction: 0.6,
                            child: Pad(
                              top: layout.spacing.tiny,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DefaultTextStyle(
                                      style: DefaultTextStyle.of(context).style
                                          .merge(
                                            (theme
                                                        .listTileTheme
                                                        .subtitleTextStyle ??
                                                    theme.textTheme.bodyMedium)!
                                                .copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                      child: widget.subtitle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Space.horizontal(layout.spacing.large),
                    SizedBox.square(
                      dimension: layout.buttonSize.large,
                      child: Center(
                        child: ExpandToCollapseIcon(expanded: expanded),
                        // child: Icon(MdiIcons.unfoldLessHorizontal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final grouped in widget.children.groupedCards())
              NewAnimatedListed(
                fadeFirstFraction: 0.7,
                axisAlignment: 1,
                listed: expanded,
                duration: duration,
                curve: curve,
                child: grouped,
              ),
          ],
        ),
        //
      ],
    );
  }
}
