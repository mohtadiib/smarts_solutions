import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/utilities/password_field.dart';
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
import 'authservice.dart';

class CompleteData extends StatefulWidget {

  @override
  _CompleteDataState createState() => _CompleteDataState();
}

class _CompleteDataState extends State<CompleteData> {
  String _password;

  bool itemActive = true;
  bool langChang , progressButton = false , regionValid = true,
  regionLoding = false;
  final formKey = new GlobalKey<FormState>();

  String firstname , lastname , countiry , _phone;

  final _passwordFieldKey = GlobalKey<FormFieldState<String>>();


  _setPhoneUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    setState(() {
      _phone = prefs.getString('userPhone');
    });
  }


  @override
  void initState() {
    setState(() {
      langChang = AppModel.lamgug;
      }
    );
    super.initState();
    _setPhoneUser();
  }

  String shopId;
  void _onShopDropItemSelected(String newValueSelected) {
    setState(() {
      this.shopId = newValueSelected;
      this.regionValid = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
        builder: (context , cart , child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              body: Form(
                key: formKey,
                child: Center(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Directionality(
                            textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
                            child: customAppBar(Translations.of(context).complete_user_title,context )),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                            child: Container(
                                child: Text(Translations.of(context).complete_sub_user_title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.grey[600]
                                  ),)
                            ),
                          ),
                        ),
                        lineDraw(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10,left: 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30,bottom: 20,left: 10,right: 10),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 10, left: 10, top: 5),
                                    child: TextFormField(
                                      onChanged: (val) {
                                        setState(() {
                                          this.firstname = val;
                                        }
                                        );
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return Translations.of(context).firstNameValid;
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        labelText: Translations.of(context).firstname,
                                      ),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10, left: 10, top: 5),
                                    child: TextFormField(
                                      onChanged: (val) {
                                        setState(() {
                                          this.lastname = val;
                                          }
                                        );
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return Translations.of(context).lastNameValid;
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.supervised_user_circle),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        labelText: Translations.of(context).lastname,
                                      ),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5, left: 5, top: 5),
                                    child: StreamBuilder<QuerySnapshot>(
                                        stream: Firestore.instance.collection('regions').snapshots(), builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return CupertinoActivityIndicator();
                                      }else{
                                        return Card(
                                          color: Theme.of(context).cardColor,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: regionValid? Colors.grey:Colors.redAccent,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: 60,
                                            padding: EdgeInsets.only(bottom: 0,top: 0,right: 10,left: 50),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.location_on,
                                                  color: regionValid? Colors.grey:Colors.redAccent,
                                                  size: 25,
                                                  semanticLabel: 'Text to announce in accessibility modes',
                                                ),
                                                Expanded(
                                                  child: DropdownButton(
                                                    icon: Padding(
                                                      padding: const EdgeInsets.only(right: 2),
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
                                                        size: 32,
                                                        color: regionValid?Theme.of(context).primaryColor:Colors.redAccent,
                                                      ),
                                                    ),
                                                    value: shopId,
                                                    isDense: true,
                                                    onChanged: (valueSelectedByUser) {
                                                      _onShopDropItemSelected(valueSelectedByUser);
                                                    },
                                                    hint: Text(Translations.of(context).Region,style: TextStyle(
                                                        color: regionValid? Colors.grey:Colors.redAccent,
                                                        fontSize: 18
                                                    ),
                                                    ),
                                                    items: snapshot.data.documents
                                                        .map((DocumentSnapshot document) {
                                                      return DropdownMenuItem<String>(
                                                        value: document.data['name_ar'],
                                                        child: document.data['active']?
                                                        Container(
                                                          child:
                                                          Center(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 8),
                                                              child: Text(langChang?document.data['name_ar']:document.data['name_en']),
                                                            ),
                                                          ),

                                                        ) : InkWell(
                                                          onTap: (){
                                                            ackAlert(context , Cart.complete_data_disable_country);
                                                          },
                                                          child: Container(
                                                            color: Colors.grey[200],
                                                            child: Column(
                                                              children: <Widget>[
                                                                Center(
                                                                  child: Text(langChang?document.data['name_ar']:document.data['name_en'] , style: TextStyle(
                                                                      color: Colors.grey[400]
                                                                  ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )/*Text(document.data['name_ar'] )*/,
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10, left: 10, top: 5),
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
                                        });
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
                                  top: 20, right: 20, left: 20, bottom: 5),
                              child: Container(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: FlatButton(
                                    onPressed: () {

                                   /*   if(shopId != null){
                                        if (formKey.currentState.validate()) {
                                          regionValid = true;
                                          completeUserData( null,_phone, null,firstname,lastname ,shopId ,_password, (){
                                             _goToBage(firstname,lastname,shopId,_password);
                                             print('success complete inser data');
                                             setState(() {
                                               regionValid = true;
                                             });
                                            }
                                          );
                                          setState(() {
                                            progressButton = true;
                                          }
                                          );
                                        }
                                      }else{
                                        setState(() {
                                          regionValid = false;
                                        });
                                      }*/

                                      },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: !progressButton? Text(Translations.of(context).button_agree, style: TextStyle(
                                        fontSize: 18
                                    ),):CupertinoActivityIndicator(),
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


  _goToBage(String first , last ,region ,pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    prefs.setBool('login_user', true);
    prefs.setString('name', AppModel.lamgug?first+' '+last:last+' '+first);
    prefs.setString('region', region);
    prefs.setString('pass', pass);
    Navigator.pop(context);
    AuthService().goToSelectPage(context);

  }

}
