import 'package:best_flutter_ui_templates/modle/cart.dart';
import 'package:best_flutter_ui_templates/providor.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapOrders extends StatefulWidget {
  String lat , lng , title , orderId;
  MapOrders({this.lat,this.lng,this.title,this.orderId});

  @override
  MapOrdersState createState() => MapOrdersState();
}

class MapOrdersState extends State<MapOrders> {
  //
  Completer<GoogleMapController> _controller = Completer();
  static LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(45.531563, -122.677433),
    tilt: 59.440,
    zoom: 11.0,
  );

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: AppModel.lamgug?'موقعي':'My Location',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }


  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _center = LatLng(Cart().convertToDouble(widget.lat), Cart().convertToDouble(widget.lng));
      _lastMapPosition = LatLng(Cart().convertToDouble(widget.lat), Cart().convertToDouble(widget.lng));
    });
    _onAddMarkerButtonPressed();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
          ),
            Opacity(
              opacity: 0.8,
              child: Container(
                  height: 90,
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                        ],
                      ),
                    borderRadius: new BorderRadius.only(
                      bottomRight: const Radius.circular(30),
                      bottomLeft: const Radius.circular(30),
                    ),
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40,left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                    ), onPressed: () {
                    Navigator.pop(context);
                  },
                  ),
                  Spacer(),
                  Spacer(),
                  Text(
                    '${widget.orderId}',
                    style: TextStyle(
                        color: Colors.black54
                    ),
                  ),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}