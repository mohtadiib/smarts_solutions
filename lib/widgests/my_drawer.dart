import 'package:best_flutter_ui_templates/helps/contact_us.dart';
import 'package:best_flutter_ui_templates/helps/logoin_choose.dart';
import 'package:best_flutter_ui_templates/helps/mogtarah.dart';
import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/network/insert_profile.dart';
import 'package:best_flutter_ui_templates/screens/copons/my_coupons.dart';
import 'package:best_flutter_ui_templates/screens/notification/notification.dart';
import 'package:best_flutter_ui_templates/screens/onboarding_screen.dart';
import 'package:best_flutter_ui_templates/screens/user/login/login_with_google.dart';
import 'package:best_flutter_ui_templates/screens/user/profile/profile.dart';
import 'package:best_flutter_ui_templates/utilities/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'dart:convert' show json;
import 'package:best_flutter_ui_templates/screens/help/help.dart';
import 'package:best_flutter_ui_templates/screens/last_order/last_orders.dart';
import 'package:best_flutter_ui_templates/screens/user/login/authservice.dart';
import 'package:best_flutter_ui_templates/translation_strings.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';
import '../providor.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:share/share.dart';


class CustomDrawer extends StatefulWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  BuildContext context;
   CustomDrawer({this.scaffoldKey,this.context});

  @override
  CustomDrawerState createState() {
    return CustomDrawerState();
  }
}
class CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {

       String _urlUserImage , _userName , _userEmail , _phone;
       _showButton() async {
         SharedPreferences prefs = await SharedPreferences.getInstance();
         setState(() {
           _urlUserImage = prefs.getString('photoUrl');
           if(prefs.getString('name') == null){
             _userName = AppModel.lamgug?'لم يحدد':'not found';
           }else{
             _userName = prefs.getString('name');
           }

           if(prefs.getString('userPhone') == null){
             _phone = AppModel.lamgug?'لم يحدد':'not found';
           }else{
             _phone = prefs.getString('userPhone');
           }
           if(prefs.getString('email') == null){
             _userEmail = AppModel.lamgug?'لم يحدد':'not found';
            }else{
             _userEmail = prefs.getString('email');
           }

           }
         );
       }
       bool _googleProg = false;

