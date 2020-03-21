import 'package:counter_spell_new/core.dart';

class UIExpert extends StatelessWidget {
  const UIExpert();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          for(final Widget child in <Widget>[
            for(final List<Widget> list in const <List<Widget>>[
              <Widget>[
                _DoubleIcon(
                  icon2: null,
                  icon1: Icons.menu,
                  text: "Open menu",
                ),
                _DoubleIcon(
                  icon2: null,
                  icon1: Icons.menu,
                  text: '"Game" tab',
                ),
                _Buttons(),
              ],
              <Widget>[
                _DoubleIcon(
                  icon2: null,
                  icon1: Icons.space_bar,
                  text: "Closed panel",
                ),
                _DoubleIcon(
                  icon1: CSIcons.lifeIconOutlined, 
                  icon2: CSIcons.historyIconFilled, 
                  text: "Life or History page",
                ),
                _Buttons(),
              ],
            ]) Row(children: <Widget>[
              for(final Widget child in list)
                Container(
                  constraints: BoxConstraints(maxWidth: 100),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: child,
                ),
            ].separateWith(const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: const Icon(Icons.keyboard_arrow_right),
            )),),

          ]) Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: child,
          ),
        ].separateWith(const Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Text("or"),
        )),),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {

  const _Buttons();

    @override
  Widget build(BuildContext context) {
    return const _DoubleIcon(
      icon1: McIcons.account_multiple_outline, 
      icon2: McIcons.restart, 
      text: "Buttons",
    );
  }
}

class _DoubleIcon extends StatelessWidget {

  final IconData icon1;
  final IconData icon2;
  final String text;

  const _DoubleIcon({
    @required this.icon1,
    @required this.icon2,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for(final Widget child in <Widget>[
              Icon(icon1),
              if(icon2 != null) Icon(icon2),
            ]) 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              ),
          ].separateWith(const Text("/", style: TextStyle(fontSize: 20),)),
        ),
        Text(text, textAlign: TextAlign.center,)
      ],
    );
    
  }
}