
import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/screens/user/login/authservice.dart';
import 'package:best_flutter_ui_templates/utilities/snack_bar.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import '../../providor.dart';
import '../../translation_strings.dart';
import 'api.dart';

class LatestScrVisit extends StatefulWidget {

  String userLocation,timeVisit,dateVisit_ar,dateVisit_en , lat,lng;
  LatestScrVisit({this.userLocation,this.timeVisit,this.dateVisit_ar , this.dateVisit_en ,this.lat,this.lng});
  @override
  _LatestScrVisitState createState() => _LatestScrVisitState();
}

class _LatestScrVisitState extends State<LatestScrVisit> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _name , _phone ,_region;
  bool _checkPhone = false , _checkRegion = false;
  bool _chePhone = false , _chkRegion = false;
  bool _checkName = false , _cheName = false;


  final formKey = new GlobalKey<FormState>();

  bool progressButton = false;
  _getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if(prefs.getString('userPhone') == null){
        _checkPhone = false;
      }else{
        _checkPhone = true;
      }

      if(prefs.getString('region') == null){
        _checkRegion = false;
      }else{
        _checkRegion = true;
      }

      if(prefs.getString('name') == null){
        _checkName = false;
      }else{
        _checkName = true;
      }

      _phone = prefs.getString('userPhone');
      _name = prefs.getString('name');
      _region = prefs.getString('region');

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfile();
    _showButton();
  }
  bool _notific;

  _showButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _notifi = prefs.getBool('notifi');

    setState(() {
      _notific = _notifi;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
        child: Scaffold(
          key: _scaffoldKey,
          body: Form(
            key: formKey,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    customAppBar(!AppModel.lamgug? 'Teckit':'تفاصيل الطلب' ,context),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        color: Colors.yellow[50],
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: _cheName?Colors.red:Colors.transparent),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)), // set rounded corner radius
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex:1,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 5,right: 5),
                                                      child: Text(!AppModel.lamgug? 'User Name ':'اسم المستخدم ',
                                                        style: TextStyle(
                                                            fontFamily: 'Cairo',
                                                            fontSize: 13,
                                                            color: Colors.grey
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: 20,
                                                    color: Colors.grey[400],
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: _checkName?Padding(
                                                      padding: EdgeInsets.only(left: 10,right: 10),
                                                      child: Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex: 4,
                                                              child: Text('${_name}',
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontFamily: 'Cairo',
                                                                    fontSize:15,
                                                                    color: Theme.of(context).primaryColor
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: IconButton(
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  color: Colors.black54,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _cheName = false;
                                                                  });
                                                                  _showDialogInsertName(context,_name);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ): Padding(
                                                      padding: EdgeInsets.only(left: 10,right: 10),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text('يجب ادخال الاسم',
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontFamily: 'Cairo',
                                                                    fontSize:13,
                                                                    color: Colors.grey
                                                                )
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                Icons.add,
                                                                color: Colors.blue,
                                                                size: 20,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  _cheName = false;
                                                                }
                                                                );
                                                                _showDialogInsertName(context,_name);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: _chePhone?Colors.red:Colors.transparent),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0)), // set rounded corner radius
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex:1,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              child: Text(!AppModel.lamgug? 'phone Number ' :'رقم الهاتف ',
                                                style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color: Colors.grey[400],
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: _checkPhone?Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 4,
                                                      child: Directionality(
                                                        textDirection: TextDirection.ltr,
                                                        child: Text('${_phone}',
                                                          textAlign: AppModel.lamgug?TextAlign.end:TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize:15,
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.black54,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _chePhone = false;
                                                          });
                                                          AuthService().editPhone((){
                                                            _getProfile();
                                                          },context);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ): Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text('يجب ادخال رقم الهاتف',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            fontFamily: 'Cairo',
                                                            fontSize:13,
                                                            color: Colors.grey
                                                        )
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Colors.green,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _chePhone = false;
                                                        }
                                                        );
                                                        AuthService().editPhone((){
                                                          _getProfile();
                                                        },context);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: _chkRegion?Colors.red:Colors.transparent),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0)), // set rounded corner radius
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex:1,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              child: Text(!AppModel.lamgug? 'Region' :'المنطقة ',
                                                style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color: Colors.grey[400],
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: _checkRegion?Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text('${_region}',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            fontFamily: 'Cairo',
                                                            fontSize:15,
                                                            color: Theme.of(context).primaryColor
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.black54,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _chkRegion = false;
                                                          });
                                                          _showDialog(context);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ): Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text('يجب اختيار المنطقة',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            fontFamily: 'Cairo',
                                                            fontSize:13,
                                                            color: Colors.grey
                                                        )
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Colors.green,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _chkRegion = false;
                                                        }
                                                        );
                                                        _showDialog(context);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex:1,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              child: Text(!AppModel.lamgug? 'Visit Time ' :'وقت الزيارة ',
                                                style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color: Colors.grey[400],
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10 ,right: 10),
                                              child: Text('${widget.timeVisit}',
                                                style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize:15,
                                                    color: Theme.of(context).primaryColor
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex:1,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              child: Text(!AppModel.lamgug? 'Visit Date ' :'تاريخ الزيارة ',
                                                style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color: Colors.grey[400],
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10 ,right: 10),
                                              child: Text(AppModel.lamgug?'${widget.dateVisit_ar}':'${widget.dateVisit_en}',
                                                style: TextStyle(
                                                    fontSize:15,
                                                    color: Theme.of(context).primaryColor
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex:1,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              child: Text(!AppModel.lamgug? 'My Location ' :'موقعي ',
                                                style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color: Colors.grey[400],
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10 ,right: 10),
                                              child: Text('${widget.userLocation}',
                                                style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize:14,
                                                    color: Theme.of(context).primaryColor
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                progressButton?Opacity(
                  opacity: 0.8,
                  child:  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                  ),
                ):Container(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20, right: 15, left: 15, bottom: 30),
                    child: Container(
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: FlatButton(
                          onPressed: () {
                           if(!progressButton){
                             if (_phone != null) {
                               if (_region != null) {
                                 createVisitOrder(_region,_name,_phone,widget.timeVisit,
                                     widget.dateVisit_ar,widget.lat,widget.lng,context,(){
                                       setState(() {
                                         progressButton = false;
                                       });
                                     },(){
                                       snackShow(context, AppModel.lamgug?'فشلت العملية حاول مرة اخرى':'Error in connection',Colors.red[800] ,Icon(
                                         Icons.error_outline,
                                         color: Colors.white,
                                       ),_scaffoldKey
                                       );
                                     }
                                 );
                                 setState(() {
                                   progressButton = true;
                                 });
                               }else{
                                 setState(() {
                                   _chkRegion = true;
                                 });
                               }
                             }else{
                               setState(() {
                                 _chePhone = true;
                               });
                             }
                           }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:Text(Translations.of(context).button_agree, style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18
                          ),),
                          color: !progressButton?Theme
                              .of(context)
                              .primaryColorDark:Colors.grey[200],
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                progressButton?Center(
                  child: Opacity(
                    opacity: 1,
                    child:  Container(
                      child: Image(
                        image: AssetImage(
                          'assets/loading/loading_send_order.gif',
                        ),
                      ),
                    ),
                  ),
                ):Container(),
                progressButton?Center(
                  child: Text(
                    AppModel.lamgug?'إرسال الطلب ...':'Ordering ...',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Theme.of(context).primaryColor,
                        fontSize: 14),),
                ):Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String regio;
  void _onShopDropItemSelected(String newValueSelected) {
    setState(() {
      regio = newValueSelected;
      this.regionValid = true;
      _region = regio;
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
              color: Colors.yellow[50],
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: regionValid? Colors.grey[400]:Colors.redAccent,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.only(bottom: 0,top: 0,right: 10,left: 10),
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
                          child: Text(AppModel.lamgug?'اختر منطقة':'Enter Your Region',style: TextStyle(
                              color: regionValid? Colors.grey:Colors.redAccent,
                              fontSize: 16
                          ),),
                        ),
                        items: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          print('region length here : ${snapshot.data.documents.length}');
                          return DropdownMenuItem<String>(
                            value: document.data['name_ar'],
                            child: !document.data['active']?
                            Container(
                              child:
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(AppModel.lamgug?document.data['name_ar']:document.data['name_en'],
                                    style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15),),
                                ),
                              ),

                            ) : InkWell(
                              onTap: (){
                                ackAlert(context , Cart.complete_data_disable_country);
                              },
                              child: Expanded(
                                child: Container(
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

  void _showDialog(BuildContext context) {
    slideDialog.showSlideDialog(
      context: context,
      child: Center(child: Padding(
        padding: const EdgeInsets.only(right: 40,left: 40,top: 20),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child:
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('regions').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CupertinoActivityIndicator());
                }else{
                  return  SizedBox(
                    height: 400,
                    child: ListView(
                      children: snapshot.data.documents.map((
                          DocumentSnapshot document) {
                        return Container(
                            child: Directionality(
                              textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
                              child: Column(
                                children: <Widget>[
                                  !document.data['active']?GestureDetector(
                                    onTap: (){
                                      ackAlert(context , Cart.complete_data_disable_country);
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.sync_problem,color: Colors.grey[400],
                                      ),
                                      title: Text(AppModel.lamgug?document.data['name_ar']:document.data['name_en'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey[400]),),
                                    ),
                                  ):GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _region = document.data['name_ar'];
                                        _checkRegion = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                          Icons.location_on
                                      ),
                                      title: Text(AppModel.lamgug?document.data['name_ar']:document.data['name_en'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey[600]),),
                                    ),
                                  ),
                                  Divider()
                                ],
                              ),
                            ),
                        );
                      }
                      ).toList(),
                    ),
                  );
                }
              }
          ),
        ),
      )),
    );
  }


  void _showDialogInsertName(BuildContext context,String name) {
    slideDialog.showSlideDialog(
        context: context,
        child: EditNameUser(voidCallback: (){
          _getProfile();
        },
          name: name,
        )
    );
  }

}


