import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../screens/last_order/direct/items_drect_order/network_items_direct_orders/model_direct_items_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'direct_model.dart';

class DirectOrderProvider extends ChangeNotifier{

  List<DirectModel> myLastOrder = [];

  List<DirectModel> get getlistMyCart{
    return myLastOrder;
  }

  set myCartList(List<DirectModel> mycartList){
    myLastOrder = mycartList;
    notifyListeners();
  }

  int _index;

  set setIndex(int _ind){
    _index = _ind;
    notifyListeners();
  }

  set payOrder(String pay){
    myLastOrder[_index].payment_type = pay;
    notifyListeners();
  }
  set statusOrder(String _status){
    myLastOrder[_index].order_status = _status;
    notifyListeners();
  }

  setPayOrderIndex(DirectOrderProvider directOrderProvider,String _payTint,_status,int _index) async {
    directOrderProvider.setIndex = _index;
    print('_index order: ${_index}');

    directOrderProvider.setPayOrder(directOrderProvider , _payTint,_status);
    notifyListeners();
  }

  setPayOrder(DirectOrderProvider directOrderProvider,String _payWay,_status) async {
    print('pay order: ${_payWay}');

    _payWay != null?directOrderProvider.payOrder = _payWay:null;
    _status != null?directOrderProvider.statusOrder = _status:null;
    notifyListeners();
  }


  DirectModel _currentMycart;
  UnmodifiableListView<DirectModel> get mycartList => UnmodifiableListView(myLastOrder);
  DirectModel get currentMycart => _currentMycart;

  void getLastDirectOrders(DirectOrderProvider laOrModel,VoidCallback voidCallback) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _user_id = prefs.getString('user_docId');

    QuerySnapshot snapshot = await Firestore.instance.
    collection('direct_orders').orderBy('timestamp', descending: true).
    where('order_user_id',isEqualTo: _user_id)
    .getDocuments().whenComplete((){
      voidCallback();
    });
    List<DirectModel> _myItemList = [];
    snapshot.documents.forEach((document){
      DirectModel myCart = DirectModel.fromMap(document.data);
      _myItemList.add(myCart);
     }
    );
    laOrModel.myCartList = _myItemList;
    notifyListeners();
  }
//-----------------------------last order items--------------------------------------------------

  List<ItemsDirectOrderModel> listLastOrderItems = [];

  List<ItemsDirectOrderModel> get getLastOrderItems{
    return listLastOrderItems;
  }

  set setLastOrderItems(List<ItemsDirectOrderModel> mycartList){
    listLastOrderItems = mycartList;
    notifyListeners();
  }


  ItemsDirectOrderModel _currentListItems;
  UnmodifiableListView<ItemsDirectOrderModel> get listLastOItems => UnmodifiableListView(listLastOrderItems);
  ItemsDirectOrderModel get currentlistOrderItems => _currentListItems;

  void getDirectOredrItems(DirectOrderProvider foodNotifier ,String collKey) async{
    QuerySnapshot snapshot = await Firestore.instance.collection('direct_orders/$collKey/itemsOrder').getDocuments();
    List<ItemsDirectOrderModel> _myItemList = [];
    snapshot.documents.forEach((document){
      ItemsDirectOrderModel myCart = ItemsDirectOrderModel.fromMap(document.data);
      _myItemList.add(myCart);
    }
    );
    foodNotifier.setLastOrderItems = _myItemList;
    notifyListeners();
  }


}