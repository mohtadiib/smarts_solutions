import 'package:best_flutter_ui_templates/categories//categories.dart';
import 'package:best_flutter_ui_templates/helps/logoin_choose.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/screens/user/profile/region_not_service_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/utilities/snack_bar.dart';
import 'package:best_flutter_ui_templates/network/insert_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../translation_strings.dart';
import '../../map_view.dart';
import '../../visite_time.dart';
import 'package:provider/provider.dart';
import '../../../modle/cart.dart';
import 'login_phone_pass.dart';
import 'login_with_google.dart';
import 'loginpage.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class AuthService {

/*  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return CompleteData();
          } else {
            return LoginPage();
           }
          }
        );
       }*/

  editPhone(VoidCallback voidCallback,BuildContext context) {
    signOut(() {
      Navigator.of(context).push(PageRouteTransition(
          animationType: AnimationType2.slide_up,
          builder: (context){
            return StreamBuilder(
                stream: FirebaseAuth.instance.onAuthStateChanged,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    voidCallback();
                    return GoBack();
                  } else {
                    return LoginPage();
                  }
                }
            );
          }
         )
        );
      }
    );
  }

  //Sign out
  signOut(VoidCallback voidCallback) {
    FirebaseAuth.instance.signOut().whenComplete((){
      voidCallback();
    });
  }
  //SignIn
  signIn(AuthCredential authCreds,VoidCallback voidCallback) {
    FirebaseAuth.instance.signInWithCredential(authCreds).whenComplete((){
      voidCallback();
    });
  }
  signInWithOTP(smsCode, verId,BuildContext context,VoidCallback voidCallback) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds,(){
      voidCallback();
    });
  }
  setTestPage(int text)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    prefs.setInt('selectPage', text);
  }

  setEditPhone(int text)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    prefs.setInt('editPhone', text);
  }

  //prefs.setBool('login_user', true);
  getLoginUser(BuildContext context,GlobalKey<ScaffoldState> _scaffoldKey) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time

    if(prefs.getBool('login_user')){
      goToSelectPage(context);
      print('num11 login here: ${prefs.getBool('login_user')}');

    }else {
      print('check user login here: ${prefs.getBool('login_user')}');

      AuthService().showLoginDialog(
          context,
          _scaffoldKey,
          AppModel.lamgug?'رجاءاً قم بإنشاء حساب او تسجيل الدخول حتى تستطيع إكمال الطلب':
          'Please make an account or login so you can create an order'
      );
    }
  }


  _logout(VoidCallback voidCallback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthService().signOut((){
      handleSignOut((){
        prefs.setBool('login_user', false);
        prefs.setString('name', null);
        prefs.setString('region', null);
        prefs.setString('pass', null);
        prefs.setString('userPhone', null);
        prefs.setString('email', null);
        prefs.setString('user_docId', null);
        prefs.setString('photoUrl', null);
        voidCallback();
      });
    });
  }
  bool progress = false;

  showLoginDialog(BuildContext context,GlobalKey<ScaffoldState> _scaffoldKey,String _title) {
    slideDialog.showSlideDialog(
        context: context,
        child: LoginChoose(
          scaffoldKey: _scaffoldKey,
          title: _title,
        )
    );
  }

  GoogleSignInAccount _currentUser;
  String _contactText;

  goToSelectPage(BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    setLogin();
    int _selectPage = prefs.getInt('selectPage');
    Navigator.of(context).push(PageRouteTransition(
        animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
        builder: (context){
          if(_selectPage == 1){
            return Categories();
          }else if(_selectPage == 2){
            return MapViewPage(
                date_ar: 'direct',
                date_en: 'dfgh',
                time_ar: 'dfghdg');
           }else{
            return VisiteTime();
          }
        }
      )
    );
  }


  setLogin()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login_user', true);
  }

  void showProgressDialog() {}


}

class GoBack extends StatefulWidget {
  @override
  _GoBackState createState() => _GoBackState();
}

class _GoBackState extends State<GoBack> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}

logout(VoidCallback voidCallback) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  AuthService().signOut((){
    handleSignOut((){
      prefs.setBool('login_user', false);
      prefs.setString('name', null);
      prefs.setString('region', null);
      prefs.setString('pass', null);
      prefs.setString('userPhone', null);
      prefs.setString('email', null);
      prefs.setString('user_docId', null);
      prefs.setString('photoUrl', null);
      voidCallback();
    });
  });
}

Future<void> ackAlert(BuildContext context , String txt) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return ServiceNotFound();
    },
  );
}


