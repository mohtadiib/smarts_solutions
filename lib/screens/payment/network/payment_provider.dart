import 'dart:collection';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'payment_model.dart';

class PaymentProvider extends ChangeNotifier{

  //----------------------------get Categories--------------------------

  List<PaymentModel> listPaymentList = [];

  List<PaymentModel> get getPaymentList{
    return listPaymentList;
  }

  set setPaymentList(List<PaymentModel> mycartList){
    listPaymentList = mycartList;
    notifyListeners();
  }

  PaymentModel _currentListPaymentList;
  UnmodifiableListView<PaymentModel> get myPaymentList => UnmodifiableListView(listPaymentList);
  PaymentModel get currentLisitPaymentList => _currentListPaymentList;

  void getPaymetn(PaymentProvider catProvider ,VoidCallback voidCallback) async{
    catProvider.listPaymentList.clear();
    QuerySnapshot snapshot = await Firestore.instance.collection('payment_way').
    where('status',isEqualTo: true).
    getDocuments().whenComplete((){
      voidCallback();
    });
    List<PaymentModel> _myItemList = [];
    snapshot.documents.forEach((document){
      PaymentModel myCart = PaymentModel.fromMap(document.data);
      _myItemList.add(myCart);
    }
    );
    catProvider.setPaymentList = _myItemList;
    notifyListeners();
  }


  getPayment(PaymentProvider catProvider,
      VoidCallback voidCallback,VoidCallback voiError)async{

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {

      getPaymetn(catProvider , voidCallback);

    } else if (connectivityResult == ConnectivityResult.wifi) {
      getPaymetn(catProvider , voidCallback);
    }else{
      voiError();
    }
  }

}