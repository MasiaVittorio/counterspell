import 'package:counter_spell/core.dart';

import 'stuff/all.dart';

class CrazySpecificStuff extends StatelessWidget {
  static double size = 450.0;

  const CrazySpecificStuff({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      "Crazy specific stuff",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text("Krarkulator"),
            onTap: CSActions.krarkulator,
          ),
          for (final item in items)
            ListTile(
              title: Text(item.title),
              onTap: () => Stage.of(context)!.showAlert(
                item,
                size: item.size,
              ),
            ),
        ],
      ),
    );
  }

  static const List<GenericAlert> items = [
    // KrarkAndSakashima(),
    ZndrspltOkaum(),
    ManaPool(),
  ];
}
