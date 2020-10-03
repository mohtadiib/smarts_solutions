import 'dart:async';

import 'package:best_flutter_ui_templates/screens/last_order/cancel_order/cancel_order.dart';
import 'package:best_flutter_ui_templates/screens/last_order/last_order_items.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/screens/payment/get_payment_way.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:provider/provider.dart';
import '../../translation_strings.dart';
import 'package:flutter/material.dart';
import 'direct/network/direct_model.dart';
import 'direct/network/direct_provider.dart';
import 'map_orders.dart';
import 'visit/network/model_last_visit.dart';
import 'visit/network/visit_provider.dart';
import 'api.dart';

class LastOrders extends StatefulWidget {
  ItemsOrderState createState() => new ItemsOrderState();
}

double discretevalue = 2.0;
double hospitaldiscretevalue = 25.0;

class ItemsOrderState extends State<LastOrders> {

  getData(){
    getLastOrders(context,(){
      setState(() {
        progData = false;
      });
    },(){
      setState(() {
        getErrorConnection = true;
      }
      );
    });
  }
  bool langChang;
  bool showTooTip = true;
  int _xxx = 0;
  startTimeout() {
    showTooTip = true;
    print('timer here start');
    return new Timer(Duration(seconds: 5), handleTimeout);
  }

   handleTimeout() {  // callback function
    setState(() {
      print('timer here end');
      showTooTip = false;
    });
  }
  @override
  void initState() {
//    startTimeout();
    setState(() {
      langChang = AppModel.lamgug;
      }
    );
    getData();
    super.initState();
  }

