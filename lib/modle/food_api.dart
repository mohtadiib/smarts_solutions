import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/modle/food_notifier.dart';
import 'package:best_flutter_ui_templates/screens/final_screen.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providor.dart';
import 'oder_items.dart';

//------------------------------------------create order------------------------------------------------------
showNotifSys(){
  final DocumentReference postRef = Firestore.instance.document('notific/kbt4ncvVPzrugf8Z4dRR');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      await tx.update(
          postRef, <String, dynamic>{'numNoti': postSnapshot.data['numNoti'] + 1});
    }
   }
  );
}

void createDirectOrder(String _unit,_region,_category_id ,_name ,_phone , _lat ,_lng ,_total , _quantity ,
    tasleek , damaan, _payType ,List<MyCart> _productlist ,BuildContext _context,VoidCallback _voidCallback) async{
  final DocumentReference postRef = Firestore.instance.document('order_count/direct');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      await tx.update(
          postRef, <String, dynamic>{'count': postSnapshot.data['count'] + 1});
      createOrder( _unit,_region,_category_id ,_name ,_phone , _lat ,_lng ,_total , _quantity ,
          tasleek ,  damaan, _payType,(postSnapshot.data['count']+1).toString(), _productlist,_context , (){
            _voidCallback();
            showNotifSys();
          });
      }
    }
  );
}

Future<String> createOrder( String _unit,_region,_category_id ,_name ,_phone , _lat ,_lng ,_total , _quantity ,
    tasleek , damaan,_payType,orderId ,List<MyCart> _productlist ,BuildContext _context,VoidCallback _voidCallback) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userID = prefs.getString('user_docId');

//  String userID = (await _firebaseAuth.currentUser()).uid;

  print('direct user id is here'+userID);

  insertOrder(_unit,_region,userID ,_name ,_phone , _category_id , _lat ,_lng ,_total , _quantity  ,tasleek , damaan,_payType,orderId ,_productlist, _context, _voidCallback);

  return userID;
}


void insertOrder(String _unit,_region,userID ,_name ,_phone , _category_id , _lat ,_lng ,_total , _quantity  ,
    tasleek , damaan ,_payType,orderId,List<MyCart> _productlist,BuildContext _context,VoidCallback _voidCallback) async {

  var dbTimeKey = DateTime.now();
  var formatDate = DateFormat.yMMMd('en_US');
  var formatTime = DateFormat.jm('en_US');

  String _date = formatDate.format(dbTimeKey);
  String _time = formatTime.format(dbTimeKey);

  final collRef = Firestore.instance.collection('direct_orders');
  DocumentReference docReference = collRef.document();

  String docId = docReference.documentID;
  String _order_id = 'D-'+docId[0]+docId[1]+docId[2]+docId[3]+orderId;
  String _orderCapCode = docId[4]+docId[5]+docId[6]+orderId;

  docReference.setData({
    'isExpanded' : false,
    'order_docId' : docId,
    'order_unit' : _unit,

    'timestamp' : FieldValue.serverTimestamp(),

    'order_id' : _order_id.toUpperCase(),
    'order_cap_code' : _orderCapCode.toUpperCase(),
    'build_category': _category_id,
    'order_time': _time,
    'order_date' : _date,
    'order_total': _total.toString(),
    'order_item_quantity': _quantity.toString(),
    'payment_type': 'no',

    'order_tasleek': tasleek,
    'payment_damaan': damaan,
    'region': _region,

    'lat': _lat,
    'lng': _lng,

    'order_user_name' : _name,
    'order_user_phone':_phone,

    'order_user_id': userID,
    'order_captin_name': 'لم يحدد',
    'order_captin_phone': 'لم يحدد',
    'order_type': true,
    'order_status': 'تم الإرسال',

  }).then((doc) {
    insertItemsOrders(docReference.documentID ,_productlist,(){
      _voidCallback();
      Navigator.pop(_context);
      Navigator.of(_context).push(PageRouteTransition(
          animationType: AppModel.lamgug?  AnimationType2.slide_left : AnimationType2.slide_right,
          builder: (context) => FinalDirectScreen(
              order_docID: docId,
              userId: userID,
              userName: _name,
              orderTime:_time,
              orderDate:_date,
              orderId:_order_id,
              orderStatus:'تم الإرسال',
              orderType: AppModel.lamgug?'مباشر':'Direct',
              total: _total.toString(),
              quantity:_quantity.toString(),
              paytybe:'not done',
              tasleek:tasleek,
              damaan: damaan)
      )
      );
    });
    print('orders id here ${docReference.documentID}');
  }).catchError((error) {
    print('error insert herer :'+error);
  }
  );
}

void insertItemsOrders(String _orderID ,List<MyCart> _productlist ,VoidCallback _voidCallback) async {
  final databaseReference = Firestore.instance;
  for(var i = 0; i < _productlist.length; i++){
    if(Cart().convertToInt(_productlist[i].quantity) != 0){
      await databaseReference.collection("direct_orders/"+_orderID+"/itemsOrder")
          .document()
          .setData({
        'orderID' : _orderID,
        'productName_ar': _productlist[i].name_ar,
        'productName_en': _productlist[i].name_en,
        'product_price': _productlist[i].price,
        'product_quantity': _productlist[i].quantity,
        'product_total': _productlist[i].total
      }
      ).whenComplete((){
        Cart().setOrderId(_orderID);
        _voidCallback();
      }
      );
    }
  }
}
