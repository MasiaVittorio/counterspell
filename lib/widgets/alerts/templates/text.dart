// import 'package:counter_spell_new/core.dart';

// class TextAlert extends StatelessWidget {
//   final String text;
//   final String title;

//   const TextAlert(this.text, {this.title});

//   @override
//   Widget build(BuildContext context) {
//     final Color background = Theme.of(context).scaffoldBackgroundColor;
//     return Material(
//       color: background,
//       child: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Positioned.fill(
//             child: SingleChildScrollView(
//               physics: Stage.of(context).panelScrollPhysics(),
//               child: Column(
//                 children: <Widget>[
//                   if(title != null) SizedBox(height: AlertTitle.height),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(text),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if(title != null) Positioned(
//             top: 0.0,
//             right: 0.0,
//             left: 0.0,
//             height: AlertTitle.height,
//             child: Container(
//               color: background.withOpacity(0.7),
//               child: AlertTitle(title),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }