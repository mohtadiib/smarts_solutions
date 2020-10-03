import 'dart:collection';
import 'dart:ffi';
import 'package:best_flutter_ui_templates/categories/network/model_cat.dart';
import 'package:best_flutter_ui_templates/modle/oder_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends ChangeNotifier{

  static String userLocation_Lat = '';
  static String userLocation_Lng = '';

  String tasleekType;

  String get getTasleekType{
    return tasleekType;
  }

  String getTasleekAr(){
    if(tasleekType == null){
      return 'لا يحتاج';
    }else {
      return tasleekType;
    }
  }

  String orderID = '';
  String orderTime = '';
  String orderDate = '';
  bool order_type = true;
  String myLocation = '';
  String myCategories;
  String payType;

  set setpayType(String _payType){
    payType = _payType;
    notifyListeners();
  }

  //-----------------------------------Visit-----------------------------------------

  String date_en =  "No Selected";
  String time_en = "No Selected";

  String date_ar =  "لم يًحدد";
  String time_ar = "لم يًحدد";

//------------------------------------------------------------------------------------------------

  void setCategoriesName(String catig){
    this.myCategories = catig;
    notifyListeners();
  }

  String get categoriesName{
  return  myCategories;
  }



  //--------------------------------------------------------------------

  String getOrderId(){
    if(order_type){
      return this.orderID+'S-';
    }else{
      return this.orderID+'C-';
    }
  }

   setOrderId(String oredrId){
    this.orderID = oredrId;
   }



  int total_quantity = 0;
  double totalAppBar = 0.0;
  String unit_ar;
  String unit_en,keyPhone = '249';
  int damman_grad = 0;
  String damaan_name;
  static String  complete_data_disable_country = 'لا تتوفر الخدمة في هذه المنطقة، سنقوم باخبارك بمجرد توفرها' ;

  set setDamaan_name(String quan){
    damaan_name = quan;
    notifyListeners();
  }

  set setDamaan_grad(int quan){
    damman_grad = quan;
    notifyListeners();
  }

  setDamaanGrad(Cart cart,int _damaan){
    cart.setDamaan_grad = _damaan;
    notifyListeners();
  }


  setDamaanNAme(Cart cart,String _damaan){
    cart.setDamaan_name = _damaan;
    notifyListeners();
  }

  set setTotal_quantity(int quan){
    total_quantity = quan;
    notifyListeners();
  }

  set setTotalAppBar(double quan){
    totalAppBar = quan;
    notifyListeners();
  }


  List<MyCart> listMyCart = [];

  List<MyCart> get getlistMyCart{
    return listMyCart;
  }



  MyCart _currentMycart;
  UnmodifiableListView<MyCart> get mycartList => UnmodifiableListView(listMyCart);
  MyCart get currentMycart => _currentMycart;

//-------------------------------------GET LIST DATA---------------------------
  set myCartList(List<MyCart> mycartList){
    listMyCart = mycartList;
    notifyListeners();
  }
//----------------------------------------------------------------------------------------
  set currentMycartList(MyCart myCart){
    _currentMycart = myCart;
    notifyListeners();
  }
//---------------------------------API GET DATA-------------------------------------------------------------------
  void getFoods(Cart foodNotifier ,String collKey , VoidCallback voidS) async{
    foodNotifier.listMyCart.clear();
    QuerySnapshot snapshot = await Firestore.instance.collection('items')
        .where('active',isEqualTo: true)
        .where('category_id',isEqualTo: collKey)
        .getDocuments().whenComplete(() {
      voidS();
    });
    List<MyCart> _myItemList = [];
    snapshot.documents.forEach((document){
      MyCart myCart = MyCart.fromMap(document.data);
      _myItemList.add(myCart);
      }
    );
    foodNotifier.myCartList = _myItemList;
    foodNotifier.setTotal_quantity = 0;
    foodNotifier.totalAppBar = 0;
    damman_grad = 0;
    notifyListeners();
  }
