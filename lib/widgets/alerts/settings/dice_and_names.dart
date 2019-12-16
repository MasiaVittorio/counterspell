import 'dart:math';

import 'package:counter_spell_new/core.dart';

enum _ThrowType {
  coin,
  d20,
  name
}
class _Throw<T> {
  final _ThrowType type;
  final int value;
  _Throw(this.type, Random generator, int max,):
    value = generator.nextInt(max) + 1;
}

class DiceThrower extends StatefulWidget {

  static const double height = _DiceThrowerState._thrower + 360.0; 

  @override
  _DiceThrowerState createState() => _DiceThrowerState();
}

class _DiceThrowerState extends State<DiceThrower> {

  Random generator;
  SidAnimatedListController controller;
  final List<_Throw> throws = <_Throw>[];

  @override
  void initState() {
    super.initState();
    this.controller = SidAnimatedListController();
    this.generator = Random(DateTime.now().millisecondsSinceEpoch);
  }
  
  static const double _thrower = 56.0;
  static const Map<_ThrowType, String> predicates = {
    _ThrowType.coin: "Flip",
    _ThrowType.name: "Name",
    _ThrowType.d20: "Throw",
  };
  static const Map<_ThrowType,IconData> icons = {
    _ThrowType.coin: McIcons.coin,
    _ThrowType.name: Icons.person_outline,
    _ThrowType.d20: McIcons.dice_d20,
  };  

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return CSBloc.of(context).game.gameState.gameState.build((_,state){
      final List<String> names = state.names.toList();
      return HeaderedAlert(
        "",
        alreadyScrollableChild: true,
        child: SidAnimatedList(
          physics: SidereusScrollPhysics(
            bottomBounce: true,
            bottomBounceCallback: stage.panelController.closePanel,
            alwaysScrollable: false,
            neverScrollable: false,
          ),
          itemBuilder: (_, index, animation) => SizeTransition(
            axisAlignment: -1.0,
            axis: Axis.vertical,
            sizeFactor: animation,
            child: _ThrowWidget(this.throws[index], names),
          ),
          listController: controller,
          initialItemCount: 0,
          reverse: true,
          shrinkWrap: true,
          primary: false,
        ),
        bottom: Container(
          height: _thrower,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              for(final type in [_ThrowType.coin, _ThrowType.name, _ThrowType.d20])
                Expanded(child: FlatButton.icon(
                  label: Text(predicates[type] ?? "?? error"),
                  icon: Icon(icons[type] ?? McIcons.dice_multiple),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  onPressed: (){
                    this.setState((){
                      this.throws.insert(0, _Throw(type, generator, {
                        _ThrowType.coin: 2, 
                        _ThrowType.name: names.length, 
                        _ThrowType.d20: 20,
                      }[type]));
                      this.controller.insert(0, duration: duration);
                    });
                  },
                )),
            ],
          ),
        ),
      );

    },);
  }
  static const duration = const Duration(milliseconds: 300);

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
      _ThrowType.d20: McIcons.hexagon_outline,
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
        break;
      case _ThrowType.name:
        return Container(
          height: size,
          alignment: Alignment.center,
          child: Text(title),
        );
        break;
      case _ThrowType.d20:
        return Container(
          height: size,
          child: Row(children: <Widget>[
            Spacer(), 
            Spacer(), 
            Expanded(
              child: child,
            ),
          ])
        );
        break;
      default:
        return Container();
    }

  }
  static const Map<int,IconData> coinIcons = {
    1: McIcons.coin,
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
