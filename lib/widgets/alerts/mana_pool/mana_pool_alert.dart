import 'dart:math';

import 'package:counter_spell/logic/mana_pool_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ManaPoolAlert extends StatelessWidget
    with PanelAlert, FullScreenPanelAlert {
  const ManaPoolAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final manaPoolLogic = context.counterSpell.manaPoolLogic;

    return manaPoolLogic.pool.build(
      (context, pool) => _ManaPoolAlert(pool: pool, logic: manaPoolLogic),
    );
  }
}

class _ManaPoolAlert extends StatefulWidget
    with PanelAlert, FullScreenPanelAlert {
  const _ManaPoolAlert({required this.pool, required this.logic});

  final ManaPool pool;
  final ManaPoolLogic logic;

  @override
  State<_ManaPoolAlert> createState() => _ManaPoolAlertState();
}

class _ManaPoolAlertState extends State<_ManaPoolAlert> {
  PoolColor color = PoolColor.colorless;
  void onChangedColor(PoolColor value) => setState(() {
    color = value;
  });

  ManaPool get pool => widget.pool;

  int amount(PoolColor c) => pool[c] ?? 0;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.theme;
    final colorScheme = color.colorScheme(appTheme.brightness);
    final theme = appTheme.copyWith(colorScheme: colorScheme);
    final layout = theme.layout;

    return Theme(
      data: theme,
      child: PanelList.custom(
        title: const Text('Mana pool'),
        trailing: IconButton.filledTonal(
          onPressed: widget.logic.clearAll,
          icon: const Icon(Icons.clear_all),
        ),
        bottom: GroupedCard(
          isFirst: true,
          isLast: true,
          backgroundColor: colorScheme.primaryContainer,
          child: Pad(
            all: layout.padding.medium,
            child: Text(
              color.description,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        customBuilder: (context, invisibleHeader, invisibleBottom) => Column(
          children: [
            invisibleHeader,
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 290),
                  child: ColorSelector(
                    onChanged: onChangedColor,
                    color: color,
                    pool: pool,
                  ),
                ),
              ),
            ),
            Pad(
              horizontal: layout.margin.medium,
              bottom: layout.spacing.medium,
              top: layout.spacing.tiny,
              child: Text(
                color.longName,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            ValueRow(
              value: amount(color),
              onEdit: (value) => widget.logic.onEdit(color, value),
            ),
            Space.vertical(layout.spacing.large),
            ...<Widget>[
              ListTile(
                title: const Text('Double'),
                leading: Icon(MdiIcons.chevronDoubleUp),
                onTap: amount(color) == 0
                    ? null
                    : () => widget.logic.onDouble(color),
              ),
              ListTile(
                title: const Text('Spend all'),
                leading: Icon(MdiIcons.chevronDoubleDown),
                onTap: amount(color) == 0
                    ? null
                    : () => widget.logic.onClear(color),
              ),
            ].groupedCards(),
            invisibleBottom!,
          ],
        ),
      ),
    );
  }
}

class ColorSelector extends StatelessWidget {
  const ColorSelector({
    super.key,
    required this.color,
    required this.onChanged,
    required this.pool,
  });

  final PoolColor color;
  final ValueChanged<PoolColor> onChanged;
  final ManaPool pool;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return Pad(
      horizontal: layout.margin.huge,
      vertical: layout.margin.large,
      child: Stack(
        children: [
          Positioned.fill(
            child: CircularLayout(
              angles: CircularLayout.anglesFromStartAngleAndFullTurn(
                -90,
                5,
                clockwise: false,
              ),
              children: [
                for (final c in [
                  PoolColor.white,
                  PoolColor.blue,
                  PoolColor.black,
                  PoolColor.red,
                  PoolColor.green,
                ])
                  ColouredIconToggle(
                    value: pool.amount(c),
                    color: c,
                    selected: c == color,
                    onChanged: (s) => onChanged(s ? c : PoolColor.colorless),
                  ),
              ],
            ),
          ),
          Center(
            child: ColouredIconToggle(
              value: pool.amount(PoolColor.colorless),
              color: PoolColor.colorless,
              selected: color == PoolColor.colorless,
              onChanged: (_) => onChanged(PoolColor.colorless),
            ),
          ),
          Al.bottomRight(
            child: ColouredIconToggle(
              color: PoolColor.treasures,
              selected: color == PoolColor.treasures,
              value: pool.amount(PoolColor.treasures),
              onChanged: (s) =>
                  onChanged(s ? PoolColor.treasures : PoolColor.colorless),
            ),
          ),
        ],
      ),
    );
  }
}

