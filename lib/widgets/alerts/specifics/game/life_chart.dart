import 'dart:math' as math;

import 'package:counter_spell_new/core.dart';
import 'package:fl_chart/fl_chart.dart';


class LifeChart extends StatelessWidget {

  static const double height = 350.0;

  const LifeChart();

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context)!;
    final ThemeData theme = Theme.of(context);
    final Color bkgColor = theme.scaffoldBackgroundColor;
    final TextStyle? textStyle = theme.textTheme.bodyText2; 

    return Material(child: bloc.game!.gameState!.gameState.build((_, gameState){
      final List<Player?> players = gameState.players.values.toList();

      return Column(children: <Widget>[
        PanelTitle("Life Chart"),
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(children: <Widget>[
            Expanded(child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: bkgColor,
              ),
              padding: const EdgeInsets.fromLTRB(8.0, 12.0, 20.0, 4.0),
              child: _Chart(gameState),
            ),),
          ],),
        ),),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            for(int i=0; i<players.length; ++i)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Chip(
                  label: Text(players[i]!.name),
                  backgroundColor: i < _colors.length ? _colors[i] : Colors.grey,
                  labelStyle: textStyle!.copyWith(
                    color: (i < _colors.length ? _colors[i] : Colors.grey).contrast,
                  ),
                ),
              ),
          ],),
        ),
      ],);
    },),);
  }

  static const List<Color> _colors = [
    Colors.blue, 
    Colors.red, 
    Colors.yellow, 
    Colors.green, 
    Colors.lightBlue, 
    Colors.green,
    Colors.black,
    Colors.grey,
  ];
    

}





class _Chart extends StatelessWidget {

  final GameState gameState;

  _Chart(this.gameState);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color canvasColor = theme.canvasColor;
    final TextStyle? textStyle = theme.textTheme.bodyText2; 

    final List<Player?> players = [
      for(final player in gameState.players.values)
        player,
    ];

    int? maxLife = players.first!.states.first.life;
    int? minLife = players.first!.states.last.life;
    for(final player in players){
      for(final state in player!.states){
        if(state.life! > maxLife!) maxLife = state.life;
        if(state.life! < minLife!) minLife = state.life;
      }
    }
    double minLifeDouble = math.min(minLife, 0.0)!.closestMultipleOf(5.0, upper: false, overshoot: true);
    double maxLifeDouble = math.max(maxLife, 0.0)!.closestMultipleOf(5.0, upper: true, overshoot: true);

    final SideTitles lifeTitles = _lifeTitles(
      minLifeDouble, maxLifeDouble, textStyle,
      startingLife: players.first!.states.first.life!,
    );

    final int maxSeconds = players.first!.states.last.time
        .difference(gameState.players.values.first!.states.first.time)
        .inSeconds;
    
    final Map<String,double> maxTimeAndInterval = _maxTimeAndInterval(maxSeconds);
    final double? maxTime = maxTimeAndInterval["maxTime"];
    final double? interval = maxTimeAndInterval["interval"];

    final SideTitles timeTitles =  SideTitles(
      showTitles: true,
      reservedSize: 22,
      margin: 10,
      interval: interval,
      getTitles: (double seconds) => seconds != 0.0
        ? _timeFormat(seconds.toInt())
        : "",
      getTextStyles: (_) => textStyle!,
    );

