import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../oder_items.dart';
import 'model_last_order.dart';

class LOrModel extends ChangeNotifier{

  List<MyLastOrder> myLastOrder = [];

  List<MyLastOrder> get getlistMyCart{
    return myLastOrder;
  }

  set myCartList(List<MyLastOrder> mycartList){
    myLastOrder = mycartList;
    notifyListeners();
  }


  MyLastOrder _currentMycart;
  UnmodifiableListView<MyLastOrder> get mycartList => UnmodifiableListView(myLastOrder);
  MyLastOrder get currentMycart => _currentMycart;

  void getLastOrders(LOrModel laOrModel) async{
    QuerySnapshot snapshot = await Firestore.instance.collection('orders').getDocuments();
    List<MyLastOrder> _myItemList = [];
    snapshot.documents.forEach((document){
      MyLastOrder myCart = MyLastOrder.fromMap(document.data);
      _myItemList.add(myCart);
    }
    );
    laOrModel.myCartList = _myItemList;
    notifyListeners();
  }
//-----------------------------last order items--------------------------------------------------

  List<MyCart> listLastOrderItems = [];

  List<MyCart> get getLastOrderItems{
    return listLastOrderItems;
  }

  set setLastOrderItems(List<MyCart> mycartList){
    listLastOrderItems = mycartList;
    notifyListeners();
  }


  MyCart _currentListItems;
  UnmodifiableListView<MyCart> get listLastOItems => UnmodifiableListView(listLastOrderItems);
  MyCart get currentlistOrderItems => _currentListItems;

  void getOredrItems(LOrModel foodNotifier ,String collKey) async{
    QuerySnapshot snapshot = await Firestore.instance.collection('orders/'+collKey+'/f5TPoiWcPkrxF5aefmZS').getDocuments();
    List<MyCart> _myItemList = [];
    snapshot.documents.forEach((document){
      MyCart myCart = MyCart.fromMap(document.data);
      _myItemList.add(myCart);
    }
    );
    foodNotifier.setLastOrderItems = _myItemList;
    notifyListeners();
  }


}