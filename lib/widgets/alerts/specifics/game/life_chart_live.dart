import 'package:counter_spell_new/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:time/time.dart';

class AnimatedLifeChart extends StatelessWidget {

  const AnimatedLifeChart();

  static const double height = 550.0;

  @override
  Widget build(BuildContext context) {
    return Material(child: CSBloc.of(context)!
      .game!.gameState!.gameState.build((_, gameState)
        => _LifeChartLive(gameState),
      ),
    );
  }
}



class _LifeChartLive extends StatefulWidget {
  
  _LifeChartLive(this.gameState):
    assert(gameState != null),
    gameDuration = gameState.lastTime.difference(gameState.firstTime).abs(),
    gameLenght = gameState.historyLenght,
    names = gameState.names.toList()..sort(),
    times = <Duration>[for(final state in gameState.players.values.first!.states) 
      state.time.difference(gameState.players.values.first!.states.first.time),
    ],
    maxValue = ((){
      int? max = gameState?.players?.values?.first?.states?.first?.life ?? 0;
      for(final player in gameState.players.values){
        for(final state in player!.states){
          if(max! < state.life!)
            max = state.life;
          final int taken = state.totalDamageTaken;
          if(max! < taken)
            max = taken;
          final int casts = state.totalCasts;
          if(max < casts)
            max = casts;
        }
      }
      return max!.toDouble();
    })(),
    showDamage = gameState.players.values.any(
      (player) => player!.states.any(
        (state) => state.totalDamageTaken != 0,
      ),
    ),
    showCasts = gameState.players.values.any(
      (player) => player!.states.any(
        (state) => state.totalCasts != 0,
      ),
    );


  //real variable  
  final GameState gameState;

  //derived variables, but extracted on widget creation to be 
  //readily available here for frequent computations needed during animations
  final Duration gameDuration;
  final int gameLenght;
  final List<Duration> times;
  final List<String> names;
  final double maxValue;
  final bool showDamage;
  final bool showCasts;

  @override
  _LifeChartLiveState createState() => _LifeChartLiveState();
}


class _LifeChartLiveState extends State<_LifeChartLive> with TickerProviderStateMixin {

  //====================================================
  // State =========================================
  late AnimationController controller;
  //these are not computed at each tick because it would be expensive
  // if we are at a new index then the states will be taken and the state updated
  int? index;
  late List<PlayerState> states; 
  late Duration swapAnimationDuration;


  //====================================================
  // Initialize and dispose ========================
  @override
  void initState() {
    super.initState();
    this.controller = AnimationController(
      vsync: this,
      duration: _idealDuration,
    );
    this.index = 0;
    this.states = getStates(this.index);
    this.swapAnimationDuration = _swapAnimationDuration(this.index!);
    this.listenToAnimation();
  }

  void listenToAnimation(){
    this.controller.addListener((){
      final _newIndex = _currentIndex;

      if(_newIndex != this.index){
        this.index = _newIndex;
        this.states = getStates(this.index);
        this.swapAnimationDuration = _swapAnimationDuration(this.index!);
        this.setState((){});
      }
    });
  }

  @override
  void dispose(){
    this.controller.dispose();
    super.dispose();
  }


  //====================================================
  // Getters ========================================
  static const List<int> _okSeconds = <int>[2,5,10,20,30];
  double get _secondsBasedOnActions => widget.gameLenght / 10;
  double get _secondsBasedOnTime => widget.gameDuration.inMinutes / 10;
  int get _secondsMean => ((_secondsBasedOnActions + _secondsBasedOnTime)/2).round();
  Duration get _idealDuration {
    final int d = _secondsMean;
    return _okSeconds.reduce((a, b){
      if((a-d).abs() < (b-d).abs())
        return a;
      return  b;
    }).seconds;
  }

  int get _currentIndex => widget.times.lastIndexWhere((Duration time) => time.inMilliseconds / widget.gameDuration.inMilliseconds <= controller.value);

  List<PlayerState> getStates(int? index) => <PlayerState>[for(final name in widget.names)
    widget.gameState.players[name]!.states[index!],
  ];

  bool get isPlaying => this.controller.isAnimating;


  //====================================================
  // Actions =========================================
  void play() {
    if(this.controller.value == 1.0) reset();
    this.controller.forward();
  }
  void pause() => this.controller.stop();
  void reset() => this.controller.reset();
  void playPause(){
    if(isPlaying) pause();
    else play();
    this.setState((){});
  }
  void selectDuration(Duration newDuration){
    this.controller.duration = newDuration;
    reset();
    this.setState((){});
  }

