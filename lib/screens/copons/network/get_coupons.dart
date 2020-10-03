import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'coup_provider.dart';

getCoupons(bool old,int _count_coupon,BuildContext context,String userId,int dateToDay ,int limitDay,
    VoidCallback voidCallback,VoidCallback voiError)async{

  chechInternet((){
    CouponProvider directOrderProvider = Provider.of<CouponProvider>(context , listen: false);
    CouponProvider().getCoupons(old,_count_coupon,directOrderProvider,userId,dateToDay,limitDay,voidCallback);
  },(){
    CouponProvider directOrderProvider = Provider.of<CouponProvider>(context , listen: false);
    CouponProvider().getCoupons(old,_count_coupon,directOrderProvider,userId,dateToDay,limitDay,voidCallback);
  },(){
    voiError();
  });
  }


chechInternet(VoidCallback _mobile,VoidCallback _wifi ,VoidCallback _voiError)async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    _mobile();
  } else if (connectivityResult == ConnectivityResult.wifi) {
    _wifi();
  }else{
    _voiError();
  }
}