  bool progData = true ,getErrorConnection = false;
  bool regionValid = true;
  bool damaanValid = true;



  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    setState(() {
      getErrorConnection = false;
      progData = true;
    });
    getData();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:   Column(
        children: <Widget>[
          customAppBar(Translations.of(context).last_order_title ,context),
          Expanded(
            flex: 10,
            child:DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).primaryColorLight,
                    constraints: BoxConstraints.expand(height: 40),
                    child: TabBar(
                        labelColor: Colors.blue,
                        indicatorColor: Theme.of(context).primaryColorDark,
                        indicatorWeight: 2,
                        tabs:
                        [
                          Tab(text: AppModel.lamgug?'مباشرة':"Direct"),
                          Tab(text: AppModel.lamgug?'الزيارات':"Visits"),
                        ]),
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(children: [
                        Consumer<DirectOrderProvider>(
                          builder: (context , directOrder , child){
                            print('direct orders length : '+directOrder.myLastOrder.length.toString());
                            return SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: true,
                              footer: CustomFooter(
                                builder: (BuildContext context,LoadStatus mode){
                                  Widget body ;
                                  return Container(
                                    height: 55.0,
                                    child: Center(child:body),
                                  );
                                },
                              ),
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              child:  _listLastOrder(directOrder.myLastOrder),
                            );
                          },
                        ),
                        Consumer<VisitProvider>(
                          builder: (context , visits , child){
                            return SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: true,
                              footer: CustomFooter(
                                builder: (BuildContext context,LoadStatus mode){
                                  Widget body ;
                                  return Container(
                                    height: 55.0,
                                    child: Center(child:body),
                                  );
                                },
                              ),
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              child:  _listLastVisitOrders(visits.listLastVisitList),
                            );
                          },
                        ),
                      ]
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listLastOrder(List <DirectModel> _list){
    return getErrorConnection?
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          'assets/config/computer.svg',
          semanticsLabel: 'Acme Logo',
          width: 60,
          height: 60,
        ),
        SizedBox(height: 5,),
        Text(
          AppModel.lamgug?'يجب الاتصال بالانترنت':'No Internet Connection',style: TextStyle(
            fontFamily: 'Cairo',
            color: Colors.grey,fontSize: 13
        ),
        )
      ],
    ):progData?Center(child
        : SizedBox(
          width: 70,
              child: Container(
                child: Image.asset(
                    'assets/notifi/home_loading.gif'
                ),
              ),
            ),
        )
        :_list.length == 0 ?
    Padding(
      padding: const EdgeInsets.only(bottom: 90),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.not_interested,color: Colors.grey[400],size: 40,
          ),
          Text(
            AppModel.lamgug?'لا توجد طلبات':'No Items',style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.grey,fontSize: 13
          ),
          ),
        ],
      ),
    ):
    ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int indexx) {
          if (_list.length == 0) {
            return Text(AppModel.lamgug?'لا يوجد طلبات ':'No Items',style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,color: Colors.grey
          ),);
          } else {
//            _xxx++;
//            print('xxx : $_xxx');
//            _xxx <= 1?startTimeout():null;
            return Padding(
             padding: new EdgeInsets.only(top: 3,right: 5,left: 5),
              child: _list[indexx].isExpanded != null? ExpansionPanelList(
                expansionCallback: (int i, bool isExpanded) {
                  setState(() {
                    _list[indexx].isExpanded = !_list[indexx].isExpanded;
                  }
                  );
                },
                animationDuration: Duration(milliseconds: 200),
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return new Container(
                        child: Padding(
                          padding: AppModel.lamgug?EdgeInsets.only(right: 0):EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex:5,
                                child: Row(
                                  children: <Widget>[
                                    ClipOval(
                                        child: Material(
                                          color: Colors.transparent, // button color
                                          child: InkWell(
                                            child: SizedBox(width: 40, height: 40, child: Icon(
                                              _list[indexx].order_status != 'تم الإرسال'?
                                              Icons.save:Icons.clear,
                                              color:
                                              _list[indexx].order_status == 'تم الإرسال'?
                                              Theme.of(context).primaryColor:
                                              Theme.of(context).primaryColor.withOpacity(0.1),
                                            ),
                                            ),
                                            onTap: () {
                                              _list[indexx].order_status == 'تم الإرسال'?
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    CancelOrder(
                                                      collection :'direct_orders',
                                                      documentId:_list[indexx].order_docId ,
                                                      direct: true,
                                                      index: indexx,
                                                    ),
                                              ):null;
                                            },
                                          ),
                                        )
                                    ),
                                    Expanded(
                                      flex : 3,
                                      child: Text(_list[indexx].order_id,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex : 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: 20,
                                            child: _list[indexx].order_status == 'تم التنفيذ'?SvgPicture.asset(
                                              'assets/order/done.svg',
                                              semanticsLabel: 'Acme Logo',
                                              width: 20,
                                              height: 20,
                                            ):_list[indexx].order_status == 'لا يمكن التنفيذ'
                                                  || _list[indexx].order_status == 'رفض العميل'
                                                  || _list[indexx].order_status == 'Canceled'?
                                            SvgPicture.asset(
                                              'assets/order/cancel.svg',
                                              semanticsLabel: 'Acme Logo',
                                              width: 20,
                                              color: Colors.red[300],
                                              height: 20,
                                            ):_list[indexx].order_status == 'تم بدون كود'?
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
                                    Text('${_list[indexx].order_time}',style: TextStyle(
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
                                    Text('${_list[indexx].order_date}',style: TextStyle(
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
                    isExpanded: _list[indexx].isExpanded,
                    body: Padding(
                      padding: EdgeInsets.only(
                          right: 1, left: 1, bottom: 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500],
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
                              height: 400,
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
                                          '${_list[indexx].order_date}',
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
                                          '${_list[indexx].order_id}',
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
                                              _list[indexx].order_status == 'تم التنفيذ'?AppModel.lamgug?
                                              'تم التنفيذ':'Done':
                                              _list[indexx].order_status == 'تم بدون كود'?AppModel.lamgug?
                                              'تم بدون كود':'Done without code':
                                              _list[indexx].order_status == 'لا يمكن التنفيذ'?AppModel.lamgug?
                                              'لا يمكن التنفيذ':'Cannot execute':
                                              _list[indexx].order_status == 'رفض العميل'?AppModel.lamgug?
                                              'رفض العميل':'The client refused':
                                              _list[indexx].order_status == 'تم اللإرسال'?AppModel.lamgug?
                                              'تم اللإرسال':'Sent':
                                              _list[indexx].order_status == 'في التشغيل'?AppModel.lamgug?
                                              'في التشغيل':'processing':_list[indexx].order_status,
                                              style: TextStyle(
                                                color: _list[indexx].order_status == 'تم التنفيذ' ||
                                                    _list[indexx].order_status == 'تم بدون كود'
                                                    ?
                                                Colors.green:
                                                _list[indexx].order_status == 'لا يمكن التنفيذ'
                                                    || _list[indexx].order_status == 'رفض العميل'
                                                    || _list[indexx].order_status == 'Canceled'?
                                                Colors.red:Colors.orange,
                                                fontSize: 13,
                                                fontFamily: 'Cairo',
                                                height: 1.6,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 0,right: 0),
                                              child: Container(
                                                height: 15,
                                                child: _list[indexx].order_status == 'تم التنفيذ'?SvgPicture.asset(
                                                  'assets/order/done.svg',
                                                  semanticsLabel: 'Acme Logo',
                                                  width: 20,
                                                  height: 20,
                                                ):_list[indexx].order_status == 'لا يمكن التنفيذ'
                                                    || _list[indexx].order_status == 'رفض العميل'
                                                    || _list[indexx].order_status == 'Canceled'?
                                                SvgPicture.asset(
                                                  'assets/order/cancel.svg',
                                                  semanticsLabel: 'Acme Logo',
                                                  width: 20,
                                                  color: Colors.red[300],
                                                  height: 20,
                                                ):_list[indexx].order_status == 'تم بدون كود'?
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
                                          _list[indexx].order_type?Translations.of(context).order_type_direct:
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
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 25),
                                          child: Text(
                                            AppModel.lamgug?'الدفع':'Payment',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: Colors.brown[400],
                                              fontSize: 13,
                                              height: 1.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      _list[indexx].payment_type == 'no' &&(
                                          _list[indexx].order_status == 'تم الإرسال' ||
                                              _list[indexx].order_status == 'في التشغيل'
                                      )?
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: FlatButton(
                                                onPressed: () {

                                                  print('order_total here : ${indexx}');
                                                  Navigator.of(context).push(PageRouteTransition(
                                                      animationType: AnimationType2.slide_up,
                                                      builder: (context) => PaymentWays(
                                                        indexList: indexx,
                                                        orderDocId: _list[indexx].order_docId,
                                                        totalMon: _list[indexx].order_total,
                                                        orderId: _list[indexx].order_id,
                                                        userName: _list[indexx].order_username,
                                                        userID: _list[indexx].order_user_id,
                                                      )
                                                  )
                                                  );

                                                },
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                padding: EdgeInsets.all(0.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                        AppModel.lamgug?'اكمال الدفع':'Complete Pay',
                                                        style: TextStyle(color: Colors.white,fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.payment,color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                color: Colors.orange,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ),
                                      ):
                                      _list[indexx].payment_type == 'no' &&(
                                          _list[indexx].order_status != 'تم الإرسال' &&
                                              _list[indexx].order_status != 'في التشغيل'
                                      )?
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'تم من الادارة',
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                                height: 1.6,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.info,
                                              size: 18,
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                      ):
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              '${_list[indexx].payment_type}',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15.0,
                                                height: 1.6,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              _list[indexx].payment_type == 'cash'?Icons.attach_money
                                                  :Icons.payment,
                                              size: 18,
                                              color: Colors.green,
                                            )
                                          ],
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
                                          '${_list[indexx].order_captin_name}',
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
                                          '${_list[indexx].order_captin_phone}',
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
                                  _list[indexx].order_status != 'تم التنفيذ'?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 25),
                                          child: Text(
                                            AppModel.lamgug?'كود اكمال الطلب':'Order Code',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 15.0,
                                              height: 1.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${_list[indexx].orderCapCode}',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 16,
                                            height: 1.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ):Container(),
                                  _list[indexx].order_status != 'تم التنفيذ'?Divider(
                                    color: Colors.grey[350],
                                  ):Container(),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).push(PageRouteTransition(
                                                animationType: testLang() == 'Next'?  AnimationType2.slide_up : AnimationType2.slide_up,
                                                builder: (context) => LastOrderItems(
                                                  _list[indexx].order_docId,
                                                  _list[indexx].order_time,
                                                  _list[indexx].order_date,
                                                  _list[indexx].order_id,
                                                  _list[indexx].order_status,
                                                  _list[indexx].order_type,
                                                  _list[indexx].order_captin_name,
                                                  _list[indexx].order_captin_phone,

                                                  _list[indexx].order_total,
                                                  _list[indexx].order_item_quantity,
                                                  _list[indexx].order_damaan,
                                                  _list[indexx].order_tasleek,
                                                  _list[indexx].order_captin_name,
                                                  _list[indexx].order_captin_phone,
                                                )
                                            )
                                            );

                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                          padding: EdgeInsets.all(0.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  Translations.of(context).details,
                                                  style: TextStyle(color: Colors.white,fontSize: 13),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.wrap_text,color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).push(PageRouteTransition(
                                                animationType: AnimationType2.slide_up,
                                                builder: (context) => MapOrders(
                                                  lat: _list[indexx].lat,
                                                  lng: _list[indexx].lng,
                                                  orderId: _list[indexx].order_id,
                                                )
                                            )
                                            );

                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                          padding: EdgeInsets.all(0.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  AppModel.lamgug?'الموقع':'On Map',
                                                  style: TextStyle(color: Colors.white,fontSize: 13),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.map,color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
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
            ) :
            Container(
              height: 50,
              color: Colors.grey[200],
              ),
            );
          }
        }
    );
  }

  Widget _listLastVisitOrders(List <LastVisit> _list){
    return getErrorConnection?
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          'assets/config/computer.svg',
          semanticsLabel: 'Acme Logo',
          width: 60,
          height: 60,
        ),
        SizedBox(height: 5,),
        Text(
          AppModel.lamgug?'يجب الاتصال بالانترنت':'No Internet Connection',style: TextStyle(
            fontFamily: 'Cairo',
            color: Colors.grey,fontSize: 13
        ),
        )
      ],
    ):progData?
        Center(child
            : SizedBox(
          width: 70,
          child: Container(
            child: Image.asset(
                'assets/notifi/home_loading.gif'
            ),
          ),
        ),
        )
        :_list.length == 0 ?
    Padding(
      padding: const EdgeInsets.only(bottom: 90),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.not_interested,color: Colors.grey[400],size: 40,
          ),
          Text(
            AppModel.lamgug?'لا توجد طلبات':'No Items',style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.grey,fontSize: 15
          ),
          ),
        ],
      ),
    ):
    ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int indexx) {
          return _list.length != 0?Padding(
            padding: new EdgeInsets.only(top: 0,right: 5,left: 5),
            child: _list[indexx].isExpanded != null?
            Padding(
              padding: const EdgeInsets.all(1),
              child: ExpansionPanelList(
                  expansionCallback: (int i, bool isExpanded) {
                    setState(() {
                      _list[indexx].isExpanded = !_list[indexx].isExpanded;
                    }
                    );
                  },
                  animationDuration: Duration(milliseconds: 200),
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Container(
                          child: Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ClipOval(
                                    child: Material(
                                      color: Colors.transparent, // button color
                                      child: InkWell(
                                        child: SizedBox(width: 40, height: 40, child: Icon(
                                          _list[indexx].order_status != 'تم الإرسال'?
                                          Icons.save:Icons.clear,
                                          color:
                                          _list[indexx].order_status == 'تم الإرسال'?
                                          Theme.of(context).primaryColor:
                                          Theme.of(context).primaryColor.withOpacity(0.1),
                                        ),
                                        ),
                                        onTap: () {
                                          _list[indexx].order_status == 'تم الإرسال'?
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                CancelOrder(
                                                  collection :'visit_orders',
                                                  documentId:_list[indexx].order_docId ,
                                                  direct: false,
                                                  index: indexx,
                                                ),
                                          ):null;
                                        },
                                      ),
                                    )
                                ),
                                Expanded(
                                  flex:3,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(_list[indexx].order_id,
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
                                              child: _list[indexx].order_status == 'تم التنفيذ'?SvgPicture.asset(
                                                'assets/order/done.svg',
                                                semanticsLabel: 'Acme Logo',
                                                width: 20,
                                                height: 20,
                                              ):_list[indexx].order_status == 'لا يمكن التنفيذ'
                                                  || _list[indexx].order_status == 'رفض العميل'
                                                  || _list[indexx].order_status == 'Canceled'?
                                              SvgPicture.asset(
                                                'assets/order/cancel.svg',
                                                semanticsLabel: 'Acme Logo',
                                                width: 20,
                                                color: Colors.red[300],
                                                height: 20,
                                              ):_list[indexx].order_status == 'تم بدون كود'?
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
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Text(_list[indexx].create_time,style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey
                                        ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5,right: 5),
                                          child: Container(
                                            width: 200,
                                            height: 1,
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                        Text(_list[indexx].create_date,style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey
                                        ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      isExpanded: _list[indexx].isExpanded,
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
                                height: MediaQuery.of(context).size.height*0.57,
                                child: ListView(
                                  children: <Widget>[
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
                                                fontSize: 13.0,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _list[indexx].order_id,
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
                                                fontSize: 13.0,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                _list[indexx].order_status == 'تم التنفيذ'?AppModel.lamgug?
                                                'تم التنفيذ':'Done':
                                                _list[indexx].order_status == 'تم بدون كود'?AppModel.lamgug?
                                                'تم بدون كود':'Done without code':
                                                _list[indexx].order_status == 'لا يمكن التنفيذ'?AppModel.lamgug?
                                                'لا يمكن التنفيذ':'Cannot execute':
                                                _list[indexx].order_status == 'رفض العميل'?AppModel.lamgug?
                                                'رفض العميل':'The client refused':
                                                _list[indexx].order_status == 'تم اللإرسال'?AppModel.lamgug?
                                                'تم اللإرسال':'Sent':
                                                _list[indexx].order_status == 'في التشغيل'?AppModel.lamgug?
                                                'في التشغيل':'processing':_list[indexx].order_status,
                                                style: TextStyle(
                                                  color: _list[indexx].order_status == 'تم التنفيذ' ||
                                                      _list[indexx].order_status == 'تم بدون كود'
                                                      ?
                                                  Colors.green:
                                                  _list[indexx].order_status == 'لا يمكن التنفيذ'
                                                      || _list[indexx].order_status == 'رفض العميل'
                                                      || _list[indexx].order_status == 'Canceled'?
                                                  Colors.red:Colors.orange,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 13,
                                                  height: 1.6,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 0,right: 0),
                                                child: Container(
                                                  height: 15,
                                                  child: _list[indexx].order_status == 'تم التنفيذ'?SvgPicture.asset(
                                                    'assets/order/done.svg',
                                                    semanticsLabel: 'Acme Logo',
                                                    width: 20,
                                                    height: 20,
                                                  ):_list[indexx].order_status == 'لا يمكن التنفيذ'
                                                      || _list[indexx].order_status == 'رفض العميل'
                                                      || _list[indexx].order_status == 'Canceled'?
                                                  SvgPicture.asset(
                                                    'assets/order/cancel.svg',
                                                    semanticsLabel: 'Acme Logo',
                                                    width: 20,
                                                    color: Colors.red[300],
                                                    height: 20,
                                                  ):_list[indexx].order_status == 'تم بدون كود'?
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
                                                fontSize: 13.0,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            !_list[indexx].order_type?Translations.of(context).order_type_direct:
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
                                              AppModel.lamgug?'زمن الزيارة':'Visit Time',
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: Colors.grey[500],
                                                fontSize: 13.0,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _list[indexx].visit_time,
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
                                              AppModel.lamgug?'تاريخ الزيارة':'Visit Date',
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: Colors.grey[500],
                                                fontSize: 13.0,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _list[indexx].visit_date,
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
                                                fontSize: 13.0,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _list[indexx].order_captin_name,
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
                                                fontSize: 13.0,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _list[indexx].order_captin_phone,
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
                                    _list[indexx].order_status != 'تم التنفيذ'?Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 25),
                                            child: Text(
                                              AppModel.lamgug?'كود اكمال الطلب':'Order Code',
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: Colors.grey[500],
                                                fontSize: 13.0,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${_list[indexx].orderCapCode}',
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 16,
                                              height: 1.6,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ):Container(),
                                    _list[indexx].order_status != 'تم التنفيذ'?Divider(
                                      color: Colors.grey[350],
                                    ):Container(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 70,left: 70,top: 20),
                                      child: FlatButton(
                                        onPressed: () {

                                          Navigator.pop(context);
                                          Navigator.of(context).push(PageRouteTransition(
                                              animationType: AnimationType2.slide_up,
                                              builder: (context) => MapOrders(
                                                orderId: _list[indexx].order_id,
                                                lat: _list[indexx].lat,
                                                lng: _list[indexx].lng,
                                              )
                                          )
                                          );

                                        },
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                        padding: EdgeInsets.all(0.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                AppModel.lamgug?'الموقع':'On Map',
                                                style: TextStyle(color: Colors.white,fontSize: 13),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.map,color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                        color: Colors.grey,
                                      ),
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
            )
                : Container(
              height: 50,
              color: Colors.grey[200],
            ),
          ):Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Center(child: Text(AppModel.lamgug?'لا توجد طلبات':'No Orders')),
          );
        }
    );
  }
  String testLang(){
    return Translations.of(context).button_next;
  }

  void showAsBottomSheet(Widget map) async {
    final result = await showSlidingBottomSheet(
        context,
        builder: (context) {
          return SlidingSheetDialog(
            elevation: 30,
            cornerRadius: 20,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [1, 1, 1],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            builder: (context, state) {
              return Container(
                height: 800,
                child: Center(
                  child: Material(
                    child: InkWell(
                      onTap: () => Navigator.pop(context, 'This is the result.'),
                      child: map,
                    ),
                  ),
                ),
              );
            },
          );
        }
    );

    print(result); // This is the result.
  }
}