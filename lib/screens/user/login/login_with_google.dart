import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);



class SignInDemo {
  Future<void> handleSignIn(VoidCallback voidCallback,VoidCallback errorCall) async {
    try {
      await googleSignIn.signIn().whenComplete(() => voidCallback());
    } catch (error) {
      errorCall();
      print(error);
    }
  }

}