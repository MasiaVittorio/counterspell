import 'package:counter_spell_new/core.dart';

class UIExpert extends StatelessWidget {
  const UIExpert();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: Text("Some visual hint to do that achievement"),
    );
  }
}