import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/screens/copons/genarate_copon.dart';
import 'package:best_flutter_ui_templates/screens/copons/get_dat.dart';
import 'package:best_flutter_ui_templates/screens/copons/network/get_coupons.dart';
import 'package:best_flutter_ui_templates/screens/copons/network/model.dart';
import 'package:best_flutter_ui_templates/screens/copons/network/coup_provider.dart';
import 'package:best_flutter_ui_templates/screens/help/help_items.dart';
import 'package:best_flutter_ui_templates/screens/last_order/direct/network/direct_provider.dart';
import 'package:best_flutter_ui_templates/screens/notification/notification.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/utilities/snack_bar.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:cache_image/cache_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as dateTime;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:best_flutter_ui_templates/translation_strings.dart';
import 'package:best_flutter_ui_templates/widgests/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import '../../screens/payment/payment_bill.dart';
import 'insert_bill.dart';
import 'network/payment_model.dart';
import 'network/payment_provider.dart';

class PaymentWays extends StatefulWidget {
  int indexList;
  String totalMon , orderId , userName , userID , orderDocId;
  PaymentWays({this.indexList,this.orderDocId,this.totalMon,this.orderId , this.userName , this.userID});
  @override
  _PaymentWaysState createState() => _PaymentWaysState();
}

class _PaymentWaysState extends State<PaymentWays> {

  double total_all = 0;
  bool checkCouponDay = true , _progBtn = false;
  String _cop_limit,
      _createTime , _createDate;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String _cop_count_use , _price_new_cop ,
      _more_cop_price ,_text_send ,_result_show_ar ,_result_show_en;

  _getCopData() async {
    Firestore.instance.collection('copuons_sys').getDocuments().then((query) {
      if(query.documents.isNotEmpty){
        setState(() {
          _cop_limit = query.documents[0].data['cop_limit'];
          _more_cop_price = query.documents[0].data['more_cop_price'];
          _price_new_cop  = query.documents[0].data['price_cop'];
          _result_show_ar = query.documents[0].data['result_show_ar'];
          _result_show_en = query.documents[0].data['result_show_en'];
          _text_send      = query.documents[0].data['message_send_cop'];
          _cop_count_use  = query.documents[0].data['cop_count_use'];
         }
        );
      }
      }
    ).whenComplete((){
      _getCop();
    });
  }

  bool progCop = true;

