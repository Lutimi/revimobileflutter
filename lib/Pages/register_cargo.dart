import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterCargo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterCargo();
}

class _RegisterCargo extends State<RegisterCargo> {
  final HttpService httpService = HttpService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Register Cargo"),
        ),
      ),
    );
  }
}
