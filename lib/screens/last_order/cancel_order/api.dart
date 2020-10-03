
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

updateOrderStatus(collection ,selectedDoc ,order_status ,_order_hint,VoidCallback _voidCallback ) async {
  final databaseReference = Firestore.instance;
  await databaseReference.collection(collection)
      .document(selectedDoc)
      .updateData({
    'order_hint': _order_hint,
    'order_status': order_status,
    'order_captin_name': 'Order Canceled',
    'order_captin_phone': 'Order Canceled',
  }
  ).whenComplete((){
    _voidCallback();
  });
}
