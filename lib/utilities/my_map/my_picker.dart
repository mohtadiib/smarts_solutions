import 'dart:async';

import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as $;

import 'string_map.dart';

class PlacePickerResult {
  LatLng latLng;
  String address;

  PlacePickerResult(this.latLng);

  @override
  String toString() {
    return 'latLng: $latLng';
  }
}

class PlacePickerScreen extends StatefulWidget {
  final String googlePlacesApiKey;
  final LatLng initialPosition;
  final Color mainColor;

  final MapPickerStrings mapStrings;
  final String placeAutoCompleteLanguage;

  const PlacePickerScreen(
      {Key key,
        @required this.googlePlacesApiKey,
        @required this.initialPosition,
        @required this.mainColor,
        this.mapStrings,
        this.placeAutoCompleteLanguage})
      : super(key: key);

  @override
  State<PlacePickerScreen> createState() => PlacePickerScreenState(
      googlePlacesApiKey: googlePlacesApiKey,
      initialPosition: initialPosition,
      mainColor: mainColor,
      mapStrings: mapStrings,
      placeAutoCompleteLanguage: placeAutoCompleteLanguage);
}

class PlacePickerScreenState extends State<PlacePickerScreen> {
  final String googlePlacesApiKey;
  final LatLng initialPosition;
  final Color mainColor;

  MapPickerStrings strings;
  String placeAutoCompleteLanguage;

  PlacePickerScreenState(
      {@required this.googlePlacesApiKey,
        @required this.initialPosition,
        @required this.mainColor,
        @required mapStrings,
        @required placeAutoCompleteLanguage}) {
    centerCamera = LatLng(initialPosition.latitude, initialPosition.longitude);
    zoomCamera = 16;
    selectedLatLng =
        LatLng(initialPosition.latitude, initialPosition.longitude);

    _places = GoogleMapsPlaces(apiKey: googlePlacesApiKey);

    this.strings = mapStrings ?? MapPickerStrings.english();
    this.placeAutoCompleteLanguage = 'en';
  }

  GoogleMapsPlaces _places;
  GoogleMapController googleMapController;

  //Camera
  LatLng centerCamera;
  double zoomCamera;

  //My Location
  LatLng myLocation;

  //Selected
  LatLng selectedLatLng;
  LatLng selectedLat;
  LatLng selectedLang;

  String selectedAddress;

  bool loadingAddress = false;
  bool movingCamera = false;
  bool ignoreGeocoding = false;
  bool areaTrue = false;

  static double _defaultZoom = 16;

