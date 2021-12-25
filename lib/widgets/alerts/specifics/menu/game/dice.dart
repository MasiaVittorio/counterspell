import 'dart:math';

import 'package:counter_spell_new/core.dart';

class _Throw {
  final int max;
  final int value;
  _Throw(Random generator, this.max):
    value = generator.nextInt(max) + 1;
}

class DiceThrower extends StatefulWidget {

  static const double height = _DiceThrowerState._thrower + 360.0; 

  @override
  _DiceThrowerState createState() => _DiceThrowerState();
}

class _DiceThrowerState extends State<DiceThrower> {

  late Random generator;
  SidAnimatedListController? controller;
  final List<_Throw> throws = <_Throw>[];

  @override
  void initState() {
    super.initState();
    this.controller = SidAnimatedListController();
    this.generator = Random(DateTime.now().millisecondsSinceEpoch);
  }
  
  static const double _thrower = 56.0;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;

    return Material(
      child: SizedBox(
        height: DiceThrower.height,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Expanded(
                    child: SidAnimatedList(
                      physics: SidereusScrollPhysics(
                        bottomBounce: true,
                        bottomBounceCallback: stage.closePanel,
                        alwaysScrollable: false,
                        neverScrollable: false,
                      ),
                      itemBuilder: (_, index, animation) => SizeTransition(
                        axisAlignment: -1.0,
                        axis: Axis.vertical,
                        sizeFactor: animation,
                        child:_ThrowWidget(this.throws[index]),
                      ),
                      listController: controller,
                      initialItemCount: 0,
                      reverse: true,
                      shrinkWrap: true,
                      primary: false,
                    ),
                  ),

                  UpShadower(child: Container(
                    height: _thrower,
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        for(final max in [2,6,20])
                          Expanded(child: TextButton.icon(
                            label: Text(predicates[max] ?? "?? error"),
                            icon: Icon(_ThrowWidget.icons[max] ?? McIcons.dice_multiple),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(vertical: 16.0),
                              ),
                            ),
                            onPressed: (){
                              this.setState((){
                                this.throws.insert(0, _Throw(generator, max));
                                this.controller!.insert(0, duration: duration);
                              });
                            },
                          )),
                      ],
                    ),
                  ),),

                ],
              ),
            ),
            if(AlertComponents.drag)
              const Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                child: const AlertDrag(),
              ),
          ],
        ),
      ),
    );
  }
  static const duration = const Duration(milliseconds: 300);

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

    return Row(
      children: <Widget>[
        if(data.max == 6)
          Spacer(),
        if(data.max == 20)
          ...[Spacer(), Spacer()],
        Expanded(child: ListTile(
          title: Text( (data.max == 2)
            ? ({1: "head", 2: "tail"}[data.value] ?? "?? error")
            : ("${data.value}")
          ),
          leading: Icon({
            2: coinIcons[data.value],
            6: d6icons[data.value],
            20: McIcons.hexagon_outline,
          }[data.max] ?? McIcons.dice_multiple),
        ),),
        if(data.max == 2)
          ...[Spacer(), Spacer()],
        if(data.max == 6)
          Spacer(),
      ],
    );
  }
  static const Map<int,IconData> icons = {
    6: McIcons.dice_3,
    20: McIcons.dice_d20,
    2: McIcons.bitcoin
  };  
  // static const Map<int,String> subtitles = {
  //   2: "coin",
  //   6: "d6",
  //   20: "d20",
  // };
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
