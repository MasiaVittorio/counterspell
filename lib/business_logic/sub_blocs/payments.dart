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
  final PersistentVar<List<String>> purchasedIds; //past done purchases
  final BlocVar<List<Donation>> donations; //all available (wrapper for UI)


  //===========================================
  // Constructor
  CSPayments(this.parent): 
    unlocked = PersistentVar<bool>(
      key: "counterspell_bloc_var_payments_unlocked",
      initVal: false,
      toJson: (b) => b,
      fromJson: (j) => j as bool,
    ),
    purchasedIds = PersistentVar<List<String>>(
      initVal: <String>[],
      key: 'counterspell_bloc_var_payments_purchaseIds',
      fromJson: (json) => <String>[for(final s in json as List) s as String],
      toJson: (list) => list,
    ),
    donations = BlocVar<List<Donation>>(<Donation>[])
  {
    _subscription = InAppPurchaseConnection
        .instance
        .purchaseUpdatedStream
        //LOW PRIORITY: ANDREBBE ASCOLTATA ANCOR PRIMA DEL PRIMO WIDGET DELLA MAIN LOLLOLOL
        .listen((List<PurchaseDetails> purchases) {
          reactToNewPurchases(purchases);
        });

    check();
  }


  //===========================================
  // Methods
  void check() async {
    await availableItems();

    if(this.unlocked.reading){
      this.unlocked.readCallback = (result){
        if(result == false){
          this.restore();
        }
      };
    } else {
      if(this.unlocked.value == false){
        this.restore();
      }
    }
  }


  Future<void> availableItems() async {

    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      return;
    }

    final ProductDetailsResponse response = 
      await InAppPurchaseConnection.instance
        .queryProductDetails(products);

    if (response.notFoundIDs.isNotEmpty) {
        // Handle the error.
    }
    this.items = response.productDetails;
    
    // print('check items added: ${items.length}');
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
    ]);
  }
  String _titleCleaner(String s){
    String ret = '';
    for(final x in s.split('')){
      if(x != '(') ret += x;
      else break;
    }
    return ret;
  }

  void restore(){

  }

  void reactToNewPurchases(List<PurchaseDetails> purchases){

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