    return LineChart(LineChartData(
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: false),
      clipData: FlClipData.none(),
      extraLinesData: ExtraLinesData(horizontalLines: [HorizontalLine(y: 0.0, strokeWidth: 1.0)]),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(tooltipBgColor: canvasColor.withOpacity(0.9)),
      ),          // lineTouchData: ,
      maxX: maxTime,
      minX: 0.0,
      maxY: maxLifeDouble,
      minY: minLifeDouble,
      // rangeAnnotations: ,
      titlesData: FlTitlesData(
        leftTitles: lifeTitles,
        bottomTitles: timeTitles,
      ),
      lineBarsData: <LineChartBarData>[
        for(int i=0; i < players.length; ++i)
          LineChartBarData(
            spots: <FlSpot>[for(final playerState in players[i]!.states)
              FlSpot(
                playerState.time.difference(gameState.firstTime)
                  .inSeconds
                  .abs()
                  .toDouble(), 
                playerState.life!
                  .toDouble(),
              ),
            ],
            colors: [LifeChart._colors[i].withOpacity(0.5)],
            barWidth: 1.5,
            dotData: FlDotData(
              show: false,
              getDotPainter: (_,__,___,____) => FlDotCirclePainter(
                color: LifeChart._colors[i],
                radius: 1,
              ),
            ),
          ),  
      ],
    ),);
  }

  static SideTitles _lifeTitles(double minLife, double maxLife, TextStyle? textStyle, {
    required int startingLife,
  }){
    assert(maxLife >= minLife, "max life must be greater than min life");

    double interval;
    Set<double> okNumbers;


    //both min and max life are multiples of 10. a 5 interval seems appropriate;
    interval = 5.0;

    //we want something around 3 or 4 numbers written on our graph Y axis
    final double range = maxLife - minLife;
    final double spanBigger = (range/_nLifes).closestMultipleOf(5.0, upper: true);
    final Set<double> okNumbersBigger = <double>{
      startingLife.toDouble(),
      for(int i=1; i <= _nLifes; ++i) 
        ...<double>[
          if(startingLife + i * spanBigger < maxLife) 
            startingLife + i * spanBigger,
          if(startingLife - i * spanBigger > minLife) 
            startingLife - i * spanBigger,
        ],
    };
    if(_nLifesOk.contains(okNumbersBigger.length)){
      okNumbers = okNumbersBigger;    
    } else {
      final double spanSmaller = (range/_nLifes).closestMultipleOf(10.0, upper: false);
      final Set<double> okNumbersSmaller = <double>{
        startingLife.toDouble(),
        for(int i=1; i <= _nLifes; ++i) 
          ...<double>[
            if(startingLife + i * spanSmaller < maxLife) 
              startingLife + i * spanSmaller,
            if(startingLife - i * spanSmaller > minLife) 
              startingLife - i * spanSmaller,
          ],
      };
      if(_nLifesOk.contains(okNumbersSmaller.length)){
        okNumbers = okNumbersSmaller;
      } else {
        okNumbers = okNumbersSmaller;
        debugPrint("something wrong with the number of life titles here");
      }
    }

    assert(minLife != null);
    assert(maxLife != null);
    assert(interval != null);
    assert(okNumbers != null);


    return SideTitles(
      showTitles: true,
      reservedSize: 22,
      margin: 10,
      interval: interval,
      getTextStyles: (_) => textStyle!,
      getTitles: (double life) 
        => okNumbers.contains(life) ? "${life.toInt()}" : "",
    );
  }


  static Map<String,double> _maxTimeAndInterval(int max){

    double maxTime;
    //remember: min is always zero
    double interval;

    if(max < 28){ // 30 seconds
      maxTime = 35.0;
      interval = 15.0;
    } else if(max < 56){ // one minute
      maxTime = 70.0;
      interval = 30.0;
    } else {
      double span;
      if(max < 60*5 - 10){ // one to five minutes
        span = 30.0; // 30 seconds span
      } else if(max < 60*10 - 15){ // five to ten minutes
        span = 60.0; // 1 minute span
      } else if(max < 60*15 - 20){ // ten to 15 minutes
        span = 60.0 * 2; // 2 minutes span
      } else if(max < 60*30 - 25){ // 15 to 30 minutes
        span = 60.0 * 5; // 5 minutes span
      } else if(max < 60*60 - 30){ // 30 minutes to 1 hour
        span = 60.0 * 10; // 10 minutes span
      } else if(max < 60*60*1.5 - 45){ // 1 hour to 1 hour and a half
        span = 60.0 * 20; // 20 minutes span
      } else if(max < 60*60*4 - 60*2){ // 1 hour and a half to 4 hours
        span = 60.0 * 30; // 30 minutes span
      } else if(max < 60*60*10 - 60*10){ // 4 hours to 10 hours
        span = 60.0 * 60; // 1 hour span
      } else { // more than 10 hours 
        span = 60.0 * 60 * 2; // 2 hours span
      }
      assert(span != null);

      maxTime = max.closestMultipleOf(span, upper: true, overshoot: true);
      interval = (maxTime/_nTimes).closestMultipleOf(span);
    }

    assert(maxTime != null);
    assert(interval != null);

    return <String,double>{
      "maxTime": maxTime,
      "interval": interval,
    };
  }




  static String _timeFormat(int seconds){

    if(seconds < 60){ // 60 seconds
      return "${seconds}s";
    } 
    else if(seconds < 60*10){ // one to ten minutes
      final int minutes = (seconds/60).floor();
      final int remainder = seconds % 60;
      if(remainder == 0) return "${minutes}m";
      else return "${minutes}m:${remainder}s";
    } 
    else if(seconds < 60*60){ // ten to 60 minutes
      final int minutes = (seconds/60).floor();
      return "${minutes}m";
    } 
    else if(seconds < 60*60*4){ // 1 to 4 hours 
      final int hours = (seconds/(60*60)).floor();
      final int remainder = seconds % (60*60);
      final int mins = (remainder / 60).floor();
      if(mins == 0) return "${hours}h";
      return "${hours}h : ${mins}m";
    } 
    else { // over 4 hours
      final int hours = (seconds/(60*60)).floor();
      return "${hours}h";
    }
  }

  static const int _nLifes = 4;
  static const Set<int> _nLifesOk = <int>{3,4,5};
  static const int _nTimes = 3;
  
}
