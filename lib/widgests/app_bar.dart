import 'package:flutter/material.dart';

AppBar myAppBar(String title,BuildContext context){
  return AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    title: Center(child: Text(title)),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () {
          print('Click search');
        },
      ),
      IconButton(
        icon: Icon(Icons.help),
        onPressed: () {
          print('Click start');
        },
      ),
    ],
  );
}