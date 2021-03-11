import 'package:counter_spell_new/core.dart'; 
import 'stuff/all.dart';


/// TODO: add a new button / section in the info tab to include this crazy yet oddly and disturbingly specific stuff

class CrazySpecificStuff extends StatelessWidget {

  static double size = 450.0;

  const CrazySpecificStuff();

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      "Crazy specific stuff", 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for(final item in items)
            ListTile(
              title: Text(item.title),
              onTap: () => Stage.of(context).showAlert(
                item,
                size: item.size,
              ),
            ),
        ],
      ),
    );
  }

  static const List<GenericAlert> items = [
    KrarkAndSakashima(),
  ];
  


}
