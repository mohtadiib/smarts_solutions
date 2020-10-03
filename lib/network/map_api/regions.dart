import '../../modle/regions_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../net_provider.dart';

class GetRegions{

  Future<Regions> getRegions(NetProvider netProvider) async{
    QuerySnapshot snapshot = await Firestore.instance.collection('regions').where('active',isEqualTo: true).getDocuments();
    List<Regions> _myItemList = [];
    snapshot.documents.forEach((document){
      Regions myCart = Regions.fromMap(document.data);
      _myItemList.add(myCart);
    });
    netProvider.myCartList = _myItemList;
  }
}