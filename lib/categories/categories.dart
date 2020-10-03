import 'package:best_flutter_ui_templates/categories/network/model_cat.dart';
import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/screens/help/help_items.dart';
import 'package:best_flutter_ui_templates/screens/items_orders.dart';
import 'package:best_flutter_ui_templates/screens/notification/notification.dart';
import 'package:best_flutter_ui_templates/screens/user/login/authservice.dart';
import 'package:best_flutter_ui_templates/screens/user/profile/profile.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:cache_image/cache_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:best_flutter_ui_templates/translation_strings.dart';
import 'package:best_flutter_ui_templates/widgests/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  @override
  void initState() {
    dismissProgressDialog();
    super.initState();
    AuthService().setTestPage(1);
    Cart cart = Provider.of<Cart>(context , listen: false);
    Cart().getUnitCantery(cart,(){
    });
    Cart().getImageUser(cart);
    Cart().getCategs(cart,(){
      setState(() {
        progData = false;
      });

    },(){
      setState(() {
        getErrorConnection = true;
      });
      }
    );

  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    setState(() {
      getErrorConnection = false;
      progData = true;
      }
    );

    Cart cart = Provider.of<Cart>(context , listen: false);
    Cart().getCategs(cart,(){
      setState(() {
        progData = false;
      });

    },(){
      setState(() {
        getErrorConnection = true;
      });
      }
    );


    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Directionality(
          textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
                              child: Consumer<Cart>(
                              builder: (context , cart , child) {
                                print('catego list : '+cart.getCategoriesList.length.toString());
                                return Consumer<AppModel>(
                                  builder: (context , model , child) {
                                    //print('my list : '+cart.listMyCart.length.toString());
                                    return Scaffold(
                                      backgroundColor: Colors.white,
                                      key: scaffoldKey,
                                      drawer: CustomDrawer(
                                        context:context,
                                        scaffoldKey: scaffoldKey,
                                      ),
                                      body: Column(
                                        children: <Widget>[
                                          custAppBar(cart.urlUserImage,cart.testLogin,Translations.of(context).catigories ,cart.notification,context,(){
                                            scaffoldKey.currentState.openDrawer();
                                          }
                                          ),
                                          Expanded(
                                            child:  _listCategories(cart.getCategoriesList,cart)
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                          ),
                      ));
                    }


      //--------------------------------------categ list------------------------------
  bool progData = true ,getErrorConnection = false;

  Widget _listCategories(List <CategoriesModel> _list,Cart cart){
    return getErrorConnection?
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          'assets/config/computer.svg',
          semanticsLabel: 'Acme Logo',
          width: 60,
          height: 60,
        ),
        SizedBox(height: 5,),
        Text(
          AppModel.lamgug?'يجب الاتصال بالانترنت':'No Internet Connection',style: TextStyle(
            color: Colors.grey,fontSize: 13
        ),
        )
      ],
    ):progData?Center(child
        : SizedBox(
          width: 70,
          child: Container(
            child: Image.asset(
               'assets/notifi/home_loading.gif'
             ),
          ),
        ),
        )
        :_list.length == 0 ?
    Padding(
      padding: const EdgeInsets.only(bottom: 90),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.not_interested,color: Colors.grey[400],size: 40,
          ),
          Text(
            AppModel.lamgug?'لا توجد فئات':'No Items',style: TextStyle(
              color: Colors.grey,fontSize: 15
          ),
          ),
        ],
      ),
    ):
    ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int indexx) {
          return _list.length != 0?
          Padding(
            padding: const EdgeInsets.only(bottom: 10,right: 5,left: 5),
            child: Card(
              elevation: 10,
              child: Container(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    ProgressiveImage(
                      placeholder: AssetImage('assets/loading/loading_image.gif'),
                      // size: 1.87KB
                      thumbnail: CacheImage(_list[indexx].image),
                      // size: 1.29MB
                      image: CacheImage(_list[indexx].image),
                      height: 200,
                      width: 500,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: FractionalOffset
                                .topRight,
                            child: Padding(
                              padding: EdgeInsets
                                  .only(top: 20),
                              child: Opacity(
                                opacity: 0.8,
                                child: FlatButton(
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .only(
                                          bottomLeft: Radius
                                              .circular(
                                              15.0),
                                          topLeft: Radius
                                              .circular(
                                              15.0))),
                                  child: AppModel.lamgug? Text(
                                    _list[indexx].name_ar,
                                    style: TextStyle(
                                        fontSize: 25,
                                    ),
                                  )
                                      : Text(
                                    _list[indexx].name_en,
                                    style: TextStyle(
                                        fontSize: 20
                                    ),
                                  ),
                                  color: Colors
                                      .white,
                                  textColor: Theme
                                      .of(context)
                                      .primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets
                                  .only(top: 20),
                              child: Opacity(
                                opacity: 0.8,
                                child: FlatButton(
                                  onPressed: () {
                                    String catKey = _list[indexx].docId;
                                    Alert(
                                      context: context,
                                      style: alertStyle,
                                      type: AlertType
                                          .info,
                                      title: "",
                                      desc: AppModel.lamgug?'عزيزي العميل،اذا كنت غير متأكد تماماَ مما تريد تطويره وتحتاج لتفاصيل اضافية، يمكننا زيارتك في المكان الذي سيتم تطويره قبل طلب الخدمة لتقييم احتياجاتك':
                                      'Dear customer, if you are not completely sure what you want to develop and need additional details, we can visit you at the place to be developed before requesting the service to assess your needs',
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            Translations
                                                .of(
                                                context)
                                                .create_visit,
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: Theme
                                                    .of(
                                                    context)
                                                    .primaryColor,
                                                fontWeight: FontWeight
                                                    .bold,
                                                fontSize: 15),
                                          ),
                                          onPressed: () {
                                            cart.myCategories = _list[indexx].name_en;
                                            Navigator.pop(context);
                                            AuthService().setTestPage(3);
                                            AuthService().getLoginUser(context,scaffoldKey);
                                          },
                                          color: Colors
                                              .grey[200],
                                          radius: BorderRadius
                                              .circular(
                                              5),
                                        ),

                                        DialogButton(
                                          child: Text(
                                            Translations
                                                .of(
                                                context)
                                                .direct_order,
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: Theme
                                                    .of(
                                                    context)
                                                    .primaryColor,
                                                fontWeight: FontWeight
                                                    .bold,
                                                fontSize: 15),
                                          ),
                                          onPressed: () {
                                            cart.order_type =
                                            true;
                                            cart.myCategories = _list[indexx].name_en;

                                            print(cart.myCategories);
                                            Navigator.pop(context);
                                            Navigator.of(context).push(PageRouteTransition(
                                                animationType: AnimationType2.slide_left,
                                                builder: (context) => ItemsOrder(catKey)

                                            ));

                                          },
                                          color: Colors
                                              .grey[200],
                                          radius: BorderRadius
                                              .circular(
                                              5),
                                        ),
                                      ],
                                    ).show();
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3,bottom: 3),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              Translations
                                                  .of(
                                                  context)
                                                  .create_order,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15
                                              )
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      width: 140,
                                    ),
                                  ),
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
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
          ):
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Center(child: Text(AppModel.lamgug?'لا توجد طلبات':'No Orders')),
          );
        }
    );
  }

    }

