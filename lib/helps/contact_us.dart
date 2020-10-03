import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/screens/last_order/map_orders.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'network/contact_provider.dart';

import '../translation_strings.dart';
import 'network/model_contact.dart';

class ContactUS extends StatefulWidget {
  ContactUSState createState() => new ContactUSState();
}
class ContactUSState extends State<ContactUS> {

  bool progre = true;
  @override
  void initState() {
    super.initState();
    ContactProvider directOrderProvider = Provider.of<ContactProvider>(context , listen: false);
    ContactProvider().getContactData(directOrderProvider,(){
      setState(() {
        progre = false;
      });
    });
  }
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Consumer<ContactProvider>(  //37 19 08 25 218
            builder: (context , contact , child){
              return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('units').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return Center(child: new CupertinoActivityIndicator());
                    default:
                      return new ListView(
                        children: snapshot.data.documents.map((DocumentSnapshot document) {
                          return Column(
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Image(
                                    image: AssetImage(
                                      'assets/notifi/contact.png',
                                    ),
                                    height: MediaQuery.of(context).size.height*0.4,
                                    width: MediaQuery.of(context).size.height*0.9,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: FlatButton(
                                      onPressed: () {
                                        UrlLauncher.launch('tel:+${document['contactPhone']}');
                                      },
                                      shape: CircleBorder(),
                                      child :Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.call,color: Colors.white,size: 18,
                                          ),
                                        ],
                                      )
                                      , color: iconColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(
                                        document['contactPhone'],
                                        textAlign: AppModel.lamgug?TextAlign.end:TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15.0,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: (){
                                        UrlLauncher.launch('tel:+${249920749357}');
                                      },
                                      child: Text(
                                        AppModel.lamgug?'اتصال؟':'Call?',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue,
                                          fontSize: 12,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                child: Divider(
                                  color: Colors.grey[350],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: FlatButton(
                                      onPressed: () {
                                        launchEmail(document['contactEmail']);
                                      },
                                      shape: CircleBorder(),
                                      child :Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.email,color: Colors.white,size: 15,
                                          ),
                                        ],
                                      )
                                      , color: iconColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: AppModel.lamgug?30:0,right: AppModel.lamgug?0:30),
                                        child: Text(
                                          document['contactEmail'],
                                          textAlign: AppModel.lamgug?TextAlign.end:TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: (){
                                        launchEmail(document['contactEmail']);
                                      },
                                      child: Text(
                                        AppModel.lamgug?'مراسلة؟':'Send?',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue,
                                          fontSize: 12,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                child: Divider(
                                  color: Colors.grey[350],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: FlatButton(
                                      onPressed: () {

                                      },
                                      shape: CircleBorder(),
                                      child :Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,color: Colors.white,size: 18,
                                          ),
                                        ],
                                      )
                                      , color: iconColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(
                                        AppModel.lamgug?document['address']:document['address_en'],
                                        textAlign: AppModel.lamgug?TextAlign.end:TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                child: Divider(
                                  color: Colors.grey[350],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Spacer(),
                                  Expanded(
                                    flex: 3,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).push(PageRouteTransition(
                                            animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                            builder: (context) => MapOrders(
                                              lat: document['lat'].toString(),
                                              lng: document['lng'].toString(),
                                              orderId: 'SmartSolution',
                                            )
                                        )
                                        );

                                      },
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                      padding: EdgeInsets.all(0.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              AppModel.lamgug?'الموقع على الخريطة':'On Map',
                                              style: TextStyle(color: Colors.white,fontSize: 13),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.map,color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      color: iconColor,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              )
                            ],
                          );
                        }).toList(),
                      );
                  }
                },
              )/*_listLastVisitOrders(contact.listLastVisitList)*/;
            },
          ),
          Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 50,right: 10,left: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10,),
                    Text(
                      AppModel.lamgug?'تواصل معنا':'Help US',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color iconColor = Colors.blue[600];

  Widget _listLastVisitOrders(List <ModelContact> _list){
    int indexx = 0;
    return progre?Center(child: CupertinoActivityIndicator()):Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height*0.94,
          child: ListView(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image(
                    image: AssetImage(
                      'assets/notifi/contact.png',
                    ),
                    height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.height*0.9,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      onPressed: () {
                        UrlLauncher.launch('tel:+${_list[indexx].contactPhone}');
                      },
                      shape: CircleBorder(),
                      child :Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.call,color: Colors.white,size: 18,
                          ),
                        ],
                      )
                      , color: iconColor,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        _list[indexx].contactPhone,
                        textAlign: AppModel.lamgug?TextAlign.end:TextAlign.start,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15.0,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        UrlLauncher.launch('tel:+${249920749357}');
                      },
                      child: Text(
                        AppModel.lamgug?'اتصال؟':'Call?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: Divider(
                  color: Colors.grey[350],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      onPressed: () {
                        launchEmail(_list[indexx].contactEmail);
                      },
                      shape: CircleBorder(),
                      child :Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.email,color: Colors.white,size: 15,
                          ),
                        ],
                      )
                      , color: iconColor,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        _list[indexx].contactEmail,
                        textAlign: AppModel.lamgug?TextAlign.end:TextAlign.start,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        launchEmail(_list[indexx].contactEmail);
                      },
                      child: Text(
                        AppModel.lamgug?'مراسلة؟':'Send?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: Divider(
                  color: Colors.grey[350],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      onPressed: () {

                      },
                      shape: CircleBorder(),
                      child :Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,color: Colors.white,size: 18,
                          ),
                        ],
                      )
                      , color: iconColor,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        AppModel.lamgug?_list[indexx].address:_list[indexx].address_en,
                        textAlign: AppModel.lamgug?TextAlign.end:TextAlign.start,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15.0,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: Divider(
                  color: Colors.grey[350],
                ),
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Expanded(
                    flex: 3,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(PageRouteTransition(
                            animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                            builder: (context) => MapOrders(
                              lat: _list[indexx].lat,
                              lng: _list[indexx].lng,
                              orderId: 'SmartSolution',
                            )
                        )
                        );

                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      padding: EdgeInsets.all(0.0),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AppModel.lamgug?'الموقع على الخريطة':'On Map',
                              style: TextStyle(color: Colors.white,fontSize: 15),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.map,color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      color: iconColor,
                    ),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  launchEmail(String email) async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }

}