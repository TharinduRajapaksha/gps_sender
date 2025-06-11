import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const taskName = "sendLocation";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == taskName) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      var response = await http.post(
        Uri.parse('http://<YOUR_PUBLIC_SERVER_IP>:3000/location'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "latitude": position.latitude,
          "longitude": position.longitude,
          "timestamp": DateTime.now().toIso8601String(),
        }),
      );
      print("Location sent: ${response.statusCode}");
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "1",
    taskName,
    frequency: Duration(minutes: 15),
  ); // Android min interval is 15 mins
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Tracker',
      home: Scaffold(
        appBar: AppBar(title: Text("Location Tracker")),
        body: Center(child: Text("Tracking location in background...")),
      ),
    );
  }
}
