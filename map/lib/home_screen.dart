import 'package:flutter/material.dart';
import 'map_sample.dart'; // Assuming the map screen code is in a file named map_sample.dart

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapSimple()),
            );
          },
          child: Text('Show Map'),
        ),
      ),
    );
  }
}
