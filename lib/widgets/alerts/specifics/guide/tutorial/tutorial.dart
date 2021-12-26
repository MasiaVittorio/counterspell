// import 'components/all.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/guide/tutorial/components/page_reactor.dart';
import 'components/all.dart';


class AdvancedTutorial extends StatelessWidget {

  const AdvancedTutorial();

  static int get pages => TutorialContent.children.length;
  static const double height = double.infinity;

  @override
  Widget build(BuildContext context) {
    return _AdvancedTutorial(
      Stage.of(context)!.panelController.alertController.savedStates[stateKey],
    );
  }

  static const String stateKey = "advanced tutorial page stage";
}

class _AdvancedTutorial extends StatefulWidget {

  final int? initialPage;

  const _AdvancedTutorial(this.initialPage);

  @override
  _AdvancedTutorialState createState() => _AdvancedTutorialState();
}

class _AdvancedTutorialState extends State<_AdvancedTutorial> {

  PageController? pageController;

  @override
  void initState() {
    super.initState();
    this.pageController = PageController(
      viewportFraction: 0.9,
      initialPage: widget.initialPage ?? 0,
    );
  }

  @override
  void dispose() {
    this.pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned.fill(
        top: PanelTitle.height,
        bottom: _bottomHeight,
        child: TutorialContent(pageController),
      ),
      Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        child: PageReactor(controller: pageController!, builder: (_,page)
          => PanelTitle(TutorialContent.titles[page], animated: true),
        ),
      ),
      Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        height: _bottomHeight,
        child: Center(child: TutorialControls(pageController)),
      ),
    ],);
  }

  static const double _bottomHeight = 70;
}