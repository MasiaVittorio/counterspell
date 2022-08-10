// import 'package:counter_spell_new/core.dart';



// class HintAlertExtended extends StatelessWidget {
  
//   final Hint hint;
//   const HintAlertExtended(this.hint);

//   @override
//   Widget build(BuildContext context) {
//     return Stage<CSPage,SettingsPage>(
//       wholeScreen: false,
//       mainPages: const StagePagesData.nullable(
//         defaultPage: CSPage.life,
//         orderedPages: <CSPage>[CSPage.history, CSPage.life, CSPage.commanderDamage],
//       ),
//       collapsedPanel: const _Collapsed(),
//       body: _Body(hint),
//       extendedPanel: _Extended(hint),
//       topBarContent: StageTopBarContent(
//         title: const StageTopBarTitle(
//           panelTitle: "CounterSpell",
//         ), 
//         subtitle: StageBuild.offPanelPage<SettingsPage>((_, page) 
//           => AnimatedText(page != hint.panelPage
//             ? 'Go to "${settingsThemes[hint.panelPage!]!.name}" tab'
//             : "Here!"
//           ),
//         ), 
//       ),
//     );
//   }
// }



// class _Collapsed extends StatelessWidget {

//   const _Collapsed();

//   @override
//   Widget build(BuildContext context) {
//     return const ListTile(
//       title: Text("Swipe me up!"),
//       leading: Icon(Icons.keyboard_arrow_up),
//     );
//   }
// }

// class _Extended extends StatelessWidget {

//   const _Extended(this.hint);
//   final Hint hint;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: StageBuild.offPanelPage<SettingsPage>((_, page)  
//             => Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 AnimatedText(
//                   page == hint.panelPage  
//                     ? '"${hint.shortPanelPageName}" tab!'
//                     : 'Go to "${hint.shortPanelPageName}" tab'
//                 ),
//                 Icon(
//                   page == hint.panelPage
//                     ? Icons.check_circle_outline
//                     : Icons.close_outlined,
//                   size: 40,
//                 ),
//                 AnimatedText(
//                   page == hint.panelPage  
//                     ? hint.text
//                     : "Wrong Tab"
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _Body extends StatelessWidget {
//   const _Body(this.hint);
//   final Hint hint;
//   @override
//   Widget build(BuildContext context) 
//     => _BodyInternal(Stage.of(context), hint);
// }

// class _BodyInternal extends StatefulWidget {

//   const _BodyInternal(this.stage, this.hint);
//   final StageData<CSPage,SettingsPage?>? stage;
//   final Hint hint;
//   @override
//   _BodyInternalState createState() => _BodyInternalState();
// }

// class _BodyInternalState extends State<_BodyInternal> {

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 1)).then((_){
//       stage!.openPanel();
//       stage!.panelPagesController!.goToPage(hint.panelPage);
//     });
//   }

//   StageData? get stage => widget.stage; 
//   Hint get hint => widget.hint; 

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: ListTile(
//       title: Text("Open the panel-menu!", textAlign: TextAlign.center),
//     ),);
//   }
// }


