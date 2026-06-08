import 'dart:math';

import 'package:counter_spell/data/icon/all.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

typedef ManaPool = Map<PoolColor, int>;

extension ManaPoolExtensions on Map<PoolColor, int> {
  int amount(PoolColor color) => this[color] ?? 0;
}

class ManaPoolLogic extends LogicBase {
  final Reactive<ManaPool> pool = Reactive({});

  void onEdit(PoolColor c, int a) {
    pool.value[c] = a < 0 ? 0 : a;
    pool.refresh();
  }

  void onAdd(PoolColor color, int increment) =>
      onEdit(color, pool.value.amount(color) + increment);
  void onAddOne(PoolColor color) => onAdd(color, 1);
  void onRemoveOne(PoolColor color) => onAdd(color, -1);
  void onClear(PoolColor color) => onEdit(color, 0);
  void onAddFive(PoolColor color) => onAdd(color, 5);
  void onRemoveBig(PoolColor color) => onAdd(color, -5);
  int bigRemovable(PoolColor color) => min(pool.value.amount(color), 5);
  void onDouble(PoolColor color) => onEdit(color, pool.value.amount(color) * 2);

  void clearAll() {
    pool.value = {};
    pool.refresh();
  }

  @override
  void dispose() {
    pool.dispose();
    super.dispose();
  }

  ManaPoolLogic();
}

enum PoolColor {
  white(
    'White is the color of organization, law, and morality. It seeks peace through order.',
    'White mana',
    Color(0xFFFFFED8),
  ),
  blue(
    'Blue is the color of logic, depth, and progress. It seeks perfection through knowledge.',
    'Blue mana',
    Color(0xFFA9DCEF),
  ),
  black(
    'Black is the color of death, amorality, and individualism. It seeks satisfaction through ruthlessness.',
    'Black mana',
    Color(0xFFB3ADAF),
  ),
  red(
    'Red is the color of impulse, emotion, and chaos. Red seeks freedom through action.',
    'Red mana',
    Color(0xFFEEA489),
  ),
  green(
    'Green is the color of nature, instinct, and harmony. Green seeks growth through acceptance.',
    'Green mana',
    Color(0xFF93CBA4),
  ),
  colorless(
    'Detached from all other colors and philosophies, colorless cards tend to be unique, artificial, and unknowable.',
    'Colorless mana',
    Color(0xFFCAC3C0),
  ),
  treasures(
    'Treasure tokens are colorless artifacts that can be sacrificed to add one mana of any color to your mana pool.',
    'Treasures',
    Color(0xFFC6AA64),
  );

  const PoolColor(this.description, this.longName, this.seed);

  final String description;
  final String longName;

  final Color seed;

  ColorScheme colorScheme(Brightness brightness) => ColorScheme.fromSeed(
    seedColor: seed,
    brightness: brightness,
    dynamicSchemeVariant: this == PoolColor.colorless
        ? DynamicSchemeVariant.monochrome
        : DynamicSchemeVariant.tonalSpot,
  );

  IconData get icon => switch (this) {
    PoolColor.white => ManaIcons.w,
    PoolColor.blue => ManaIcons.u,
    PoolColor.black => ManaIcons.b,
    PoolColor.red => ManaIcons.r,
    PoolColor.green => ManaIcons.g,
    PoolColor.colorless => ManaIcons.c,
    PoolColor.treasures => MdiIcons.treasureChest,
  };

  // Widget widget({double size = 28}) => Container(
  //   margin: EdgeInsets.all(size * 0.055),
  //   width: size,
  //   height: size,
  //   decoration: BoxDecoration(
  //     color: seed,
  //     borderRadius: BorderRadius.circular(size),
  //   ),
  //   child: Icon(icon, color: Colors.black, size: size * 0.70),
  // );
}
