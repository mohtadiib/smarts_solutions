import 'dart:convert';

import 'package:best_flutter_ui_templates/utilities/my_map/keys.dart';
import 'package:best_flutter_ui_templates/utilities/pick_map/src/components/floating_card.dart';
import 'package:best_flutter_ui_templates/utilities/pick_map/src/models/pick_result.dart';
import 'package:best_flutter_ui_templates/utilities/pick_map/src/place_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewPicker extends StatelessWidget {
  // Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.yellow,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Place Picker Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PickResult selectedPlace;
  bool noService = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map Place Picer Demo"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Load Google Map"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          apiKey: APIKeys.apiKey,
                          initialPosition: HomePage.kInitialPosition,
                          useCurrentLocation: true,
                          //usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            selectedPlace = result;
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          //forceSearchOnZoomChanged: true,
                          //automaticallyImplyAppBarLeading: false,
                          //autocompleteLanguage: "ko",
                          //region: 'au',
                          //selectInitialPosition: true,
                          selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {

                            if(selectedPlace != null){
                              var lat = selectedPlace.geometry.location.lat.toString();
                              var latInt = double.parse(lat[0]+lat[1]);
                              assert(latInt is double);
                              print(latInt); // 12345

                              checkRegion(latInt);

                            }


                            print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                            return isSearchBarFocused
                                ? Container()
                                : FloatingCard(
                              bottomPosition: MediaQuery.of(context).size.height * 0.05,
                              leftPosition: MediaQuery.of(context).size.width * 0.025,
                              rightPosition: MediaQuery.of(context).size.width * 0.025,
                              width: MediaQuery.of(context).size.width * 0.9,
                              borderRadius: BorderRadius.circular(12.0),
                              elevation: 4.0,
                              color: Theme.of(context).cardColor,
                              child: state == SearchingState.Searching
                                  ? _buildLoadingIndicator()
                                  : noService? _buildSelectionDetails(context, selectedPlace,(){
//                                       Navigator.of(context).pop();

                                print('my location here :');
                                setState(() {
                                  this.selectedPlace = selectedPlace;
                                });
                              }):Padding(
                                padding: const EdgeInsets.only(top: 20,bottom: 20),
                                child: Center(
                                  child: Text('لا توجد خدمة في هذه المنطقة'),
                                ),
                              ),
                            );
                          },
                          // pinBuilder: (context, state) {
                          //   if (state == PinState.Idle) {
                          //     return Icon(Icons.favorite_border);
                          //   } else {
                          //     return Icon(Icons.favorite);
                          //   }
                          // },
                        );
                      },
                    ),
                  );
                },
              ),
              selectedPlace == null ? Container() : Text(selectedPlace.geometry.location.lat.toString() ?? ""),
            ],
          ),
        ));
  }

  Widget _buildLoadingIndicator() {
    return Container(
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
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            result.formattedAddress,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Select here",
              style: TextStyle(fontSize: 16),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            onPressed: () {
              voidCallback();
            },
          ),
        ],
      ),
    );
  }

  void checkRegion(double doubleLat){
    if(doubleLat == 19.0){
      this.noService = true;
    }else{
      this.noService = false;
    }
  }

}
