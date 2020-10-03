import 'package:best_flutter_ui_templates/categories//categories.dart';
import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/modle/food_api.dart';
import 'package:best_flutter_ui_templates/modle/food_notifier.dart';
import 'package:best_flutter_ui_templates/my_app.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation_home_screen.dart';
import '../utilities/theme.dart';
import '../utilities/styles.dart';

import '../translation_strings.dart';

class OnboardingScreen extends StatefulWidget {

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 6;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;



  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  _goTo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('first_time') == null){
      prefs.setBool('first_time', false);
      prefs.setBool('notifi', false);
      prefs.setBool('login_user', false);

      Navigator.pop(context);
      Navigator.of(context).push(PageRouteTransition(
          animationType: AppModel.lamgug?AnimationType.slide_left:AnimationType.slide_right,
          builder: (context) => Categories()
       )
      );

      Cart cart = Provider.of<Cart>(context , listen: false);
      Cart().setNotification(cart ,false,false,false);

    }else{
      Navigator.pop(context);
      _startTime();
    }

  }
  _startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('first_time')){
      prefs.setBool('first_time', true);
    }else{
      prefs.setBool('first_time', false);
    }

    if(prefs.getBool('notifi')){
      prefs.setBool('notifi', true);
    }else{
      prefs.setBool('notifi', false);
    }

    if(prefs.getBool('login_user')){
      prefs.setBool('login_user', true);
    }else{
      prefs.setBool('login_user', false);
    }
  }



  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 9.0),
      height: 7,
      width: isActive ? 15.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: welcomScrn());
  }
  Widget welcomScrn(){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/welcome_background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: skipTestLan()== 'Skip' ? FractionalOffset.bottomRight : FractionalOffset.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: FlatButton(
                          color: Colors.white,
                          shape: StadiumBorder(),
                          onPressed: () {
                            _goTo();
                          },
                          child: Text(
                            Translations.of(context).Skip,
                            style: TextStyle(
                              color: colorPrimary(),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Container(
                      child: PageView(
                        physics: ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          welScreen(Translations.of(context).welcome1_title
                              ,Translations.of(context).welcome1_subtitle,'well_first.png' , 250,250),

                          welScreen(Translations.of(context).welcome2_title
                              ,Translations.of(context).welcome2_subtitle,'well_tow.png', 250,250),

                          welScreen(Translations.of(context).welcome3_title
                              ,Translations.of(context).welcome3_subtitle,'well_service.png', 220,220),

                          welScreen(Translations.of(context).welcome4_title
                              ,Translations.of(context).welcome4_subtitle,'wel_staer.png', 250,250),

                          welScreen(Translations.of(context).welcome5_title
                              ,Translations.of(context).welcome5_subtitle,'well_condetion.png', 180,180),

                          Center(
                            child: ListView(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top:50,right: 20,left: 20),
                                  child: Image(
                                    image: AssetImage( skipTestLan()== 'Skip' ?
                                    'assets/images/welcome_image/welcome6en.png' : 'assets/images/welcome_image/welcome6ar.png',
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
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: skipTestLan()== 'Skip' ? FractionalOffset.bottomRight : FractionalOffset.bottomLeft,
                      child: FlatButton(
                        color: Colors.white,
                        shape: StadiumBorder(),
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              Translations.of(context).Next,
                              style: TextStyle(
                                color: colorPrimary(),
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: colorPrimary(),
                              size: 15,
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
        bottomSheet: _currentPage == _numPages - 1
            ? GestureDetector(
          onTap: (){
            _goTo();
          },
          child: Container(
          height: 80.0,
          width: double.infinity,
          color: colorPrimary(),
          child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 0.0),
                child: Text(
                  Translations.of(context).getStarted,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: colorWhite(),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ),
        ),
            )
            : Text(''),
      ),
    );
  }

  Widget welScreen(String title ,String subtitle ,String image, double width ,double height){
    return  Padding(
      padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 30),
      child: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(20)),
                  ),
                  child: Image(
                    image: AssetImage(
                      'assets/images/welcome_image/'+image,
                    ),
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 20,left: 20),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: Colors.blue[900],
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 5.0),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: Colors.blue[900]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color colorPrimary(){
    return Theme.of(context).primaryColorDark;
  }

  Color colorWhite(){
    return Colors.white;
  }

  String skipTestLan(){
    return Translations.of(context).Skip;
  }

}
