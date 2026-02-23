import 'dart:math';

import 'package:counter_spell/core.dart';
import 'package:counter_spell/models/random/all.dart';

class DiceThrower extends StatefulWidget {
  static const double height = 650;

  const DiceThrower({super.key});

  @override
  State createState() => _DiceThrowerState();
}

class _DiceThrowerState extends State<DiceThrower> {
  late Random generator;

  ThrowType _throwType = ThrowType.name;
  DiceType _diceType = DiceType.d20;

  late SidAnimatedListController controller;
  final List<Throw> throws = <Throw>[];

  @override
  void initState() {
    super.initState();
    controller = SidAnimatedListController();
    generator = Random(DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final CSBloc bloc = CSBloc.of(context);

    return bloc.game.gameState.gameState.build(
      (_, state) {
        final List<String> names = state.names.toList();
        return HeaderedAlert(
          "",
          alreadyScrollableChild: true,
          bottom: controls(names, bloc),
          child: SidAnimatedList(
            physics: SidereusScrollPhysics(
              bottomBounce: true,
              bottomBounceCallback: stage!.closePanel,
              alwaysScrollable: false,
              neverScrollable: false,
            ),
            itemBuilder: (_, index, animation) => SizeTransition(
              axisAlignment: -1.0,
              axis: Axis.vertical,
              sizeFactor: animation,
              child: _ThrowWidget(throws[index], names),
            ),
            listController: controller,
            initialItemCount: 0,
            reverse: true,
            shrinkWrap: true,
            primary: false,
          ),
        );
      },
    );
  }

  Widget controls(List<String> names, CSBloc bloc) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Space.vertical(10),
          SubSection(
            [
              ListTile(
                title: Text(_throwType.predicate),
              )
            ],
            onTap: () => throwOrFlip(names, bloc),
          ),
          RadioSlider(
            items: [
              const RadioSliderItem(
                title: Text("Coin"),
                icon: Icon(McIcons.bitcoin),
              ),
              const RadioSliderItem(
                title: Text("Name"),
                icon: Icon(Icons.person_outline),
              ),
              RadioSliderItem(
                title: const Text("Dice"),
                icon: Icon(_diceType.icon),
              ),
            ],
            selectedIndex: ThrowType.values.indexOf(_throwType),
            onTap: (i) => setState(() {
              _throwType = ThrowType.values[i];
            }),
          ),
          AnimatedListed(
            listed: _throwType == ThrowType.dice,
            child: RadioSlider(
              items: [
                for (final type in DiceType.values)
                  RadioSliderItem(
                    title: Text(type.name),
                    icon: Icon(type.icon),
                  ),
              ],
              selectedIndex: DiceType.values.indexOf(_diceType),
              onTap: (i) => setState(() {
                _diceType = DiceType.values[i];
              }),
            ),
          ),
        ],
      );

  void throwOrFlip(List<String> names, CSBloc bloc) {
    setState(() {
      throws.insert(
        0,
        Throw(
          _throwType,
          generator,
          {
            ThrowType.coin: 2,
            ThrowType.name: names.length,
            ThrowType.dice: _diceType.max,
          }[_throwType]!,
          _diceType,
        ),
      );
      controller.insert(0, duration: duration);
      bloc.achievements.flippedOrRolled();
    });
  }

  static const duration = Duration(milliseconds: 300);
}

class _ThrowWidget extends StatelessWidget {
  final Throw data;
  final List<String> names;
  const _ThrowWidget(this.data, this.names);

  static const double size = 56.0;

  @override
  Widget build(BuildContext context) {
    String title;
    if (data.type == ThrowType.coin) {
      title = {1: "head", 2: "tail"}[data.value] ?? "?? error";
    } else if (data.type == ThrowType.name) {
      title = names[data.value - 1];
    } else {
      title = "${data.value}";
    }
    final IconData icon = {
          ThrowType.coin: coinIcons[data.value],
          ThrowType.name: Icons.person_outline,
          ThrowType.dice: data.diceType == DiceType.d20
              ? McIcons.hexagon_outline
              : d6icons[data.value],
        }[data.type] ??
        McIcons.dice_multiple;

    final Widget child = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(icon),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(title),
        ),
      ],
    );

    switch (data.type) {
      case ThrowType.coin:
        return Container(
          height: size,
          alignment: Alignment.centerLeft,
          child: child,
        );
      case ThrowType.name:
        return Container(
          height: size,
          alignment: Alignment.center,
          child: Text(title),
        );
      case ThrowType.dice:
        return SizedBox(
            height: size,
            child: Row(children: <Widget>[
              const Spacer(),
              const Spacer(),
              Expanded(
                child: child,
              ),
            ]));
    }
  }

  static const Map<int, IconData> coinIcons = {
    1: McIcons.bitcoin,
    2: McIcons.circle_outline,
  };
  static const Map<int, IconData> d6icons = {
    1: McIcons.dice_1,
    2: McIcons.dice_2,
    3: McIcons.dice_3,
    4: McIcons.dice_4,
    5: McIcons.dice_5,
    6: McIcons.dice_6,
  };
}
