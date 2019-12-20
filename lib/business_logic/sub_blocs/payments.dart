import 'dart:io';

import 'package:counter_spell_new/core.dart';

import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class CSPayments {

  void dispose(){
    this.unlocked.dispose();
    _subscription.cancel();
    this.purchasedIds.dispose();
    this.donations.dispose();
  }


  //===========================================
  // Values
  final CSBloc parent;
  List<ProductDetails> items = <ProductDetails>[]; //all available

  final PersistentVar<bool> unlocked; 
  StreamSubscription<List<PurchaseDetails>> _subscription; //react to new purchase
  final PersistentVar<Set<String>> purchasedIds; //past done purchases
  final BlocVar<List<Donation>> donations; //all available (wrapper for UI)
  String log = "";

  //===========================================
  // Constructor
  CSPayments(this.parent): 
    unlocked = PersistentVar<bool>(
      key: "counterspell_bloc_var_payments_unlocked",
      initVal: false,
      toJson: (b) => b,
      fromJson: (j) => j as bool,
    ),
    purchasedIds = PersistentVar<Set<String>>(
      initVal: <String>{},
      key: 'counterspell_bloc_var_payments_purchaseIds',
      fromJson: (json) => <String>{for(final s in json as List) s as String},
      toJson: (sset) => [for(final s in sset) s],
    ),
    donations = BlocVar<List<Donation>>(<Donation>[])
  {
    _subscription = InAppPurchaseConnection
        .instance
        .purchaseUpdatedStream
        .listen((List<PurchaseDetails> purchases) {
          reactToNewPurchases(purchases);
        });

    check();
  }


  //===========================================
  // Methods
  void logAdd(String newLine){
    log += "\n$newLine";
    // print(newLine);
  }



  void check() async {
    logAdd("enter method: check()");
    await availableItems();

    logAdd("inside method: check() -> available items retrieved");

    if(this.unlocked.reading){
      logAdd("inside method: check() -> unlocked var is still reading, adding restore to read callback");
      this.unlocked.readCallback = (result){
        logAdd("inside method: check() -> calling read callback, unlocked: $result");
        if(result == false){
          logAdd("inside method: check() -> unlocked var after read is false, try to restore");
          this.restore();
        }
      };
    } else {
      logAdd("inside method: check() -> unlocked var is ready");
      if(this.unlocked.value == false){
        logAdd("inside method: check() -> unlocked var is false, try to restore");
        this.restore();
      } else {
        logAdd("inside method: check() -> pro features already unlocked tho (not launching restore)");
      }
    }
  }




  Future<void> availableItems() async {
    logAdd("enter method: availableItems()");
    bool available = false;
    try {
      available = await InAppPurchaseConnection.instance.isAvailable();      
    } catch (e) {
      logAdd("inside method: availableItems() ->InAppPurchaseConnection.instance.isAvailable() thrown error $e");
      //strange that this .isAvailable() method can throw, lol?
      return;
    }

    if (!available) {
      logAdd("inside method: availableItems() ->InAppPurchaseConnection.instance.isAvailable() returned false");
      // The store cannot be reached or accessed. Update the UI accordingly.
      return;
    }

    logAdd("inside method: availableItems() ->connection available, now waiting for queryProductDetails from list $products");
    final ProductDetailsResponse response = 
      await InAppPurchaseConnection.instance
        .queryProductDetails(products);

    if (response.notFoundIDs.isNotEmpty) {
      logAdd("inside method: availableItems() ->some ids were NOT found: ${response.notFoundIDs}");
    }

    this.items = response.productDetails;
    logAdd("inside method: availableItems() ->items retrieved: ${this.items.length}");
    
    this.donations.set(<Donation>[
      for(final item in this.items)
        Donation(
          productID: item.id,
          amount: item.price,
          title: _titleCleaner(item.title),
          amountNum: double.tryParse(<String>[
            for(final char in item.price.split(""))
              if(["0","1","2","3","4","5","6","7","8","9","."].contains(char))
                 char,
          ].join()) ?? 0.0,
        ),
    ]..sort((d1,d2) => ((d1.amountNum - d2.amountNum)*100).round()));
  }
  String _titleCleaner(String s){
    String ret = '';
    for(final x in s.split('')){
      if(x != '(') ret += x;
      else break;
    }
    return ret;
  }




  Future<void> restore() async {
    logAdd("enter method: restore() -> waiting for queryPastPurchases()");

    final QueryPurchaseDetailsResponse pastResponse = await InAppPurchaseConnection.instance.queryPastPurchases();
    if (pastResponse.error != null) {
      logAdd("inside method: restore() -> pastPurchases() had an error: ${pastResponse.error}");
      return;
      // Handle the error.
    }

    logAdd("inside method: restore() -> pastPurchases() found: ${pastResponse.pastPurchases.length} past purchases");
    for (PurchaseDetails purchase in pastResponse.pastPurchases) {
      logAdd("inside method: restore() -> past purchase: ${purchase.productID} // ${purchase.purchaseID}: status: ${purchase.status}");

      if (Platform.isIOS) {
        logAdd("inside method: restore() -> platform is iOS, have to call InAppPurchaseConnection.instance.completePurchase(${purchase.productID}), but only if it is not still pending");
        // Mark that you've delivered the purchase. Only the App Store requires
        // this final confirmation.
        if(purchase.status != PurchaseStatus.pending) {
          InAppPurchaseConnection.instance.completePurchase(purchase);
        }
      }
    }

    logAdd("inside method: restore() -> waiting for getUndealPurchases()");

    final List<PurchaseDetails> undealts = await InAppPurchaseConnection.instance.getUndealPurchases();

    logAdd("inside method: restore() -> getUndealPurchases() found: ${undealts.length} non completed purchases");
    for (PurchaseDetails purchase in undealts) {
      logAdd("inside method: restore() -> non completed purchase: ${purchase.productID} // ${purchase.purchaseID}: status: ${purchase.status}");

      if (Platform.isIOS) {
        logAdd("inside method: restore() -> platform is iOS, have to call InAppPurchaseConnection.instance.completePurchase(${purchase.productID}), but only if it is not still pending");
        // Mark that you've delivered the purchase. Only the App Store requires
        // this final confirmation.
        if(purchase.status != PurchaseStatus.pending) {
          InAppPurchaseConnection.instance.completePurchase(purchase);
        }
      }
    }

    this.purchasedIds.set(<String>{
      for(final details in [...pastResponse.pastPurchases, ...undealts])
        if(details.status != PurchaseStatus.pending)
          details.productID,
    });

    logAdd("inside method: restore() -> detected purchased ids: ${purchasedIds.value}");

    if(purchasedIds.value.isNotEmpty) {
      logAdd("inside method: restore() -> unlocking since past purchases is not empty");
      this.unlocked.setDistinct(true);
    }
    else {
      logAdd("inside method: restore() -> LOCKING since past purchases is empty");
      this.unlocked.set(false);
    }

  }



  void reactToNewPurchases(List<PurchaseDetails> purchases){
    logAdd("enter method: reactToNewPurchases() with parameter: ");

    bool found = false;

    for(final detail in purchases){
      if(detail == null){
        logAdd("inside method: reactToNewPurchases() -> NULL purchase, skipping");
        continue;
      }
      logAdd("inside method: reactToNewPurchases() -> purchase: ${detail.productID}");
      if(detail.productID != null && !purchasedIds.value.contains(detail.productID)){
        purchasedIds.value.add(detail.productID);
        found = true;
        logAdd("inside method: reactToNewPurchases() -> this purchase was not previously saved!");
      }
      if (Platform.isIOS) {
        logAdd("inside method: reactToNewPurchases() -> platform is iOS, have to call InAppPurchaseConnection.instance.completePurchase(${detail.productID}), but only if it is not still pending");
        // Mark that you've delivered the purchase. Only the App Store requires
        // this final confirmation.
        if(detail.status != PurchaseStatus.pending) {
          InAppPurchaseConnection.instance.completePurchase(detail);
        }
      }
    }

    if(found){
      purchasedIds.refresh();
    }
  }




  void purchase(String productID) async {
    logAdd("enter method: purchase(id: $productID)");
    if (this.purchasedIds.value.contains(productID)) return;

    ProductDetails productDetails;
    for(final item in this.items){
      if(item.id == productID) productDetails = item;
    }
    logAdd("inside method: purchase() -> product details found? ${productDetails != null}");
    if(productDetails == null) return;

    logAdd("inside method: purchase() -> calling InAppPurchaseConnection.instance.buyNonConsumable()");
    await InAppPurchaseConnection.instance.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: productDetails)
    );
  }



  static const Set<String> androidProducts = <String>{
    'com.mvsidereusart.counterspell.cultivate',
    'com.mvsidereusart.counterspell.unstable',
    'com.mvsidereusart.counterspell.propaganda',
    'com.mvsidereusart.counterspell.ghostly',
    'com.mvsidereusart.counterspell.20',
  };

  static const Set<String> appleProducts = <String>{
    'com.mvsidereusart.counterspell.unstable',
    'com.mvsidereusart.counterspell.propaganda',
    'com.mvsidereusart.counterspell.ghostly',
    'com.mvsidereusart.counterspell.20',
  };

  Set<String> get products {
    if (Platform.isAndroid) {
      return androidProducts;
    } else if (Platform.isIOS) {
      return appleProducts;
    }
    return <String>{};
  }



}



class Donation{
  String title;
  String amount;
  String productID;
  double amountNum;

  Donation({
    @required this.productID, 
    @required this.amount, 
    @required this.title, 
    @required this.amountNum,
  });

}
