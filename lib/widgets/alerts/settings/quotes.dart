import 'package:counter_spell_new/core.dart';

class QuotesAlert extends StatelessWidget {

  const QuotesAlert();

  static const double height = 450;

  @override
  Widget build(BuildContext context) {
    final List<String> cards = <String>[for(final name in FlavorTexts.map.keys) name];

    return HeaderedAlert("MtG Quotes", 
      child: ListView.builder(
        itemBuilder: (_, i){
          if(i == 0) return const SizedBox(height: AlertTitle.height);

          final String card = cards[i-1];
          final String quote = FlavorTexts.map[card];

          return Section([
            SectionTitle(card),
            ListTile(title: Text(quote)),
          ]);
        },
        itemCount: FlavorTexts.map.length+1,
      ),
      alreadyScrollableChild: true,
      bottom: ListTile(
        title: const Text("Submit your favorite quote"),
        leading: const Icon(Icons.mail_outline),
        onTap: () => Stage.of(context).showAlert(
          const ContactsAlert(),
          size: AlternativesAlert.heightCalc(2),
        ),
      ),
    );
  }
}