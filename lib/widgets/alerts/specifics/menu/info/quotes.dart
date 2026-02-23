import 'package:counter_spell/core.dart';

class QuotesAlert extends StatelessWidget {
  const QuotesAlert({super.key});

  static const double height = 450;

  @override
  Widget build(BuildContext context) {
    final List<String> cards = <String>[
      for (final name in FlavorTexts.map.keys) name
    ];
    final stage = Stage.of(context)!;

    return HeaderedAlert(
      "MtG quotes",
      alreadyScrollableChild: true,
      bottom: ListTile(
        title: const Text("Submit your favorite quote"),
        leading: const Icon(Icons.mail_outline),
        onTap: () => stage.showAlert(
          const ContactsAlert(),
          size: AlternativesAlert.heightCalc(2),
        ),
      ),
      child: ListView.builder(
        physics: stage.panelController.panelScrollPhysics(),
        itemBuilder: (_, i) {
          final String card = cards[i];
          final String quote = FlavorTexts.map[card]!;

          return Section([
            SectionTitle(card),
            ListTile(
              title: Text(
                quote,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ]);
        },
        itemCount: FlavorTexts.map.length,
      ),
    );
  }
}