//-----------------------------dialog name ------------------------


class EditNameUser extends StatefulWidget {

  VoidCallback voidCallback;
  String name;
  EditNameUser({this.voidCallback,this.name});
  @override
  _EditNameUserState createState() => _EditNameUserState();
}

class _EditNameUserState extends State<EditNameUser> {

  String _user_id;
  printId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    setState(() {
      _user_id = prefs.getString('user_docId');
    });
    print('user id here : ${_user_id}');
  }

  void updateNameUser(String _docid,
      _name, VoidCallback _voidCallback) async {

    final databaseReference = Firestore.instance;
    await databaseReference.collection("users")
        .document(_docid)
        .updateData({
      'name' : _name,
    }
    ).whenComplete((){
      _voidCallback();
    });
  }
  final _ormKey = new GlobalKey<FormState>();
  final _username = TextEditingController();
  bool progressButton = false;

  _saveEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    prefs.setString('name', _username.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _username.text = widget.name;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _ormKey,
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20,left: 20,top: 20),
              child: TextFormField(
                style :TextStyle(
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
                  hintText: 'ادخل الاسم',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              )
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 20, right: 20, left: 20, bottom: 5),
            child: Container(
              child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      printId();

                      if (_ormKey.currentState.validate()) {
                        updateNameUser(_user_id,_username.text,(){
                          setState(() {
                            progressButton = false;
                            _saveEdit();
                            widget.voidCallback();
                          }
                          );
                        });
                        setState(() {
                          progressButton = true;
                        }
                        );
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: !progressButton? Text(AppModel.lamgug?'موافق':'OK', style: TextStyle(
                        fontSize: 20
                    ),):CupertinoActivityIndicator(),
                    color: !progressButton?Colors.green:Colors.green[100],
                    textColor: Colors.white,
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