  _cutCopuon(double _price_cop){
    CouponProvider couponProvider = Provider.of<CouponProvider>(context , listen: false);
    CouponProvider().setCopPriceEmpty(couponProvider);
    setState(() {
      total_all =  total_all  - _price_cop;
      }
    );
  }
  _getCop() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getCoupons(false,Cart().convertToInt(_cop_count_use),context,prefs.getString('user_docId'),
        DatTim().mathSumToDayDate(),Cart().convertToInt(_cop_limit),(){
      setState(() {
        progCop = false;
        getErrorConnection = false;
      });
    },(){
      setState(() {
        getErrorConnection = true;
      });
    });
  }
  @override
  void initState() {
    _getCopData();
    PaymentProvider cart = Provider.of<PaymentProvider>(context , listen: false);
    PaymentProvider().getPayment(cart,(){
      setState(() {
        progData = false;
      });
    },(){
      setState(() {
        getErrorConnection = true;
      });
    }
    );

    super.initState();
    setState(() {
      total_all =  DatTim().convertToDouble(widget.totalMon);
    });
  }

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
      child: Consumer<AppModel>(
          builder: (context , model , child) {
            return Consumer<Cart>(
                builder: (context , cart , child) {
                  return Consumer<CouponProvider>(
                    builder: (context , couponProv , child) {
                      return Scaffold(
                          key: scaffoldKey,
                          drawer: CustomDrawer(
                            context:context,
                            scaffoldKey: scaffoldKey,
                          ),
                          body: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  customAppBar(AppModel.lamgug?'اختر طريقة الدفع':'Payment Ways' ,context),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      child: Container(
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: Consumer<PaymentProvider>(
                                              builder: (context , payment , child) {
                                                    print('listPaymentList is : '+payment.listPaymentList.length.toString());
                                                    return _listPaymentWay(payment.listPaymentList,couponProv.listCuopon);
                                                    }
                                                ),
                                              ),
                                              progCop? Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        AppModel.lamgug?'تحميل الكوبونات':'loading coupons',
                                                      style: TextStyle(
                                                        color: Colors.grey[500]
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    CupertinoActivityIndicator(),
                                                  ],
                                                ),
                                              )
                                                  : Center(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(10)),
                                                          color: couponProv.sumCoupPrice != 0?
                                                          Theme.of(context).primaryColorLight.withOpacity(1):
                                                          Colors.grey[100],
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.4),
                                                              spreadRadius: 3,
                                                              blurRadius: 6,
                                                              offset: Offset(0, 1), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: couponProv.sumCoupPrice != 0?Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <Widget>[
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(right: 0),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Align(
                                                                          alignment: FractionalOffset
                                                                              .topRight,
                                                                          child: Padding(
                                                                            padding: EdgeInsets
                                                                                .only(top: 0),
                                                                            child: Opacity(
                                                                              opacity: 0.8,
                                                                              child: FlatButton(
                                                                                onPressed: () {},
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius
                                                                                        .only(
                                                                                        bottomLeft: Radius
                                                                                            .circular(
                                                                                            15.0),
                                                                                        topLeft: Radius
                                                                                            .circular(
                                                                                            15.0))),
                                                                                child:  Row(
                                                                                  children: <Widget>[
                                                                                    Icon(
                                                                                        Icons.bookmark_border,
                                                                                        color: Theme.of(context).primaryColor
                                                                                    ),
                                                                                    Text(
                                                                                      'مجموع الكوبونات',
                                                                                      style: TextStyle(
                                                                                          fontSize: 13
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                color: Colors
                                                                                    .white,
                                                                                textColor: Theme
                                                                                    .of(context)
                                                                                    .primaryColor,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Image(
                                                                    image: AssetImage(
                                                                      'assets/images/logo.png',
                                                                    ),
                                                                    height: 100,
                                                                    width: 300,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <Widget>[
                                                                Text('${couponProv.sumCoupPrice}',style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: Theme.of(context).primaryColor
                                                                ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text(AppModel.lamgug?'${cart.unit_ar}':'${cart.unit_en}',style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Theme.of(context).primaryColor.withOpacity(0.4)
                                                                ),
                                                                ),

                                                              ],
                                                            ),
                                                            Align(
                                                              alignment: Alignment.bottomCenter,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(top: 0),
                                                                child: Opacity(
                                                                  opacity: 0.8,
                                                                  child: FlatButton(
                                                                    onPressed: () {
                                                                      _showDialog(
                                                                          couponProv.listCuopon[0].unit_coupon_ar,
                                                                          couponProv.listCuopon[0].unit_coupon_en,
                                                                          context,
                                                                          total_all,
                                                                          couponProv.sumCoupPrice,
                                                                              (){
                                                                            _cutCopuon(couponProv.sumCoupPrice);
                                                                          },(){

                                                                        var dbTimeKey = DateTime.now();
                                                                        var formatDate = dateTime.DateFormat.yMMMd('en_US');
                                                                        var formatTime = dateTime.DateFormat.jm('en_US');
                                                                        setState(() {
                                                                          _createTime = formatDate.format(dbTimeKey);
                                                                          _createDate = formatTime.format(dbTimeKey);
                                                                          _progBtn = true;
                                                                        });
                                                                        createBill(context,_createTime ,_createDate,widget.orderId,widget.userName,total_all,couponProv.listCuopon[0].unit_coupon_ar,context,(){
                                                                          saveUpdateCop(
                                                                              widget.orderDocId,
                                                                              DatTim().convertToDouble(widget.totalMon),
                                                                              couponProv.listCuopon,
                                                                              (){
                                                                            Cart cart = Provider.of<Cart>(context , listen: false);
                                                                            Cart().getPayNoti(cart,(){
                                                                              Cart cartt = Provider.of<Cart>(context , listen: false);
                                                                              Cart().getProgStat(cartt,false);

                                                                              DirectOrderProvider directOrderProvider = Provider.of<DirectOrderProvider>(context , listen: false);
                                                                              DirectOrderProvider().setPayOrderIndex(directOrderProvider,'coupon',null,widget.indexList);
                                                                              Navigator.pop(context);
                                                                              Navigator.of(context).push(PageRouteTransition(
                                                                                  animationType: AppModel.lamgug?AnimationType2.slide_left:
                                                                                  AnimationType2.slide_right,
                                                                                  builder: (context) => BillPayment(
                                                                                    totalMon: widget.totalMon,
                                                                                    unit_ar: cart.unit_ar,
                                                                                    unit_en: cart.unit_en,
                                                                                    name  : widget.userName,
                                                                                    orderId : widget.orderId,
                                                                                    billNumber: couponProv.billNo,
                                                                                    createTime: _createTime,
                                                                                    createDate: _createDate,
                                                                                  )
                                                                              )
                                                                              );
                                                                            });
                                                                          });
                                                                          setState(() {
                                                                            _progBtn = false;
                                                                          });
                                                                        });
                                                                      }
                                                                      );
                                                                    },
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                        Radius.circular(10),
                                                                      ),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(top: 3,bottom: 3),
                                                                      child: Container(
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Text(AppModel.lamgug?'اختيار':'Choose',
                                                                                style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 15
                                                                                )
                                                                            ),
                                                                            SizedBox(
                                                                              width: 2,
                                                                            ),
                                                                            Icon(
                                                                              Icons.check_circle_outline,
                                                                              color: Colors.white,
                                                                              size: 18,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        width: 140,
                                                                      ),
                                                                    ),
                                                                    color: Theme
                                                                        .of(context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                            : Container(
                                                          child: SizedBox(
                                                            width: double.infinity,
                                                            height: 50,
                                                            child: FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(context).push(PageRouteTransition(
                                                                    animationType: AppModel.lamgug?
                                                                    AnimationType2.slide_left:AnimationType2.slide_right,
                                                                    builder: (context)=> AddCopons(
                                                                      cop_limit: _cop_limit,
                                                                      cop_count_use: _cop_count_use,
                                                                      price_new_cop: _price_new_cop,
                                                                      showResult_ar: _result_show_ar,
                                                                      showEn: _result_show_en,
                                                                      more_price: _more_cop_price,
                                                                    )
                                                                )
                                                                );
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(2),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Spacer(flex: 6),
                                                                  Text(
                                                                    AppModel.lamgug?'اضافة كوبون':'Add coupons',
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: Colors.white
                                                                    ),
                                                                  ),
                                                                  Spacer(
                                                                      flex: 5
                                                                  ),
                                                                  Icon(
                                                                    Icons.add,
                                                                    color: Colors.white,
                                                                  )
                                                                ],
                                                              ),
                                                              color: Theme
                                                                  .of(context)
                                                                  .primaryColorDark,
                                                              textColor: Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                    ),
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
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 70),
                                child: Opacity(
                                  opacity: 0.7,
                                  child: Container(
                                    color: total_all < DatTim().convertToDouble(widget.totalMon)?Colors.orange:Colors.blue[300],
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0,bottom: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'التكلفة الكلية',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${total_all}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            AppModel.lamgug?'${cart.unit_ar}':'${cart.unit_en}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );},
                    );
                });
          }
      ),
    );
  }

  _updateNotification(VoidCallback voidCallback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time

    String _user_id = prefs.getString('user_docId');
    Firestore.instance.collection('direct_orders')
        .where('payment_type',isEqualTo: 'no').where('order_user_id',isEqualTo: _user_id).
    getDocuments()
        .then((query) {
          if(query.documents.isEmpty){
            Cart _cart = Provider.of<Cart>(context , listen: false);
            Cart().setNotification(_cart,false ,false, null);
          }
      }
    ).whenComplete(() {
      voidCallback();
    });
  }

  bool progData = true ,getErrorConnection = false;

  Widget _listPaymentWay(List <PaymentModel> _list,List<CoupModel> listCop){
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
            color: Colors.grey,fontSize: 13
        ),
        )
      ],
    ):progData?Center(child
        : CupertinoActivityIndicator())
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
            AppModel.lamgug?'لا توجد طرق دفع متاحة':'No Items',style: TextStyle(
              color: Colors.grey,fontSize: 15
          ),
          ),
        ],
      ),
    ):
    ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int indexx) {
          return _list.length != 0?
          Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              elevation: 5,
              child: Container(
                height: 160,
                child: Stack(
                  children: <Widget>[
                    Align(
                      child: Container(
                        child: Center(
                          child: FadeInImage(
                            placeholder: AssetImage('assets/notifi/loading_ci.gif'),
                            image: CacheImage(_list[indexx].image,),
                            fit: BoxFit.cover,
                            height: 100,
                          ),
                        ),
                        height: 100,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets
                            .only(top: 0),
                        child: Opacity(
                          opacity: 0.8,
                          child: FlatButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius
                                    .only(
                                    bottomLeft: Radius
                                        .circular(
                                        15.0),
                                    topLeft: Radius
                                        .circular(
                                        15.0))),
                            child: Text(
                              _list[indexx].name,
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                            color: Colors
                                .white,
                            textColor: Theme
                                .of(context)
                                .primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets
                            .only(top: 0,bottom: 5),
                        child: Opacity(
                          opacity: 1,
                          child: FlatButton(
                            onPressed: () {

                              if(_list[indexx].name != 'cash'){
                                snackShow(context,  AppModel.lamgug?'سيتم توفيره قريبا':'It will be available soon',
                                    Colors.black54,
                                    Icon(
                                      Icons.insert_drive_file,
                                      color: Colors.white,
                                    ),scaffoldKey);
                              }else{
                                Alert(
                                  context: context,
                                  style: alertStyle,
                                  type: AlertType
                                      .success,
                                  title: "",
                                  desc: AppModel.lamgug?'سيتم تحصيل رسوم الخدمة عن طريق الدفع المباشر':'Service fee will be charged by direct payment',
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        AppModel.lamgug?'موافق':'ok',
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            color: Theme
                                                .of(
                                                context)
                                                .primaryColor,
                                            fontSize: 13),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showProgressDialog();
                                        print('order id ${widget.orderDocId}');
                                        print('listCop listCop ${listCop.length}');

                                        if(listCop.length == 0){
                                          upDateOrder(widget.orderDocId,(){
                                            print('orderDocId order: ${widget.orderDocId}');

                                            Cart cart = Provider.of<Cart>(context , listen: false);
                                            Cart().getPayNoti(cart,(){
                                              dismissProgressDialog();
                                              Navigator.pop(context);
                                              DirectOrderProvider directOrderProvider = Provider.of<DirectOrderProvider>(context , listen: false);
                                              DirectOrderProvider().setPayOrderIndex(directOrderProvider,'cash',null,widget.indexList);
                                             }
                                            );
                                          }
                                              ,'cash');
                                        }else{
                                          saveUpdateCopListEmpty(
                                              widget.orderDocId,
                                              DatTim().convertToDouble(widget.totalMon),
                                              listCop,
                                                  (){
                                                Cart cart = Provider.of<Cart>(context , listen: false);
                                                Cart().getPayNoti(cart,(){
                                                  dismissProgressDialog();
                                                  Navigator.pop(context);
                                                  DirectOrderProvider directOrderProvider = Provider.of<DirectOrderProvider>(context , listen: false);
                                                  DirectOrderProvider().setPayOrderIndex(directOrderProvider,'cash',null,widget.indexList);
                                                });
                                              }
                                          );
                                        }
                                      },
                                      color: Colors
                                          .grey[200],
                                      radius: BorderRadius
                                          .circular(
                                          5),
                                    ),

                                    DialogButton(
                                      child: Text(
                                        AppModel.lamgug?'الغاء':'Cancel',
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            color: Colors.grey,
                                            fontWeight: FontWeight
                                                .bold,
                                            fontSize: 13),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      color: Colors
                                          .grey[200],
                                      radius: BorderRadius
                                          .circular(
                                          5),
                                    ),
                                  ],
                                ).show();

                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3,bottom: 3),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(AppModel.lamgug?'اختيار':'Choose',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18
                                        )
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      _list[indexx].name != 'cash'?Icons.payment:Icons.monetization_on,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                width: 140,
                              ),
                            ),
                            color:_list[indexx].name != 'cash'? Colors.orange:Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ):
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Center(child: Text(AppModel.lamgug?'لا توجد طلبات':'No Orders')),
          );
        }
    );


  }

}


 _showDialog(String unit_ar,String unit_en ,BuildContext context ,double total ,double copPrice
    ,VoidCallback backPaym , VoidCallback goToBage) {

  print('dialog unit herer ${unit_ar}');
  print('en dialog unit herer ${unit_en}');

  slideDialog.showSlideDialog(
    context: context,
    child: CouponPaySone(
        unit_ar : unit_ar,
        unit_en : unit_en ,
        context: context ,
        total: total ,
        copPrice: copPrice,
        backPaym: backPaym ,
        goToBage: goToBage
    )
  );
}


