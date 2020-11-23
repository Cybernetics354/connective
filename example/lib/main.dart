import 'package:connective/connective.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());

  String url = "google.com";
  Connective.instance.initialize(ConnectiveConfiguration(
    url,
    delay: Duration(seconds: 2),
    timeout: Duration(seconds: 3),
    onMobileData: () {
      Fluttertoast.showToast(msg: "Mobile Data");
    },
    onWifi: () {
      Fluttertoast.showToast(msg: "Wifi");
    },
    onNoNetwork: () {
      Fluttertoast.showToast(msg: "No network");
    },
    whenOffline: () {
      Fluttertoast.showToast(msg: "Cant connect to $url");
    },
    whenOnline: () {
      Fluttertoast.showToast(msg: "Connected to $url");
    }
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Connective example",
      home: HomeMainView(),
    );
  }
}

class HomeMainView extends StatefulWidget {
  @override
  _HomeMainViewState createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connective"),
      ),
      body: Container(),
    );
  }
}