import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/screens/copons/network/model.dart';
import 'package:best_flutter_ui_templates/screens/copons/network/coup_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void createBill(BuildContext context,String time ,date, _orderID,_userName,_totall ,_unit ,BuildContext _context,VoidCallback _voidCallback) async {

  final DocumentReference postRef = Firestore.instance.document('bills_count/count');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      await tx.update(postRef, <String, dynamic>{'count': postSnapshot.data['count']+1});

      final collRef = Firestore.instance.collection('bills');
      DocumentReference docReference = collRef.document();
      String docId = docReference.documentID;
      String _billId =     docId[0]+docId[1]+docId[2]+docId[3]+(postSnapshot.data['count']+1).toString();

      docReference.setData({
        'bill_id': _billId.toUpperCase(),
        'create_date': date,
        'create_time': time,
        'order_id': _orderID,
        'user_name': _userName,
        'totall': _totall,
        'unit': _unit,
       }
      ).whenComplete((){
        CouponProvider cartt = Provider.of<CouponProvider>(context , listen: false);
        CouponProvider().getBillNo(cartt,_billId.toUpperCase());
        _voidCallback();
          }
        );
      }
    }
  );
}


saveUpdateCop(String orderDocId,double total_order,List<CoupModel> listCop ,
    VoidCallback voidCallback) async{
  double _item = 0;
  for(var i = 0; i < listCop.length; i++){

    print('cop list item : ${listCop[i].price_coupon}');
    if(total_order >= Cart().convertToDouble(listCop[i].price_coupon)){

      _item = Cart().convertToDouble(listCop[i].price_coupon);
      total_order = total_order - _item;
      print('totalOrderNew cop list item : ${total_order}');

      listCop[i].price_coupon = '0';

        print('------------------------------------------------');
        print('run method add data : ${total_order}');
        updateCop('Coupon',total_order,orderDocId,listCop[i].doc_cuop,listCop[i].price_coupon,
            voidCallback);

      // listCop.add(value)

      print('_item list item : ${listCop[i].cop_code}');
      print('_item list item : ${listCop[i].price_coupon}');

      print('------------------------------------------------');

    }else{
      _item = Cart().convertToDouble(listCop[i].price_coupon);
      _item = _item - total_order;
      listCop[i].price_coupon = _item.toString();

      print('_item list item : ${listCop[i].cop_code}');
      print('_item list item : ${listCop[i].price_coupon}');
      total_order = 0;
      print('------------------------------------------------');
      print(' items oldTotal_order : ${total_order}');

      print('run method add data : ${total_order}');
      updateCop('Coupon',total_order,orderDocId,listCop[i].doc_cuop,listCop[i].price_coupon,
      voidCallback);

      print('------------------------------------------------');

    }
  }
}


saveUpdateCopListEmpty(String orderDocId,double total_order,
    List<CoupModel> listCop , VoidCallback voidCallback) async{
  for(var i = 0; i < listCop.length; i++){
    updateCop('cash',0,orderDocId,listCop[i].doc_cuop,'0',
        voidCallback);
  }
}

updateCop(String payType,double total_order,
    String orderDocId, _doc_cuop ,priceUp,VoidCallback voidCallback)async{
  final databaseReference = Firestore.instance;
  await databaseReference.collection("coupons")
      .document(_doc_cuop)
      .updateData({
    'price_coupon' : priceUp,
  }
  ).whenComplete((){
    if(total_order == 0){
      upDateOrder(orderDocId,(){
        voidCallback();
        }
      ,payType);
    }
  }
  );
}

upDateOrder(String orderDocId , VoidCallback voidCallback,String payType) async {
  final databaseReference = Firestore.instance;
  await databaseReference.collection("direct_orders")
      .document(orderDocId)
      .updateData({
    'payment_type' : payType,
   }
  ).whenComplete((){
    voidCallback();
  });
}