import 'package:best_flutter_ui_templates/modle/last_oredrs/model_order.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../translation_strings.dart';
import '../../modle/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'direct/network/direct_provider.dart';

class LastOrderItems extends StatefulWidget {
  _LastOrderItemsState createState() => new _LastOrderItemsState();

  final String _docId,_status,_time , _dat , _ID , _engneer , _engPhone , _total , _quantity ,_damman , _tasleek, _location ,_category;
   bool _type;
  LastOrderItems(this._docId,this._time ,this._dat ,this._ID , this._status , this._type , this._engneer , this._engPhone,
      this._total ,this._quantity ,this._damman , this._tasleek , this._location , this._category);
}

double discretevalue = 2.0;
double hospitaldiscretevalue = 25.0;

class _LastOrderItemsState extends State<LastOrderItems> {

  bool langChang , _isExpanded = false;

  @override
  void initState() {
    _showButton();

    DirectOrderProvider directOrderProvider = Provider.of<DirectOrderProvider>(context , listen: false);
    DirectOrderProvider().getDirectOredrItems(directOrderProvider,widget._docId);

    setState(() {
      langChang = AppModel.lamgug;
    });
    super.initState();
  }

  bool regionValid = true;
  bool damaanValid = true , prossesButton = true;

  String shopId;
  void _onShopDropItemSelected(String newValueSelected) {
    setState(() {
      this.shopId = newValueSelected;
      this.regionValid = true;
    });
  }

  String damaanSelec;
  void _onDamaanDropItemSelected(String newValueSelected) {
    setState(() {
      this.damaanSelec = newValueSelected;
      this.damaanValid = true;
    });
  }

  bool _notific;

  _showButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _notifi = prefs.getBool('notifi');

