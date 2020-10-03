import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model_last_visit.dart';

class VisitProvider extends ChangeNotifier{

  List<LastVisit> listLastVisitList = [];

  List<LastVisit> get getLastVisit{
    return listLastVisitList;
  }

  set setLastVisit(List<LastVisit> mycartList){
    listLastVisitList = mycartList;
    notifyListeners();
  }

  int _index;

  set setIndex(int _ind){
    _index = _ind;
    notifyListeners();
  }

  set statusOrder(String _status){
    listLastVisitList[_index].order_status = _status;
    notifyListeners();
  }

  setStatusOrderIndex(VisitProvider visitProvider,String _status,int _index) async {
    visitProvider.setIndex = _index;
    visitProvider.setStatusOrder(visitProvider ,_status);
    notifyListeners();
  }

  setStatusOrder(VisitProvider directOrderProvider,String _status) async {
    directOrderProvider.statusOrder = _status;
    notifyListeners();
  }

  LastVisit _currentListLastVisit;
  UnmodifiableListView<LastVisit> get mycartList => UnmodifiableListView(listLastVisitList);
  LastVisit get currentLisitLastVisit => _currentListLastVisit;

  void getLastVisits(VisitProvider visitProvider,VoidCallback voidCallback) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _user_id = prefs.getString('user_docId');

    QuerySnapshot snapshot = await Firestore.instance.
    collection('visit_orders').orderBy('timestamp', descending: true).where('user_id',isEqualTo: _user_id)
        .getDocuments().whenComplete((){
      voidCallback();
    });
    List<LastVisit> _myItemList = [];
    snapshot.documents.forEach((document){
      LastVisit myCart = LastVisit.fromMap(document.data);
      _myItemList.add(myCart);
    }
    );
    visitProvider.setLastVisit = _myItemList;
    notifyListeners();
  }

}