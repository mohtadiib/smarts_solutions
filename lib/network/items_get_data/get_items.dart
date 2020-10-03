import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

getItems(Cart foodNotifier ,String collKey , VoidCallback voidS,VoidCallback voiError)async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    Cart().getFoods(foodNotifier,collKey,(){
      voidS();
    });
  } else if (connectivityResult == ConnectivityResult.wifi) {
    Cart().getFoods(foodNotifier,collKey,(){
      voidS();
    });
  }else{
    voiError();
  }
}