import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



saveProUser(String image, user_id,_name ,region ,phone,email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('name', _name);
  prefs.setString('region', region);
  prefs.setString('userPhone', phone);
  prefs.setString('email', email);
  prefs.setString('user_docId', user_id);
  prefs.setString('photoUrl', image);
}

updateRecord(String doc_id ,image, email,
    _name,VoidCallback _voidCallback) async {
  print('update documents user child data');

  final databaseReference = Firestore.instance;
  await databaseReference.collection("users")
      .document(doc_id)
      .updateData({
    'email' : email,
    'name' : _name,
    'image_url' : image,

  }
  ).whenComplete((){
    print('old succsess user child data');

    _voidCallback();
  }
  );

}
Future<String> createWithEmail( String image_url ,email,
    _name ,VoidCallback voidCall) async{

    print('email createRecord here');

    Firestore.instance.collection('users').getDocuments().then((que) {
      if (que.documents.isNotEmpty) {
        Firestore.instance.collection('users')
            .where('email', isEqualTo: email)
            .getDocuments().then((query) {
          if (query.documents.isNotEmpty) {
            print('documents documents insert child data');
            saveProUser( //String image, user_id,_name ,region ,phone,email
                image_url,
                query.documents[0].data['user_id'],
                _name,
                query.documents[0].data['region'],
                query.documents[0].data['phone'],
                email
            );
          updateRecord(query.documents[0].data['user_id'] ,image_url, email,
                _name,(){
                  print('new suess user child data');
                  voidCall();
                });

          } else {
            print('to child here');

            createRecord(
                image_url,
                email,
                _name,
                (){
                  voidCall();
                });
          }
        }
        );
      }else{
        print('top create here');
        createRecord(
            image_url,
            email,
            _name,
                (){
                  voidCall();
            });
        }
    });

}


void createRecord(String image_url,email,
    _name,VoidCallback _voidCallback) async {

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
        'phone' : not,
        'email' : email,
        'name' : _name,
        'image_url' : image_url,
        'region': not,
        'status': true,
        }
      ).whenComplete((){
        _voidCallback();

        saveProUser( //String image, user_id,_name ,region ,phone,email
            image_url,
            docReference.documentID,
            _name,
            not,
            not,
            email
        );
      }
      );
    }
  }
  );
}

