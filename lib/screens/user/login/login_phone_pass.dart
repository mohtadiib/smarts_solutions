import 'package:best_flutter_ui_templates/categories//categories.dart';
import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/modle/food_api.dart';
import 'package:best_flutter_ui_templates/modle/food_notifier.dart';
import 'package:best_flutter_ui_templates/screens/map_view.dart';
import 'package:best_flutter_ui_templates/utilities/password_field.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providor.dart';
import '../../../utilities/password_field.dart';
import '../../../translation_strings.dart';
import '../../../utilities/snack_bar.dart';
import 'authservice.dart';
import 'loginpage.dart';

class LoginPhonPass extends StatefulWidget {

  @override
  _LoginPhonPassState createState() => _LoginPhonPassState();
}

class _LoginPhonPassState extends State<LoginPhonPass> {

  bool itemActive = true;
  bool langChang , progressButton = false , regionValid = true,
      regionLoding = false;
  final formKey = new GlobalKey<FormState>();

  String _password;
  String _userPhone , _name,_region;
  int _testUser;

  final _passwordFieldKey = GlobalKey<FormFieldState<String>>();



  bool _notific = false;

  _showButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _notifi = prefs.getBool('notifi');

    setState(() {
      _notific = _notifi;
    });
  }
  @override
  void initState() {
    setState(() {
      langChang = AppModel.lamgug;
    }
    );
    super.initState();
    _showButton();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
        builder: (context , cart , child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              key: _scaffoldKey,
              body: Form(
                key: formKey,
                child: Center(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        customAppBar(Translations.of(context).login, context),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, right: 10, left: 10),
                            child: Container(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(PageRouteTransition(
                                        animationType: AppModel.lamgug? AnimationType2.slide_left: AnimationType2.slide_right,
                                        builder: (context) => AuthService().editPhone((){},context)
                                      )
                                    );
                                  },
                                  child: Text(AppModel.lamgug?'إنشاء حساب؟':'Create Acount?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.green,
                                        decoration: TextDecoration.underline
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ),
                        lineDraw(),
                        Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30,bottom: 20,left: 20,right: 20),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return Translations.of(context).phone_validate;
                                              }else if(value.trim().length < 10){
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
                                                this._userPhone = val;
                                              }
                                              );
                                            },
                                          ),
                                        ),
                                        flex: 4,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Text(
                                              cart.keyPhone,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.only(right: 0, left: 10, top: 5),
                                    child:
                                    PasswordField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return Translations.of(context).passValid;
                                        }else if(value.trim().length < 5){
                                          return Translations.of(context).tenPassValid;
                                        }
                                        return null;
                                      },
                                      fieldKey: _passwordFieldKey,
                                      labelText: Translations.of(context).passuser,
                                      onFieldSubmitted: (String value) {
                                        setState(() {
                                          this._password = value;
                                        }
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        lineDraw(),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20, right: 15, left: 15, bottom: 5),
                              child: Container(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: FlatButton(
                                    onPressed: () {
                                      if (formKey.currentState.validate()) {
                                        regionValid = true;
                                        _checkPhone(_userPhone , _password);
                                        setState(() {
                                          progressButton = true;
                                         }
                                        );
                                      }

                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: !progressButton?
                                    Row(
                                      children: <Widget>[
                                        Spacer(
                                          flex: 6,
                                        ),
                                        Text(Translations.of(context).button_agree, style: TextStyle(
                                            fontSize: 18
                                          ),
                                        ),
                                        Spacer(
                                          flex: 5,
                                        ),
                                        Icon(
                                          Icons.create_new_folder
                                        )
                                      ],
                                    ):CircularProgressIndicator(),
                                    color: !progressButton?Theme
                                        .of(context)
                                        .primaryColorDark:Theme.of(context).primaryColorLight,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }



  Widget lineDraw(){
    return Padding(
      padding: EdgeInsets.only(top: 3 ,left: 40 ,right: 40 ,bottom: 5),
      child: Divider(
        color: Colors.grey[400],
      ),
    );
  }

  _checkPhone(String _phone ,pass) async {
    print("phone here: $_phone");
    Firestore.instance.collection('users')
      .where('phone',isEqualTo: _phone).where('password',isEqualTo: pass)
          .getDocuments().then((query) {
      setState(() {
        progressButton = false;
        }
      );
      print("user data here: $_testUser");
      if(query.documents.isNotEmpty){


        AuthService().goToSelectPage(context);
      }else{
        snackShow(context , AppModel.lamgug?'خطأ في رقم الهاتف او كلمة المرور':'Low Internet Connection',Colors.red[800],Icon(
          Icons.error_outline,
          color: Colors.white,
        ),_scaffoldKey);
      }
        }
      );
     }
}
