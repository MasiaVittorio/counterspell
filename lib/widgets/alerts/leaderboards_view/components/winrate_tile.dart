// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:counter_spell/models/leaderboards/win_rate.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class DrawsTile extends StatelessWidget {
  const DrawsTile({super.key, required this.winRate, required this.onTap});

  final WinRate winRate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      onTap: onTap,
      leading: Icon(MdiIcons.circleOffOutline),
      title: const Text('Draws'),
      subtitle: Text(winRate.draws.toString()),
      trailing: Text(winRate.formattedDrawPercentage),
      containTrailing: false,
    );
  }
}

class WinsTile extends StatelessWidget {
  const WinsTile({super.key, required this.winRate});

  final WinRate winRate;

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      leading: const Icon(Icons.emoji_events),
      title: const Text('Wins'),
      subtitle: Text(winRate.wins.toString()),
      trailing: Text(winRate.formattedWinPercentage),
      containTrailing: false,
    );
  }
}

class LossesTile extends StatelessWidget {
  const LossesTile({super.key, required this.winRate});

  final WinRate winRate;

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      leading: Icon(MdiIcons.emoticonSad),
      title: const Text('Losses'),
      subtitle: Text(winRate.losses.toString()),
      trailing: Text(winRate.formattedLossPercentage),
      containTrailing: false,
    );
  }
}
