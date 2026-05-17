import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.alignment = const Alignment(0, 0),
  });

  final Alignment alignment;
  final Widget? icon;
  final Widget? title;
  final Widget? description;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (icon case Widget icon)
              Pad(
                horizontal: layout.margin.huge,
                child: Center(
                  child: IconTheme(
                    data: IconTheme.of(context).copyWith(size: 64),
                    child: icon,
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (title case Widget title)
                  Pad(
                    horizontal: layout.margin.huge,
                    child: DefaultTextStyle(
                      style: DefaultTextStyle.of(
                        context,
                      ).style.merge(theme.textTheme.titleLarge),
                      textAlign: TextAlign.center,
                      child: title,
                    ),
                  ),
                if (description case Widget description)
                  Pad(
                    horizontal: layout.margin.large,
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: DefaultTextStyle.of(
                        context,
                      ).style.merge(theme.textTheme.bodyMedium),
                      child: description,
                    ),
                  ),
              ].separateWith(Space.vertical(layout.spacing.small)),
            ),
          ].separateWith(Space.vertical(layout.spacing.large)),
        ),
      ),
    );
  }
}
