import 'package:counter_spell/core.dart';

import 'info_components/all.dart';

class PanelInfo extends StatelessWidget {
  const PanelInfo({super.key});

  static const double quoteSize = 70;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;

    return LayoutBuilder(
      builder: (_, constraints) => ConstrainedBox(
        constraints: constraints,
        child: ModalBottomList(
          bottom: const QuoteTile(),
          bottomHeight: quoteSize,
          physics: stage.panelController.panelScrollPhysics(),
          children: <Widget>[
            const Useful(),
            const Space.vertical(12),
            Development(
              compact: constraints.maxHeight < 600,
            ),
          ],
        ),
      ),
    );
  }
}
