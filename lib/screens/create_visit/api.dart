import 'dart:math';

import 'package:best_flutter_ui_templates/modle/food_api.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'finally_visit.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

Future<String> createVisitOrder(String _region,_name,_phone,_vivsitTime ,_dateVisit ,lat ,lng ,BuildContext _context,VoidCallback _voidCallback,VoidCallback crach) async{
//  String userID = (await _firebaseAuth.currentUser()).uid;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userID = prefs.getString('user_docId');

  print('user id is here'+userID);

  createVisit(_region,_name,_phone,userID ,_vivsitTime ,_dateVisit ,lat ,lng  , _context, _voidCallback , crach);

  return userID;
}

//-----------------complete user data----------------------------------

void createVisit(String _region,_name,_phone,_userID ,_vivsitTime,_dateVisit ,_lat ,_lng ,BuildContext _context,VoidCallback _voidCallback,VoidCallback crach) async {

  final DocumentReference postRef = Firestore.instance.document('order_count/visit');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      await tx.update(postRef, <String, dynamic>{'count': postSnapshot.data['count']+1});

      final collRef = Firestore.instance.collection('visit_orders');
      DocumentReference docReference = collRef.document();
      String docId = docReference.documentID;
      String _order_id = 'V-'+docId[0]+docId[1]+docId[2]+docId[3]+(postSnapshot.data['count']+1).toString();
      String _orderCapCode = docId[4]+docId[5]+docId[6]+(postSnapshot.data['count']+1).toString();

      var dbTimeKey = DateTime.now();
      var formatDate = DateFormat.yMMMd('en_US');
      var formatTime = DateFormat.jm('en_US');

      String date = formatDate.format(dbTimeKey);
      String time = formatTime.format(dbTimeKey);

      docReference.setData({
        'order_docId': docId,

        'create_date': date,
        'create_time': time,
        'timestamp' : FieldValue.serverTimestamp(),

        'region': _region,

        'lat': _lat,
        'lng': _lng,

        'visit_time': _vivsitTime,
        'visit_date': _dateVisit,

        'order_id': _order_id.toUpperCase(),
        'order_cap_code': _orderCapCode.toUpperCase(),

        'order_status': 'تم الإرسال',

        'order_type': true,
        'user_id' : _userID,
        'order_user_name' : _name,
        'order_user_phone':_phone,

        'order_captin_name' : 'لم يُحدد',
        'order_captin_phone' : 'لم يُحدد',

      }
      ).whenComplete((){
        showNotifSys();
        print('orderId: $docId');

        Navigator.pop(_context);
        Navigator.of(_context).push(PageRouteTransition(
            animationType: AppModel.lamgug?  AnimationType2.slide_left : AnimationType2.slide_right,
            builder: (context) => FinalVisitScreen(
                name:_name,
                visitTime:_vivsitTime,
                visitDate:_dateVisit,
                orderId:_order_id,
                orderStatus:'تم اللإرسال',
                orderType:'زيارة',
                oderCreateTime: time,
                oderCreateDate: date)
        )
        );

        _voidCallback();
      }
      ).catchError((){
        crach();
      });
    }
  }
  );
}
