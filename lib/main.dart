import 'dart:async';
import 'dart:io';

import 'package:counter_spell_new/widgets/homepage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'core.dart';

void main() => runApp(CounterSpell());

class TopNavigator extends StatelessWidget {
  const TopNavigator();

  /// to enter the backup and restore screen having the logic disposed completely
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CounterSpell',
      home: CounterSpell(),
    );
  }
}

class CounterSpell extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _CounterSpellState createState() => _CounterSpellState();
}

class _CounterSpellState extends State<CounterSpell> {
  late CSBloc bloc;
  late StreamSubscription<List<PurchaseDetails>>
      _subscription; //react to new purchase

  @override
  void initState() {
    super.initState();
    bloc = CSBloc();
    // InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    _subscription = InAppPurchase.instance.purchaseStream
        .listen((List<PurchaseDetails> purchases) {
      reactToNewPurchases(purchases);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    print("disposing counterspell logic");
    super.dispose();
  }

  void logAdd(String newLine) => this.bloc.payments.logAdd(newLine);

  void reactToNewPurchases(List<PurchaseDetails> purchases) {
    logAdd("react: 0 -> entered with list of lenght: ${purchases.length}");

    bool found = false;
    int i = 0;
    for (final detail in purchases) {
      ++i;

      logAdd("react: 1.iteration$i -> product: ${detail.productID}, purchase: ${detail.purchaseID}, status: ${detail.status}");

      if (detail.status == PurchaseStatus.pending) {
        logAdd("react: 1.iteration$i.pending -> this product status was still pending, so we skip it and continue the for cycle");
        continue;
      }

      if (!bloc.payments.purchasedIds.value.contains(detail.productID)) {
        bloc.payments.purchasedIds.value.add(detail.productID);
        found = true;
        logAdd("react: 1.iteration$i.notFound -> this purchase was not previously saved! (we should unlock later)");
      }
      if (Platform.isIOS) {
        logAdd("react: 1.iteration$i.iOS -> platform is iOS, we call completePurchase(detail)");
        // Mark that you've delivered the purchase. Only the App Store requires
        // this final confirmation.
        InAppPurchase.instance.completePurchase(detail);
      }
    }

    logAdd("react: 2 -> for cycle ended, found a new (non pending) purchase? $found");
    if (found) {
      logAdd("react: 2.true -> refresh purchasedIds and unlock");
      bloc.payments.purchasedIds.refresh();
      bloc.payments.unlocked.setDistinct(true);
    }
  }

  @override
  Widget build(context) {
    return BlocProvider<CSBloc>(
      bloc: bloc,
      child: StageProvider<CSPage, SettingsPage>(
        data: bloc.stageBloc.controller,
        child: const _MaterialApp(),
      ),
    );
  }
}

class _MaterialApp extends StatelessWidget {
  const _MaterialApp();
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of<CSPage, SettingsPage>(context)!;
    return stage.themeController.derived.themeData.build(
      (_, theme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: 'CounterSpell',
        home: const CSHomePage(key: WidgetsKeys.homePage),
      ),
    );
  }
}