    setState(() {
      _notific = _notifi;
    });
  }
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
        child: Consumer<DirectOrderProvider>(
          builder: (context , cart , child){
            //print('my list : '+cart.listMyCart.length.toString());
            return Consumer<Cart>(
              builder: (context , item , child){
                //print('my list : '+cart.listMyCart.length.toString());
                return Scaffold(
                body:   Column(
                  children: <Widget>[
                    customAppBar(Translations.of(context).last_order_items_title ,context),
                    SizedBox(
                      height: 3,
                    ),
                    Directionality(
                      textDirection: testLang() == 'Next'? TextDirection.ltr :TextDirection.rtl,
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
                                return new Container(
                                  child: Padding(
                                    padding: AppModel.lamgug?EdgeInsets.only(right: 20):EdgeInsets.only(left: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex:4,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 3,
                                                child: Text(widget._ID,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Theme.of(context).primaryColor,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 20,
                                                      child: widget._status == 'تم التنفيذ'?SvgPicture.asset(
                                                        'assets/order/done.svg',
                                                        semanticsLabel: 'Acme Logo',
                                                        width: 20,
                                                        height: 20,
                                                      ):widget._status == 'لا يمكن التنفيذ'
                                                          || widget._status == 'رفض العميل'
                                                          || widget._status == 'Canceld'?
                                                      SvgPicture.asset(
                                                        'assets/order/cancel.svg',
                                                        semanticsLabel: 'Acme Logo',
                                                        width: 20,
                                                        color: Colors.red[300],
                                                        height: 20,
                                                      ):widget._status == 'تم بدون كود'?
                                                      SvgPicture.asset(
                                                        'assets/order/done_pro.svg',
                                                        semanticsLabel: 'Acme Logo',
                                                        width: 20,
                                                        height: 20,
                                                      )
                                                          :SvgPicture.asset(
                                                        'assets/order/done_pro.svg',
                                                        semanticsLabel: 'Acme Logo',
                                                        color: Colors.orange[300],
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            children: <Widget>[
                                              Text(widget._time,style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey
                                              ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5,right: 5),
                                                child: Container(
                                                  width: 80,
                                                  height: 1,
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                              Text(widget._dat,style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey
                                              ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              isExpanded: _isExpanded,
                              body: Padding(
                                padding: EdgeInsets.only(
                                    right: 1, left: 1, bottom: 1),
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
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height*0.7,
                                        child: ListView(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).order_date_time,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget._time+' | '+widget._dat,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 15,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[350],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).order_id,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget._ID,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 15.0,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[350],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).order_status2,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        widget._status == 'تم التنفيذ'?AppModel.lamgug?
                                                        'تم التنفيذ':'Done':
                                                        widget._status == 'تم بدون كود'?AppModel.lamgug?
                                                        'تم بدون كود':'Done without code':
                                                        widget._status == 'لا يمكن التنفيذ'?AppModel.lamgug?
                                                        'لا يمكن التنفيذ':'Cannot execute':
                                                        widget._status == 'رفض العميل'?AppModel.lamgug?
                                                        'رفض العميل':'The client refused':
                                                        widget._status == 'تم اللإرسال'?AppModel.lamgug?
                                                        'تم اللإرسال':'Sent':
                                                        widget._status == 'في التشغيل'?AppModel.lamgug?
                                                        'في التشغيل':'processing':widget._status,
                                                        style: TextStyle(
                                                          color:
                                                          widget._status == 'تم بدون كود' ||
                                                              widget._status == 'تم التنفيذ'?
                                                          Colors.green:
                                                          widget._status == 'لا يمكن التنفيذ'
                                                              || widget._status == 'رفض العميل'
                                                              || widget._status == 'Canceld'?
                                                          Colors.red:Colors.orange,
                                                          fontFamily: 'Cairo',
                                                          fontSize: 13,
                                                          height: 1.6,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 20,right: 15),
                                                        child: Container(
                                                          height: 15,
                                                          child: widget._status == 'تم التنفيذ'?SvgPicture.asset(
                                                            'assets/order/done.svg',
                                                            semanticsLabel: 'Acme Logo',
                                                            width: 20,
                                                            height: 20,
                                                          ):widget._status == 'لا يمكن التنفيذ'
                                                              || widget._status == 'رفض العميل'
                                                              || widget._status == 'Canceld'?
                                                          SvgPicture.asset(
                                                            'assets/order/cancel.svg',
                                                            semanticsLabel: 'Acme Logo',
                                                            width: 20,
                                                            color: Colors.red[300],
                                                            height: 20,
                                                          ):widget._status == 'تم بدون كود'?
                                                          SvgPicture.asset(
                                                            'assets/order/done_pro.svg',
                                                            semanticsLabel: 'Acme Logo',
                                                            width: 20,
                                                            height: 20,
                                                          )
                                                              :SvgPicture.asset(
                                                            'assets/order/done_pro.svg',
                                                            semanticsLabel: 'Acme Logo',
                                                            color: Colors.orange[300],
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[350],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).order_type,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget._type?Translations.of(context).order_type_direct:
                                                    Translations.of(context).order_type_visit,
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      color: Colors.grey[600],
                                                      fontSize: 13,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.black45,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).engineer_order,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget._engneer,
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      color: Colors.grey[600],
                                                      fontSize: 13,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[350],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).phone_order,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget._engPhone,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 15.0,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.black45,
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).total_item,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget._total,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 15,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[350],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).quantity_item,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 0),
                                                    child: Text(
                                                      widget._quantity,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 15.0,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[350],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).damaan,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget._damman,
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      color: Colors.grey[600],
                                                      fontSize: 13,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).tasleek_type,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget._tasleek,
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      color: Colors.grey[600],
                                                      fontSize: 13,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[350],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).location,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget._location,
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      color: Colors.grey[600],
                                                      fontSize: 13,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[350],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25),
                                                    child: Text(
                                                      Translations.of(context).catigories,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        color: Colors.grey[500],
                                                        fontSize: 13,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget._category,
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      color: Colors.grey[600],
                                                      fontSize: 13,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                            Text('تفاصيل العناصر',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 13
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: cart.listLastOrderItems.length,
                          itemBuilder: (BuildContext context, int indexx) {
                            print('item list here :${cart.listLastOrderItems.length}');
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
                                    color: Colors.yellow[50],
                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          color: Colors.yellow[100],
                                          elevation: 0,
                                          child: Container(
                                            child: Padding(
                                              padding: new EdgeInsets.only(top: 10,right: 20,left: 20 ,bottom: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      testLang() == 'Next'? '${cart.listLastOrderItems[indexx].name_en}' :
                                                      '${cart.listLastOrderItems[indexx].name_ar}',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text('${cart.listLastOrderItems[indexx].price}',
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
                                                          testLang() == 'Next'? '${item.unit_en}' :'${item.unit_ar}',
                                                          style: TextStyle(
                                                            fontSize: 15,
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
                                                '${Translations.of(context).total_item}',
                                                style: TextStyle(
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
                                                    '${cart.listLastOrderItems[indexx].total}',
                                                    style: TextStyle(
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    testLang() == 'Next'? '${item.unit_en}' :'${item.unit_ar}',
                                                    style: TextStyle(
                                                      fontSize: 15,
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
                                                '${Translations.of(context).quantity_item}',
                                                style: TextStyle(
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
                                                        '${cart.listLastOrderItems[indexx].quantity}',
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
              );},
            );
          },
        )
    );
  }

  String testLang(){
    return Translations.of(context).button_next;
  }


}