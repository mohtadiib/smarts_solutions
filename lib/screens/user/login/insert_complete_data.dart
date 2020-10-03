/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

Future<String> completeUserData(
    String image, user_id,_name ,region ,phone,email ,VoidCallback _voidCallback) async{

  saveProUser( //String image, user_id,_name ,region ,phone,email
      query.documents[0].data['image_url'],
      query.documents[0].data['user_id'],
      query.documents[0].data['name'],
      query.documents[0].data['region'],
      query.documents[0].data['phone'],
      query.documents[0].data['email']
  );
}

updateRecord(String doc_id ,phone, email,
    _firstname, _lastname, _region,
    _password ,VoidCallback _voidCallback) async {

  final databaseReference = Firestore.instance;
  await databaseReference.collection("users")
      .document(doc_id)
      .updateData({
    'phone' : phone,
    'email' : email,
    'first_name' : _firstname,
    'last_name' : _lastname,
    'region': _region,
  }
  ).whenComplete((){
    _voidCallback();
  }
  );

}
*/
