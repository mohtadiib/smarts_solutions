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

class BillPayment extends StatefulWidget {
  String name,billNumber,visitDate,
      orderId , totalMon , unit_ar , unit_en
  ,createTime ,createDate;

  BillPayment({
    this.name,this.billNumber,
    this.orderId,this.unit_ar,
    this.unit_en,this.createTime ,
    this.createDate , this.totalMon});
  @override
  _BillPaymentState createState() => _BillPaymentState();
}

class _BillPaymentState extends State<BillPayment> {

  double _fontSize = 17;
  bool _notifi = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    colors: [Colors.green, Colors.black]),
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
                                    Cart _cart = Provider.of<Cart>(context , listen: false);
                                    Cart().setNotification(_cart,false ,null, true);
                                    Navigator.of(context).push(PageRouteTransition(
                                        animationType: AppModel.lamgug?AnimationType2.slide_right:AnimationType2.slide_left,
                                        builder: (context) => Notifications()
                                    )
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    _notifi?'assets/images/notific_active.svg':'assets/images/notific.svg',
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
                                  child: Text('تم الدفع بنجاح',
                                    style: TextStyle(
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                      fontSize: _fontSize, color: Colors.white
                                                  ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.name}', style: TextStyle(
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
                                                      .button_next == 'Next' ? 'Bill Number' : 'رقم الفاتورة'
                                                    , style: TextStyle(
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.billNumber}'
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
                                                      .button_next == 'Next' ? 'Total' : 'الإجمالي'
                                                    , style: TextStyle(
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(AppModel.lamgug?'${widget.totalMon} ${widget.unit_en}':
                                                  '${widget.totalMon} ${widget.unit_ar}'
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
                                                      .button_next == 'Next' ? 'Time' : 'الوقت'
                                                    , style: TextStyle(
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.createTime}'
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
                                                      .button_next == 'Next' ? 'Date' : 'التاريخ'
                                                    , style: TextStyle(
                                                        fontSize: _fontSize, color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text('${widget.createDate}'
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20, right: 15, left: 15, bottom: 20),
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
                                child: Row(
                                  children: <Widget>[
                                    Spacer(),
                                    Text(AppModel.lamgug?'رجوع للمجالات':'Categories', style: TextStyle(
                                        fontSize: 13
                                    ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_back
                                    )
                                  ],
                                ),
                                color: Colors.green[900],
                                textColor: Colors.white,
                              ),
                            ),
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
        height: 400,
        width: 1.0,
        color: Colors.white12,
      ),
    );
  }
}


