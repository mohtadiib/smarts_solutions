import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/screens/copons/get_dat.dart';
import 'package:best_flutter_ui_templates/screens/user/login/authservice.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:best_flutter_ui_templates/widgests/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scratcher/scratcher.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'genarate_copon.dart';
import 'network/get_coupons.dart';
import 'network/model.dart';
import 'network/coup_provider.dart';
import 'old_coupons.dart';
class MyCoupons extends StatefulWidget {
  @override
  _MyCouponsState createState() => _MyCouponsState();
}

class _MyCouponsState extends State<MyCoupons> {

  bool progData = true ,getErrorConnection = false;
  String user_id;
  bool cardBack = false , _getUnit = false;
  _getUserId()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    setState(() {
      user_id = prefs.getString('user_docId');
    });
  }

  @override
  void initState() {
    _getUserId();
    super.initState();
    AuthService().setTestPage(1);
    Cart foodNotifier = Provider.of<Cart>(context , listen: false);
    Cart().getUnitCantery(foodNotifier,(){
      setState(() {
        _getUnit = true;
      });
    });
    _getCopData();
  }

  String _cop_limit , _cop_count_use , _price_new_cop ,
      _more_cop_price ,_text_send ,_result_show_ar ,_result_show_en;
  _getCopData() async {
    Firestore.instance.collection('copuons_sys').getDocuments().then((query) {
      setState(() {
        _more_cop_price = query.documents[0].data['more_cop_price'];
        _price_new_cop  = query.documents[0].data['price_cop'];
        _result_show_ar = query.documents[0].data['result_show_ar'];
        _result_show_en = query.documents[0].data['result_show_en'];
        _text_send      = query.documents[0].data['message_send_cop'];
        _cop_count_use  = query.documents[0].data['cop_count_use'];
        _cop_limit      = query.documents[0].data['cop_limit'];
        }
      );
     }
    ).whenComplete((){

      getCoupons(false,Cart().convertToInt(_cop_count_use),context,user_id,
          DatTim().mathSumToDayDate(),Cart().convertToInt(_cop_limit),(){
            setState(() {
              progData = false;
              getErrorConnection = false;
            });
          },(){
            setState(() {
              getErrorConnection = true;
            });
          });
    });
  }
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);


  void _onRefresh() async{

    print('jksahdkfjlh');

    setState(() {
      progData = true;
      getErrorConnection = false;
    });
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

    getCoupons(false,Cart().convertToInt(_cop_count_use),context,user_id,
        DatTim().mathSumToDayDate(),Cart().convertToInt(_cop_limit),(){
      setState(() {
        progData = false;
        getErrorConnection = false;
      });
    },(){
      setState(() {
        getErrorConnection = true;
      });
    });
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
      child: Consumer<AppModel>(
          builder: (context , model , child) {
            return Consumer<CouponProvider>(
                builder: (context , visits , child) {
                  //print('my list : '+cart.listMyCart.length.toString());
                  return Scaffold(
                    key: scaffoldKey,
                    drawer: CustomDrawer(
                      context:context,
                      scaffoldKey: scaffoldKey,
                    ),
                    body: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30,right: 10,left: 20),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black54,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Spacer(),
                                Text(
                                  AppModel.lamgug?'جميع الكوبونات':'All Coupons',
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Colors.black54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  child: SizedBox(
                                    width: 100,
                                    height: 30,
                                    child: FlatButton(
                                      onPressed: () {
                                        if(_getUnit){
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
                                        }
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
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Spacer(),
                                              Text(
                                                  AppModel.lamgug?'إضافة':'Add',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12
                                                  )
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              Spacer(),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      color: _getUnit?Colors.green:Colors.green[100],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Container(
                              child: SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: false,
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                child: Container(child: _listLastVisitOrders(visits.listCuopon)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5, right: 5, left: 5, bottom: 5),
                          child: Container(
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageRouteTransition(
                                      animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                      builder: (context) => OldCoupons()));
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Spacer(),
                                    Text(AppModel.lamgug?'مستخدم او منتهي الصلاحية':'Old Coupons', style
                                        : TextStyle(
                                        fontSize: 13
                                    ),
                                    ),
                                    Spacer(),
                                    Icon(
                                        Icons.arrow_forward
                                    )
                                  ],
                                ),
                                color: Colors.grey[300],
                                textColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                }
              );
            }
          ),
        );
      }

  Widget _listLastVisitOrders(List <CoupModel> _list){
    return
    getErrorConnection?
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
    ):progData?Center(child: CupertinoActivityIndicator())
        :_list.length == 0 ?Padding(
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
          )
        :ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int indexx) {
          print('limited date here : ${_cop_limit}');

          print('sum_date_coupon date here : ${_list[indexx].sum_date_coupon}');

          print('sum_date_coupon+limited date here : ${_list[indexx].sum_date_coupon+DatTim().convertToInt(_cop_limit)}');

          return Padding(
            padding: EdgeInsets.only(bottom: 10,top: 0,right: 5,left: 5),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 150,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL, // default
                    front: Container(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)),
                          color: Theme.of(context).primaryColorLight.withOpacity(1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 3,
                              blurRadius: 6,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child:  Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                            Icons.bookmark_border,
                                            color: Theme.of(context).primaryColor
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(_list[indexx].price_coupon,style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context).primaryColor
                                        ),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(AppModel.lamgug?_list[indexx].unit_coupon_ar:_list[indexx].unit_coupon_en,style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context).primaryColor.withOpacity(0.4)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
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
                                Spacer(),
                                Container(
                                  child: SizedBox(
                                    width: 100,
                                    height: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 3,bottom: 3),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Icon(
                                              Icons.flip,
                                              color: Colors.grey[400],
                                              size: 13,
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                                AppModel.lamgug?'انظر خلف الكرت':'Flip',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 10
                                                )
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  child: SizedBox(
                                    width: 100,
                                    height: 30,
                                    child: FlatButton(
                                      onPressed: () {
                                        Share.share(AppModel.lamgug?'${_list[indexx].cop_code} ${_text_send}':
                                        '${_text_send} ${_list[indexx].cop_code}');
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
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                Icons.share,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                              Spacer(),
                                              Text(
                                                  AppModel.lamgug?'مشاركة':'Share',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12
                                                  )
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Spacer(),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    back: Container(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 3,
                              blurRadius: 6,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: FractionalOffset
                                        .topRight,
                                    child: Padding(
                                      padding: EdgeInsets
                                          .only(top: 20,right: 20,left: 20),
                                      child: Opacity(
                                        opacity: 0.8,
                                        child: Column(
                                          children: <Widget>[
                                            Text(AppModel.lamgug?'$_result_show_ar':'$_result_show_en',
                                              style: TextStyle(
                                                fontSize: 13
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Opacity(
                                      opacity: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          child:  Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3))),
                                            height: 35,
                                            width: 250,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  Spacer(
                                                    flex: 12,
                                                  ),
                                                  Text(
                                                      _list[indexx].cop_code,style: TextStyle(
                                                      fontSize: 15,
                                                      color: Theme.of(context).primaryColor.withOpacity(0.8)
                                                  )
                                                  ),
                                                  Spacer(
                                                    flex: 6,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.share,
                                                        size: 20,
                                                        color: Theme.of(context).primaryColor.withOpacity(0.8)
                                                    ), onPressed: () {
                                                    Share.share(AppModel.lamgug?'${_list[indexx].cop_code} ${_text_send}':
                                                    '${_text_send} ${_list[indexx].cop_code}');

                                                  },
                                                  ),
                                                  Spacer(
                                                    flex: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
                  ),
                ),
                _list[indexx].sum_date_coupon+DatTim().convertToInt(_cop_limit) < DatTim().mathSumToDayDate()?Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)),
                    color: Colors.grey[200].withOpacity(0.8),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppModel.lamgug?'منتهي الصلاحية':'Expired',
                          style: TextStyle(
                            color: Colors.grey[500]
                          ),
                        ),
                        Icon(
                          Icons.error,
                          color: Colors.grey[500],
                        )
                      ],
                    ),
                  ),
                ):Container(),
              ],
            ),
          );
        }
    );
  }
}