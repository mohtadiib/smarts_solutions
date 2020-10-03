import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providor.dart';

class HelpsDetails extends StatefulWidget {

  String title , title_ar;
  HelpsDetails({this.title,this.title_ar});
  @override
  _HelpsDetailsState createState() => _HelpsDetailsState();
}

class _HelpsDetailsState extends State<HelpsDetails> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showButton();
  }

  bool _notific;

  _showButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _notifi = prefs.getBool('notifi');

    setState(() {
      _notific = _notifi;
    });
  }
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            customAppBar(widget.title,context),
            Expanded(
              flex: 10,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('helps').where('title_ar',isEqualTo: widget.title_ar).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                          child: new CircularProgressIndicator());
                    default:
                      return ListView(
                        children: snapshot.data.documents.map((
                            DocumentSnapshot document) {
                          return Padding(
                            padding: EdgeInsets.only(right: 10,left: 10,top: 10,bottom: 10),
                            child:  Container(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 1,
                                  child:  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(AppModel.lamgug?document['content_ar']:document['content_en'],
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                           }
                        ).toList(),
                      );
                   }
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}
