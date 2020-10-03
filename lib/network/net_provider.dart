import 'dart:collection';

import 'package:best_flutter_ui_templates/modle/regions_model.dart';
import 'package:flutter/cupertino.dart';

class NetProvider with ChangeNotifier{

  List<Regions> listGetRegions = [];

  Regions _currentGetRegions;
  UnmodifiableListView<Regions> get getRegions => UnmodifiableListView(listGetRegions);
  Regions get currentGetRegions => _currentGetRegions;


  set myCartList(List<Regions> mycartList){
    listGetRegions = mycartList;

    notifyListeners();
  }
}