import 'package:flutter/material.dart';


snackShow(BuildContext context , String str ,Color color,Icon icon,GlobalKey<ScaffoldState> _scaffoldKey){
  final snackBar = SnackBar(
    backgroundColor: color,
    content: Container(
      child: Row(
        children: <Widget>[
          icon,
          SizedBox(
            width: 3,
          ),
          Container(
            child: Text(str,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11
              ),
            ),
          ),
        ],
      ),
    ),
    action: SnackBarAction(
      textColor: Colors.white,
      label: 'موافق',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  _scaffoldKey.currentState.showSnackBar(snackBar);
}