       @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showButton();
    }


   //----------------------------google sign in-------------------------------------------------
   GoogleSignInAccount _currentUser;
       String _contactText;
       _getGoogledata() async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // First time
        prefs.setString('photoUrl', _currentUser.photoUrl);
        prefs.setString('name', _currentUser.displayName);
        prefs.setString('email', _currentUser.email);

      }
     bool progLogOut = false;
   @override
  Widget build(BuildContext context) {
        print('login here is ok :${_userName}');
    return Consumer<Cart>(
        builder: (context , cart , child) {
          bool _testLogin = cart.testLogin;
          return Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          ClipPath(
            child: Material(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)
              ),
              child: Stack(
                children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius:AppModel.lamgug? BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20)
                            ):BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                           ),
                          ),
                            height: double.infinity ,
                            width: MediaQuery.of(context).size.width - 80,
                            child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: AppTheme.grey.withOpacity(0.6),
                                              offset: Offset(_testLogin?2.0:0,_testLogin? 4.0:0),
                                              blurRadius: _testLogin?8:0),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(70)),
                                        child: Container(
                                          color: Colors.white,
                                          child: _testLogin?_urlUserImage != null?FadeInImage.assetNetwork(
                                            height: 230,
                                            fit: BoxFit.fill,
                                            placeholder: 'assets/images/profile_image.png',
                                            image: _urlUserImage,
                                          ): Image(
                                              image: AssetImage(
                                                'assets/images/profile_image.png',
                                              )
                                          ):ClipRRect(
                                            borderRadius:
                                            const BorderRadius.all(Radius.circular(70)),
                                            child: SvgPicture.asset(
                                              'assets/user.svg',
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    _testLogin?Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '$_userName',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Cabin Sketch',
                                              color: Colors.grey[600]),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _userEmail != null?'$_userEmail':'${_phone}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Cabin Sketch',
                                              color: Colors.grey[500]),
                                        ),
                                      ],
                                    ):
                                    Container(),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  children: <Widget>[
                                    buildCard(_testLogin?AppModel.lamgug?'الملف الشخصي':'My Profile':
                                    AppModel.lamgug?'تسجيل الدخول':'Login', Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ), () {
                                      if(!_testLogin){
                                        AuthService().setTestPage(3);
                                        AuthService().showLoginDialog(
                                            widget.context,
                                            widget.scaffoldKey,
                                          AppModel.lamgug?'تسجيل الدخول وانشاء حساب':'Login or create acount'
                                        );
                                      }else{
                                        Navigator.of(context).push(PageRouteTransition(
                                            animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                            builder: (context) => Profile()
                                          )
                                        );
                                      }
                                    },Colors.grey[300]),
                                    _testLogin?buildCard(Translations.of(context).last_order,Icon(
                                      Icons.shopping_cart,
                                      color: Colors.grey,
                                    ), () {
                                      Navigator.of(context).push(PageRouteTransition(
                                          animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                          builder: (context) => LastOrders()
                                      )
                                      );
                                    },Colors.grey[300]):Container(),
                                    cart.notification?
                                    Column(
                                      children: <Widget>[
                                        FlatButton(
                                          onPressed: (){
                                            Navigator.of(context).push(PageRouteTransition(
                                                animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                                builder: (context) => Notifications()
                                            )
                                            );
                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(width: 10),
                                              Container(
                                                width: 20,
                                                height: 20,
                                                child: Icon(
                                                  Icons.notifications,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Row(
                                                children: [
                                                  Text(
                                                    Translations.of(context).notifi,
                                                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    decoration: new BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    width: 10,
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 30,right: 50,top: 0),
                                          child: Divider(
                                            color: Colors.grey[300],
                                          ),
                                        )
                                      ],
                                    ):
                                    buildCard(Translations.of(context).notifi,Icon(
                                      Icons.notifications,
                                      color: Colors.grey,
                                    ), () {
                                      Navigator.of(context).push(PageRouteTransition(
                                          animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                          builder: (context) => Notifications()
                                      )
                                      );
                                    },Colors.grey[300]),
                                    _testLogin?buildCard(AppModel.lamgug?'الرمز الترويجي':'Coupon',Icon(
                                      Icons.shopping_basket,
                                      color: Colors.grey,
                                    ), () {
                                      Navigator.of(context).push(PageRouteTransition(
                                          animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                          builder: (context) => MyCoupons()
                                      )
                                      );
                                    },Colors.grey[300]):Container(),
                                    buildCard(Translations.of(context).help, Icon(
                                      Icons.help,
                                      color: Colors.grey,
                                    ), () {
                                      Navigator.of(context).push(PageRouteTransition(
                                          animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                          builder: (context) => Helps()
                                      )
                                      );
                                    },Colors.grey[300]),

                                    buildCard(AppModel.lamgug?'الترحيب':'Welcome',Icon(
                                      Icons.subscriptions,
                                      color: Colors.grey,
                                    ), () {
                                      Navigator.of(context).push(PageRouteTransition(
                                          animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                          builder: (context) => OnboardingScreen()
                                      )
                                      );
                                    },_testLogin?Colors.grey[300]:Colors.transparent),

                                    _testLogin?
                                    progLogOut?
                                    Column(
                                      children: <Widget>[
                                        FlatButton(
                                          onPressed: (){},
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(width: 10),
                                              Container(
                                                width: 20,
                                                height: 20,
                                                child: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Row(
                                                children: [
                                                  Text(
                                                    Translations.of(context).log_out,
                                                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  CupertinoActivityIndicator()
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 30,right: 50,top: 0),
                                          child: Divider(
                                            color: Colors.transparent,
                                          ),
                                        )
                                      ],
                                    ):
                                    buildCard(Translations.of(context).log_out,Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.grey,
                                    ), () {
                                      setState(() {
                                        progLogOut = true;
                                      });
                                      logout((){
                                        setState(() {
                                          progLogOut = false;
                                        });

                                        Cart().setNotification(cart,false , false ,false);
                                        Navigator.pop(context);
                                        Cart foodNotifier = Provider.of<Cart>(context , listen: false);
                                        Cart().setImageUser(foodNotifier);
                                      });
                                    },Colors.transparent):Container(),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5,right: 5,top: 0,bottom: 10),
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    buildCard(AppModel.lamgug?'تواصل معنا':'Contact US',Icon(
                                      Icons.call,
                                      color: Colors.grey,
                                    ), () {
                                      Navigator.of(context).push(PageRouteTransition(
                                          animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                          builder: (context) => ContactUS()
                                      )
                                      );
                                    },Colors.grey[300]),

                                    _testLogin?buildCard(AppModel.lamgug?'مقترحات':'Welcome',Icon(
                                      Icons.inbox,
                                      color: Colors.grey,
                                    ), () {
                                      Navigator.of(context).push(PageRouteTransition(
                                          animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                          builder: (context) => Moqtarah()
                                      )
                                      );
                                    },Colors.grey[300]):Container(),

                                    buildCard(AppModel.lamgug?'مشاركة التطبيق':'Share App',Icon(
                                      Icons.share,
                                      color: Colors.grey,
                                    ), () {
                                      Share.share('${cart.shareApp}');

                                    },Colors.transparent),

                                  ],
                                ),
                              ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      child: Consumer<AppModel>(
                                        builder: (context , model , child) => Container(
                                          child: FlatButton(
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(10),
                                            ),
                                            color: Translations.of(context).help == "Help"?
                                            Colors.blue : Colors.white,
                                            textColor: Colors.blue,
                                            padding: EdgeInsets.all(5),
                                            onPressed: () {
                                              model.changeToAr('en');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                "english".toUpperCase(),
                                                style: TextStyle(
                                                  color: Translations.of(context).help == "Help"?
                                                  Colors.white : Colors.blue,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Consumer<AppModel>(
                                        builder: (context , model , child) => Container(
                                          child: FlatButton(
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(10),
                                            ),
                                            color: Translations.of(context).help == "Help"?
                                            Colors.white : Colors.blue,
                                            textColor: Colors.blue,
                                            padding: EdgeInsets.all(5),
                                            onPressed: () {
                                              model.changeToAr('ar');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 0),
                                              child: Text(
                                                "عربي",
                                                style: TextStyle(
                                                  color: Translations.of(context).help == "Help"?
                                                  Colors.blue : Colors.white,
                                                  fontWeight: Translations.of(context).help == "Help"?
                                                  FontWeight.bold : FontWeight.normal,
                                                  fontSize: 15,
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
                ],
              ),
            ),
          ),
        ],
      );},
    );
  }

  buildCard(String title, Icon imageIcon, VoidCallback callback ,Color color) {
    return Column(
      children: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
            callback();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10),
              Container(
                width: 20,
                height: 20,
                child: imageIcon,
              ),
              SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            ],
          ),
        ),
          Padding(
            padding: EdgeInsets.only(left: 30,right: 50,top: 0),
            child: Divider(
                color: color,
              ),
          )
      ],
    );
  }
}