//----------------------------------------------------------------------------------------------------------------------
  void minusButt(int _indexTitle){
    if(convertToInt(listMyCart[_indexTitle].quantity) != 0) {
      total_quantity--;
      double _itemtotal = convertToDouble(listMyCart[_indexTitle].total);
      _itemtotal-= itemPrice(_indexTitle);
      listMyCart[_indexTitle].total = _itemtotal.toString();
      totalAppBar -= itemPrice(_indexTitle);
      int _quant = convertToInt(listMyCart[_indexTitle].quantity);
      _quant--;
      listMyCart[_indexTitle].quantity = _quant.toString();
    }

    notifyListeners();
  }

  void addButt(int _indexTitle ){

    total_quantity++;
      double _itemTotal = convertToDouble(listMyCart[_indexTitle].total);
      _itemTotal += itemPrice(_indexTitle);
       listMyCart[_indexTitle].total = _itemTotal.toString();
      totalAppBar += itemPrice(_indexTitle);
      int _quantity = convertToInt(listMyCart[_indexTitle].quantity);
      _quantity++;
       listMyCart[_indexTitle].quantity = _quantity.toString();
      notifyListeners();
     }

  int get countItem{
    return listMyCart.length;
  }

  double get totalAppbar{
    return totalAppBar+damaan_order_totalAppBar();
  }

  double itemPrice(int _indexTitle){
    double itemrice = double.parse(listMyCart[_indexTitle].price);
    assert(itemrice is double);

    return itemrice;
  }

  double fullItemsTotalPrice(int _indexTitle){
    return convertToDouble(listMyCart[_indexTitle].total)+damaan_order_total(_indexTitle);
  }

  int quantItem(MyCart _quant){
    return convertToInt(_quant.quantity);
  }

  double item_price(MyCart _quant ,int _indexTitle){
    var _mm = double.parse(_quant.price);
    assert(_mm is double);
    return _mm + damaan_order_price(_indexTitle);
  }


  double damaan_order_total(int _indexTitle ){
    var _damman = double.parse(listMyCart[_indexTitle].total);
    assert(_damman is double);
    return _damman * damman_grad/100;
  }

  double damaan_order_totalAppBar(){
    return totalAppBar * damman_grad/100;
  }

  Void setTasleekType(String tasleek){
    this.tasleekType = tasleek;
  }


  double damaan_order_price(int _indexTitle ){
     var _m = double.parse(listMyCart[_indexTitle].price);
      assert(_m is double);

    return _m * damman_grad/100;
  }

double convertToDouble(String str){
  var _xx = double.parse(str);
  assert(_xx is double);
  return _xx;
}

  int convertToInt(String str){
    var _xx = int.parse(str);
    assert(_xx is int);
    return _xx;
  }

  set setUnitAr(String un){
    unit_ar = un;
    notifyListeners();
  }

  get getUnitAr{
    this.unit_ar = getUnitAr;
  }

  set setUnitEn(String un){
    unit_en = un;
    notifyListeners();
  }

  set setKeyPhone(String un){
    keyPhone = un;
    notifyListeners();
  }

  getUnitCantery(Cart foodNotifier,VoidCallback voidCallback) async {
    Firestore.instance.collection('units').getDocuments().then((query) {
      foodNotifier.setUnitEn = query.documents[0].data['unit_en'];
      foodNotifier.setUnitAr = query.documents[0].data['unit_ar'];
      foodNotifier.setKeyPhone = query.documents[0].data['phoneKey'];
      foodNotifier.setShareApp = query.documents[0].data['share_app'];
      foodNotifier.setPrivacy = query.documents[0].data['privacy'];

      print('unit ar here :${query.documents[0].data['unit_en']}');

      voidCallback();//share_app
      }
    );
    notifyListeners();
  }


  bool notification = false;
  bool notifBress = true;
  bool notifPayment = true;

  set setNotifPayment(bool un){
    notifPayment = un;
    notifyListeners();
  }


  set setNotifi(bool un){
    notification = un;
    notifyListeners();
  }
  set setNotiBress(bool un){
    notifBress = un;
    notifyListeners();
  }

  getNotification(Cart cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cart.setNotifi = prefs.getBool('notifi');
    cart.setNotiBress = prefs.getBool('notiPress');
    cart.setNotifPayment = prefs.getBool('notiPayment');
  }

  setNotification(Cart cart ,bool _noti , bool _notBress , bool payment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(_noti != null && _notBress != null){
      prefs.setBool('notifi',_noti);
      cart.setNotifi = _noti;
      prefs.setBool('notiPress',_notBress);
      cart.setNotiBress = prefs.getBool('notiPress');
    }else if(_noti != null){
      prefs.setBool('notifi',_noti);
      cart.setNotifi = _noti;
    }else if(_notBress != null){
      prefs.setBool('notiPress',_notBress);
      cart.setNotiBress = prefs.getBool('notiPress');
    }
    if(_noti != null && payment != null){
      prefs.setBool('notifi',_noti);
      cart.setNotifi = _noti;
      prefs.setBool('notiPayment',payment);
      cart.setNotifPayment = payment;
    }else if(_noti != null){
      prefs.setBool('notifi',_noti);
      cart.setNotifi = _noti;
    }else if(payment != null){
      prefs.setBool('notiPayment',payment);
      cart.setNotifPayment = payment;
    }
  }

  String urlUserImage;
  bool testLogin = false;
  set setUrlImage(String _image){
    urlUserImage = _image;
    notifyListeners();
  }

  set setCheckLogin(bool _log){
    testLogin = _log;
    notifyListeners();
  }


  getImageUser(Cart cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cart.setUrlImage = prefs.getString('photoUrl');

      if(prefs.getBool('login_user') != null){
        cart.setCheckLogin = prefs.getBool('login_user');
      }
      notifyListeners();
  }

  setNewImageUser(Cart cart,String image,bool login ) async {
    cart.setUrlImage = image;
    cart.setCheckLogin = login;
    notifyListeners();
  }

  setImageUser(Cart cart) async {
    cart.setUrlImage = null;

      cart.setCheckLogin = false;
    notifyListeners();
  }

  //---------------------------------get share app---------------------------------

