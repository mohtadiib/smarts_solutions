import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providor.dart';
import '../../../translation_strings.dart';

class ServiceNotFound extends StatefulWidget {

  @override
  _ServiceNotFoundState createState() => new _ServiceNotFoundState();
}

class _ServiceNotFoundState extends State<ServiceNotFound> {

  String orderStatus;
  bool progress = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _content_ar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            '',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height*0.2,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child:
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.2,
                            child: ListView(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Container(
                                      child: Text( Cart.complete_data_disable_country,
                                        textAlign: TextAlign.center,
                                        maxLines: 17,
                                        style: TextStyle(
                                            color: Colors.grey[600],fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8,right: 15,top: 5,bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          Translations.of(context).button_agree,
                                          style: TextStyle(color: Colors.grey[600],fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  color: Colors.grey[100],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}