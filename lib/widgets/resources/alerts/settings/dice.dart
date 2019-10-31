import 'dart:math';

import 'package:counter_spell_new/core.dart';

class _Throw {
  final int max;
  final int value;
  _Throw(Random generator, this.max):
    value = generator.nextInt(max) + 1;
}

class DiceThrower extends StatefulWidget {

  static const double height = _DiceThrowerState._thrower + _DiceThrowerState._throws; 

  @override
  _DiceThrowerState createState() => _DiceThrowerState();
}

class _DiceThrowerState extends State<DiceThrower> {

  Random generator;
  final List<_Throw> throws = <_Throw>[];

  @override
  void initState() {
    super.initState();
    this.generator = Random(DateTime.now().millisecondsSinceEpoch);
  }
  
  static const double _thrower = 56.0;
  static const double _throws = 360.0;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return Material(
      child: SizedBox(
        height: DiceThrower.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Container(
              height: _throws,
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                physics: stage.panelScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for(final data in this.throws)
                      _ThrowWidget(data),
                  ],
                ),
              ),
            ),

            Container(
              height: _thrower,
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  for(final max in [2,6,20])
                    Expanded(child: FlatButton.icon(
                      label: Text(predicates[max] ?? "?? error"),
                      icon: Icon(_ThrowWidget.icons[max] ?? McIcons.dice_multiple),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      onPressed: (){
                        this.setState((){
                          this.throws.add(_Throw(generator, max));
                        });
                      },
                    )),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  static const Map<int, String> predicates = {
    2: "Flip",
    6: "Throw",
    20: "Throw",
  };
}

class _ThrowWidget extends StatelessWidget {
  const _ThrowWidget(this.data);
  final _Throw data;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text( (data.max == 2)
        ? ({1: "head", 2: "tail"}[data.value] ?? "?? error")
        : ("${data.value}")
      ),
      leading: Icon({
        2: coinIcons[data.value],
        6: d6icons[data.value],
        20: McIcons.hexagon_outline,
      }[data.max] ?? McIcons.dice_multiple),
    );
  }
  static const Map<int,IconData> icons = {
    6: McIcons.dice_3,
    20: McIcons.dice_d20,
    2: McIcons.coin,
  };  
  static const Map<int,String> subtitles = {
    2: "coin",
    6: "d6",
    20: "d20",
  };
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
