// import 'package:counter_spell/core.dart';

// class ThemeResetter extends StatelessWidget {

//   const ThemeResetter();

//   @override
//   Widget build(BuildContext context) {
//     final stage = Stage.of(context);

//     return ListTile(
//       title: const Text("Reset to default"),
//       leading: const Icon(McIcons.restart),
//       onTap: () => stage.showAlert(ConfirmAlert(
//         warningText: "Are you sure? This action cannot be undone.",
//         confirmText: "Yes, reset to default colors",
//         cancelText: "No, keep the current theme",
//         action: () {
//           final themeController = stage.themeController;
//           final style = themeController.brightness.darkStyle.value;
//           final brightness = themeController.brightness.brightness.value;
//           final colorPlace = themeController.colorPlace.value;

//           final defaultScheme = CSColorScheme.defaultScheme(
//             brightness.isLight, 
//             style, 
//             colorPlace,
//           ); 
//           Map<CSPage,Color> perPage = <CSPage,Color>{
//             for(final entry in defaultScheme.perPage.entries)
//               entry.key: Color(entry.value.value),
//           }; // copy the map

//           themeController.currentColorsController.editPanelPrimary(defaultScheme.primary);
//           themeController.currentColorsController.editMainPagedPrimaries(perPage);
//           themeController.currentColorsController.editAccent(defaultScheme.accent);
//         },
//       ),size: ConfirmAlert.height),
//     );
//   }
// }