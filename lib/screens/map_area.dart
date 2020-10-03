import '../utilities/my_map/flutter_map_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AreaMap extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Map Picker Demo'),
      );
    }
  }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const LatLng DEFAULT_LAT_LNG = LatLng(40.416775, 	-3.703790); //Madrid
  var api_key = 'AIzaSyBlTe_M8c4bbCutC-3433CTuIjNiLs0oBA';

  String result = '';

  @override
  Widget build(BuildContext context) {

    pickArea() async{
      AreaPickerResult pickerResult = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  AreaPickerScreen(
        googlePlacesApiKey: api_key,
        initialPosition: DEFAULT_LAT_LNG,
        mainColor: Theme.of(context).primaryColor,
        mapStrings: MapPickerStrings.english(),
        placeAutoCompleteLanguage: 'en',
        markerAsset: 'assets/images/icon_look_area.png',
      )));

      setState(() {
        result = pickerResult.toString();
      });
    }
    pickPlace() async {
      PlacePickerResult pickerResult = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  PlacePickerScreen(
        googlePlacesApiKey: api_key,
        initialPosition: DEFAULT_LAT_LNG,
        mainColor: Theme.of(context).primaryColor,
        placeAutoCompleteLanguage: 'en',
          ),
        ),
      );

      var shortLan = shortLangt(pickerResult.toString(),true);

      setState(() {
        result = shortLan;
        }
      );
    }


    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: pickArea,
                child: Text("Pick area"),
              ),
              RaisedButton(
                onPressed: pickPlace,
                child: Text("Pick place"),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(result),
              ),
            ],
          ),
        ),
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