class ValueRow extends StatelessWidget {
  const ValueRow({super.key, required this.value, required this.onEdit});

  final int value;
  final ValueChanged<int> onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final int bigDecrement = min(value, 5);

    return Pad(
      horizontal: layout.margin.medium,
      child: SizedBox(
        height: 64,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: _Button(
                onTap: value < 1 ? null : () => onEdit(value - bigDecrement),
                isFirst: true,
                child: Text('-$bigDecrement'),
              ),
            ),
            Expanded(
              child: _Button(
                onTap: value < 1 ? null : () => onEdit(value - 1),
                child: const Text('-1'),
              ),
            ),
            Expanded(
              child: _Button(
                onTap: null,
                isPrimary: true,
                child: Text('$value'),
              ),
            ),
            Expanded(
              child: _Button(
                onTap: () => onEdit(value + 1),
                child: const Text('+1'),
              ),
            ),
            Expanded(
              child: _Button(
                onTap: () => onEdit(value + 5),
                isLast: true,
                child: const Text('+5'),
              ),
            ),
          ].separateWith(Space.horizontal(layout.spacing.medium)),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.onTap,
    required this.child,
    this.isFirst = false,
    this.isLast = false,
    this.isPrimary = false,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool isFirst;
  final bool isLast;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final colorScheme = theme.colorScheme;
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: GroupedCard.borderRadius(
        layout,
        isFirst: isFirst,
        isLast: isLast,
        direction: .horizontal,
      ),
      color: isPrimary
          ? theme.colorScheme.primaryContainer
          : onTap != null
          ? theme.colorScheme.surfaceContainer
          : theme.colorScheme.surfaceContainerLowest,
      child: InkResponse(
        onTap: onTap,
        child: Center(
          child: DefaultTextStyle(
            style: DefaultTextStyle.of(context).style.merge(
              (isPrimary
                      ? theme.textTheme.titleLarge
                      : theme.textTheme.bodyMedium)!
                  .copyWith(
                    fontWeight: isPrimary ? FontWeight.bold : null,
                    color: isPrimary
                        ? colorScheme.onPrimaryContainer
                        : onTap != null
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class ColouredIconToggle extends StatelessWidget {
  const ColouredIconToggle({
    required this.color,

    required this.selected,
    required this.value,
    required this.onChanged,

    this.duration = const Duration(milliseconds: 300),
    this.size = 60,
    super.key,
  });

  final PoolColor color;

  final bool selected;
  final int value;
  final void Function(bool) onChanged;

  final Duration duration;

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = color.colorScheme(theme.brightness);

    final background = selected ? scheme.primaryContainer : scheme.surface;

    return Material(
      animationDuration: duration,
      borderRadius: BorderRadius.circular(50),
      elevation: selected ? 8 : 0,
      child: AnimatedContainer(
        duration: duration,
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          color: background,
          border: Border.all(
            width: selected ? 0 : 1,
            color: scheme.outline.withValues(alpha: selected ? 0.0 : 0.8),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          borderRadius: BorderRadius.circular(size),
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onChanged(!selected),
            child: Container(
              height: size,
              width: size,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      color.icon,
                      size: size * 0.6,
                      color:
                          (selected
                                  ? scheme.onPrimaryContainer
                                  : scheme.onSurfaceVariant)
                              .withValues(alpha: 0.5),
                    ),
                  ),
                  Center(
                    child: Text(
                      value.toString(),
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: background.contrast,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
