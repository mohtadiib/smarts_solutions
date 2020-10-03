import 'dart:io';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';

import 'helps/contact_us.dart';
import 'helps/mogtarah.dart';
import 'providor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/copons/my_coupons.dart';
import 'screens/create_visit/latest_screen_visit.dart';
import 'screens/last_order/last_orders.dart';
import 'screens/lastest_screen.dart';
import 'screens/payment/get_payment_way.dart';
import 'screens/splash_screen.dart';
import 'translation.dart';
import 'utilities/theme.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Consumer<AppModel>(
        builder: (context , model , child) => ProgressDialog(
          //      loading: Container(
//        decoration: BoxDecoration(color: Color(0xa0000000), borderRadius: BorderRadius.all(Radius.circular(10.0))),
//        child: SpinKitRipple(size: 120, color: Colors.white),
//      ),
          orientation: ProgressOrientation.vertical,
          loadingText: AppModel.lamgug?"  حفظ البيانات  ":"  Saving  ",
          textStyle: TextStyle(
              fontSize: 11
          ),
          child: MaterialApp(
                locale: model.appLocal,
                localizationsDelegates: [
                   TranslationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                   Locale('ar', ''), // Arabic
                   Locale('en', ''), // English
                ],
                debugShowCheckedModeBanner: false,
                theme: myThemeData,
                title: "SMART SOLUTIONS",
                home: Scaffold(body: Directionality(textDirection: AppModel.lamgug?
                TextDirection.rtl:TextDirection.ltr,
                child: Splash()
                    )
                  ),
                ),
             ),
          );
        }

     }
