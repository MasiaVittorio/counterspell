import 'package:counter_spell_new/core.dart';

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
    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SizedBox(
        height: Support.height,
        child: Column(children: <Widget>[
          Expanded(child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: list(pBloc),
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                height: AlertTitle.height,
                child: title(pBloc, theme),
              ),
            ],
          )),
  	    disclaimer(pBloc),
        ],),
      ),
    );
  }

  Widget disclaimer(CSPayments pBloc){
    return UpShadower(child: Column(
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
    ),);
  }

  Widget title(CSPayments pBloc, ThemeData theme){
    return Container(
      color: theme.scaffoldBackgroundColor.withOpacity(0.7),
      child: pBloc.unlocked.build((_,unlocked) 
        => AlertTitle(refreshing
          ? "Refreshing data..."
          : unlocked ? "You are a pro!" : "Support the development",
        ),
      ),
    );
  }

  Widget list(CSPayments pBloc){
    return BlocVar.build2(pBloc.donations, pBloc.purchasedIds, 
      builder: (_, List<Donation> donations, Set<String> purchasedIds) 
        => SingleChildScrollView(
          physics: Stage.of(context).panelScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: AlertTitle.height,),
              for(final donation in donations)
                _Donation(donation, purchased: purchasedIds.contains(donation.productID))
            ],
          ),
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
    );
  }
}

class SupportInfo extends StatelessWidget {

  const SupportInfo();
  static const double height = 500.0;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: Stage.of(context).panelScrollPhysics(),
        child: Column(children: <Widget>[
          const Section([
            AlertTitle('How to unlock "pro" features', centered: false,),
            ListTile(title: Text("The amount of the money you donate doesn't matter to the app. You can donate just a buck and you'll get every pro feature unlocked. You can make bigger or multiple donations and you'll unlock the same stuff."),),
          ]),
          const Section([
            SectionTitle('What are those features'),
            ListTile(title: Text("Currently, the only pro feature is the theme engine. If you already made a donation and unlocked it, you will get any future \"pro\" feature if I ever add any"),),
          ]),
          const Section([
            SectionTitle("My reasons"),
            ListTile(title: Text("I don't want to put a lot of different features behind different paywalls, I made this app because I felt I needed it to play my commander games more easily and I feel like its core features should always stay free."),),
            ListTile(
              title: Text("If you want to donate more than just the lowest amount you should do that because you appreciate my work, not to unlock the latest skin or stuff like that."),
              subtitle: Text(
                "(Also, linking different features to different purchases is annoying to code. Right now the app considers you a pro user simply if the list of past purchases is not empty, lol)",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
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
      ),
    );
  }
}