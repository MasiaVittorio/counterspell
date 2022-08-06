import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stage/panel/collapsed_components/circle_button.dart';



class HintAlertCollapsed extends StatelessWidget {
  
  const HintAlertCollapsed(this.hint);
  final Hint hint;

  @override
  Widget build(BuildContext context) {
    return Stage<CSPage,SettingsPage>(
      key: ValueKey(hint.text),
      wholeScreen: false,
      mainPages: StagePagesData.nullable(
        defaultPage: CSPage.life,
        orderedPages: const <CSPage?,List<CSPage>>{
          CSPage.history : [CSPage.history,CSPage.life,CSPage.commanderDamage],
          CSPage.counters : [CSPage.history,CSPage.counters,CSPage.commanderDamage],
          CSPage.life : [CSPage.history,CSPage.life,CSPage.commanderDamage],
          CSPage.commanderDamage : [CSPage.life,CSPage.commanderDamage,CSPage.commanderCast],
          CSPage.commanderCast: [CSPage.history,CSPage.life,CSPage.commanderCast],
          null: [CSPage.counters,CSPage.life,CSPage.commanderDamage,],
        }[hint.page],
      ),
      collapsedPanel: _Collapsed(hint),
      body: _Body(hint),
      extendedPanel: const _Extended(),
      topBarContent: const StageTopBarContent(
        title: StageTopBarTitle(
          panelTitle: "CounterSpell",
        ), 
      ),
    );
  }
}



class _Collapsed extends StatelessWidget {

  const _Collapsed(this.hint);
  final Hint hint;

  @override
  Widget build(BuildContext context) {

    final bool? right = hint.collapsedRightSide;

    return StageBuild.offMainColors<CSPage>((_, __, colors) 
      => StageBuild.offMainPage<CSPage>((_, page) {

        final bool error = ((page != hint.page) && (hint.page != null));

        final Widget button = CircleButton(
          externalCircles: 3,
          sizeIncrement: 0.5,
          color: colors![page]!
              .withOpacity(0.07),
          size: CSSizes.barSize,
          onTap: error ? (){} : () => Stage.of(context)!.showSnackBar(
            const StageSnackBar(
              title: Text("Yeah, like that!"),
              secondary: Icon(Icons.check),
            ),
            rightAligned: hint.collapsedRightSide!,
          ),
          child: Icon(error
            ? Icons.error
            : hint.collapsedIcon,
          ),
        );

        return Row(children: [
          if(!right!)
            button
          else SizedBox(
            width: CSSizes.collapsedPanelSize,
            height: CSSizes.collapsedPanelSize,
            child: Center(child: Icon(
              error
                ? Icons.error
                : Icons.keyboard_arrow_right,
            ),),
          ),

          Expanded(child: Center(child: AnimatedText(
            error 
              ? 'Go to "${CSPages.shortTitleOf(hint.page)}" page'
              : right ? 'Use the right button' : 'Use the left button',
          ),),),

          if(right)
            button
          else SizedBox(
            width: CSSizes.collapsedPanelSize,
            height: CSSizes.collapsedPanelSize,
            child: Center(child: Icon(
              error
                ? Icons.error
                : Icons.keyboard_arrow_left,
            )),
          ),
          
        ],);
      },),
    );
  }
}

class _Extended extends StatelessWidget {

  const _Extended();

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: ListTile(
        title: Text("Nope, close the panel!"),
        leading: Icon(Icons.error),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.hint);
  final Hint hint;
  @override
  Widget build(BuildContext context) 
    => _BodyInternal(Stage.of(context), hint);
}

class _BodyInternal extends StatefulWidget {

  const _BodyInternal(this.stage, this.hint);
  final StageData<CSPage?,SettingsPage>? stage;
  final Hint hint;
  @override
  _BodyInternalState createState() => _BodyInternalState();
}

class _BodyInternalState extends State<_BodyInternal> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((_){
      stage!.mainPagesController.goToPage(hint.page);
    });
  }

  StageData? get stage => widget.stage; 
  Hint get hint => widget.hint; 

  @override
  Widget build(BuildContext context) {
    return Center(child: ListTile(
      title: Text(hint.text, textAlign: TextAlign.center),
    ),);
  }
}