var alertStyle = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: true,
  descStyle: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 13,color: Colors.grey[600],fontWeight: FontWeight.normal),
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  titleStyle: TextStyle(
    color: Colors.grey,
  ),
);



Widget custAppBar(String _image , bool _login ,String title,bool _notifi ,BuildContext context,VoidCallback voidCallback){
  return Consumer<Cart>(
      builder: (context , cart , child) {
    //print('my list : '+cart.listMyCart.length.toString());
    return Column(
      children: <Widget>[
        SizedBox(
          height: 25,
        ),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 1, // has the effect of softening the shadow
                spreadRadius: 0.0, // has the effect of extending the shadow
                offset: Offset(
                  0.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 0,bottom: 0,left: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(flex: 1),
                ClipOval(
                    child: Material(
                      color: Colors.transparent, // button color
                      child: InkWell(
                        child: SizedBox(width: 40, height: 40, child: Icon(
                          Icons.menu,
                          color: Theme.of(context).primaryColor,
                        ),
                        ),
                        onTap: () {
                          voidCallback();
                        },
                      ),
                    )
                ),
                Spacer(flex: 5),
                Text(
                  title,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 19,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold
                  ),
                ),
                Spacer(flex: 5),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(PageRouteTransition(
                        animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                        builder: (context) => Profile()
                    )
                    );
                  },
                  child: Container(
                    height: 20,
                    width: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(70)),
                      child: Container(
                        color: Colors.white,
                        child: _login?_image != null?FadeInImage.assetNetwork(
                          height: 20,
                          fit: BoxFit.fill,
                          placeholder: 'assets/images/profile_image.png',
                          image: _image,
                        ): Image(
                            image: AssetImage(
                              'assets/images/profile_image.png',
                            )
                        ):ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(70)),
                          child: SvgPicture.asset(
                            'assets/user.svg',
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 2),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      child: SvgPicture.asset(
                        cart.notification?'assets/notifi/notifi_active.svg':'assets/notifi/bell.svg',
                        semanticsLabel: 'Acme Logo',
                        width: 20,
                        height: 20,
                      ),
                      onTap: (){
                        Navigator.of(context).push(PageRouteTransition(
                            animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                            builder: (context) => Notifications()
                         )
                        );
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ClipOval(
                        child: Material(
                          color: Colors.transparent, // button color
                          child: InkWell(
                            child: SizedBox(width: 40, height: 40, child: Icon(
                              Icons.help,
                              color: Theme.of(context).primaryColor,
                            ),
                            ),
                            onTap: (){
                              Navigator.of(context).push(PageRouteTransition(
                                  animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                  builder: (context) => HelpsDetails(
                                    title: Translations.of(context).catigories,
                                    title_ar: 'المجالات',
                                    )
                                  )
                                );
                              },
                          ),
                        )
                    ),
                  ],
                ),
                Spacer(flex: 1)
              ],
            ),
          ),
        ),
      ],
    );},
  );
}