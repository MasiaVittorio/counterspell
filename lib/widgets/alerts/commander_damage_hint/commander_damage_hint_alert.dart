import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CommanderDamageHintAlert extends StatelessWidget {
  const CommanderDamageHintAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return const PanelList.shrink(
      title: Text('Commander damage view'),
      children: [
        GroupedCard(
          isFirst: true,
          child: ColoredTile(
            title: Text('Tap to select the attacker'),
            seed: Colors.red,
            leading: Icon(Icons.touch_app_outlined),
            subtitle: Text('You can also swap between partner commanders'),
          ),
        ),
        GroupedCard(
          isLast: true,
          child: ColoredTile(
            title: Text('Scroll on the defender'),
            seed: Colors.blue,
            leading: Icon(Icons.swipe_right),
            subtitle: Text('To deal damage'),
          ),
        ),
      ],
    );
  }
}
