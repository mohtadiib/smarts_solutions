import 'package:best_flutter_ui_templates/screens/last_order/direct/network/direct_provider.dart';
import 'package:best_flutter_ui_templates/screens/last_order/visit/network/visit_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providor.dart';
import '../../../translation_strings.dart';
import 'api.dart';

class CancelOrder extends StatefulWidget {
  String documentId , collection;
  int index;

  bool direct;

  CancelOrder({
    this.direct,
    this.index,
    this.documentId,
    this.collection
  });

  @override
  _CancelOrderState createState() => new _CancelOrderState();
}

class _CancelOrderState extends State<CancelOrder> {

  String _orderStatus = 'Canceled';
  bool progress = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _content_ar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            AppModel.lamgug?'الغاء الطلب':'Cancel Order',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height*0.2,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child:
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.2,
                            child: ListView(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                        AppModel.lamgug?'سيتم الغاء الطلب بالضغط على تأكيد'
                                            :'Cancel the Order by clicking Confirm',
                                        textAlign: TextAlign.center,
                                        maxLines: 17,
                                        style: TextStyle(
                                            color: Colors.grey[600],fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    print('doc id here :${widget.documentId}');
                                    setState(() {
                                      progress = true;
                                    });
                                    print('collection is : '+widget.collection);
                                    updateOrderStatus(widget.collection,
                                        widget.documentId,_orderStatus,
                                        'Order Canceled',(){
                                          print('success done');
                                          setState(() {
                                            progress = false;
                                          });
                                          print('direct bool ${widget.direct}');
                                          print('widget.index  ${widget.index}');

                                          if(widget.direct){
                                            DirectOrderProvider directOrderProvider = Provider.of<DirectOrderProvider>(context , listen: false);
                                            DirectOrderProvider().setPayOrderIndex(directOrderProvider,null,_orderStatus,widget.index);
                                          }else{
                                            print('direct bool ${widget.direct}');
                                            VisitProvider visitProvider = Provider.of<VisitProvider>(context,listen:false);
                                            VisitProvider().setStatusOrderIndex(visitProvider, _orderStatus,widget.index);
                                          }
                                          Navigator.pop(context);
                                        }
                                    );
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        progress?CupertinoActivityIndicator():Row(
                                          children: <Widget>[
                                            Text(
                                              AppModel.lamgug?'تأكيد':'Done',
                                              style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  color: Colors.white,fontSize: 15),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Icon(
                                              Icons.done,color: Colors.white,
                                              size: 15,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  color: progress?Colors.orange[100]:Colors.red,
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8,right: 15,top: 5,bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          Translations.of(context).cancel_button,
                                          style: TextStyle(color: Colors.grey[600],fontSize: 15),
                                        ),
                                        Icon(
                                          Icons.close,color: Colors.grey[600],
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                  color: Colors.grey[100],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}