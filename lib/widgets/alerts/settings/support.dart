import 'package:counter_spell_new/core.dart';
import 'package:flutter/services.dart';

class Support extends StatefulWidget {

  const Support();
  static const double height = 450.0;

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {

  bool refreshing = false;

  void restore(CSPayments pBloc) async {
    setState((){
      refreshing = true;
    });
    await pBloc.restore();
    setState((){
      refreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pBloc = CSBloc.of(context).payments;
    return pBloc.unlocked.build((_,unlocked) 
      => HeaderedAlert(
        refreshing ? "Refreshing data..." : unlocked ? "You are a pro!" : "Support the development",
        child: list(pBloc),
        bottom: disclaimer(pBloc),
      ),
    );
  }

  Widget disclaimer(CSPayments pBloc){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: const Text("You can support the developer by making any donation from this list. If you do, you'll unlock all the \"pro\" features no matter the amount of the donation."),
        ),
        Row(children: <Widget>[
          Expanded(child: ListTile(
            title: Text("More info"),
            leading: Icon(Icons.info_outline),
            onTap: () => Stage.of(context).showAlert(const SupportInfo(), size: SupportInfo.height,),
          )),
          Expanded(child: ListTile(
            title: Text("Refresh"),
            leading: Icon(McIcons.restart),
            onTap: () => this.restore(pBloc),
          )),
        ],),
      ],
    );
  }

  Widget list(CSPayments pBloc){
    return BlocVar.build2(pBloc.donations, pBloc.purchasedIds, 
      builder: (_, List<Donation> donations, Set<String> purchasedIds) 
        => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for(final donation in donations)
              _Donation(donation, purchased: purchasedIds.contains(donation.productID))
          ],
        ),
    );
  }
}


class _Donation extends StatelessWidget {
  final bool purchased;
  final Donation donation;

  const _Donation(this.donation, {@required this.purchased});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(donation.title),
      leading: Icon(purchased ? Icons.favorite : Icons.favorite_border),
      trailing: Text(donation.amount),
      onTap: () => CSBloc.of(context).payments.purchase(donation.productID),
    );
  }
}

class SupportInfo extends StatelessWidget {

  const SupportInfo();
  static const double height = 500.0;
  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      "Donations info",
      bottom: ListTile(
        title: const Text("Copy payments log"),
        subtitle: const Text("For debugging purposes"),
        leading: const Icon(McIcons.bug_check),
        trailing: const Icon(Icons.content_copy),
        onTap: () => Clipboard.setData(ClipboardData(text: CSBloc.of(context).payments.log)),
      ),
      child: Column(children: <Widget>[
        const Section([
          SectionTitle('How to unlock "pro" features'),
          ListTile(title: Text("The amount of the money you donate doesn't matter. You can donate just the lowest possible amount and you'll get every pro feature unlocked. You can make bigger or multiple donations and you'll unlock the same stuff."),),
        ]),
        const Section([
          SectionTitle('What are those features'),
          ListTile(title: Text("At this moment, the pro features include the theme engine and the leaderboards. If you already made a donation and unlocked those, you will get any future \"pro\" feature if I ever add any"),),
          SubSection([ListTile(subtitle: Text(
            "CounterSpell already saves stats of your past games even while the leaderboards are locked.",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),),],),
          CSWidgets.heigth10,
        ]),
        const Section([
          SectionTitle("My reasons"),
          ListTile(title: Text("I made this app because I wanted to use it myself, and I feel like its core features should always stay free to anyone else who apprecieate it like I do."),),
          ListTile(title: Text("If you want to donate more than just the lowest amount you should do that because you appreciate my work, not to unlock the latest skin or stuff like that."),),
          SubSection([ListTile(subtitle: Text(
            "(Also, linking different features to different purchases is annoying to code. Right now the app considers you a pro user simply if the list of past purchases is not empty, lol)",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),),],),
          CSWidgets.heigth10,
        ]),
        Padding(
          padding: const EdgeInsets.only(right:16.0, left: 16.0, bottom: 14.0),
          child: Text(
            FlavorTexts.rancor, 
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],),
    );
  }
}