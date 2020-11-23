import 'dart:io';

import 'package:TS_AppsMovil/Model/User.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Settings();
}

class _Settings extends State<SettingsScreen> {
  final HttpService httpService = HttpService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final imagePicker = ImagePicker();

  String firstName = "";
  String lastName = "";
  String language = "";
  String paymentCurrency = "";
  String phone = "";
  File profileImage;
  String profileURL;
  auth.User _currentUser;
  UserResponse apiUser;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    profileURL = null;
    String email = _currentUser.email;
    DocumentReference checkExistEmail =
        FirebaseFirestore.instance.collection('users').doc(email);
    checkExistEmail.get().then((data) => {
          if (data.exists)
            {
              checkLoginStatus(data.get("email").toString(),
                  data.get("password").toString()),
            }
          else
            {}
        });
  }

  checkLoginStatus(String email, String password) async {
    sharedPreferences = await SharedPreferences.getInstance();

    String _currentEmail = _currentUser.email;
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentEmail)
        .get();
    int id = variable.data()['id'];
    Map<String, dynamic> response =
        await httpService.getConfigurationByUserId(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Card(
      margin: const EdgeInsets.fromLTRB(30, 100, 30, 100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Form(
            child: ListView(
          children: <Widget>[
            Center(
              child: profileImage == null
                  ? FloatingActionButton(
                      onPressed: getImage,
                      tooltip: 'Agrega una imagen',
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                      ),
                    )
                  : Image.file(
                      profileImage,
                      height: 150,
                      width: 150,
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                icon: FaIcon(FontAwesomeIcons.signature),
                labelText: 'Nombres',
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
              autovalidate: true,
            ),
            // Apellidos
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                icon: FaIcon(FontAwesomeIcons.signature),
                labelText: 'Apellidos',
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
              autovalidate: true,
            ),
            // Un textForm para email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autovalidate: true,
            ),
            // Un textForm para password
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                  icon: Icon(Icons.lock), labelText: 'Password'),
              obscureText: true,
              autocorrect: false,
              autovalidate: true,
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                icon: FaIcon(FontAwesomeIcons.phone),
                labelText: 'Telefono',
              ),
              keyboardType: TextInputType.number,
              autocorrect: false,
              autovalidate: true,
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Text('Guardar cambios', style: TextStyle(fontSize: 20)),
              color: Color(0xff007bff),
              textColor: Colors.white,
            ),
          ],
        )),
      ),
    ));
  }

  Future getImage() async {
    var tempImage = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      profileImage = File(tempImage.path);
    });
  }
}
