import 'package:counter_spell_new/core.dart';

class AptRole extends StatelessWidget {

  AptRole({
    @required this.actionBloc,
    @required this.name,
    @required this.pageColors,
    @required this.rawSelected,
  });

  final CSGameAction actionBloc;
  final Map<CSPage,Color> pageColors;
  final String name;
  final bool rawSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: (){
        actionBloc.selected.value[name]= rawSelected == null ? true : null;
        actionBloc.selected.refresh();
      },
      child: Checkbox(
        activeColor: pageColors[CSPage.life],
        value: rawSelected,
        tristate: true,
        onChanged: (b) {
          actionBloc.selected.value[name] = rawSelected == false ? true : false;
          actionBloc.selected.refresh();
        },
      ),
      //TODO: attacca / difendi
    );

  }
}