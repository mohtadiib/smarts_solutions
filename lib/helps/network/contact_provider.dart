import 'dart:collection';
import 'model_contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactProvider extends ChangeNotifier{

  List<ModelContact> listLastVisitList = [];

  List<ModelContact> get getLastVisit{
    return listLastVisitList;
  }

  set setLastVisit(List<ModelContact> mycartList){
    listLastVisitList = mycartList;
    notifyListeners();
  }

  ModelContact _currentListLastVisit;
  UnmodifiableListView<ModelContact> get mycartList => UnmodifiableListView(listLastVisitList);
  ModelContact get currentLisitLastVisit => _currentListLastVisit;

  void getContactData(ContactProvider visitProvider,VoidCallback voidCallback) async{
    QuerySnapshot snapshot = await Firestore.instance.
    collection('units').getDocuments().whenComplete((){
      voidCallback();
      }
    );
    List<ModelContact> _myItemList = [];
    snapshot.documents.forEach((document){
      ModelContact myCart = ModelContact.fromMap(document.data);
      _myItemList.add(myCart);
     }
    );
    visitProvider.setLastVisit = _myItemList;
    notifyListeners();
  }

}