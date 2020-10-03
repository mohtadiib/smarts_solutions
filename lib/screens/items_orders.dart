import 'package:best_flutter_ui_templates/providor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:best_flutter_ui_templates/widgests/button_project.dart';
import 'package:flutter/cupertino.dart';
import '../modle/cart.dart';
import 'package:provider/provider.dart';
import '../translation_strings.dart';
import '../widgests/my_drawer.dart';
import 'package:flutter/material.dart';
import '../network/items_get_data/get_items.dart';

import 'user/login/authservice.dart';

class ItemsOrder extends StatefulWidget {
  ItemsOrderState createState() => new ItemsOrderState();

  final String collectionKEY;

  ItemsOrder(this.collectionKEY);
}

double discretevalue = 2.0;
double hospitaldiscretevalue = 25.0;

class ItemsOrderState extends State<ItemsOrder> {

  bool langChang;
  @override
  void initState() {
    AuthService().setTestPage(2);
    setState(() {
      langChang = AppModel.lamgug;
    });
    Cart foodNotifier = Provider.of<Cart>(context , listen: false);
    getItems(foodNotifier,widget.collectionKEY,(){
      setState(() {
        tasleekMenuSelec = null;
        damaanMenuSelec = null;

        progData = false;
        getErrorConnection = false;
      });
    },(){
      setState(() {
        getErrorConnection = true;
      });
    });
    super.initState();
  }

  bool regionValid = true,progData = true ,getErrorConnection = false;
  bool damaanValid = true , sanckShow = false;

  String tasleekMenuSelec;
  void _onDamaanDropItemSelected(String newValueSelected) {
    setState(() {
      Cart foodNotifier = Provider.of<Cart>(context , listen: false);
      Cart().setDamaanGrad(foodNotifier, Cart().convertToInt(newValueSelected));
      this.tasleekMenuSelec = newValueSelected;
      this.regionValid = true;
    });
  }

