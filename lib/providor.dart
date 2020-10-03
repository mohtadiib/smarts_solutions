import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_app.dart';

class Providor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context , model , child) {
        return MyApp();
      },
    );
  }
}

class AppModel extends ChangeNotifier {


  static bool lamgug = true;
  Locale appLocale = Locale('en');
  Locale get appLocal => appLocale ?? Locale("ar");


  set setAppLocale(bool un){
    if(un){
      lamgug = true;
      appLocale = Locale('ar');
    }else{
      lamgug = false;
      appLocale = Locale('en');
    }
    notifyListeners();
  }

  checkLang(AppModel appModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool lang = prefs.getBool('lang');
    if (lang){// Not first time
      appModel.setAppLocale = true;
    } else {// First time
      appModel.setAppLocale = false;
    }
  }


  void changeToAr(String lang){

    if(lang == 'ar'){
      lamgug = true;
      _langSave(true);
    }else{
      lamgug = false;
      _langSave(false);
    }

    print(lamgug);

    appLocale = Locale(lang);

    notifyListeners();
  }


  _langSave(bool _lan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('lang',_lan);
  }
}