  //====================================================
  // Build =========================================
  @override
  Widget build(BuildContext context) {
    return Material(child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const PanelTitle("Life Chart"),
        Expanded(child: layoutChart()),
        buildControls(),
        CSWidgets.height5,
        CSWidgets.divider,
        CSWidgets.height15,
        Center(child: buildDurationSelector()),
        CSWidgets.height15,
      ],
    ),);
  } 

  Widget layoutChart(){
    final StageData<CSPage,SettingsPage> stage = Stage.of(context) as StageData<CSPage, SettingsPage>;
    final CSBloc bloc = CSBloc.of(context)!;
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2.0,
        vertical: 8.0,
      ),
      child: BlocVar.build2(
        stage.themeController.derived.mainPageToPrimaryColor!,
        bloc.themer!.defenceColor,
        builder:(_, dynamic colors, dynamic defenceColor) 
          =>SubSection(<Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 12.0, 0.0, 10.0),
              child: buildLegenda(colors, defenceColor, theme),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: buildChart(colors, defenceColor, theme)
            ),),
          ],),
      ),
    );
  }

  Widget buildLegenda(
    Map<CSPage,Color> colors, 
    Color? defenceColor, 
    ThemeData theme,
  ){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if(widget.showCasts)
            _LegendaItem(colors[CSPage.commanderCast], "Casts", theme: theme),

          _LegendaItem(colors[CSPage.life], "Life", theme: theme),
          if(widget.showDamage)
            _LegendaItem(defenceColor, "Damage", theme: theme),
        ],
      ),
    );
  }

  Widget buildChart(
    Map<CSPage,Color> colors, 
    Color? defenceColor, 
    ThemeData theme,
  ){

    final TextStyle style = theme.textTheme.bodyText2!.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.5),
    );

    final double maxTitle = widget.maxValue.closestMultipleOf(10, lower: true);

    return  BarChart(
      BarChartData(
        barGroups: _barGroupsData(
          this.states,
          lifeColor: colors[CSPage.life],
          defenceColor: defenceColor,
          castColor: colors[CSPage.commanderCast],
        ),
        // groupsSpace: 16.0,
        maxY: widget.maxValue,
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (_) => style,
            margin: 20,
            reservedSize: style.fontSize,
            interval: 1.0,
            getTitles: (double value){
              return safeSubString(widget.names[value.toInt()], 3);
            }
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (_) => style,
            margin: 34,
            reservedSize: style.fontSize,
            interval: maxTitle/2,
            getTitles: (double value){
              return "${value.toInt()}";
              // return "";
            }
          )
        ),
        axisTitleData: FlAxisTitleData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: false),
      ), 
      swapAnimationDuration: swapAnimationDuration,
    );
  }

  static String safeSubString(String start, int len){
    if(start.length >  len) return start.substring(0,len-1)+'.';
    else return start; 
  }

  Duration _swapAnimationDuration(int i){
    if(i >= widget.times.length - 1) return Duration(milliseconds: 200);

    final double nextDiff = (widget.times[i + 1] - widget.times[i]).inMilliseconds.abs() * 0.70; //milliseconds
    
    //result / controller.duration = nextDiff / gameDuration

    return (this.controller.duration!.inMilliseconds * nextDiff / widget.gameDuration.inMilliseconds)
        .clamp(20, 200).milliseconds;
  }

  static const _controlsHeight = 56.0;
  Widget buildControls(){
    return Container(
      height: _controlsHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: AnimatedBuilder(
        animation: this.controller,
        builder: (_,__) => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: 60,
              child: Text("-${(widget.gameDuration * (1.0 - this.controller.value)).textFormat}"),
            ),
            Expanded(child: Slider(
              onChanged: (val) => this.setState((){
                this.controller.value = val;
              }),
              value: this.controller.value,
            ),
            ),
            InkResponse(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              onTap: playPause,
              child: Container(
                alignment: Alignment.center,
                width: _controlsHeight,
                height: _controlsHeight,
                child: ImplicitlyAnimatedIcon(
                  icon: AnimatedIcons.play_pause, 
                  progress: isPlaying ? 1.0 : 0.0,
                  duration: CSAnimations.medium,
                  curve: Curves.easeOut,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDurationSelector(){
    final int currently = this.controller.duration!.inSeconds;
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          child: Text("Play over:"),
        ),
        Expanded(child: Center(child: ToggleButtons(
          isSelected: <bool>[for(final s in _okSeconds) 
            currently == s,
          ],
          children: <Widget>[for(final s in _okSeconds)
            Text("${s}s"),
          ],
          onPressed: (i) => this.selectDuration(_okSeconds[i].seconds),
        ),),),
      ],
    );
  }


  //====================================================
  // Chart data =====================================

  static const double _barWidth = 10.0;
  List<BarChartGroupData> _barGroupsData(List<PlayerState> states,{
    required Color? lifeColor,
    required Color? defenceColor,
    required Color? castColor,
  }) => <BarChartGroupData>[
    for(int i=0; i<states.length; i++)
      BarChartGroupData(barsSpace: 5, x: i, barRods: [
        if(widget.showCasts)
          BarChartRodData(
            y: states[i].totalCasts.toDouble(),
            colors: [castColor!],
            width: _barWidth,
          ),

        BarChartRodData(
          y: states[i].life!.toDouble().clamp(0.0, double.infinity),
          colors: [lifeColor!],
          width: _barWidth,
        ),

        if(widget.showDamage)
          BarChartRodData(
            y: states[i].totalDamageTaken.toDouble(),
            colors: [defenceColor!],
            width: _barWidth,
          ),
      ]),
  ];
}




class _LegendaItem extends StatelessWidget {
  final Color? color;
  final String text;
  final ThemeData theme;

  const _LegendaItem(this.color, this.text, {
    required this.theme,
  });
  
  static const double height = _LifeChartLiveState._barWidth * 2;

  @override 
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          // border: Border.all(color: lineColor),
        ),
        child: Row(children: <Widget>[
          Container(
            height: height,
            width: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(height),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(text),
          ),
        ],),
      ),
    );
  }
}