import 'package:best_flutter_ui_templates/screens/notification/notification.dart';
import 'package:best_flutter_ui_templates/screens/user/login/authservice.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:best_flutter_ui_templates/translation_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providor.dart';
import 'help_items.dart';

class Helps extends StatefulWidget {
  @override
  _HelpsState createState() => _HelpsState();
}

class _HelpsState extends State<Helps> {

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
      child: Consumer<AppModel>(
          builder: (context , model , child) {
            return Scaffold(
              body: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 1, // has the effect of softening the shadow
                              spreadRadius: 0.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                1.0, // vertical, move down 10
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
                                flex: 5,
                              ),
                              Text(
                                Translations.of(context).help_title,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Spacer(
                                flex: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                    Expanded(
                      flex: 10,
                      child: Padding(
                       padding: EdgeInsets.only(right: 10,left: 10),
                       child: Container(
                        child: Center(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance.collection('helps').snapshots(),
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
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(PageRouteTransition(
                                              animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                              builder: (context) => HelpsDetails(
                                                title: AppModel.lamgug?document['title_ar']:document['title_en'],
                                                title_ar: document['title_ar'],
                                              )

                                          ));
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.white, width: 1),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          elevation: 1,
                                          child: ListTile(
                                            title:  Text('${AppModel.lamgug?document['title_ar']:document['title_en']}',
                                              style: TextStyle(
                                                  fontSize: 16
                                              ),
                                            ),
                                            subtitle: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:5,
                                                  child: Text('${AppModel.lamgug?document['content_ar']:document['content_en']}',
                                                    style: TextStyle(
                                                      fontSize: 13
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Icon(
                                                    Icons.more_horiz,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            leading: Icon(
                                                Icons.help
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    ).toList(),
                                  );
                               }
                            },
                          ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );;
          }
      ),
    );
  }
}
