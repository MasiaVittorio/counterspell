import 'package:counter_spell_new/core.dart';

class QuotesAlert extends StatelessWidget {

  const QuotesAlert();

  static const double height = 450;

  @override
  Widget build(BuildContext context) {
    final List<String> cards = <String>[for(final name in FlavorTexts.map.keys) name];
    final stage = Stage.of(context);

    return HeaderedAlert("MtG quotes", 
      child: ListView.builder(
        physics: stage.panelScrollPhysics(),
        itemBuilder: (_, i){
          if(i == 0) return const SizedBox(height: AlertTitle.height);

          final String card = cards[i-1];
          final String quote = FlavorTexts.map[card];

          return Section([
            SectionTitle(card),
            ListTile(title: Text(quote, style: TextStyle(fontStyle: FontStyle.italic),),),
          ]);
        },
        itemCount: FlavorTexts.map.length+1,
      ),
      alreadyScrollableChild: true,
      bottom: ListTile(
        title: const Text("Submit your favorite quote"),
        leading: const Icon(Icons.mail_outline),
        onTap: () => stage.showAlert(
          const ContactsAlert(),
          size: AlternativesAlert.heightCalc(2),
        ),
      ),
    );
  }
}