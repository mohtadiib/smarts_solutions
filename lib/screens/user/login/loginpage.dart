import 'dart:async';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import "package:http/http.dart" as http;
import 'dart:convert' show json;

import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/translation_strings.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:best_flutter_ui_templates/widgests/texit_field/pin_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flippable_box/flippable_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authservice.dart';
import '../../../utilities/snack_bar.dart';
import 'insert_with_phone.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo = '', verificationId, smsCode;
  bool codeSent = false , _isFlipped = false , buttonTab = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _notific = false;
  _showButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _notifi = prefs.getBool('notifi');

    setState(() {
      _notific = _notifi;
    });
  }

  Timer _timer;
  int _second ;
  int _minut;
  bool finishTimer = false;

  void startTimer() {
    setState(() {
      finishTimer = false;
      _second = 0;
      _minut = 2;
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
              if(_minut == 0 && _second == 0){
                timer.cancel();
                setState(() {
                  finishTimer = true;
                });
              }else  if (_second == 0) {
                _minut = _minut - 1;
                _second = 60;
          } else {
            _second = _second - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showButton();
    startTimer();
  }
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Consumer<Cart>(
        builder: (context , cart , child) {
          return Scaffold(
            key: _scaffoldKey,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: customAppBar(AppModel.lamgug?'تسجيل رقم الهاتف':'Login Phone',context )),
                Expanded(
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Form(
                            key: formKey,
                            child: Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 15,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 10, right: 10, top: 0,bottom: 0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                  child: codeSent  ? Text(Translations
                                                      .of(context)
                                                      .user2_sub_title + '\n' +cart.keyPhone+this.phoneNo,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ) : Text(Translations
                                                      .of(context)
                                                      .user_sub_title,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                  )
                                              ),
                                              codeSent  ? FlatButton(
                                                color: Colors.transparent,
                                                onPressed: (){
                                                  setState(() {
                                                    codeSent = false;
                                                  });
                                                },
                                                child: Text(Translations
                                                    .of(context)
                                                    .edit_phone,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.green[500],
                                                  ),
                                                ),
                                              ): Text(''),
                                            ],
                                          ),
                                        ),
                                        FlippableBox(
                                          front: Container(
                                            width: double.infinity,
                                            height: 210,
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: Colors.white, width: 1),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                elevation: 5,
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        child:Directionality(
                                                          textDirection: TextDirection.rtl,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  Expanded(
                                                                    child: Container(
                                                                      width: double.infinity,
                                                                      child: TextFormField(
                                                                        textAlign: TextAlign.left,
                                                                        style: TextStyle(
                                                                          color: Theme.of(context).primaryColor,
                                                                          fontSize: 14
                                                                        ),
                                                                        validator: (value) {
                                                                          if (value.isEmpty) {
                                                                            return Translations.of(context).phone_validate;
                                                                          }else if(value.trim().length < 9){
                                                                            return Translations.of(context).valPhoneMinTen;
                                                                          }
                                                                          return null;
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          prefixIcon: Icon(Icons.phone_android),
                                                                          labelText: Translations
                                                                              .of(context)
                                                                              .phone_hint,
                                                                        ),
                                                                        keyboardType: TextInputType.phone,
                                                                        maxLength: 10,
                                                                        onChanged: (val) {
                                                                          setState(() {
                                                                            this.phoneNo = val;
                                                                           }
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    flex: 6,
                                                                  ),
                                                                  Expanded(
                                                                    child: Container(
                                                                      child: Directionality(
                                                                        textDirection: TextDirection.ltr,
                                                                        child: Text(
                                                                          '${cart.keyPhone}',
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                            color: Theme.of(context).primaryColor
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    flex: 2,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          back: Container(
                                            width: double.infinity,
                                            height: 210,
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding:  EdgeInsets.all(10),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: Colors.white, width: 1),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                elevation: 4,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: 30,left: 5,right: 10,bottom: 30),
                                                        child:  Container(
                                                          color: Colors.white,
                                                          margin: EdgeInsets.all(10),
                                                          padding: EdgeInsets.all(0),
                                                          child: PinPut(
                                                            fieldsCount: 6,
                                                            onSubmit: (String pin) {
                                                              AuthService().signInWithOTP(
                                                                  pin, verificationId,context,(){

                                                                showProgressDialog();

                                                                createWithPhone(context,phoneNo, (){
                                                                  AuthService().setLogin();
                                                                  print('success complete inser data');
                                                                  snackShow(context,  AppModel.lamgug?'تمت العملية بنجاح':'Success Process', Colors.green,Icon(
                                                                    Icons.done,
                                                                    color: Colors.white,
                                                                  ),_scaffoldKey);
                                                                  setState(() {
                                                                    buttonTab = false;
                                                                  }
                                                                  );
                                                                  Navigator.pop(context);
                                                                  dismissProgressDialog();
                                                                  }
                                                                );
                                                              });
                                                              pin = this.smsCode;
                                                            },
                                                            focusNode: _pinPutFocusNode,
                                                            controller: _pinPutController,
                                                            submittedFieldDecoration: _pinPutDecoration.copyWith(
                                                            borderRadius: BorderRadius.circular(20)),
                                                            selectedFieldDecoration: _pinPutDecoration,
                                                            followingFieldDecoration: _pinPutDecoration.copyWith(
                                                              borderRadius: BorderRadius.circular(5),
                                                              border: Border.all(
                                                                color: Theme.of(context).primaryColor.withOpacity(.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Center(child: !finishTimer?Text(AppModel.lamgug?
                                                        _second>9?"0$_minut:$_second يتم التحقق التلقائي خلال ":
                                                        "0$_minut:0$_secondيتم التحقق التلقائي خلال ":
                                                    _second>9?"Automatic verification is done through 0$_minut:$_second":
                                                    "Automatic verification is done through 0$_minut:0$_second",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.orange
                                                      ),
                                                    ):GestureDetector(
                                                      onTap: (){
                                                        startTimer();
                                                         verifyPhone(cart.keyPhone+phoneNo);
                                                      },
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(AppModel.lamgug?'اعادة ارسال':'ReSendٌ',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                              color: Colors.green,
                                                            ),
                                                          ),
                                                          Container(
                                                            color: Colors.green,
                                                            height: 1,
                                                            width: 50,
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          isFlipped: codeSent,
                                          bg: BoxDecoration(color: Colors.transparent),
                                          //Paints the box itself with a shared background
                                          duration: 0.5,
                                          //half second duration
                                          flipVt: true,
                                          //Flip vertically instead of horizontal
                                          curve: Curves.easeOut,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, right: 20, left: 20, bottom: 10),
                                          child: Container(
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 55,
                                              child: FlatButton(
                                                onPressed: () {

                                                  print('pin here :${_pinPutController.text}');
                                                  if (formKey.currentState.validate()) {
                                                    setState(() {
                                                      buttonTab = true;
                                                      }
                                                    );
                                                    codeSent?
                                                    AuthService().signInWithOTP(
                                                        _pinPutController.text, verificationId,context,(){
                                                      createWithPhone(context,phoneNo, (){
                                                          AuthService().setLogin();
                                                          print('success complete inser data');
                                                          snackShow(context,  AppModel.lamgug?'تمت العملية بنجاح':'Success Process', Colors.green,Icon(
                                                            Icons.done,
                                                            color: Colors.white,
                                                          ),_scaffoldKey);
                                                          setState(() {
                                                            buttonTab = false;
                                                          }
                                                          );
                                                          Navigator.pop(context);

                                                      }
                                                      );
                                                    }):
                                                    verifyPhone(
                                                        cart.keyPhone+phoneNo);
                                                        }
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: !codeSent ?!buttonTab ? Text(Translations
                                                    .of(context)
                                                    .button_agree, style: TextStyle(
                                                    fontSize: 18
                                                ),
                                                ) : CupertinoActivityIndicator():
                                                prodUploadData?Text(Translations
                                                    .of(context)
                                                    .user_button_verify, style: TextStyle(
                                                    fontSize: 18
                                                ),
                                                ):CupertinoActivityIndicator(),
                                                color: !codeSent?!buttonTab ?
                                                Theme.of(context).primaryColorDark
                                                    : Theme.of(context).primaryColorLight:
                                                prodUploadData?Colors.yellow[700]:Colors.yellow[200],
                                                textColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          );
          }
        ),
    );
  }

  bool prodUploadData = false;

  Future<void> verifyPhone(phoneNo) async {

    final PhoneVerificationCompleted verified = (AuthCredential authResult) {

      setState(() {
        prodUploadData = true;
      });
      createWithPhone(context,phoneNo, (){
        AuthService().signIn(authResult,(){
          setState(() {
            prodUploadData = false;
          });
          AuthService().setLogin();
          print('success complete inser data');
          snackShow(context,  AppModel.lamgug?'تمت العملية بنجاح':'Success Process', Colors.green,Icon(
            Icons.done,
            color: Colors.white,
          ),_scaffoldKey);
          setState(() {
            buttonTab = false;
           }
          );
        });
       }
      );
    };
    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      setState(() {
        buttonTab = false;
      });
          snackShow(context , AppModel.lamgug?'خطا في الاتصال':'Error in connection, try again later',Colors.red[800],Icon(
            Icons.error_outline,
            color: Colors.white,
          ),_scaffoldKey);
      print('${authException.message}');
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
        buttonTab = false;
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      setState(() {
        buttonTab = false;
      });
      startTimer();
      snackShow(context, AppModel.lamgug?'فشلت العملية حاول مرة اخرى':'Error in connection',Colors.red[800] ,Icon(
        Icons.error_outline,
         color: Colors.white,
        ),_scaffoldKey
      );
      this.verificationId = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
