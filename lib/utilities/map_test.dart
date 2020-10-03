import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventLocation extends StatefulWidget {
  const EventLocation({Key key}) : super(key: key);
  @override
  _EventLocationState createState() => _EventLocationState();
}

class _EventLocationState extends State<EventLocation> {
  bool _mapLoading = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.4220, -122.0841),
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) =>
                setState(() => _mapLoading = false),
          ),
          (_mapLoading)
              ? Container(
            height: size.height,
            width: size.width,
            color: Colors.grey[100],
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}