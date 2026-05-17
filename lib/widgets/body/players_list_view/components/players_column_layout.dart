import 'package:counter_spell/widgets/body/players_list_view/components/players_list_layout.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayersColumnLayout extends StatelessWidget {
  const PlayersColumnLayout({
    super.key,
    required this.children,
    this.extraTopChild,
  });

  final List<Widget> children;
  final Widget? extraTopChild;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final safe = context.safe;

    return Pad(
      top: PlayerListLayoutBuilder.topMargin(layout, safe),
      bottom: PlayerListLayoutBuilder.bottomMargin(layout, safe),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ?extraTopChild,
          for (final child in children) Expanded(child: child),
        ].separateWith(Space.vertical(PlayerListLayoutBuilder.spacing(layout))),
      ),
    );
  }
}
