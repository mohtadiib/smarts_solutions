import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providor.dart';

class Moqtarah extends StatefulWidget {

  String name;
  Moqtarah({this.name});
  @override
  _MoqtarahState createState() => _MoqtarahState();
}

class _MoqtarahState extends State<Moqtarah> {

  String _user_id;
  printId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    setState(() {
      _user_id = prefs.getString('user_docId');
    });
    print('user id here : ${_user_id}');
  }


  _addMoqta(String moq_details,user_id,VoidCallback voidCallback)async{
    final collRef = Firestore.instance.collection('moqtarahat');
    DocumentReference docReference = collRef.document();
    docReference.setData({
      'user_id' : user_id,
      'moq_id' : docReference.documentID,
      'moq_details' : moq_details,
    }
    ).whenComplete((){
      voidCallback();
    }
    );
  }
  final _ormKey = new GlobalKey<FormState>();
  final _username = TextEditingController();
  bool progressButton = false , sendDone = false;


  @override
  void initState() {
    printId();
    // TODO: implement initState
    super.initState();
    setState(() {
      _username.text = widget.name;
       }
     );
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Form(
            key: _ormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.9,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Image(
                                image: AssetImage(
                                  'assets/notifi/eqtrah.png',
                                ),
                                height: MediaQuery.of(context).size.height*0.3,
                                width: MediaQuery.of(context).size.height*0.9,
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 20,left: 20,top: 20),
                              child: TextFormField(
                                maxLines: 10,
                                style :TextStyle(
                                  color: Colors.green,
                                  fontSize: 15,
                                ),
                                controller: _username,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return AppModel.lamgug?'الرجاء ادخال قيمة':'please inter value';}
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: AppModel.lamgug?'اكتب استفسار أو اقتراح':'Write an inquiry or suggestion',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20, right: 20, left: 20, bottom: 5),
                            child: Container(
                              child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: FlatButton(
                                    onPressed: () {
                                      if (_ormKey.currentState.validate()) {
                                        _addMoqta(_username.text,_user_id,(){
                                          setState(() {
                                            progressButton = false;
                                            sendDone = true;
                                             }
                                           );
                                          }
                                        );
                                        setState(() {
                                          progressButton = true;
                                        }
                                        );
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: !progressButton? Row(
                                      children: <Widget>[
                                        Spacer(),
                                        Text(sendDone?AppModel.lamgug?'تم الارسال':'Send Done':AppModel.lamgug?'ارسال':'Send', style: TextStyle(
                                            fontSize: 16
                                         ),
                                        ),
                                        Spacer(),
                                        Icon(
                                            sendDone?Icons.done:Icons.send
                                        )
                                      ],
                                    ):CupertinoActivityIndicator(),
                                    color: sendDone?Colors.green:!progressButton?Colors.blue:Colors.blue[100],
                                    textColor: Colors.white,
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                      AppModel.lamgug?'ساعدنا برأيك':'Help US',
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
}
