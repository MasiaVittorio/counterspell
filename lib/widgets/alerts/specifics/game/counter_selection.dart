// import 'package:counter_spell_new/core.dart';


// class CounterSelector extends StatelessWidget {
//   const CounterSelector();
//   @override
//   Widget build(BuildContext context) {
//     final CSBloc bloc = CSBloc.of(context);
//     final ThemeData theme = Theme.of(context);
//     final CSGameAction gameAction = bloc.game.gameAction;
//     final StageData<CSPage,SettingsPage> stage = Stage.of(context);

//     return stage.themeController.derived.mainPageToPrimaryColor.build((_,map)
//       => Material(
//         child: SingleChildScrollView(
//           physics: stage.panelController.panelScrollPhysics(),
//           child: gameAction.counterSet.build((context, current)
//             => IconTheme.merge(
//               data: const IconThemeData(opacity: 1.0),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     const PanelTitle("Pick counter"),
//                     for(final counter in gameAction.counterSet.list)
//                       SidRadioListTile<String>(
//                         activeColor: theme.accentColor,
//                         groupValue: current.longName,
//                         value: counter.longName,
//                         onChanged: gameAction.chooseCounterByLongName,
//                         title: Text(counter.longName),
//                         secondary: Icon(
//                           counter.icon, 
//                           color: counter.longName == current.longName 
//                             ? theme.accentColor
//                             : null,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ));
//   }
// }