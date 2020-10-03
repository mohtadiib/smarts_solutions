import 'package:best_flutter_ui_templates/categories/categories.dart';
import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/screens/notification/notification.dart';
import 'package:best_flutter_ui_templates/screens/user/login/authservice.dart';
import 'package:best_flutter_ui_templates/translation_strings.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/widgests/my_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'payment/get_payment_way.dart';

class FinalDirectScreen extends StatefulWidget {

  String  orderTime,
          orderDate,
          orderId,
          orderStatus,
          orderType,
          total,
          quantity,
          tasleek,
          damaan,
          userName,
          userId,
          order_docID,
          paytybe;

  FinalDirectScreen({
    this.order_docID,
    this.userId,this.userName,
    this.orderTime,this.orderDate,
    this.orderId,this.orderStatus,
    this.orderType,this.total ,
    this.quantity ,this.paytybe,
    this.tasleek,this.damaan});
  @override
  _FinalDirectScreen createState() => _FinalDirectScreen();
}

class _FinalDirectScreen extends State<FinalDirectScreen> {

  double _fontSize = 13;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Cart cart = Provider.of<Cart>(context , listen: false);
    Cart().setNotification(cart,true , true ,true);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
        builder: (context , cart , child) {
          //print('my list : '+cart.listMyCart.length.toString());
          return Scaffold(
            drawer: CustomDrawer(),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Theme
                        .of(context)
                        .primaryColor, Colors.black]),
              ),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30,bottom: 0,left: 20,right: 20),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: <Widget>[
                             Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.help,color: Colors.white,size: 20,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                    Cart cart = Provider.of<Cart>(context , listen: false);
                                    Cart().setNotification(cart,true , true ,null);
                                    Navigator.of(context).push(PageRouteTransition(
                                        animationType: AppModel.lamgug?AnimationType2.slide_right:AnimationType2.slide_left,
                                        builder: (context) => Notifications()
                                    )
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    cart.notification?'assets/images/notific_active.svg':'assets/images/notific.svg',
                                    semanticsLabel: 'Acme Logo',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ],
                        ),
                             IconButton(
                               icon: Icon(
                                 Icons.share,
                                 color: Colors.white,
                                ), onPressed: () {

                               },
                             )
                           ],
                         ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 50, left: 50, right: 50),
                          child: Container(
                            child: Image(
                              image: AssetImage(
                                'assets/images/succses.png',
                              ),
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  child: Text('تم الطلب بنجاح',
                                    style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white
                                    ),)
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10,top: 20,left: 10,right: 10),
                                child:
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(AppModel.lamgug?'رقم الطلب'
                                                      :'Order ID'
                                                      , style: TextStyle(
                                                          fontFamily: 'Cairo',
                                                          fontSize: _fontSize, color: Colors.white
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.orderId}'
                                                    , style: TextStyle(
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(AppModel.lamgug?'اسم العميل'
                                                      :'User Name', style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      fontSize: _fontSize, color: Colors.white
                                                  ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.userName}', style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      fontSize: _fontSize, color: Colors.white
                                                  ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(Translations
                                                      .of(context)
                                                      .button_next == 'Next' ? 'Create Time' : 'وقت انشاء الطلب'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.orderTime}'
                                                    , style: TextStyle(
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(Translations
                                                      .of(context)
                                                      .button_next == 'Next' ? 'Create Date' : 'التاريخ'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.orderDate}'
                                                    , style: TextStyle(
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(Translations
                                                      .of(context)
                                                      .button_next == 'Next' ? 'Category' : 'الفئة'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${cart.categoriesName}'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(Translations
                                                      .of(context)
                                                      .button_next == 'Next' ? 'Order Type' : 'نوع الطلب'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.orderType}'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(Translations
                                                      .of(context)
                                                      .button_next == 'Next' ? 'Order Status' : 'حالة الطلب'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.orderStatus}'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(Translations
                                                      .of(context)
                                                      .button_next == 'Next' ? 'Tasleek Type' : 'نوع التسليك'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.tasleek}'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(Translations
                                                      .of(context)
                                                      .button_next == 'Next' ? 'Damaan' : 'الضمان'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.damaan}'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(Translations
                                                      .of(context)
                                                      .button_next == 'Next' ? 'Total' : 'الاجمالي'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(AppModel.lamgug?'${widget.total} ${cart.unit_en}':'${widget.total} ${cart.unit_ar}'
                                                    , style: TextStyle(
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(Translations
                                                      .of(context)
                                                      .button_next == 'Next' ? 'Items Quantity' : 'عدد العناصر'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.quantity}'
                                                    , style: TextStyle(
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(Translations
                                                      .of(context)
                                                      .button_next == 'Next' ? 'Payment' : 'الدفع'
                                                    , style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.paytybe}'
                                                    , style: TextStyle(
                                                        fontSize: _fontSize, color: Colors.white
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
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 20, right: 15, left: 15, bottom: 5),
                                child: Container(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(PageRouteTransition(
                                            animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                            builder: (context) => PaymentWays(
                                              orderDocId: widget.order_docID,
                                              totalMon: widget.total,
                                              orderId: widget.orderId,
                                              userName: widget.userName,
                                              userID: widget.userId,
                                            )

                                            //  PaymentWays({this.totalMon,this.orderId , this.userName , this.userID});
                                        )
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Spacer(
                                            flex: 4,
                                          ),
                                          Text(AppModel.lamgug?'اكمال الدفع':'Payment', style: TextStyle(
                                              fontSize: 13
                                          ),
                                          ),
                                          Spacer(
                                            flex: 3,
                                          ),
                                          Icon(
                                            Icons.payment,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                      color: Colors.green,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5, right: 15, left: 15, bottom: 20),
                                child: Container(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(AppModel.lamgug?'رجوع للمجالات':'Categories', style: TextStyle(
                                          fontSize: 13
                                      ),
                                      ),
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget lineDraw(){
    return Padding(
      padding: EdgeInsets.only(top: 3 ,left: 40 ,right: 40 ,bottom: 5),
      child: Container(
        height: MediaQuery.of(context).size.height*0.70,
        width: 1.0,
        color: Colors.white.withOpacity(0.2),
      ),
    );
  }
}
