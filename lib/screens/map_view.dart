import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/modle/regions_model.dart';
import 'package:best_flutter_ui_templates/network/map_api/regions.dart';
import 'package:best_flutter_ui_templates/network/net_provider.dart';
import 'package:best_flutter_ui_templates/utilities/my_map/keys.dart';
import 'package:best_flutter_ui_templates/utilities/pick_map/src/components/floating_card.dart';
import 'package:best_flutter_ui_templates/utilities/pick_map/src/models/pick_result.dart';
import 'package:best_flutter_ui_templates/utilities/pick_map/src/place_picker.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_visit/latest_screen_visit.dart';
import '../providor.dart';
import 'lastest_screen.dart';


class MapViewPage extends StatefulWidget {

  String date_ar , date_en ,time_ar;
  MapViewPage({Key key , this.date_ar , this.date_en ,this.time_ar}) : super(key: key);

  static final kInitialPosition = LatLng(24.039680 , 45.483447);

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  PickResult selectedPlace;
  bool noService = true;
  var location = Location();
  String _firstName , _lastName , _phoneNumber;

  _getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

  }


  @override
  void initState() {
    NetProvider netProvider = Provider.of<NetProvider>(context , listen: false);
    GetRegions().getRegions(netProvider);
    // TODO: implement initState
    super.initState();
    _checkGps();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Consumer<NetProvider>(
          builder: (context , netPov , child) {
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  PlacePicker(
                    apiKey: APIKeys.apiKey,
                    initialPosition: MapViewPage.kInitialPosition,
                    hintText: AppModel.lamgug?'بحث':'Search',
                    useCurrentLocation: false,
                    usePlaceDetailSearch: true,
                    searchForInitialValue: true,
                    forceSearchOnZoomChanged: false,
                    searchingText: 'اسم المنطقة',
                    onPlacePicked: (result) {
                      selectedPlace = result;
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    selectedPlaceWidgetBuilder: (_, selectedPlace,
                        state, isSearchBarFocused) {
                      if (selectedPlace != null) {
                        var lat = selectedPlace.geometry.location
                            .lat.toString();
                        int latInt = int.parse(lat[0] + lat[1]);
                        assert(latInt is int);
                        print('latetude here :' +
                            latInt.toString()); //

                        var lang = selectedPlace.geometry.location
                            .lng.toString();
                        int langInt = int.parse(
                            lang[0] + lang[1]);

                        assert(langInt is int);
                        print('langtude here :' +
                            langInt.toString()); //


                        _checkRegionPosition(latInt, langInt ,netPov.listGetRegions);

                      }


                      print(
                          "state: $state, isSearchBarFocused: $isSearchBarFocused");
                      return isSearchBarFocused
                          ? Container()
                          : FloatingCard(
                        bottomPosition: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05,
                        leftPosition: MediaQuery
                            .of(context)
                            .size
                            .width * 0.025,
                        rightPosition: MediaQuery
                            .of(context)
                            .size
                            .width * 0.025,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
                        borderRadius: BorderRadius.circular(12.0),
                        elevation: 4.0,
                        color: Theme
                            .of(context)
                            .cardColor,
                        child: state == SearchingState.Searching
                            ? _buildLoadingIndicator()
                            : noService ? _buildSelectionDetails(
                            context, selectedPlace, () {
                          Cart.userLocation_Lat = selectedPlace.geometry.location.lat.toString();
                          Cart.userLocation_Lng = selectedPlace.geometry.location.lng.toString();

                          print('my location here :');
                          setState(() {
                            this.selectedPlace = selectedPlace;
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);

                          Navigator.of(context).push(PageRouteTransition(
                              animationType: AppModel.lamgug?  AnimationType2.slide_left : AnimationType2.slide_right,
                              builder: (context) => widget.date_ar == 'direct'?
                              LatestScreen(
                                lat: this.selectedPlace.geometry.location.lat.toString(),
                                lng: this.selectedPlace.geometry.location.lng.toString(),
                                locationName: this.selectedPlace.formattedAddress,
                              )
                                  :LatestScrVisit(
                                userLocation: this.selectedPlace.formattedAddress,
                                timeVisit: widget.time_ar,
                                dateVisit_ar: widget.date_ar,
                                dateVisit_en: widget.date_en,
                                lat: this.selectedPlace.geometry.location.lat.toString(),
                                lng: this.selectedPlace.geometry.location.lng.toString(),
                              )
                          )
                          );

                        }) : Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                AppModel.lamgug?'لا تتوفر خدمات Smart Solutions في هذه المنطقة':'there is no service in this area',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[400]
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: EdgeInsets.only(top: 20,bottom: 20),
      height: 48,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildSelectionDetails(BuildContext context, PickResult result,VoidCallback voidCallback) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            result.formattedAddress,
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,),
          Container(
            width: double.infinity,
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 7,bottom: 7),
                child: Text(
                  AppModel.lamgug?'تحديدها كنقطة الالتقاط':'Determine my location',
                  style: TextStyle(fontSize: 15,
                      color: Colors.white),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: () {
                voidCallback();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _checkRegionPosition(int doubleLat,int langtude ,List<Regions> list){

    print('region list here:'+list.length.toString());
    this.noService = false;
    for(var i = 0; i < list.length; i++){

      if(list[i].lat != '' && list[i].lng != ''){
        int _lat = Cart().convertToInt(list[i].lat[0]+list[i].lat[1]);
        int _lng = Cart().convertToInt(list[i].lng[0]+list[i].lng[1]);

        print('lat is here:'+_lat.toString());
        print('lng is here:'+_lng.toString());
        print('-----------------------------------');


        if(doubleLat == _lat && langtude == _lng ){
          this.noService = true;
          print('true LatLng here is lat :'+_lat.toString());

          print(' is lng :'+_lng.toString());

        }
      }else{
        this.noService = false;
      }
    }
  }

  double convertToDouble(String str){
    var _xx = double.parse(str);
    assert(_xx is double);
    return _xx;
  }
  Future _checkGps() async {
    if(!await location.serviceEnabled()){
      location.requestService();
      //    _openSettingsMenu("ACTION_ACCESSIBILITY_SETTINGS");
    }
  }
}
