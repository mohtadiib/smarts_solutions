import 'package:best_flutter_ui_templates/categories/categories.dart';
import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/utilities/animation_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/onboarding_screen.dart';
import 'dart:async';
import '../utilities/theme.dart';
import '../providor.dart';
class Splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<Splash> {

  bool showButton = true;
  int _durationInt = 2600;

  _showButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    print('welcome object is :'+showButton.toString());
    var _duration = new Duration(milliseconds: _durationInt);

    if (firstTime != null && !firstTime) {// Not first time
      return Timer(_duration, navigationPageHome);
    } else {// First time
      return showButton = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showButton();
    AppModel appModel = Provider.of<AppModel>(context , listen: false);
    AppModel().checkLang(appModel);
    _getNoti();
  }

  _getNoti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Cart cart = Provider.of<Cart>(context , listen: false);
    Cart().setNotification(
        cart ,
        prefs.getBool('notifi') ,
        prefs.getBool('notiPress') ,
        prefs.getBool('notiPayment')
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: myThemeData,
      debugShowCheckedModeBanner: false,
      home: _SplashScreen()
    );
  }

  Widget _SplashScreen(){
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: Padding(
              padding:
              EdgeInsets.only( right: 10,left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2,left: 2),
                      child:
                      Container(
                        child: FutureBuilder(
                            future: this._fetchData(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return LogoApp();
                                default:
                                  return Image.asset('assets/images/logo.png');
                              }
                            }
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                           Container(
                            child: FutureBuilder(
                                future: this._fetchData(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: Container()
                                      );
                                    default:
                                      return !showButton? _langugButton() : Container();
                                  }
                                }
                            ),
                          ),
                       ],
                     ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(),
                  )
                ],//
              ),
           ),
        ),
    );
  }

  _fetchData() async {
    await Future.delayed(Duration(milliseconds: _durationInt));
    return 'REMOTE DATA';
  }

  //---------------------------------tets welcome--------------------------------------

  _startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    print('welcome object is :'+firstTime.toString());

    if (firstTime != null && !firstTime) {// Not first time
      return navigationPageHome();
    } else {// First time
      return navigationPageWel();
    }
  }

  void navigationPageHome() {
    Navigator.pop(context);
    Navigator.of(context).push(PageRouteTransition(
        animationType:AnimationType.fade,
        builder: (context) => Categories()
      )
    );

  }

  void navigationPageWel() {
    Navigator.pop(context);
    Navigator.of(context).push(PageRouteTransition(
        animationType: AnimationType.fade,

        builder: (context) => OnboardingScreen()
      )
    );

  }


  //---------------------------------------------------------------------------


  Widget _langugButton(){
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _changeLang("ar",Padding(
                    padding: const EdgeInsets.only(top: 5 , bottom: 5),
                    child: Text('العربيــة' , style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                          )
                        ),
                      ),
                    ),
                  Container(
                    height: 5,
                  ),
                  _changeLang("en",
                    Padding(
                      padding: const EdgeInsets.only(top: 5 , bottom: 5),
                      child: Text('ENGLISH' , style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                        )
                      ),
                    ),
                   ),
                 ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _changeLang(String lang , Widget _widget){
    return  Consumer<AppModel>(
        builder: (context , model , child) => Padding(
          padding: const EdgeInsets.only(right: 70,left: 70,top: 5,bottom: 5),
          child: Container(
            child: FlatButton(
              onPressed: () {

                Navigator.pop(context);
                model.changeToAr(lang);
                _startTime();

              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff0d729a), Color(0xff104b85)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5,top: 3),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right:10,left:10),
                              child: _widget,
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
       );
     }
    }