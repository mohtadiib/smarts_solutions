import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void updateProfile(String _docid,
    _name, _region, VoidCallback _voidCallback) async {

  final databaseReference = Firestore.instance;
  await databaseReference.collection("users")
      .document(_docid)
      .updateData({
    'name' : _name,
    'region': _region,
   }
  ).whenComplete((){
    _voidCallback();
  });
}

void updateEmail(String _docid,
    _email,name,photo, VoidCallback _voidCallback) async {

  print('begin up pro : ${name}');


  SharedPreferences prefs = await SharedPreferences.getInstance();

  final databaseReference = Firestore.instance;
  await databaseReference.collection("captins")
      .document(_docid)
      .updateData({
    'email' : _email,
    'first_name' : name,
    'image_url' : photo,
  }
  ).whenComplete((){
    prefs.setString('email',_email);
    prefs.setString('photoUrl',photo);
    prefs.setString('name',name);

    print('finish up pro : ${_email}');
    _voidCallback();
  });
}