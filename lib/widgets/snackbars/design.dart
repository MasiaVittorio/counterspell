import 'package:counter_spell/core.dart';

class DesignSnackBar extends StatelessWidget {
  const DesignSnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final CSThemer themer = bloc.themer;

    return StageSnackBar(
      secondary: const Icon(McIcons.android_studio),
      title: themer.flatDesign.build((_, flat) => Text(
            flat ? "Flat design" : "Solid design",
          )),
      subtitle: const Text(
        "Tap to toggle",
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      onTap: themer.toggleFlatDesign,
      scrollable: true,
    );
  }
}
