import 'dart:io';

import 'package:counter_spell_new/core.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class CSPayments {

  void dispose(){
    this.unlocked.dispose();
    this.purchasedIds.dispose();
    this.donations.dispose();
  }


  //===========================================
  // Values
  final CSBloc parent;
  List<ProductDetails> items = <ProductDetails>[]; //all available

  final PersistentVar<bool> unlocked; 
  final PersistentVar<Set<String>> purchasedIds; //past done purchases
  final BlocVar<List<Donation>> donations; //all available (wrapper for UI)
  String log = "";

  //===========================================
  // Constructor
  CSPayments(this.parent): 
    unlocked = PersistentVar<bool>(
      key: "counterspell_bloc_var_payments_unlocked",
      initVal: kDebugMode,
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
    //IMPORTANT: moved all the subscription handling in the main stateful witget's initState, so it will intercept any past purchase before.
    // (strange to think that is needed, since the whole BLoC constructor is syncronous, but we will still try this way)

    check();
  }


  //===========================================
  // Methods
  void logAdd(String newLine){
    final now = DateTime.now();
    log += "\n(${now.hour.toString().padLeft(2, "0")}:${now.hour.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}) $newLine";
  }



  void check() async {
    logAdd("check: 0 -> entered");
    await availableItems();

    logAdd("check: 1 -> available items retrieved");

    if(this.unlocked.reading){
      logAdd("check: 2.a -> unlocked var is still reading, adding restore to read callback");
      this.unlocked.readCallback = (result){
        logAdd("read callback (set during check 2.a): 0 -> entered, unlocked: $result");
        if(result == false){
          logAdd("read callback (set during check 2.a): 1.a -> it was locked, so we call restore");
          this.restore();
        } else {
          logAdd("read callback (set during check 2.a): 1.b -> it was unlocked already, so we call nothing");
        }
      };
    } else {
      logAdd("check: 2.b -> unlocked var is ready: NOT still reading. value: ${this.unlocked.value}");
      if(this.unlocked.value == false){
        logAdd("check: 2.b.a -> it was locked, so we call restore");
        this.restore();
      } else {
        logAdd("check: 2.b.a -> it was unlocked already, so we call nothing");
      }
    }
  }




  Future<void> availableItems() async {
    logAdd("availableItems: 0 -> entered, checking if connection is available");
    bool available = false;
    try {
      available = await InAppPurchaseConnection.instance.isAvailable();      
    } catch (e) {
      logAdd("availableItems: 0.error -> InAppPurchaseConnection.instance.isAvailable() thrown error $e");
      //strange that this .isAvailable() method can throw, lol?
      return;
    }

    logAdd("availableItems: 1 -> available result: $available");
    if (!available) {
      logAdd("availableItems: 1.a -> unavailable connection, returning null (rip)");
      // The store cannot be reached or accessed. Update the UI accordingly.
      return;
    }

    logAdd("availableItems: 2 -> available connection, now waiting for queryProductDetails from list $products");
    final ProductDetailsResponse response = 
      await InAppPurchaseConnection.instance
        .queryProductDetails(products);

    if (response.notFoundIDs.isNotEmpty) {
      logAdd("availableItems: 3.a -> some ids were NOT found: ${response.notFoundIDs}");
    }

    this.items = response.productDetails;
    logAdd("availableItems: 4 -> number of items retrieved: ${this.items.length}, creating the Donation objects");
    
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

    logAdd("availableItems: 5 -> returning null without errors");
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
    logAdd("restore: 0 -> entered, waiting for queryPastPurchases()");

    final QueryPurchaseDetailsResponse pastResponse = await InAppPurchaseConnection.instance.queryPastPurchases();
    if (pastResponse.error != null) {
      logAdd("restore: 0.error -> queryPastPurchases() had an error: returning -> code: (${pastResponse.error.code}), details:(${pastResponse.error.details}), message:(${pastResponse.error.message})");
      return;
      // Handle the error.
    }

    logAdd("restore: 1 -> queryPastPurchases() found: ${pastResponse.pastPurchases.length} past purchases");

    int i = 0;
    for (PurchaseDetails purchase in pastResponse.pastPurchases) {
      ++i;
      logAdd("restore: 1.iteration_$i -> product: ${purchase.productID} // purchase: ${purchase.purchaseID} ==> status: ${purchase.status}");

      if (Platform.isIOS) {
        logAdd("restore: 1.iteration_$i.iOS -> platform is iOS, should call completePurchase(details) (only if it is not still pending)");
        // Mark that you've delivered the purchase. Only the App Store requires
        // this final confirmation.
        if(purchase.status != PurchaseStatus.pending) {
          logAdd("restore: 1.iteration_$i.iOS -> indeed not pending, calling completePurchase(details)");
          InAppPurchaseConnection.instance.completePurchase(purchase);
        }
      }
    }

    this.purchasedIds.set(<String>{
      for(final details in pastResponse.pastPurchases)
        if(details.status != PurchaseStatus.pending)
          details.productID,
    });
    logAdd("restore: 2 -> purchased ids are set (only not pending). number: ${purchasedIds.value.length}");

    if(purchasedIds.value.isNotEmpty) {
      logAdd("restore: 2.a -> unlocking since purchasedIds is not empty");
      this.unlocked.setDistinct(true);
    }
    else {
      logAdd("restore: 2.a -> locking since purchasedIds is empty indeed");
      this.unlocked.set(false);
    }

    logAdd("restore: 4 -> returning null without errors");
  }




  void purchase(String productID) async {
    logAdd("purchase: 0 -> entered with productID: $productID");
    if (this.purchasedIds.value.contains(productID)){
      logAdd("purchase: 0.contains -> we already have this one, so we should return with error. Was the app unlocked? ${unlocked.value}");
      if(!unlocked.value){
        logAdd("purchase: 0.contains.locked -> strange. unlocking before returning with error");
        unlocked.set(true);
      }
      return;
    }


    logAdd("purchase: 1 -> do we have a ProductDetail corresponding to this id?");
    ProductDetails productDetails;
    for(final item in this.items){
      if(item.id == productID) productDetails = item;
    }
    if(productDetails == null){
      logAdd("purchase: 1.null -> strangely, we don't");
      return;
    } else {
      logAdd("purchase: 1.notNull -> we obviously do, so we call buyNonConsumable(productDetails) (async! to be awaited)");
    }

    final result = await InAppPurchaseConnection.instance.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: productDetails)
    );

    logAdd("purchase: 2 -> buyNonConsumable(productDetails) awaited, its return should mean nothing but here it is: $result. also, returning this method without errors.");
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
  final String title;
  final String amount;
  final String productID;
  final double amountNum;

  Donation({
    @required this.productID, 
    @required this.amount, 
    @required this.title, 
    @required this.amountNum,
  });

}
