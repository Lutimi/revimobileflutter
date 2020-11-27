import 'package:TS_AppsMovil/Model/User.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Profile();
}

class _Profile extends State<ProfileScreen> {
  final HttpService httpService = HttpService();
  final FocusNode myFocusNode = FocusNode();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  String firstName = "";
  String lastName = "";
  String profileURL;
  SharedPreferences sharedPreferences;

  auth.User _currentUser;
  UserResponse apiUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    String email = _currentUser.email;
    profileURL = null;
    DocumentReference checkExistEmail =
        FirebaseFirestore.instance.collection('users').doc(email);
    checkExistEmail.get().then((data) => {
          if (data.exists)
            {
              checkLoginStatus(data.get("email").toString(),
                  data.get("password").toString()),
              callSetState(),
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
    String recEmail = variable.data()['email'];
    String recPass = variable.data()['password'];

    Map<String, dynamic> response = await httpService.signIn(recEmail, recPass);
    apiUser = UserResponse.fromJson(response['resource']);
    debugPrint("apiUser : " + apiUser.email);
    firstName = apiUser.firstName;
    lastName = apiUser.lastName;
    profileURL = _currentUser.photoURL;
    callSetState();
  }

  void callSetState() {
    setState(
        () {}); // it can be called without parameters. It will redraw based on changes done in _SecondWidgetState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,

                    end: Alignment.bottomCenter,
                    colors: [Color(0xff1565c0), Color(0xff1565c0)])),

          ),
          Container(
            width: double.infinity,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  child: profileURL == null
                      ? CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png",
                              scale: 0.3),
                        )
                      : CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(profileURL, scale: 0.3),
                        ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  firstName + lastName,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 22.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Servicios Solicitados",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff1565c0),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "5200",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xff1565c0),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Conductores Favoritos",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff1565c0),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "28.5K",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xff1565c0),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Servicios concretados",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff1565c0),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "1300",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xff1565c0),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Acerca del usuario",
                          style: TextStyle(
                              color: Color(0xff1565c0),
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0),
                        ),
                        SizedBox(height: 20),
                        CustomRow(Icon(FontAwesomeIcons.gamepad),
                            Text("Nombres : "), Text(firstName)),
                        CustomRow(Icon(FontAwesomeIcons.signature),
                            Text("Apellidos : "), Text(lastName)),
                        CustomRow(Icon(FontAwesomeIcons.envelope),
                            Text("Correo : "), Text(lastName)),
                        CustomRow(Icon(FontAwesomeIcons.phone),
                            Text("Telefono : "), Text(lastName)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Detalles:",
                    style: TextStyle(
                        color: Color(0xff1565c0),
                        fontStyle: FontStyle.normal,
                        fontSize: 28.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Nombres : ' + firstName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    'Apellidos : ' + lastName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    'Correo : ' + lastName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    'Telefono : ' + lastName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),*/
          /*
          SizedBox(
            height: 20.0,
          ),*/
          /*Container(
            width: 300.00,
            child: RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                elevation: 0.0,
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Color(0xff1565c0), Color(0xff1565c0)]),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        child: Text(
                          "Volver",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26.0,
                              fontWeight: FontWeight.w300),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )),
                )),
          ),*/
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomRow extends StatelessWidget {
  Text col1;
  Text col2;
  Icon icon;

  CustomRow(icon, col1, col2) {
    this.col1 = col1;
    this.col2 = col2;
    this.icon = icon;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        hoverColor: Colors.lightBlue[200],
        child: Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon,
                SizedBox(width: 10),
                col1,
                SizedBox(width: 10),
                col2,
              ],
            )));
  }
}
