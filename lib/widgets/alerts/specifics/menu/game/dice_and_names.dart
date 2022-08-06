import 'dart:math';

import 'package:counter_spell_new/core.dart';

enum _ThrowType {
  coin,
  dice,
  name
}

class _Throw {
  final _ThrowType type;
  final int value;
  final _DiceType _diceType;
  _Throw(this.type, Random generator, int max, this._diceType,):
    value = generator.nextInt(max) + 1;
}

class DiceThrower extends StatefulWidget {

  static const double height = _DiceThrowerState._throwerHeight + 360.0; 

  @override
  State createState() => _DiceThrowerState();
}

enum _DiceType{
  d6,
  d20,
}

extension on _DiceType {
  int get max => this == _DiceType.d6 ? 6 : 20;
  IconData get icon => this == _DiceType.d6 ? McIcons.dice_d6 : McIcons.dice_d20;
  _DiceType get other => this == _DiceType.d6 ? _DiceType.d20 : _DiceType.d6;
}

class _DiceThrowerState extends State<DiceThrower> {

  late Random generator;
  _DiceType _diceType = _DiceType.d20;
  SidAnimatedListController? controller;
  final List<_Throw> throws = <_Throw>[];


  @override
  void initState() {
    super.initState();
    controller = SidAnimatedListController();
    generator = Random(DateTime.now().millisecondsSinceEpoch);
  }
  
  static const double _throwerHeight = 56.0;
  static const Map<_ThrowType, String> predicates = {
    _ThrowType.coin: "Flip",
    _ThrowType.name: "Name",
    _ThrowType.dice: "Throw",
  };

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final CSBloc bloc = CSBloc.of(context)!;

    return bloc.game.gameState.gameState.build((_,state){
      final List<String> names = state.names.toList();
      return HeaderedAlert(
        "",
        alreadyScrollableChild: true,
        bottom: Container(
          height: _throwerHeight,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              for(final type in [_ThrowType.coin, _ThrowType.name, _ThrowType.dice])
                Expanded(child: TextButton.icon(
                  label: Text(predicates[type] ?? "?? error"),
                  icon: Icon({
                    _ThrowType.coin: McIcons.bitcoin,
                    _ThrowType.name: Icons.person_outline,
                    _ThrowType.dice: _diceType.icon,
                  }[type] ?? McIcons.dice_multiple),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  onLongPress: type != _ThrowType.dice ? null : () => setState(() {
                    _diceType = _diceType.other;
                  }),
                  onPressed: (){
                    setState((){
                      throws.insert(0, _Throw(
                        type, 
                        generator, 
                        {
                          _ThrowType.coin: 2, 
                          _ThrowType.name: names.length, 
                          _ThrowType.dice: _diceType.max,
                        }[type]!,
                        _diceType,
                      ),);
                      controller!.insert(0, duration: duration);
                      bloc.achievements.flippedOrRolled();
                    });
                  },
                )),
            ],
          ),
        ),
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

    },);
  }
  static const duration = Duration(milliseconds: 300);

}

class _ThrowWidget extends StatelessWidget {
  final _Throw data;
  final List<String> names;
  const _ThrowWidget(this.data, this.names);

  static const double size = 56.0;

  @override
  Widget build(BuildContext context) {
    String title;
    if(data.type == _ThrowType.coin){
      title = {1: "head", 2: "tail"}[data.value] ?? "?? error";
    } else if (data.type == _ThrowType.name){
      title = names[data.value - 1];
    } else {
      title = "${data.value}";
    }
    final IconData icon = {
      _ThrowType.coin: coinIcons[data.value],
      _ThrowType.name: Icons.person_outline,
      _ThrowType.dice: data._diceType == _DiceType.d20 
        ? McIcons.hexagon_outline
        : d6icons[data.value],
    }[data.type] ?? McIcons.dice_multiple;

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
      case _ThrowType.coin:
        return Container(
          height: size,
          alignment: Alignment.centerLeft,
          child: child,
        );
      case _ThrowType.name:
        return Container(
          height: size,
          alignment: Alignment.center,
          child: Text(title),
        );
      case _ThrowType.dice:
        return SizedBox(
          height: size,
          child: Row(children: <Widget>[
            const Spacer(), 
            const Spacer(), 
            Expanded(
              child: child,
            ),
          ])
        );
      default:
        return Container();
    }

  }
  static const Map<int,IconData> coinIcons = {
    1: McIcons.bitcoin,
    2: McIcons.circle_outline,
  };
  static const Map<int,IconData> d6icons = {
    1: McIcons.dice_1,
    2: McIcons.dice_2,
    3: McIcons.dice_3,
    4: McIcons.dice_4,
    5: McIcons.dice_5,
    6: McIcons.dice_6,
  };  
}