String shareApp = '';
  set setShareApp(String _share){
    shareApp = _share;
    notifyListeners();
  }

  String privacy = '';
  set setPrivacy(String _share){
    privacy = _share;
    notifyListeners();
  }


  bool progLogin = false;
  set setprogLogin(bool _progLogin){
    progLogin = _progLogin;
    notifyListeners();
  }
  setProgLog(Cart cart , bool prog){
    cart.setprogLogin = prog;
    notifyListeners();
  }

  bool progStat = false;
  set setProgStat(bool _progLogin){
    progStat = _progLogin;
    notifyListeners();
  }
  getProgStat(Cart cart , bool prog){
    cart.setProgStat = prog;
    notifyListeners();
  }


  //----------------------------get Categories--------------------------

  List<CategoriesModel> listcaetgoriesList = [];

  List<CategoriesModel> get getCategoriesList{
    return listcaetgoriesList;
  }

  set setCategoriesList(List<CategoriesModel> mycartList){
    listcaetgoriesList = mycartList;
    notifyListeners();
  }

  CategoriesModel _currentListCategoriesList;
  UnmodifiableListView<CategoriesModel> get myCategoriesList => UnmodifiableListView(listcaetgoriesList);
  CategoriesModel get currentLisitCategoriesList => _currentListCategoriesList;

  void getCategories(Cart catProvider ,VoidCallback voidCallback) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    catProvider.listcaetgoriesList.clear();
    QuerySnapshot snapshot = await Firestore.instance.collection('categories').
    where('active',isEqualTo: true).
    where('status',isEqualTo: true).
    getDocuments().whenComplete((){

      String _user_id = prefs.getString('user_docId');

      if(_user_id != null){
        getPayNoti(catProvider,(){
          voidCallback();
        });
      }else{
        voidCallback();
      }

    });
    List<CategoriesModel> _myItemList = [];
    snapshot.documents.forEach((document){
      CategoriesModel myCart = CategoriesModel.fromMap(document.data);
      _myItemList.add(myCart);
     }
    );
    catProvider.setCategoriesList = _myItemList;
    notifyListeners();
  }


  getCategs(Cart catProvider,
      VoidCallback voidCallback,VoidCallback voiError)async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      getCategories(catProvider , voidCallback);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      getCategories(catProvider , voidCallback);
    }else{
      voiError();
    }
  }
  getPayNoti(Cart cart,VoidCallback voidCallback) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _user_id = prefs.getString('user_docId');

    print('notiPayment  is : ${prefs.getBool('notiPayment')}');
     Firestore.instance.collection('direct_orders').
      where('payment_type',isEqualTo: 'no').
      where('order_user_id',isEqualTo: _user_id).
      getDocuments().then((query) {
        if(query.documents.isNotEmpty){
          print('list pay length is : ${query.documents.length}');
          setNotification(cart,true,null,true);
        }else{
          print('list pay length is empty');
          if(prefs.getBool('notiPress') == false){
            setNotification(cart,false,null,false);
          }else{
            setNotification(cart,null,null,false);
          }
          print('notiPayment  is : ${prefs.getBool('notiPayment')}');
        }
      }).whenComplete((){
        voidCallback();
      });

  }


/*
  String unit_coupon_ar , unit_coupon_en;

  set setunit_coupon_en(String _u_en){
    unit_coupon_en = _u_en;
    notifyListeners();
  }
  set setunit_coupon_ar(String _u_ar){
    unit_coupon_ar = _u_ar;
    notifyListeners();
  }

  setUnitCoupon(Cart cart ,_unit_ar,_unit_en){
    cart.setunit_coupon_ar = _unit_ar;
    cart.setunit_coupon_en = _unit_en;
    notifyListeners();
  }
*/

}