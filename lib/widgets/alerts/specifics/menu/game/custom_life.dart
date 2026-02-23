import 'package:counter_spell/core.dart';

class CustomStartingLife extends StatelessWidget {
  const CustomStartingLife({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final initialInt = bloc.settings.gameSettings.currentStartingLife;
    final initial = initialInt.toString();
    return InsertAlert(
      onConfirm: (string) => bloc.settings.gameSettings
          .changeStartingLife(int.tryParse(string) ?? initialInt),
      inputType: TextInputType.number,
      checkErrors: (string) {
        final int? n = int.tryParse(string);
        if (n == null) return "Invalid text";
        return null;
      },
      hintText: initial,
      labelText: "Insert custom starting life",
    );
  }
}
