import 'dart:math';

import 'package:counter_spell_new/core.dart';


class ArenaMenuActions extends StatelessWidget {

  const ArenaMenuActions({
    required this.reorderPlayers,
    required this.exit,
    required this.close,
    required this.names,
  });

  final VoidCallback reorderPlayers;
  final VoidCallback exit;
  final VoidCallback close;
  final List<String> names;

  @override
  Widget build(BuildContext context) {

    final bloc = CSBloc.of(context)!;

    final thrower = bloc.achievements.flippedOrRolled;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Section(<Widget>[
          const PanelTitle("Actions"),
          ArenaFirstActions(reorderPlayers, exit),
          CSWidgets.divider,
          _Restarter(close),
        ]),
        Section(<Widget>[
          SectionTitle("Random"),
          RandomListTile(2, onThrowCallback: thrower,),
          RandomListTile(6, onThrowCallback: thrower,),
          RandomListTile(20, onThrowCallback: thrower,),
          RandomListTile(
            null, 
            values: names,
            title: const Text("Pick name"),
            leading: const Icon(Icons.person_outline),
            onThrowCallback: thrower,
          ),
        ]),
      ],
    );
  }
}

class _Restarter extends StatelessWidget {

  const _Restarter(this.closeMenu);
  final VoidCallback closeMenu;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final state = bloc.game.gameState;

    return ConfirmableTile(
      onConfirm: (){
        state.restart(GameRestartedFrom.arena, avoidPrompt: true);
        closeMenu.call();
      },
      leading: Icon(McIcons.restart),
      titleBuilder: (_,__) => Text("New game"),
      subTitleBuilder: (_, pressed) => AnimatedText(pressed ? "Confirm?" : "Start fresh"),
    );
  }
}



class ArenaFirstActions extends StatelessWidget {

  ArenaFirstActions(this.reorderPlayers, this.exit);
  final VoidCallback reorderPlayers;
  final VoidCallback exit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 10.0),
      child: Row(children: <Widget>[
        Expanded(child: ExtraButton(
          text: "Reorder players",
          icon: McIcons.account_group_outline,
          onTap: reorderPlayers,
        )),
        Expanded(child: ExtraButton(
          text: "Exit Arena mode",
          icon: Icons.close,
          onTap: exit,
        )),
      ].separateWith(CSWidgets.extraButtonsDivider)),
    );
  }
}



class RandomListTile extends StatefulWidget {

  const RandomListTile(
    this.max, {
      this.values, 
      this.leading, 
      this.title,
      this.onThrowCallback,
    }
  );
  
  final int? max; /// 2 = coin, 6 = d6, 20 = d20
  final List<String>? values; /// If you want each number to represent a result (the lenght of this list will override the max value!)
  final Widget? leading;
  final Widget? title;
  final VoidCallback? onThrowCallback;

  @override
  _RandomListTileState createState() => _RandomListTileState();
}

class _RandomListTileState extends State<RandomListTile> with SingleTickerProviderStateMixin {

  late AnimationController animation;
  late Random generator;
  int? value;
  
  @required 
  void initState(){
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );
    generator = Random(DateTime.now().millisecondsSinceEpoch);
  }

  @override
  void dispose(){
    animation.dispose();
    super.dispose();
  }

  void move() async {
    if(!mounted) return;
    await animation.animateTo(1.0, curve: Curves.easeOut);
    if(!mounted) return;
    animation.animateBack(0.0, curve: Curves.easeIn);
  }

  void generate() => setState(() {
    ///from 1 to max inclusive
    value = generator.nextInt(max!) + 1; 
  });

  void tap(){
    generate();
    move();
    widget.onThrowCallback?.call();
  }

  static const Map<int,IconData> icons = <int,IconData>{
    2: McIcons.bitcoin,
    6: McIcons.dice_d6,
    20: McIcons.dice_d20,
  };

  static const Map<int,String> titles = <int,String>{
    2: "Flip coin",
    6: "Throw d6",
    20: "Throw d20",
  };

  List<String>? get values => widget.values;
  int? get max => values?.length ?? widget.max;
  IconData get icon => icons[max!] ?? Icons.help_outline;
  String get title => titles[max!] ?? "Throw d$max";

  String? get valueString => value == null 
    ? "/" 
    : values?.elementAt(value!-1) 
      ?? ((max == 2) ? const {1: "tails", 2: "head"}[value!] : "$value");

  Widget get trailing => Text(valueString!);
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tap,
      leading: widget.leading ?? Icon(icon),
      title: widget.title ?? Text(title),
      trailing: AnimatedBuilder(
        animation: animation,
        child: trailing,
        builder: (_, child) => Padding(
          padding: EdgeInsetsDirectional.only(end: animation.value * 12),
          child: child,
        ),
      ),
    );
  }
}