  ///BASIC
  _moveCamera(LatLng latLng, double zoom) async {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: zoom)));
  }

  Future<$.LocationData> _getLocation() async {
    var location = new $.Location();
    $.LocationData locationData;
    try {
      locationData = await location.getLocation();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      locationData = null;
    }

    if (locationData != null)
      myLocation = LatLng(locationData.latitude, locationData.longitude);

    return locationData;
  }

  Future<Address> _reverseGeocoding(double lat, double lng) async {
    final coordinates = new Coordinates(lat, lng);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    return first;
  }

  @override
  Widget build(BuildContext context) {
    _setSelectedAddress(LatLng latLng, String address) async {
      setState(() {
        selectedAddress = address;
        selectedLatLng = LatLng(latLng.latitude, latLng.longitude);

        int lantArea = int.parse(shortLangt(selectedLatLng.toString(),true));
        assert(lantArea is int);

        int langetArea = int.parse(shortLangt(selectedLatLng.toString(),false));
        assert(lantArea is int);

        print('my langet area :'+langetArea.toString());

        print('my lantet area :'+lantArea.toString());


        if( lantArea == 19 && langetArea == 37){
          areaTrue = true;
        }else{
          areaTrue = false;
        }

      });
    }

    ///GO TO
    _searchPlace() async {
      var location;
      if (myLocation != null) {
        location = Location(myLocation.latitude, myLocation.longitude);
      } else {
        location =
            Location(initialPosition.latitude, initialPosition.longitude);
      }
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: googlePlacesApiKey,
        mode: Mode.fullscreen,
        // Mode.fullscreen
        language: placeAutoCompleteLanguage,
        location: location,
      );

      if (p != null) {
        // get detail (lat/lng)
        PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId);
        final lat = detail.result.geometry.location.lat;
        final lng = detail.result.geometry.location.lng;

        var latLng = LatLng(lat, lng);
        var address = p.description;

        CameraPosition newPosition =
        CameraPosition(target: latLng, zoom: _defaultZoom);

        ignoreGeocoding = true;
        googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(newPosition));

        _setSelectedAddress(latLng, address);
      }
    }

    _goToMyLocation() async {
      await _getLocation();
      if (myLocation != null) {
        _moveCamera(myLocation, _defaultZoom);
      }
    }

    ///WIDGETS
    Widget _mapButtons() {
      return Padding(
        padding: EdgeInsets.only(top: 40, left: 8, right: 8),
        child: Column(
          children: <Widget>[
            FloatingActionButton(
              heroTag: "FAB_SEARCH_PLACE",
              backgroundColor: Colors.white,
              child: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                _searchPlace();
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: FloatingActionButton(
                heroTag: "FAB_LOCATION",
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.my_location,
                  color: Colors.black,
                ),
                onPressed: () {
                  _goToMyLocation();
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: centerCamera,
                    zoom: zoomCamera,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                  },
                  onTap: (latLng) {
                    CameraPosition newPosition =
                    CameraPosition(target: latLng, zoom: _defaultZoom);
                    googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(newPosition));
                  },
                  onCameraMoveStarted: () {
                    setState(() {
                      movingCamera = true;
                    });
                  },
                  onCameraMove: (position) {
                    centerCamera = position.target;
                    zoomCamera = position.zoom;
                  },
                  onCameraIdle: () async {
                    if (ignoreGeocoding) {
                      ignoreGeocoding = false;
                      setState(() {
                        movingCamera = false;
                      });
                    } else {
                      setState(() {
                        movingCamera = false;
                        loadingAddress = true;
                      });

                      var address = (await _reverseGeocoding(
                          centerCamera.latitude, centerCamera.longitude))
                          .addressLine;
                      loadingAddress = false;

                      _setSelectedAddress(centerCamera, address);
                    }
                  },
                ),
                _mapButtons(),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(
                      Icons.location_on,
                      size: 60,
                      color: mainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: ListTile(
                    title: Text(strings.address),
                    subtitle: selectedAddress == null
                        ? Text(strings.firstMessageSelectAddress)
                        : Text(selectedAddress),
                    trailing: loadingAddress
                        ? CircularProgressIndicator(
                      backgroundColor: mainColor,
                    )
                        : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 160,
                        padding: EdgeInsets.only(right: 16),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(strings.cancel),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: mainColor)),
                        ),
                      ),
                      Expanded(
                        child: areaTrue? FlatButton(
                          onPressed: !movingCamera &&
                              !loadingAddress &&
                              selectedAddress != null
                              ? () {
                            PlacePickerResult result = PlacePickerResult(
                                selectedLatLng);
                            print(result);

                            Navigator.pop(context, result);
                          }
                              : null,
                          child: Text(
                            strings.selectAddress,
                            style: TextStyle(color: Colors.white),
                          ),
                          color: mainColor,
                          disabledColor: Colors.grey[350],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: mainColor)),
                        ):Text('لا تتوفر الخدمة في هذه المنطقة'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  String shortLangt(String longtLang,bool langTest){
    String str = longtLang;
    String start;
    String end;
    if(langTest){
      start = "(";
      end = ",";
    }else{
      start = ",";
      end = ",";
    }
    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);
    print('lang here :'+str.substring(startIndex + start.length, endIndex)); // brown fox jumps
    var shLant = str.substring(startIndex + start.length, endIndex);
    var lang = shLant.toString().trim();
    var shortLangt = lang[0]+lang[1];
    return shortLangt;// 'artlang'
  }
}
