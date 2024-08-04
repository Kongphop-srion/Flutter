import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSimple extends StatefulWidget {
  @override
  _MapSimpleState createState() => _MapSimpleState();
}

class _MapSimpleState extends State<MapSimple> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.4212312321, -122.0923593),
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Google Map'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            markerId: MarkerId('Marker1'),
            position: LatLng(37.4212312321, -122.0923593),
            infoWindow: InfoWindow(
              title: 'Marker Title',
              snippet: 'Marker Description',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _zoomToMarker,
        child: Icon(Icons.zoom_in),
      ),
    );
  }

  Future<void> _zoomToMarker() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(37.4212312321, -122.0923593),
      16.0,
    ));
  }
}
