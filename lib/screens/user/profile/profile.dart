import 'package:best_flutter_ui_templates/helps/logoin_choose.dart';
import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/screens/user/login/authservice.dart';
import 'package:best_flutter_ui_templates/screens/user/login/login_with_google.dart';
import 'package:best_flutter_ui_templates/utilities/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import '../../../translation_strings.dart';
import 'update.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool _update = false , progressButton = false;
  String _docId , _imageProfile ,  regionEd ;
  bool _testLogin = false;
  final formKey = new GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  GoogleSignInAccount _currentUser;

  _getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _imageProfile = prefs.getString('photoUrl');

    setState(() {
      if(prefs.getString('email') != null){
        _email.text = prefs.getString('email');
      }else{
        _email.text = AppModel.lamgug?'ادخل الايميل':'Enter Email';
      }

      if(prefs.getString('name') != null){
        _username.text = prefs.getString('name');
      }else{
        _username.text = AppModel.lamgug?'ادخل الاسم':'Enter Name';
      }
      if(prefs.getString('region') != null){
        regionEd = prefs.getString('region');
      }else{
        regionEd = AppModel.lamgug?'ادخل المنطقة':'Enter Region';
      }
      if(prefs.getString('userPhone') != null){
        _phone.text = prefs.getString('userPhone');
      }else{
        _phone.text = AppModel.lamgug?'ادخل رقم الهاتف':'Enter Phone';
      }
      _docId = prefs.getString('user_docId');

      if(prefs.getBool('login_user') != null){
        _testLogin = prefs.getBool('login_user');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfile();

    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    }
    );
    googleSignIn.signInSilently();

  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  printId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    String user_id = prefs.getString('user_docId');

    print('user id here : ${_docId}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Form(
        key: formKey,
        child: Stack(
          children: <Widget>[
            Container(
              height: 320,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]),
                shape: BoxShape.rectangle,
                borderRadius:  BorderRadius.only(
                  bottomLeft:  Radius.circular(300),
                  bottomRight: Radius.circular(300),
                ),
              ),
            ),
            Container(
              height: 230,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]),
                shape: BoxShape.rectangle,
                borderRadius:  BorderRadius.only(
                  bottomLeft:  Radius.circular(300),
                  bottomRight: Radius.circular(300),
                ),
              ),
            ),
            ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 230,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20,left: 20),
                          child: Container(
                            height: 350,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20,top: 10,left: 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.black54,
                                            size: 30,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: _update?TextFormField(
                                            style :TextStyle(
                                              fontFamily: 'Cairo',
                                              color: Colors.green,
                                              fontSize: 15,
                                            ),
                                            controller: _username,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return AppModel.lamgug?'الرجاء ادخال قيمة':'please inter value';}
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ):Text(_username.text,style: TextStyle(
                                            fontFamily: 'Cairo',
                                            color: Colors.black54,
                                            fontSize: 15,
                                          )
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.phone_android,
                                            color: Colors.black54,
                                            size: 30,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex:6,
                                                child: Directionality(
                                                  textDirection: TextDirection.ltr,
                                                  child: Text(_phone.text,style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                    ),
                                                    textAlign: AppModel.lamgug?TextAlign.end:TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.mode_edit,
                                                    color: _update?Colors.green[700]:Colors.black54,
                                                  ),
                                                  onPressed: () {
                                                    printId();
                                                    AuthService().signOut((){
                                                      AuthService().editPhone((){
                                                        _getProfile();
                                                      },context);
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.black54,
                                            size: 25,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: _update?regionEdit():
                                          Text(regionEd,style: TextStyle(
                                            fontFamily: 'Cairo',
                                            color: Colors.black54,
                                            fontSize: 15,
                                          )
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Icon(
                                            Icons.email,
                                            color: Colors.black54,
                                            size: 30,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex:7,
                                                child: Text(_email.text,style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                )
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.mode_edit,
                                                        color: _update?Colors.green[700]:Colors.black54,
                                                      ),
                                                      onPressed: () {
                                                        _showDialog(context,scaffoldKey);                                          },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20, right: 70, left: 70, bottom: 5),
                          child: Container(
                            child: SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: _update?FlatButton(
                                onPressed: () {
                                  printId();

                                  if (formKey.currentState.validate()) {
                                    updateProfile(_docId,_username.text,regio,(){
                                      setState(() {
                                        progressButton = false;
                                        _update = !_update;
                                      }
                                      );
                                      _saveEdit();
                                    });
                                    setState(() {
                                      progressButton = true;
                                    }
                                    );
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: !progressButton? Text(AppModel.lamgug?'تعديل':'Edit', style: TextStyle(
                                    fontSize: 20
                                ),):CupertinoActivityIndicator(),
                                color: !progressButton?Colors.green:Colors.green[100],
                                textColor: Colors.white,
                              ):Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]),
                shape: BoxShape.rectangle,
                borderRadius:  BorderRadius.only(
                  bottomLeft:  Radius.circular(250),
                  bottomRight: Radius.circular(250),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50,right: 10,left: 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10,),
                      Text(
                        AppModel.lamgug?'الملف الشخصي':'Profile',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: _update?Colors.grey[300]:Colors.transparent,
                          borderRadius:  BorderRadius.all(Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: IconButton(
                            icon: Icon(
                              Icons.mode_edit,
                              color: _testLogin? _update?Colors.green[700]:Colors.black54:
                              Colors.grey[300],
                            ),
                            onPressed: () {
                              setState(() {
                                if(_testLogin){
                                  _update = !_update;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(2.0, 4.0),
                          blurRadius: 8),
                    ],
                  ),
                  child: ClipRRect(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(70)),
                      child: _imageProfile == null?
                      Image.asset('assets/images/profile_image.png')
                          :FadeInImage.assetNetwork(
                        height: 230,
                        fit: BoxFit.fill,
                        placeholder: 'assets/images/profile_image.png',
                        image: _imageProfile,
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String regio;
  void _onShopDropItemSelected(String newValueSelected) {
    setState(() {
      regio = newValueSelected;
      this.regionValid = true;
    });
  }

  bool regionValid = true;

  Widget regionEdit(){
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('regions').snapshots(),
        builder: (context, snapshot) {
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
            height: 50,
            padding: EdgeInsets.only(bottom: 0,top: 0,right: 10,left: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 32,
                        color: regionValid?Theme.of(context).primaryColor:Colors.redAccent,
                      ),
                    ),
                    value: regio,
                    isDense: true,
                    onChanged: (valueSelectedByUser) {
                      _onShopDropItemSelected(valueSelectedByUser);
                    },
                    hint: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(Translations.of(context).Region,style: TextStyle(
                          color: regionValid? Colors.green:Colors.redAccent,
                          fontSize: 16
                      ),),
                    ),
                    items: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                          print('region length here : ${snapshot.data.documents.length}');
                      return DropdownMenuItem<String>(
                        value: document.data['name_ar'],
                        child: document.data['active']?
                        Container(
                          child:
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(AppModel.lamgug?document.data['name_ar']:document.data['name_en'],
                              style: TextStyle(color: Colors.green,fontSize: 15),),
                            ),
                          ),

                        ) : GestureDetector(
                          onTap: (){
                            ackAlert(context , Cart.complete_data_disable_country);
                          },
                          child: Container(
                            color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text(AppModel.lamgug?document.data['name_ar']:document.data['name_en'] , style: TextStyle(
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
    );
  }

  void _showDialog(BuildContext context,GlobalKey<ScaffoldState> _scaffoldKey) {
    slideDialog.showSlideDialog(
      context: context,
      child: Center(child: Padding(
        padding: const EdgeInsets.only(right: 20,left: 20,top: 20),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(AppModel.lamgug?'تعديل الايميل':
              'Edit Google Acount',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.grey[600],
                    fontSize: 13
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 10, right: 30, left: 30, bottom: 30),
                child: Container(
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: FlatButton(
                      onPressed: () {
                        handleSignOut((){
                          SignInDemo().handleSignIn((){
                            googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
                              if (account != null) {
                                print('account.displayName up pro : ${account.displayName}');
                                updateEmail(_docId,account.email,account.displayName,account.photoUrl,(){
                                  Navigator.pop(context);
                                  _getProfile();
                                  snackShow(context,  AppModel.lamgug?'تمت العملية بنجاح':
                                  'Success Process', Colors.green,Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),_scaffoldKey);
                                 }
                                );
                              }
                            }
                            );
                          },(){

                            snackShow(context , AppModel.lamgug?' الاتصال بالإنترنت ضعيف':
                            'Low Internet Connection',Colors.red[800],Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            ),_scaffoldKey);

                          });
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                              color: Colors.grey[400],
                              width: 1,
                              style: BorderStyle.solid
                          )                                                ),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/icons-google.svg',
                            semanticsLabel: 'Acme Logo',
                            width: 25,
                            height: 25,
                          ),
                          Spacer(),
                          Text(AppModel.lamgug?
                          'تعديل ايميل قوقل':'Edit Google Email', style: TextStyle(
                              fontSize: 14
                          ),
                          ),
                          Spacer(),
                        ],
                      ),
                      color: Colors.white,
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  _saveEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    prefs.setString('name', _username.text);
    prefs.setString('region', regio);
    _getProfile();
  }

}
