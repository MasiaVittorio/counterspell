// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerTileTitle extends StatelessWidget {
  const PlayerTileTitle({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Text(
      name,
      style: theme.textTheme.titleLarge!.copyWith(
        color: DefaultTextStyle.of(context).style.color,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
