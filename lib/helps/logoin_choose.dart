// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert' show json;

import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/network/insert_profile.dart';
import 'package:best_flutter_ui_templates/screens/user/login/authservice.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/utilities/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providor.dart';
import 'network/web_view.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Future<void> handleSignOut(VoidCallback voidCallback){
  _googleSignIn.disconnect().whenComplete((){
    voidCallback();
  });
}

class LoginChoose extends StatefulWidget {
  String title;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  LoginChoose({this.scaffoldKey,this.title});

  @override
  State createState() => SignWithGoogleState();
}

class SignWithGoogleState extends State<LoginChoose> {
  GoogleSignInAccount _currentUser;
  String _contactText;
  loginGo(){
    Cart cartt = Provider.of<Cart>(context , listen: false);
    Cart().setProgLog(cartt,true);
    if(cartt.progLogin){
      checkNoti((){
        print('_googleProg user: ${cartt.progLogin}');
        print('email user: ${_currentUser.email}');
        print('name user: ${_currentUser.displayName}');
        print('phone user: ${_currentUser.photoUrl}');
        createWithEmail(_currentUser.photoUrl, _currentUser.email,_currentUser.displayName,(){
          Cart cart = Provider.of<Cart>(context , listen: false);
          Cart().setProgLog(cart,false);
          print('top mmm complete inser data');
          Cart foodNotifier = Provider.of<Cart>(context , listen: false);
          Cart().setNewImageUser(foodNotifier,_currentUser.photoUrl,true);
          print('success createWithEmail complete inser data');
          AuthService().setLogin();
          snackShow(context,  AppModel.lamgug?'تمت العملية بنجاح':
          'Success Process', Colors.green,Icon(
            Icons.done,
            color: Colors.white,
          ),widget.scaffoldKey);
          Navigator.pop(context);
          }
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if(_currentUser != null) {
        _handleGetContact();
        }
      });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      loginGo();
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody(Cart cart) {
    return Padding(
      padding: EdgeInsets.only(right: 10,left: 10,top: 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.55,
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, right: 30, left: 30, bottom: 20),
                  child: Text('${widget.title}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.grey[600],
                        fontSize: 15
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, right: 30, left: 30, bottom: 10),
                  child: Container(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          AuthService().editPhone((){
                          },context);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3,bottom: 3),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                ),
                                Spacer(),
                                Text(
                                    AppModel.lamgug?'انشاء حساب':'Create an acount',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: Colors.white,
                                        fontSize: 15
                                    )
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                        color: Colors.green[600],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40,left: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 1,
                        color: Colors.grey[300],
                        width: 50,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppModel.lamgug?'أو':
                        'OR',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey[300],
                        width: 50,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, right: 30, left: 30, bottom: 5),
                  child: Container(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        onPressed: () {
                          _loginUserApp();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                                color: Colors.grey[400],
                                width: 1,
                                style: BorderStyle.solid
                            )
                        ),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icons-google.svg',
                              semanticsLabel: 'Acme Logo',
                              width: 25,
                              height: 25,
                            ),
                            Spacer(
                              flex: 4,
                            ),
                            !cart.progLogin?Text(AppModel.lamgug?
                            'تسجيل بحساب قوقل':'Login With Google', style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14
                            ),
                            ):Center(
                              child: Row(
                                children: <Widget>[
                                  Text(AppModel.lamgug?
                                  'تسجيل الدخول':'Login', style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 12,
                                      color: Colors.grey[400]
                                  ),
                                  ),
                                  SizedBox(width: 5,),
                                  CupertinoActivityIndicator(),
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 5,
                            ),
                          ],
                        ),
                        color: Colors.white,
                        textColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 30, right: 30, left: 30, bottom: 20),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          AppModel.lamgug?'عند تسجيل الدخول، انا اوافق على':
                          'Upon logging in, I agree to',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.grey[500],
                              fontSize: 12
                          )
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: (){//WebViewExample
                          Navigator.of(context).push(PageRouteTransition(
                              animationType: AppModel.lamgug?
                              AnimationType2.slide_left:AnimationType2.slide_right,
                              builder: (context)=> WebViewExample(
                                iniUrl: cart.privacy,
                              )
                          )
                          );
                        },
                        child: Text(
                            AppModel.lamgug?'الشروط والأحكام وسياسات الخصوصية':
                            'the terms, conditions and privacy policies',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Colors.blue,
                                fontSize: 12
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context , cart , child){
        return _buildBody(cart);},
    );
  }

  checkNoti(VoidCallback _voidCallback){
    Cart cart = Provider.of<Cart>(context , listen: false);
    Cart().getPayNoti(cart,(){
      _voidCallback();
    });
  }

  _loginUserApp(){
    print('user is : ${_currentUser.toString()}');
    _currentUser != null?
        logout((){
         _handleSignIn();
        }):_handleSignIn();
       }
}