import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/utilities/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/widgets.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providor.dart';
import '../../translation_strings.dart';
import 'get_dat.dart';

class AddCopons extends StatefulWidget {

  String price_new_cop ,cop_limit,cop_count_use , showResult_ar,showEn,sendText , more_price;
  AddCopons({this.price_new_cop ,this.cop_limit,this.cop_count_use,this.showResult_ar,this.showEn,this.sendText,this.more_price});
  @override
  _AddCoponsState createState() => _AddCoponsState();
}

class _AddCoponsState extends State<AddCopons> {

  bool itemActive = true , _login;
  bool langChang , _progressButton = false , regionValid = true,
      regionLoding = false;
  final formKey = new GlobalKey<FormState>();

  String  _coponGet;

  @override
  void initState() {

    Cart foodNotifier = Provider.of<Cart>(context , listen: false);
    Cart().getUnitCantery(foodNotifier,(){

    });
    donecreateCode = true;
    setState(() {
      langChang = AppModel.lamgug;
      donecreateCode = false;
     }
    );
    super.initState();

  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        body: Form(
          key: formKey,
          child: Consumer<Cart>(
        builder: (context , cart , child) {
                //print('my list : '+cart.listMyCart.length.toString());
                return  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 30,right: 10,left: 20),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: Colors.black54,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        SizedBox(width: 30,),
                                        Text(
                                          AppModel.lamgug?'اضافة كوبون':'Coupon',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Spacer(),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30,bottom: 20,left: 40,right: 40),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Theme.of(context).primaryColor,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return AppModel.lamgug?'ادخل الرمز الترويجي':'Enter a Copon';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(Icons.new_releases),
                                                  labelText: AppModel.lamgug?'ادخل رمز ':'Enter a Copon',
                                                ),
                                                keyboardType: TextInputType.text,
                                                textCapitalization: TextCapitalization.sentences,
                                                maxLength: 5,
                                                onChanged: (val) {
                                                  setState(() {
                                                    this._coponGet = val;
                                                  }
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, right: 20, left: 20, bottom: 5),
                                            child: Container(
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: FlatButton(
                                                  onPressed: () {
                                                    _saveNewCop('ريال','SRC');
                                                    setState(() {
                                                      _progressButton = true;
                                                    });

                                                    if (formKey.currentState.validate()) {
                                                      setState(() {
                                                        _progressButton = true;
                                                      });
                                                      _checkCoupon(_coponGet,cart.unit_ar,cart.unit_en);
                                                    }
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  child: !donecreateCode?!_progressButton?
                                                  Text(Translations.of(context).button_agree,
                                                    style: TextStyle(
                                                      fontSize: 17
                                                  ),):CupertinoActivityIndicator()
                                                      :Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Spacer(),
                                                          Text(AppModel.lamgug?'تمت العملية':'Done', style
                                                           : TextStyle(
                                                          fontSize: 13
                                                    ),
                                                  ),
                                                          Spacer(),
                                                          Icon(
                                                            Icons.done
                                                          )
                                                        ],
                                                      ),
                                                  color: !donecreateCode?!_progressButton?Theme
                                                      .of(context)
                                                      .primaryColorDark:Theme.of(context).primaryColorLight:
                                                        Colors.green[200],
                                                  textColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          donecreateCode?Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: new EdgeInsets.only(top: 0,right: 20,left: 20),
                                                child: Container(
                                                  height: 150,
                                                  child: FlipCard(
                                                    direction: FlipDirection.HORIZONTAL, // default
                                                    front: Container(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(10)),
                                                          color: Theme.of(context).primaryColorLight.withOpacity(1),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.4),
                                                              spreadRadius: 3,
                                                              blurRadius: 6,
                                                              offset: Offset(0, 1), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child:  Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <Widget>[
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(right: 20),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Icon(
                                                                            Icons.bookmark_border,
                                                                            color: Theme.of(context).primaryColor
                                                                        ),
                                                                        SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        Text('${widget.price_new_cop}',style: TextStyle(
                                                                            fontSize: 18,
                                                                            color: Theme.of(context).primaryColor
                                                                        ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 6,
                                                                        ),
                                                                        Text(AppModel.lamgug?'${cart.unit_ar}':'${cart.unit_en}',style: TextStyle(
                                                                            fontSize: 15,
                                                                            color: Theme.of(context).primaryColor.withOpacity(0.4)
                                                                        ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Image(
                                                                    image: AssetImage(
                                                                      'assets/images/logo.png',
                                                                    ),
                                                                    height: 100,
                                                                    width: 300,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              child: SizedBox(
                                                                width: 100,
                                                                height: 30,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 3,bottom: 3),
                                                                  child: Container(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: <Widget>[
                                                                        Icon(
                                                                          Icons.flip,
                                                                          color: Colors.grey[400],
                                                                          size: 13,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 2,
                                                                        ),
                                                                        Text(
                                                                            AppModel.lamgug?'انظر خلف الكرت':'Flip',
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                                color: Theme.of(context).primaryColor.withOpacity(0.4),
                                                                                fontSize: 10
                                                                            )
                                                                        ),
                                                                        Spacer(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    back: Container(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(10)),
                                                          color: Colors.grey[200],
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.4),
                                                              spreadRadius: 3,
                                                              blurRadius: 6,
                                                              offset: Offset(0, 1), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: Stack(
                                                          alignment: Alignment.bottomCenter,
                                                          children: <Widget>[
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(50)),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: <Widget>[
                                                                  Align(
                                                                    alignment: FractionalOffset
                                                                        .topCenter,
                                                                    child: Padding(
                                                                      padding: EdgeInsets
                                                                          .only(top: 20,right: 20,left: 20),
                                                                      child: Opacity(
                                                                        opacity: 0.8,
                                                                        child: Column(
                                                                          children: <Widget>[
                                                                            Text(AppModel.lamgug?'${widget.showResult_ar}':'${widget.showEn}',
                                                                              style: TextStyle(
                                                                                  fontSize: 13
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Align(
                                                                    alignment: Alignment.bottomCenter,
                                                                    child: Opacity(
                                                                      opacity: 1,
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(bottom: 10),
                                                                        child: GestureDetector(
                                                                          onTap: (){
                                                                            print('share here');
                                                                          },
                                                                          child: Container(
                                                                            child: Scratcher(
                                                                              brushSize: 30,
                                                                              threshold: 50,
                                                                              color: Colors.grey,
                                                                              onChange: (value) { print("Scratch progress: $value%"); },
                                                                              onThreshold: () { print("Threshold reached, you won!"); },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.all(
                                                                                        Radius.circular(3))),
                                                                                height: 35,
                                                                                width: 250,
                                                                                child: Center(
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: <Widget>[
                                                                                      Spacer(
                                                                                        flex: 12,
                                                                                      ),
                                                                                      Text(
                                                                                          '${_copunCode.toUpperCase()}',style: TextStyle(
                                                                                          fontSize: 15,
                                                                                          color: Theme.of(context).primaryColor.withOpacity(0.8)
                                                                                      )
                                                                                      ),
                                                                                      Spacer(
                                                                                        flex: 6,
                                                                                      ),
                                                                                      IconButton(
                                                                                        icon: Icon(
                                                                                            Icons.share,
                                                                                            size: 20,
                                                                                            color: Theme.of(context).primaryColor.withOpacity(0.8)
                                                                                        ), onPressed: () {
                                                                                        Share.share(AppModel.lamgug?'${_copunCode}-${widget.sendText}':
                                                                                        '${widget.sendText}-${_copunCode}');
                                                                                        },
                                                                                      ),
                                                                                      Spacer(
                                                                                        flex: 1,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ):Padding(
                                            padding: const EdgeInsets.only(right: 20,left: 20),
                                            child: Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10.0)), // set rounded corner radius

                                                  border: Border.all(color: Colors.grey[300])
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                },
          ),
        ),
      ),
    );
  }

  bool creditBool = false;
  int _testUser;
  String _copunCode , _user_code_id , _docID , _price_old_coupon;
  int _count,_sum_date;
  bool donecreateCode = false;

  _checkCoupon(String _copCode, uint_ar,unit_en) async {

    _saveNewCop(uint_ar,unit_en);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time

    String _user_id = prefs.getString('user_docId');

    Firestore.instance.collection('coupons')
        .where('user_id_coupon',isEqualTo: _user_id)
        .getDocuments().then((query) {
      if(query.documents.isEmpty) {
        Firestore.instance.collection('coupons')
            .where('cop_code',isEqualTo: _copCode)
            .getDocuments().then((query) {
          setState(() {
            _progressButton = false;
            _testUser    = query.documents.length;
            }
          );
          print("_testUser data here: ${_testUser}");

          if(query.documents.isNotEmpty){
            setState(() {
              _docID       = query.documents[0].data['docId_coupon'];
              _count       = query.documents[0].data['count_coupon'];
              _price_old_coupon    = query.documents[0].data['price_coupon'];
              _sum_date    = query.documents[0].data['sum_date_coupon'];
              _user_code_id    = query.documents[0].data['user_id_coupon'];
            });
            print("_count data here: ${_count}");
            print("_sum_date data here: ${_sum_date}");
            print("_user_code_id data here: ${_user_code_id}");


            if(_sum_date+DatTim().convertToInt(widget.cop_limit) > DatTim().mathSumToDayDate() &&
                _count < DatTim().convertToInt(widget.cop_count_use)){

              print("_progressButton data here: ${_progressButton}");

              _saveNewCop(uint_ar,unit_en);
              setState(() {
                _progressButton = false;
              });

            }else{
              snackShow(context , AppModel.lamgug?'الرمز الترويجي منتهي الصلاحية':'The Coupon is expired ',Colors.red[800],Icon(
                Icons.error_outline,
                color: Colors.white,
              ),_scaffoldKey);
              setState(() {
                _progressButton = false;
              });
            }

          }else{
            snackShow(context , AppModel.lamgug?'الرمز الترويجي غير صحيح':'The Coupon is invalid',Colors.red[800],Icon(
              Icons.error_outline,
              color: Colors.white,
            ),_scaffoldKey);
            setState(() {
              _progressButton = false;
            });
          }
        }
        );

        }else{
        setState(() {
          _progressButton = false;
        });
        snackShow(context , AppModel.lamgug?'لا يمكنك انشاء اكثر من كوبون':'The Coupon is invalid',Colors.black54,Icon(
          Icons.error_outline,
          color: Colors.white,
         ),_scaffoldKey);
        }

      });
  }
  _saveNewCop(String uint_ar,unit_en)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First time
    String user_id = prefs.getString('user_docId');

    print('user id : ${user_id}');
    final DocumentReference postRef = Firestore.instance.document('coupon_count/count');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{'count': postSnapshot.data['count']+1});

        final collRef = Firestore.instance.collection('coupons');
        DocumentReference docReference = collRef.document();
        String coiponCode = docReference.documentID[0]+
            docReference.documentID[1]+docReference.documentID[2]+docReference.documentID[3]+docReference.documentID[4];
        docReference.setData({
          'selected' : false,
          'id' : postSnapshot.data['count']+1,
          'status': true,
          'cop_code' : coiponCode.toUpperCase(),
          'docId_coupon' : docReference.documentID,
          'user_id_coupon' : user_id,
          'count_coupon' : 0,
          'sum_date_coupon' : DatTim().mathSumToDayDate(),
          'price_coupon' : '160',
          'unit_coupon_ar' : uint_ar,
          'unit_coupon_en' : unit_en,

          'timestamp' : FieldValue.serverTimestamp(),

        }
        ).whenComplete((){
          setState(() {
            _copunCode = coiponCode;
            _UpdateOldCop(uint_ar,unit_en);
          }
          );
        }
        ).catchError((){
          print('errorr here');

        }).timeout(Duration(seconds: 5), onTimeout: () {
          // handle transaction timeout here
          print('timeout errorr here');
        });


      }
    }
    );
  }
  //TS7Y5

  _UpdateOldCop(String uint_ar,unit_en)async{

    final DocumentReference postRef = Firestore.instance.document('coupon_count/count');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{'count': postSnapshot.data['count']+1});

        final collRef = Firestore.instance.collection('coupons');
        DocumentReference docReference = collRef.document();
        String coiponCode = docReference.documentID[0]+
            docReference.documentID[1]+docReference.documentID[2]+docReference.documentID[3]+docReference.documentID[4];
        docReference.setData({

          'selected' : false,
          'id' : postSnapshot.data['count']+1,
          'cop_code' : coiponCode.toUpperCase(),
          'docId_coupon' : docReference.documentID,
          'user_id_coupon' : _docID,
          'count_coupon' : 0,
          'sum_date_coupon' : DatTim().mathSumToDayDate(),
          'price_coupon' : '10',
          'unit_coupon_ar' : uint_ar,
          'unit_coupon_en' : unit_en,
          'status': true,

          'timestamp' : FieldValue.serverTimestamp(),


        }
        ).whenComplete((){
          setState(() {
            donecreateCode = true;
          });
        }
        ).catchError((){
          print('errorr here');

        }).timeout(Duration(seconds: 5), onTimeout: () {
          // handle transaction timeout here
          print('timeout errorr here');
          });
        }
      }
    );
  }

/*
  _saveUpdateCop()async{
    print('widget.more_price is ${widget.more_price}');
    print('_docID is ${_docID}');

    final databaseReference = Firestore.instance;
    await databaseReference.collection("coupons")
        .document(_docID)
        .updateData({
      'price_coupon' : (DatTim().convertToInt(_price_old_coupon)+DatTim().convertToInt(widget.more_price)).toString(),
    }
    ).whenComplete((){
      setState(() {
        donecreateCode = true;
      });
    });

  }
*/



  Widget lineDraw(){
    return Padding(
      padding: EdgeInsets.only(top: 3 ,left: 40 ,right: 40 ,bottom: 5),
      child: Divider(
        color: Colors.grey[400],
      ),
    );
  }

}
