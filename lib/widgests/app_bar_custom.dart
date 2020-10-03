import 'package:best_flutter_ui_templates/screens/help/help.dart';
import 'package:best_flutter_ui_templates/screens/notification/notification.dart';
import 'package:best_flutter_ui_templates/screens/user/login/authservice.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providor.dart';

Widget customAppBar(String title ,BuildContext context){
  return Column(
    children: <Widget>[
      SizedBox(
        height: 26,
      ),
      Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                2.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 0,bottom: 0,left: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Spacer(
                flex: 1,
              ),
              ClipOval(
                  child: Material(
                    color: Colors.transparent, // button color
                    child: InkWell(
                      child: SizedBox(width: 40, height: 40, child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).primaryColor,
                      ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
              ),
              Spacer(
                flex: 6,
              ),
              Text(
                title,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
              ),
              Spacer(
                flex: 6,
              ),
              ClipOval(
                  child: Material(
                    color: Colors.transparent, // button color
                    child: InkWell(
                      child: SizedBox(width: 40, height: 40, child: Icon(
                        Icons.help,
                        color: Theme.of(context).primaryColor,
                      ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(PageRouteTransition(
                            animationType: AppModel.lamgug? AnimationType2.slide_left: AnimationType2.slide_right,
                            builder: (context) => Helps()
                          )
                        );
                      },
                    ),
                  )
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}