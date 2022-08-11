import 'package:auto_size_text/auto_size_text.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/resources/biggest_square.dart';


class TutorialPrompt extends StatelessWidget {

  const TutorialPrompt({Key? key}) : super(key: key);

  static const double height = 400;

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    return SizedBox(
      height: height,
      child: Column(children: [
        const AlertDrag(),
        title,
        const Padding(
          padding: EdgeInsets.fromLTRB(20,12,20,18),
          child: subtitle,
        ),
        Expanded(flex: 10, child: yes(logic)),
        const Space.vertical(10),
        Expanded(flex: 9, child: no(logic)),
        const Space.vertical(10),
      ],),
    );
  }

  static const title = Text(
    "Need a tutorial?",
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 20),
  );
  static const subtitle = Text(
    "You'll be able to play around with the app while it runs",
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
  );

  Widget button(
    VoidCallback onTap, 
    String title, 
    IconData icon, 
    Color? color,
  ) => SubSection(
    [Expanded(child: Center(child: Row(
      children: [
        const Space.horizontal(4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 56),
          child: BiggestSquareBuilder(
            builder: (_, size) => Center(child: Icon(icon, size: size*24/56,)),
            scale: 1.0,
          ),
        ),
        const Space.horizontal(4),
        Expanded(child: AutoSizeText(
          title, 
          minFontSize: 8,
          maxFontSize: 16,
          maxLines: 2,
          style: const TextStyle(fontSize: 16),
        )),
        const Space.horizontal(20),
      ],
    ),),)],
    onTap: onTap,
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    color: true,
    overrideColor: color,
  );

  Widget yes(CSBloc logic) => button(
    () => logic.tutorial.showTutorial(null),
    "Yes, show me around!",
    Icons.check,
    null,
  );
  Widget no(CSBloc logic) => button(
    () => CSSettingsApp.hintAtTutorial(logic, ms: 0),
    "No, but show me where to find it in case I need it later",
    Icons.close,
    CSColors.delete.withOpacity(0.1),
  );

}