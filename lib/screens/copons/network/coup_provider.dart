import 'dart:collection';
import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model.dart';

class CouponProvider extends ChangeNotifier{

  List<CoupModel> listCuopon = [];
  List<CoupModel> oldListCuopon = [];

  List<CoupModel> get getLastVisit{
    return listCuopon;
  }

  set setLastVisit(List<CoupModel> mycartList){
    listCuopon = mycartList;
    notifyListeners();
  }

  set setoldListCuopon(List<CoupModel> mycartList){
    oldListCuopon = mycartList;
    notifyListeners();
  }


  double sumCoupPrice = 0;
  set setSumCoupPrice(double _sumCoupPrice){
    sumCoupPrice = _sumCoupPrice;
    notifyListeners();
  }

  setCopPriceEmpty(CouponProvider visitProvider){
    visitProvider.setSumCoupPrice = 0;
    notifyListeners();
    print('sum mohtady herer : ${sumCoupPrice}');
  }


  _copPrice(CouponProvider visitProvider , List<CoupModel> listCop){
    double _price = 0;
      for(var i = 0; i < listCop.length; i++){
        _price = _price + Cart().convertToDouble(listCop[i].price_coupon);
      }
    visitProvider.setSumCoupPrice = _price;

      notifyListeners();
    print('sum mohtady herer : ${sumCoupPrice}');

  }

  CoupModel _currentListLastVisit;
  UnmodifiableListView<CoupModel> get mycartList => UnmodifiableListView(listCuopon);
  CoupModel get currentLisitLastVisit => _currentListLastVisit;

  void getCoupons(bool old,int _count_coupon,CouponProvider visitProvider, userId,int dateToDay,int limitDay,VoidCallback voidCallback) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    String user_id = prefs.getString('user_docId');
print('-------------------------------------------------------------------------------------');
    print('user id here : ${user_id}');
    print('-------------------------------------------------------------------------------------');
    print('old id here : ${old}');
    print('-------------------------------------------------------------------------------------');
    print('count_coupon id here : ${_count_coupon}');
    print('dateToDay id here : ${dateToDay}');
    print('limitDay id here : ${limitDay}');
    print('-------------------------------------------------------------------------------------');
    print('-------------------------------------------------------------------------------------');
    print('count_coupon id here : ${dateToDay-limitDay}');
    print('-------------------------------------------------------------------------------------');
    print('-------------------------------------------------------------------------------------');

    QuerySnapshot snapshot = await Firestore.instance.collection('coupons')
        .orderBy('timestamp', descending: true)//sum_date_coupon
        .where('user_id_coupon',isEqualTo: user_id)
        .getDocuments().whenComplete((){
      voidCallback();
    });

    /*if(old){
       snapshot = await Firestore.instance.collection('coupons')
          .orderBy('timestamp', descending: true)//sum_date_coupon
          .where('user_id_coupon',isEqualTo: user_id)
          .getDocuments().whenComplete((){
        voidCallback();
      });
    }else{
       snapshot = await Firestore.instance.collection('coupons')
          .orderBy('timestamp', descending: true)//sum_date_coupon
          .where('user_id_coupon',isEqualTo: user_id)
          .where('sum_date_coupon',isGreaterThanOrEqualTo: dateToDay-limitDay)
          .where('count_coupon',isLessThan: _count_coupon)
          .getDocuments().whenComplete((){
        voidCallback();
      });
    }*/
    List<CoupModel> _myItemList = [];
    snapshot.documents.forEach((document){
      CoupModel myCart = CoupModel.fromMap(document.data);
      if(old){
        if(myCart.count_coupon > _count_coupon ||
            myCart.sum_date_coupon < dateToDay-limitDay || Cart().convertToDouble(myCart.price_coupon) == 0){
          _myItemList.add(myCart);
          visitProvider.setoldListCuopon = _myItemList;
        }
      }else{
        if(Cart().convertToDouble(myCart.price_coupon) != 0 && myCart.count_coupon < _count_coupon && myCart.sum_date_coupon > dateToDay-limitDay){
          _myItemList.add(myCart);
          visitProvider.setLastVisit = _myItemList;
        }
      }
     }
    );

    print('-------------------------------------------------------------------------------------');
    print('listCuopon id here : ${listCuopon.length}');

    _copPrice(visitProvider ,_myItemList );

    notifyListeners();
  }



  String billNo;
  set setBillNo(String _billNo){
    billNo = _billNo;
    notifyListeners();
  }
  getBillNo(CouponProvider couponProvider , String _billNo){
    couponProvider.setBillNo = _billNo;
    notifyListeners();
  }


}