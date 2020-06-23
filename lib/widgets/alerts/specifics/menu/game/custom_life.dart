import 'package:counter_spell_new/core.dart';

class CustomStartingLife extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final initial = bloc.settings.gameSettings.startingLife.value.toString();
    return InsertAlert(
      onConfirm: (string) => bloc.settings.gameSettings.startingLife.set(int.tryParse(string) ?? 40),
      inputType: TextInputType.number,
      checkErrors: (string){
        final int n = int.tryParse(string);
        if(n == null) return "Invalid text";
        return null;
      },
      hintText: initial,
      labelText: "Insert custom starting life",
    );
  }
}