import 'package:best_flutter_ui_templates/providor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modle/food_api.dart';
import 'package:flutter/cupertino.dart';
import '../modle/cart.dart';
import 'package:provider/provider.dart';
import '../translation_strings.dart';
import 'package:flutter/material.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import 'user/login/authservice.dart';

class LatestScreen extends StatefulWidget {

  String lat, lng ,locationName;
  LatestScreen({this.lat,this.lng,this.locationName});
  _LatestScreenState createState() => new _LatestScreenState();

}

double discretevalue = 2.0;
double hospitaldiscretevalue = 25.0;

class _LatestScreenState extends State<LatestScreen> {

  bool langChang;
  String _name , _phone , _region;
  final formKey = new GlobalKey<FormState>();

  bool _checkPhone = false , _checkRegion = false;
  bool _chePhone = false , _chkRegion = false;
  bool _checkName = false , _cheName = false;


  _getProfile()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
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
      _region = prefs.getString('region');
      _name = prefs.getString('name');
    }
    );
  }

  @override
  void initState() {
    _getProfile();
    setState(() {
      langChang = AppModel.lamgug;
    });
    super.initState();
  }

  bool regionValid = true , _isExpanded = true;
  bool damaanValid = true , prossesButton = true;

  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
        child: Consumer<Cart>(
          builder: (context , cart , child){
            return Scaffold(
              body: Form(
                key: formKey,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5, // has the effect of softening the shadow
                                  spreadRadius: 0.0, // has the effect of extending the shadow
                                  offset: Offset(
                                    0.0, // horizontal, move right 10
                                    10.0, // vertical, move down 10
                                  ),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0,bottom: 0,left: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: IconButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  Center(child: Text(Translations.of(context).checkOut_bage_title,style: TextStyle(
                                      fontSize: AppModel.lamgug?18:15,
                                      fontFamily: 'Cairo',
                                      color: Theme.of(context).primaryColor
                                  ),
                                  )),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10,left: 10),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.help,
                                            color: Theme.of(context).primaryColor,
                                          ), onPressed: () {  },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: ExpansionPanelList(
                                expansionCallback: (int i, bool isExpanded) {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  }
                                  );
                                },
                                animationDuration: Duration(milliseconds: 200),
                                children: [
                                  ExpansionPanel(
                                    headerBuilder: (BuildContext context, bool isExpanded) {
                                      return GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            _isExpanded = !_isExpanded;
                                          });
                                        },
                                        child: new Container(
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 20,left: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  flex:1,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text(AppModel.lamgug?'بيانات الطلب':'Order Info',
                                                              style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  fontSize: 15,
                                                                  color: Theme.of(context).primaryColor,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                            Spacer(flex: 1),
                                                            Icon(
                                                              _phone != null && _region != null?Icons.done:Icons.info,
                                                              color:_phone != null && _region != null?Colors.green:Colors.orange,
                                                              size: 20,
                                                            ),
                                                            Spacer(flex: 6),
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
                                      );
                                    },
                                    isExpanded: _isExpanded,
                                    body: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[400],
                                              offset: Offset(0.0, 0.0),
                                            ),
                                            BoxShadow(
                                              color: Colors.grey[200],
                                              offset: Offset(0.0, 0.0),
                                              spreadRadius: -2, //extend the shadow
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height*0.6,
                                          child: ListView(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Card(
                                                  color: Colors.yellow[50],
                                                  elevation: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(bottom: 10,top: 20),
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
                                                                                child: Text(testLang() == 'Next'? 'User Name ':'اسم المستخدم ',
                                                                                  style: TextStyle(
                                                                                      fontFamily: 'Cairo',
                                                                                      fontSize: testLang() == 'Next'? 13 : 13,
                                                                                      color: Colors.grey
                                                                                  ),
                                                                                ),
                                                                              ),
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
                                                              Divider(),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 10,right: 10),
                                                                child: Container(
                                                                  width: double.infinity,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(color: _chePhone?Colors.red:Colors.transparent),
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
                                                                                child: Text(!AppModel.lamgug? 'phone Number ' :'رقم الهاتف ',
                                                                                  style: TextStyle(
                                                                                      fontFamily: 'Cairo',
                                                                                      fontSize: testLang() == 'Next'? 13 : 13,
                                                                                      color: Colors.grey
                                                                                  ),
                                                                                ),
                                                                              ),
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
                                                                                        child: Text('${_phone}',
                                                                                          textAlign: TextAlign.start,
                                                                                          style: TextStyle(
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
                                                                                          color: Colors.blue,
                                                                                          size: 20,
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
                                                              ),
                                                              Divider(),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 10,right: 10),
                                                                child: Container(
                                                                  width: double.infinity,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(color: _chkRegion?Colors.red:Colors.transparent),
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
                                                                                child: Text(!AppModel.lamgug? 'Region ' :'المنطقة',
                                                                                  style: TextStyle(
                                                                                      fontFamily: 'Cairo',
                                                                                      fontSize: 14,
                                                                                      color: Colors.grey
                                                                                  ),
                                                                                ),
                                                                              ),
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
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(left: 0,right: 0),
                                                                                          child: Text('${_region}',
                                                                                            textAlign: TextAlign.start,
                                                                                            style: TextStyle(
                                                                                                fontFamily: 'Cairo',
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
                                                                                child: GestureDetector(
                                                                                  onTap: (){
                                                                                    setState(() {
                                                                                      _chkRegion = false;
                                                                                    }
                                                                                    );
                                                                                    _showDialog(context);
                                                                                  },
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
                                                                                            size: 20,
                                                                                            color: Colors.blue,
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
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Divider(),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 15,right: 15),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(testLang() == 'Next'? 'Total ':'المجموع الكلي ',
                                                                        style: TextStyle(
                                                                            fontFamily: 'Cairo',
                                                                            fontSize: testLang() == 'Next'? 13 : 13,
                                                                            color: Colors.grey
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                                                        child: Text(testLang() == 'Next'? '${cart.totalAppbar.toString()} ${cart.unit_en}' :'${cart.totalAppbar.toString()} ${cart.unit_ar}',
                                                                          style: TextStyle(
                                                                              fontSize: testLang() == 'Next'? 15 : 15,
                                                                              color: Theme.of(context).primaryColor
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 15,right: 15),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(testLang() == 'Next'? 'Quantitys ' :'عدد العناصر  ',
                                                                        style: TextStyle(
                                                                            fontFamily: 'Cairo',
                                                                            fontSize: testLang() == 'Next'? 13 : 13,
                                                                            color: Colors.grey
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                                                        child: Text(testLang() == 'Next'?'${cart.total_quantity.toString()}' :'${cart.total_quantity.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: testLang() == 'Next'? 15 : 15,
                                                                              color: Theme.of(context).primaryColor
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 15,right: 15),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(testLang() == 'Next'? 'Damaan ':'الضمان ',
                                                                        style: TextStyle(
                                                                            fontFamily: 'Cairo',
                                                                            fontSize: testLang() == 'Next'? 13 : 13,
                                                                            color: Colors.grey
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                                                        child: Text('${cart.damaan_name}',
                                                                          style: TextStyle(
                                                                              fontSize: testLang() == 'Next'? 15 : 15,
                                                                              color: Theme.of(context).primaryColor
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 15,right: 15),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(testLang() == 'Next'? 'Tasleek ' :'التسليك  ',
                                                                        style: TextStyle(
                                                                            fontFamily: 'Cairo',
                                                                            fontSize: testLang() == 'Next'? 13 : 13,
                                                                            color: Colors.grey
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                                                        child: Text(testLang() == 'Next'?'${cart.getTasleekAr()}' :'${cart.getTasleekAr()}',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Cairo',
                                                                              fontSize: testLang() == 'Next'? 15 : 15,
                                                                              color: Theme.of(context).primaryColor
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 15,right: 15),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                      flex:1,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 0,right: 0),
                                                                        child: Text(testLang() == 'Next'? 'Location ':'الموقع',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Cairo',
                                                                              fontSize: testLang() == 'Next'? 13 : 13,
                                                                              color: Colors.grey
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex:2,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                                                        child: Text('${widget.locationName}',
                                                                          style: TextStyle(
                                                                              fontSize: testLang() == 'Next'? 15 : 15,
                                                                              color: Theme.of(context).primaryColor
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 15,right: 15),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(testLang() == 'Next'? 'Category ':'الفئة  ',
                                                                        style: TextStyle(
                                                                            fontFamily: 'Cairo',
                                                                            fontSize: testLang() == 'Next'? 13 : 13,
                                                                            color: Colors.grey
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                                                        child: Text('${cart.myCategories}',
                                                                          style: TextStyle(
                                                                              fontSize: testLang() == 'Next'? 15 : 15,
                                                                              color: Theme.of(context).primaryColor
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
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
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(AppModel.lamgug?'تفاصيل العناصر':'Details',
                                    style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 15
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.list,
                                    color: Theme.of(context).primaryColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: cart.listMyCart.length,
                                itemBuilder: (BuildContext context, int indexx) {
                                  return Padding(
                                    padding: new EdgeInsets.only(top: 0,right: 5,left: 5),
                                    child: Directionality(
                                      textDirection: testLang() == 'Next'? TextDirection.ltr :TextDirection.rtl,
                                      child:  Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Card(
                                                color: Theme.of(context).primaryColorLight,
                                                child: Container(
                                                  child: Padding(
                                                    padding: new EdgeInsets.only(top: 10,right: 20,left: 20 ,bottom: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Text(
                                                            testLang() == 'Next'? cart.listMyCart[indexx].name_en : cart.listMyCart[indexx].name_ar,
                                                            style: TextStyle(
                                                              fontFamily: 'Cairo',
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Theme.of(context).primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text(cart.item_price(cart.listMyCart[indexx] ,
                                                                  indexx).toString(),
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Theme.of(context).primaryColor,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                testLang() == 'Next'? cart.unit_en :cart.unit_ar,
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  fontSize: 13,
                                                                  color: Theme.of(context).accentColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 20,left: 20),
                                                    child: Text(
                                                      Translations.of(context).total_item,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[600],
                                                        fontSize: 15,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 50,right: 50),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          cart.fullItemsTotalPrice(indexx).toString(),
                                                          style: TextStyle(
                                                              fontSize: 15
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          testLang() == 'Next'? cart.unit_en :cart.unit_ar,
                                                          style: TextStyle(
                                                            fontFamily: 'Cairo',
                                                            fontSize: 13,
                                                            color: Colors
                                                                .grey[400],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 20 ,left: 20
                                                    ),
                                                    child: Text(
                                                      Translations.of(context).quantity_item,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[600],
                                                        fontSize: 15,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: new Center(
                                                      child: new Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceEvenly,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 50,left: 50),
                                                            child: Text(
                                                              cart.listMyCart[indexx].quantity,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .grey[600]
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                    !prossesButton?Opacity(
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
                            top: 0, right: 15, left: 15, bottom: 20),
                        child: Container(
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  prossesButton = false;
                                });

                                if (_phone != null) {
                                  if (_region != null) {
                                    if (_name != null) {
                                      setState(() {
                                        prossesButton = false;
                                      });
                                      createDirectOrder(cart.unit_en,_region,cart.myCategories,_name,_phone,widget.lat,widget.lng,cart.totalAppbar,
                                          cart.total_quantity,cart.getTasleekAr() , cart.damaan_name,
                                          cart.payType,cart.listMyCart,context,(){
                                            setState(() {
                                              prossesButton = true;
                                            });
                                          }
                                      );

                                    }else{
                                      setState(() {
                                        _isExpanded = true;
                                        _cheName = true;
                                      });
                                    }
                                  }else{
                                    setState(() {
                                      _isExpanded = true;
                                      _chkRegion = true;
                                    });
                                  }
                                }else{
                                  setState(() {
                                    _isExpanded = true;
                                    _chePhone = true;
                                  });
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(Translations.of(context).button_agree, style: TextStyle(
                                  fontSize: 18
                              ),
                              ),
                              color: prossesButton?Theme
                                  .of(context)
                                  .primaryColorDark:Colors.grey[300],
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    !prossesButton?Center(
                      child: Image(
                        image: AssetImage(
                          'assets/loading/loading_send_order.gif',
                        ),
                      ),
                    ):Container(),
                    !prossesButton?Center(
                      child: Text(
                        AppModel.lamgug?'إرسال الطلب ...':'Ordering ...',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Theme.of(context).primaryColor,
                            fontSize: 14),
                      ),
                    ):Container()
                  ],
                ),
              ),
            );
          },
        )
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

  String testLang(){
    return Translations.of(context).button_next;
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
