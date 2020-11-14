import 'package:counter_spell_new/core.dart';



class StuffILikeAlert extends StatelessWidget {

  const StuffILikeAlert();

  static const double height = 425;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: _CommandBros.getTheme(theme),
      child: HeaderedAlert(
        "Stuff the dev likes",
        canvasBackground: true,
        child: Column(mainAxisSize: MainAxisSize.min, children: const [
          _Note("This page's content may change only when the app gets updated"),
          CSWidgets.height10,
          _Content(),
        ],),
        bottom: const _Note(
          "CounterSpell will not send you any notification to bring you to this page",
          flat: true,
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.note,{this.flat = false});
  final String note;
  final bool flat;
  @override
  Widget build(BuildContext context) {
    return SubSection(
      [ListTile(
        title: Text(
          note,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSecondary
          ),
          textAlign: TextAlign.center,
        ),
      )], 
      margin: flat ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: 10),
      borderRadius: flat 
        ? BorderRadius.circular(0) 
        : SubSection.borderRadiusDefault,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();
  @override
  Widget build(BuildContext context) {
    return const _CommandBros();
  }
}



class _CommandBros extends StatelessWidget {
  
  static ThemeData getTheme(ThemeData base) => base.copyWith(
    brightness: Brightness.dark,
    canvasColor: main,
    iconTheme: base.iconTheme.copyWith(color: color5),
    accentIconTheme: base.iconTheme.copyWith(color: color5),
    primaryIconTheme: base.iconTheme.copyWith(color: color5),
    textTheme: base.textTheme.apply(bodyColor: color5),
    colorScheme: base.colorScheme.copyWith(
      primary: main,
      primaryVariant: main,
      onPrimary: color5,
      surface: main,
      onSurface: color5,
      background: main,
      onBackground: color5,

      secondary: color2,
      secondaryVariant: color3,
      onSecondary: color5Brighter,
    ),
    scaffoldBackgroundColor: color2,
  );

  static const Color color1 = Color(0xFF003049);
  static const Color main = color1;
  static const Color card = color1Darker;
  static const Color color1Darker = Color(0xFF00293E);
  static const Color color2 = Color(0xFFD62828);
  static const Color color3 = Color(0xFFF77F00);
  // static const Color color4 = Color(0xFFFCBF49);
  static const Color color5 = Color(0xFFEAE2B7);
  static const Color color5Brighter = Color(0xFFF0EACA);

  const _CommandBros();

  static const double _size = 80.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 248,
      ),
      child: Stack(children: [
        Positioned.fill(
          top: _size/2 + 10,
          child: Container(decoration: BoxDecoration(
            color: card,
            boxShadow: [BoxShadow(
              blurRadius: 5,
              color: Color(0x89000000),
              spreadRadius: 1.5,
            )]
          )),
        ),
        Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkResponse(
                containedInkWell: true,
                onTap: CSActions.visitCommandBros,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      type: MaterialType.circle,
                      elevation: 8,
                      color: color1,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/command_bros/logo.png",
                        ),
                        backgroundColor: Colors.transparent,
                        minRadius: _size/2,
                        maxRadius: _size/2,
                      ),
                    ),
                  ),
                  Expanded(child: const Text("Command Bros", style: TextStyle(
                    fontSize: 21,
                  ),),),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Icon(
                      McIcons.youtube, 
                      color: color3,
                    ),
                  ),
                ],),
              ),
              CSWidgets.height5,
              const ListTile(
                title: Text(
                  "This playgroup is the most fun I've had with the EDH gameplay genre in a long while. If you like pure, unadultered and easy to follow EDH games with minimal animations and hilarious commentary, be sure to check them out. Also, they use CounterSpell! :D",
                  textAlign: TextAlign.center,
                ),
                onTap: CSActions.visitCommandBros,
              ),
            ],
          ),
        ),
      ],),
    );
  }
}