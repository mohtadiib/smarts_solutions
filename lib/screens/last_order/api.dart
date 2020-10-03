import 'package:best_flutter_ui_templates/screens/last_order/visit/network/visit_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'direct/network/direct_provider.dart';

getLastOrders(BuildContext context,
    VoidCallback voidCallback,VoidCallback voiError)async{

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {

    DirectOrderProvider directOrderProvider = Provider.of<DirectOrderProvider>(context , listen: false);
    DirectOrderProvider().getLastDirectOrders(directOrderProvider,(){
      voidCallback();
    });

    VisitProvider visitProvider = Provider.of<VisitProvider>(context,listen:false);
    VisitProvider().getLastVisits(visitProvider,(){
      voidCallback();
    });

  } else if (connectivityResult == ConnectivityResult.wifi) {

    DirectOrderProvider directOrderProvider = Provider.of<DirectOrderProvider>(context , listen: false);
    DirectOrderProvider().getLastDirectOrders(directOrderProvider,(){
      voidCallback();
    });

    VisitProvider visitProvider = Provider.of<VisitProvider>(context,listen:false);
    VisitProvider().getLastVisits(visitProvider,(){
      voidCallback();
    });

  }else{
    voiError();
  }
}