var alertStyle = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: true,
  descStyle: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 13,color: Colors.grey[600],fontWeight: FontWeight.normal),
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  titleStyle: TextStyle(
    color: Colors.grey,
  ),
);


Widget custAppBar(String title,bool _notifi ,BuildContext context,VoidCallback voidCallback){
  return Column(
    children: <Widget>[
      SizedBox(
        height: 25,
      ),
      Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                2.0, // vertical, move down 10
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
                padding: const EdgeInsets.only(left: 20),
                child: IconButton(
                  onPressed: (){
                    voidCallback();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                ),
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: SvgPicture.asset(
                      _notifi?'assets/images/notific_active.svg':'assets/images/notific.svg',
                      semanticsLabel: 'Acme Logo',
                      width: 20,
                      height: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: (){
                      Cart _cart = Provider.of<Cart>(context , listen: false);
                      Cart().setNotification(_cart,false ,null, null);
                      Navigator.of(context).push(PageRouteTransition(
                          animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                          builder: (context) => Notifications()
                      )
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: IconButton(
                      icon: Icon(
                        Icons.help,
                        color: Theme.of(context).primaryColor,
                      ), onPressed: () {
                      Navigator.of(context).push(PageRouteTransition(
                          animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                          builder: (context) => HelpsDetails(
                            title: Translations.of(context).catigories,
                            title_ar: 'المجالات',
                            )
                          )
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ],
  );
}

class CouponPaySone extends StatefulWidget {

  String unit_ar, unit_en;
  BuildContext context;
  double total , copPrice;
  VoidCallback backPaym;
  VoidCallback goToBage;

  CouponPaySone({this.unit_ar,this.unit_en,this.context,this.total,this.copPrice,this.backPaym
  ,this.goToBage});
  @override
  _CouponPaySoneState createState() => _CouponPaySoneState();
}

class _CouponPaySoneState extends State<CouponPaySone> {

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
        builder: (context , cart , child) {
      return Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 40,left: 40,top: 20),
            child: Container(
              child: Column(
                children: <Widget>[
                  widget.total <= widget.copPrice?Column(
                    children: <Widget>[
                      AppModel.lamgug?Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'سيتم خصم مبلغ',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black45
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.total.toString()}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black45
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.unit_ar}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black45
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'من قيمة الكوبون',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),
                          )
                        ],
                      ):
                      Row(
                        children: <Widget>[
                          Text(
                            '${widget.total.toString()}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),
                          ),
                          Text(
                            '${widget.unit_en}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),
                          ),
                          Text(
                            'will be deducted from the voucher',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Cart cartt = Provider.of<Cart>(context , listen: false);
                              Cart().getProgStat(cartt,true);
                              widget.goToBage();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3,bottom: 3),
                              child: Container(
                                child: !cart.progStat?Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Spacer(flex: 6,),
                                    Text(AppModel.lamgug?'تاكيد':'OK',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13
                                        )
                                    ),
                                    Spacer(flex: 5,),
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                    ),
                                  ],//CupertinoActivityIndicator
                                ):Center(child: CupertinoActivityIndicator()),
                                width: 200,
                                height: 40,
                              ),
                            ),
                            color: !cart.progStat?Colors.green:Colors.green[200],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Spacer(flex: 6,),
                                    Text(AppModel.lamgug?'الغاء':'Close',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13
                                        )
                                    ),
                                    Spacer(flex: 5,),
                                    Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                width: 200,
                                height: 40,
                              ),
                            ),
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ],
                  ):
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppModel.lamgug?'قيمة الكوبونات لا تغطي اجمالي التكلفة'
                                :'The value of the coupons does not cover the total cost',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppModel.lamgug?'سيتبقى مبلغ '
                                :'left ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey
                            ),
                          ),
                          Text(
                            '${widget.total - widget.copPrice}',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey
                            ),

                          ),
                          Text(
                            AppModel.lamgug?' ${widget.unit_ar} '
                                :'${widget.unit_en}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),

                          ),

                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.backPaym();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3,bottom: 3),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15,left: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(AppModel.lamgug?'خصم واكمال بطريقة دفع اخرى':'Discount and completion by another payment way',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12
                                          )
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                height: 40,
                              ),
                            ),
                            color: Colors.green,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(AppModel.lamgug?'الغاء':'Close',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13
                                        )
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                width: 200,
                                height: 40,
                              ),
                            ),
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
      );},
    );
  }
}