  String damaanMenuSelec;
  void _onTasleekDropItemSelected(String newValueSelected) {
    setState(() {
      this.damaanMenuSelec = newValueSelected;
      this.damaanValid = true;
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    setState(() {
      getErrorConnection = false;
      progData = true;
      tasleekMenuSelec = null;
      damaanMenuSelec = null;
    });
    Cart foodNotifier = Provider.of<Cart>(context , listen: false);
    getItems(foodNotifier,widget.collectionKEY,(){
      setState(() {
        progData = false;
        getErrorConnection = false;
      });
    },(){
      setState(() {
        getErrorConnection = true;
      });
    });
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }


  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
        child: Consumer<Cart>(
          builder: (context , cart , child){
            print('list data here ${cart.listMyCart.length}');
            print('prog data here ${progData}');
            return Scaffold(
              key: _scaffoldKey,
              drawer: CustomDrawer(),
              body:  Column(
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
                              color: Colors.black12,
                              blurRadius: 5, // has the effect of softening the shadow
                              spreadRadius: 0.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                10.0, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0,bottom: 0,left: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              cart.totalAppbar > 0?Container():Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: IconButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                child:
                                cart.totalAppbar > 0 ? Center( child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: cart.total_quantity < 100 ? 30 : 50,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Center(
                                            child:  Text(
                                              cart.total_quantity.toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(context).primaryColor
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          Translations.of(context).item_,
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 15,
                                              color: Theme.of(context).primaryColor
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text(
                                      cart.totalAppbar.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).primaryColor
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      !AppModel.lamgug?cart.unit_en:cart.unit_ar,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context).primaryColor
                                      ),
                                    ),
                                  ],
                                )
                                )
                                    :Center(child: Text(Translations.of(context).item_title,style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor
                                ),
                                )
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.help,
                                        color: Theme.of(context).primaryColor,
                                      ), onPressed: () {  },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(Translations.of(context).item_sub_title ,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize:11,
                                color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3 , bottom: 0, left: 5 ,right: 5),
                    child: Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5 , bottom: 0, left: 5 ,right: 5),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 0, left: 0, top: 0),
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: Firestore.instance.collection('tasleek').where('status',isEqualTo: true).snapshots(), builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return CupertinoActivityIndicator();
                                            }else{
                                              return Card(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.grey[300],
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 35,
                                                  padding: EdgeInsets.only(bottom: 0,top: 0,right: 10,left: 10),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: DropdownButton(
                                                          icon: Padding(
                                                            padding: const EdgeInsets.only(right: 5),
                                                            child: Icon(
                                                              Icons.arrow_drop_down,
                                                              size: 30,
                                                              color: regionValid?Theme.of(context).primaryColor:Colors.redAccent,
                                                            ),
                                                          ),
                                                          value: damaanMenuSelec,
                                                          isDense: true,
                                                          onChanged: (valueSelectedByUser) {
                                                            cart.setTasleekType(valueSelectedByUser);

                                                            _onTasleekDropItemSelected(valueSelectedByUser);
                                                          },
                                                          hint: Padding(
                                                            padding: const EdgeInsets.only(right: 5),
                                                            child: Text(Translations.of(context).tasleek_type,style: TextStyle(
                                                                color: regionValid? Colors.grey:Colors.redAccent,
                                                                fontSize: 11
                                                            ),
                                                            ),
                                                          ),
                                                          items: snapshot.data.documents
                                                              .map((DocumentSnapshot document) {
                                                            return DropdownMenuItem<String>(
                                                              value: document.data['name_ar'],
                                                              child: Container(
                                                                child:
                                                                Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(right: 0),
                                                                    child: Text(langChang?document.data['name_ar']:document.data['name_en'],
                                                                      style: TextStyle(fontSize: 13),),
                                                                  ),
                                                                ),
                                                              ) ,/*Text(document.data['name_ar'] )*/
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 0, left: 0, top: 0),
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: Firestore.instance.collection('damaan').where('status',isEqualTo: true).snapshots(), builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return CupertinoActivityIndicator();
                                            }else{
                                              return Card(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.grey[300],
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 35,
                                                  padding: EdgeInsets.only(bottom: 0,top: 0,right: 10,left: 10),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: DropdownButton(
                                                          icon: Icon(
                                                            Icons.arrow_drop_down,
                                                            size: 30,
                                                            color: regionValid?Theme.of(context).primaryColor:Colors.redAccent,
                                                          ),
                                                          value: tasleekMenuSelec,
                                                          isDense: true,
                                                          onChanged: (valueSelectedByUser) {
                                                          _onDamaanDropItemSelected(valueSelectedByUser);
                                                          },
                                                          hint: Padding(
                                                            padding: const EdgeInsets.only(right: 5),
                                                            child: Text(Translations.of(context).damaan,style: TextStyle(
                                                                color: regionValid? Colors.grey:Colors.redAccent,
                                                                fontSize: 11
                                                               ),
                                                            ),
                                                          ),
                                                          items: snapshot.data.documents
                                                              .map((DocumentSnapshot document) {
                                                            return DropdownMenuItem<String>(
                                                              value: document.data['grad'],
                                                              child: Container(
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(right: 0),
                                                                    child: Text(langChang?document.data['grad']:document.data['name_en'],
                                                                      style: TextStyle(fontSize: 13),),
                                                                    ),
                                                                  ),
                                                                ) ,/*Text(document.data['name_ar'] )*/
                                                              );
                                                            }
                                                          ).toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Text(
                                  Translations.of(context).damman_content+' '+'%'+(cart.damman_grad).toString()+' ',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    color: Colors
                                        .orange[200],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      footer: CustomFooter(
                        builder: (BuildContext context,LoadStatus mode){
                          Widget body ;
                          return Container(
                            height: 55.0,
                            child: Center(child:body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child:
                      getErrorConnection?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/config/computer.svg',
                            semanticsLabel: 'Acme Logo',
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(height: 5,),
                          Text(
                            AppModel.lamgug?'يجب الاتصال بالانترنت':'No Internet Connection',style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.grey,fontSize: 13
                          ),
                          )
                        ],
                      ):progData?Center(child
                          : CupertinoActivityIndicator())
                          :cart.listMyCart.length == 0?
                      Padding(
                        padding: const EdgeInsets.only(bottom: 90),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.not_interested,color: Colors.grey[400],size: 40,
                            ),
                            Text(
                              AppModel.lamgug?'لا توجد عناصر':'No Items',style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Colors.grey,fontSize: 13
                            ),
                            ),
                          ],
                        ),
                      ):
                      ListView.builder(
                          itemCount: cart.listMyCart.length,
                          itemBuilder: (BuildContext context, int indexx) {
                            return  Padding(
                                padding: new EdgeInsets.only(top: 0,right: 5,left: 5),
                                child: Directionality(
                                  textDirection: testLang() == 'Next'? TextDirection.ltr :TextDirection.rtl,
                                  child:  Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Card(
                                            color: Theme.of(context).primaryColorLight,
                                            child: Container(
                                              child: Padding(
                                                padding: new EdgeInsets.only(top: 10,right: 20,left: 20 ,bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        testLang() == 'Next'? cart.listMyCart[indexx].name_en : cart.listMyCart[indexx].name_ar,
                                                        style: TextStyle(
                                                          fontFamily: 'Cairo',
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: Theme.of(context).primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(cart.item_price(cart.listMyCart[indexx] ,
                                                              indexx).toString(),
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Theme.of(context).primaryColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            testLang() == 'Next'? cart.unit_en :cart.unit_ar,
                                                            style: TextStyle(
                                                              fontFamily: 'Cairo',
                                                              fontSize: 13,
                                                              color: Theme.of(context).accentColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(right: 20,left: 20),
                                                child: Text(
                                                  Translations.of(context).total_item,
                                                  style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    color: Colors.grey[500],
                                                    fontSize: 11,
                                                    height: 1.6,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 50,right: 50),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      cart.fullItemsTotalPrice(indexx).toString(),
                                                      style: TextStyle(
                                                          fontSize: 15
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      testLang() == 'Next'? cart.unit_en :cart.unit_ar,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: 11,
                                                        color: Colors
                                                            .grey[400],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(right: 20 ,left: 20
                                                ),
                                                child: Text(
                                                  Translations.of(context).quantity_item,
                                                  style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    color: Colors.grey[500],
                                                    fontSize: 11,
                                                    height: 1.6,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: new Center(
                                                  child: new Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: <Widget>[
                                                      MaterialButton(
                                                        color: Colors
                                                            .grey[50],
                                                        onPressed: () {
                                                          cart.addButt(indexx);
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              bottom: 0),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors
                                                                .grey,
                                                            size: 15,
                                                          ),
                                                        ),
                                                        shape: new CircleBorder(),
                                                        padding: const EdgeInsets
                                                            .all(5),
                                                      ),
                                                      Text(
                                                        cart.quantItem(cart.listMyCart[indexx]).toString(),
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors
                                                                .grey[600]
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        color: Colors
                                                            .grey[50],
                                                        onPressed: () {
                                                          cart.minusButt(indexx);
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              bottom: 9),
                                                          child: Icon(
                                                            Icons
                                                                .minimize,
                                                            color: Colors
                                                                .grey,
                                                            size: 15,
                                                          ),
                                                        ),
                                                        shape: new CircleBorder(),
                                                        padding: const EdgeInsets
                                                            .all(5),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                          }
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonNext(cart.total_quantity>0?Theme.of(context).primaryColorDark:
                        Theme.of(context).primaryColorLight , cart.total_quantity, (){
                          if(cart.total_quantity>0){
                            if(cart.damman_grad != 0){
                              _setDaman((){
                                print('nooo');
                                AuthService().setTestPage(2);
                                AuthService().getLoginUser(context,_scaffoldKey);
                              },cart.damman_grad);
                            }else{
                              Cart foodNotifier = Provider.of<Cart>(context , listen: false);
                              Cart().setDamaanNAme(foodNotifier, 'Not Need');
                              AuthService().setTestPage(2);
                              AuthService().getLoginUser(context,_scaffoldKey);
                            }
                          }else{

                           }
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        )
    );
  }



  _setDaman(VoidCallback voidCallback,int damaan_gad)async{
    String damName = '';
    print('damaan is here : ${damName}');
    print('damaan_gad is here : ${damaan_gad}');

    Firestore.instance.collection('damaan').
    where('grad',isEqualTo: damaan_gad.toString()).getDocuments().then((query) {
      print('damaan length is here : ${query.documents.length}');

      if(query.documents.isNotEmpty){
        setState(() {
          damName = query.documents[0].data['name_en'];
          }
        );
        print('damaan is here : ${damName}');

        Cart foodNotifier = Provider.of<Cart>(context , listen: false);
        Cart().setDamaanNAme(foodNotifier, damName);
      }
     }
    ).whenComplete((){
      voidCallback();
    });
  }

  String testLang(){
    return Translations.of(context).button_next;
  }
}

class ButtonNext extends StatelessWidget {
  VoidCallback voidCallback;
  Color color;
  int quant;
  ButtonNext(this.color ,this.quant, this.voidCallback);
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      buttonProject(Icon(
        Icons.navigate_next,
        color: Colors.white,
      ),Translations.of(context).button_next , color, (){
        voidCallback();
        if(quant == 0){
          snackShow(context);
            }
          }
        ),
    );
  }

  snackShow(BuildContext context){
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('الرجاء قم بتحديد عنصر واحد على الاقل',style: TextStyle(
        fontSize: 12
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
    Scaffold.of(context).showSnackBar(snackBar);
  }
}