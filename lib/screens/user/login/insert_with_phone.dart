import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


saveProUser(BuildContext context,String image, user_id,_name ,region ,phone,email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', _name);
      prefs.setString('region', region);
      prefs.setString('userPhone', phone);
      prefs.setString('email', email);
      prefs.setString('user_docId', user_id);
      prefs.setString('photoUrl', image);

  Cart foodNotifier = Provider.of<Cart>(context , listen: false);
  Cart().setNewImageUser(foodNotifier,image,true);

}

updateRecord(String doc_id ,_phone,VoidCallback _voidCallback) async {
  final databaseReference = Firestore.instance;
  await databaseReference.collection("users")
      .document(doc_id)
      .updateData({
    'phone' : _phone,
    }
   ).whenComplete((){
    _voidCallback();
  }
  );
}

Future<String> createWithPhone(BuildContext context, String _phone ,VoidCallback _voidCallback) async{
  print('email createRecord here');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // First time
  String user_id = prefs.getString('user_docId');

  print('user id here : ${user_id}');
  if(user_id != null){
    Firestore.instance.collection('users')
        .where('user_id', isEqualTo: user_id)
        .getDocuments().then((query) {
      if (query.documents.isNotEmpty) {
        saveProUser( context,//String image, user_id,_name ,region ,phone,email
            query.documents[0].data['image_url'],
            query.documents[0].data['user_id'],
            query.documents[0].data['name'],
            query.documents[0].data['region'],
            _phone,
            query.documents[0].data['email']
         );
        updateRecord(user_id ,_phone,(){
          _voidCallback();
        });

       }
     }
    );
  }else{
    Firestore.instance.collection('users').getDocuments().then((que) {
      if (que.documents.isNotEmpty) {
        Firestore.instance.collection('users')
            .where('phone', isEqualTo: _phone)
            .getDocuments().then((query) {
          if (query.documents.isNotEmpty) {
            saveProUser(context, //String image, user_id,_name ,region ,phone,email
                query.documents[0].data['image_url'],
                query.documents[0].data['user_id'],
                query.documents[0].data['name'],
                query.documents[0].data['region'],
                query.documents[0].data['phone'],
                query.documents[0].data['email']
            );
            updateRecord(query.documents[0].data['user_id'] ,_phone,(){
              _voidCallback();
            });

          } else {
            print('to child here');
            creRecord(context,
                _phone,
                _voidCallback);
          }
        }
        );
      }else{
        print('top create here');
        creRecord(context,
            _phone,
            _voidCallback);
      }
     }
    );
  }

}


void creRecord(BuildContext context,String _phone,VoidCallback _voidCallback) async {
  final DocumentReference postRef = Firestore.instance.document('user_count/count');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      await tx.update(
          postRef, <String, dynamic>{'count': postSnapshot.data['count'] + 1});

      final collRef = Firestore.instance.collection('users');
      DocumentReference docReference = collRef.document();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      // First time
      prefs.setString('user_docId', docReference.documentID);
      String not;
      docReference.setData({
        'selected' : true,
        'id' : postSnapshot.data['count'] + 1,
        'user_id' : docReference.documentID,
        'phone' : _phone,
        'email' : not,
        'name' : not,
        'image_url' : not,
        'region': not,
        'status': true,
       }
      ).whenComplete((){
        _voidCallback();//String image, user_id,_name ,region ,phone,email
        saveProUser(context,null,docReference.documentID,null,null,
            _phone,null);
      }
      );
    }
  }
  );
}

