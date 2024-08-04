import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapSample()),
                );
              },
              child: Text('Go to The Lake'),
            ),
            SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomeScreen()),
                );
              },
              child: Text('Go To My Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition kGoogleplex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.06832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926048649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: kGoogleplex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToTheLake,
        label: Text('GO To The Lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
  }
}

class MyHomeScreen extends StatelessWidget {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition kGoogleplex = CameraPosition(
    target: LatLng(13.57882113151725, 100.63165351180999),
    zoom: 14.4746,
  );

  static final CameraPosition kHome = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(13.5789149919753, 100.63164278297423),
      tilt: 59.440717697143555,
      zoom: 19.151926048649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Home'),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: kGoogleplex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToTheHome,
        label: Text('GO TO THE HOME !'),
        icon: Icon(Icons.home),
      ),
    );
  }

  Future<void> goToTheHome() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kHome));
  }
}
