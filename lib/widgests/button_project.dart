
import 'package:flutter/material.dart';

Widget buttonProject(Icon icon ,String name ,Color color,VoidCallback voidCallback){
  return FlatButton(
    onPressed: () {
      voidCallback();
    },
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    color: color,
    padding: EdgeInsets.all(0.0),
    child:  Container(
      height: 50,
      width: 300,
      alignment: Alignment.center,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Spacer(
              flex: 5,
            ),
            Padding(
              padding: EdgeInsets.only(right:10,left:10),
              child: Text(name , style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
              ),
              ),
            ),
            Spacer(
              flex: 3,
            ),
            icon,
            Spacer(
              flex: 1,
            ),
          ]
      ),
    ),
  );

}