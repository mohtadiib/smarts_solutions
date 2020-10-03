import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/screens/last_order/last_orders.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:best_flutter_ui_templates/translation_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providor.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  getDate(Timestamp inputVAl){
    String processedDate;
    processedDate = inputVAl.toString();
    return processedDate;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
      child: Consumer<AppModel>(
          builder: (context , model , child) {
            return Consumer<Cart>(
                builder: (context , cart , child) {
                  bool _notificPayment = cart.notifPayment , _notiPress = cart.notifBress;
                  print('notifBress  is : ${cart.notifBress}');
                  print('--------------------------------------------------');
                  print('notifPayment  is : ${cart.notifPayment}');
                  return Scaffold(
                        body: Column(
                          children: <Widget>[
                            customAppBar(Translations.of(context).notification_title,context),
                            !_notiPress && !_notificPayment?Padding(
                              padding: const EdgeInsets.only(top: 300),
                              child: Center(child: Text(AppModel.lamgug?'لا توجد اشعارات':'No Notifications',
                                style: TextStyle(
                                    fontSize: 18,color: Colors.grey
                                ),
                              )
                              ),
                            ):Column(
                              children: <Widget>[
                                _notiPress?newOrder():Container(),
                                _notificPayment?Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    newOrderPaymebt(),
                                  ],
                                ):Container(),
                              ],
                            ),
                          ],
                        ),
              );},
            );;
          }
      ),
    );
  }

  Widget newOrder(){
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
        Cart _cart = Provider.of<Cart>(context , listen: false);
        getPayNoti(_cart);
        Navigator.of(context).push(PageRouteTransition(
            animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
            builder: (context) => LastOrders()

        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
        child: Card(
          color: Colors.green[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 1,
          child: ListTile(
            title:  Text('${AppModel.lamgug?'طلب جديد':'New Order'}',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.green
              ),
            ),
            leading: Icon(
              Icons.new_releases,
              color: Colors.green[200],
            ),
            subtitle: Text('${AppModel.lamgug?'تم انشاء طلب جديد':'new order created'}',
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.green
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget newOrderPaymebt(){
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
/*
        Cart _cart = Provider.of<Cart>(context , listen: false);
        Cart().setNotification(_cart,false ,false, null);
*/
        Navigator.of(context).push(PageRouteTransition(
            animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
            builder: (context) => LastOrders()

          )
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 0,left: 5,right: 5),
        child: Card(
          color: Colors.orange[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 1,
          child: ListTile(
            title:  Text('${AppModel.lamgug?'اكمال الدفع':'Payment'}',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.orange
              ),
            ),
            leading: Icon(
              Icons.payment,
              color: Colors.orange[200],
            ),
            subtitle: Text('${AppModel.lamgug?'تم انشاء طلب ولم يتم تحديد طريقة الدفع ،يجب اكمال عملية الدفع حتي نستطيع معالجة طلبك':
            'An order has been created and the payment method has not been specified. The payment process must be completed'}',
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.orange
              ),
            ),
          ),
        ),
      ),
    );
  }

  getPayNoti(Cart cart) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('notiPayment  is : ${prefs.getBool('notiPayment')}');

    if(prefs.getBool('notiPayment') == false){
      cart.setNotification(cart,false,false,null);
    }else{
      cart.setNotification(cart,null,false,null);
    }
  }


}
