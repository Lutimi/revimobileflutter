import 'package:TS_AppsMovil/Model/User.dart';
import 'package:TS_AppsMovil/Pages/profile_screen.dart';
import 'package:TS_AppsMovil/Pages/register_screen_fixed.dart';
import 'package:TS_AppsMovil/Pages/category_list.dart';

import 'package:TS_AppsMovil/Pages/vehicle_list.dart';

import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:TS_AppsMovil/Utils/transitions.dart';
import 'package:TS_AppsMovil/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:TS_AppsMovil/src/bloc/authentication_bloc/authentication_event.dart';
import 'package:TS_AppsMovil/src/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'driver_list.dart';
import 'company_list.dart';

class Dashboard extends StatefulWidget {
  final UserRepository userRepository;

  Dashboard({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashBoard();
}

class _DashBoard extends State<Dashboard> {
  String firstName = "";
  String lastName = "";
  String profileURL;
  int _currentPage = 0;
  SharedPreferences sharedPreferences;
  CustomTransition customTransition = CustomTransition();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final HttpService httpService = HttpService();
  auth.User _currentUser;
  UserResponse apiUser;

  bool gateA = false;

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
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterScreenFixed(
                        userRepository: widget.userRepository)),
              )
            }
        });
  }

  final List<Widget> _navPages = [
    CategoryList(),
    DriverList(),
    CompanyList(),

    VehicleView(),
  ];

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

    gateA = true;
    callSetState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void callSetState() {
    setState(
        () {}); // it can be called without parameters. It will redraw based on changes done in _SecondWidgetState
  }

  //================================================

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text('DashBoard'),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    tooltip: 'Log out',
                    //onPressed: scaffoldKey.currentState.showSnachBar(snackBar);
                    onPressed: () {
                      //sharedPreferences.clear();
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(LoggedOut());
                    })
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 220,
                    child: DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: false,
                        children: <Widget>[
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
                                    backgroundImage:
                                        NetworkImage(profileURL, scale: 0.3),
                                  ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            firstName + " " + lastName,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(
                            'https://static.vecteezy.com/system/resources/previews/000/581/217/non_2x/abstract-dark-blue-background-with-halftone-pattern-light-blue-texture-creative-cover-design-template-vector.jpg'),
                        fit: BoxFit.fill,
                      )),
                    ),
                  ),
                  CustomDrawTile(Icon(Icons.dashboard), Text('Dashboard'),
                      Icon(Icons.arrow_right), ProfileScreen()),
                  CustomDrawTile(Icon(Icons.person), Text('Perfil'),
                      Icon(Icons.arrow_right), ProfileScreen()),
                  CustomDrawTile(
                      Icon(Icons.credit_card),
                      Text('Comprar créditos'),
                      Icon(Icons.arrow_right),
                      ProfileScreen()),
                  CustomDrawTile(
                      Icon(Icons.settings),
                      Text('Configuración de la cuenta'),
                      Icon(Icons.arrow_right),
                      ProfileScreen()),

                  CustomDrawTile(
                      Icon(Icons.car_rental),
                      Text('Vehículos'),
                      Icon(Icons.arrow_right),
                      VehicleView()),
                ],
              ),
            ),
            body: _navPages[_currentPage],
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_tree_outlined),
                  title: Text('Categorías'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text('Conductores'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work_outlined),
                  title: Text('Empresas'),
                )
              ],
              currentIndex: _currentPage,
              selectedItemColor: Colors.lightBlue[800],
              onTap: _onItemTapped,
            )),
        /*Container(
          child: gateA == false
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : null,
        )*/
      ],
    ));
  }
}

// ignore: must_be_immutable
class CustomDrawTile extends StatelessWidget {
  Icon icon1, icon2;
  Text title;
  StatefulWidget page;
  CustomDrawTile(icon1, title, icon2, page) {
    this.icon1 = icon1;
    this.icon2 = icon2;
    this.title = title;
    this.page = page;
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.lightBlue[200],
      child: Container(
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  icon1,
                  Text('  '),
                  title,
                ],
              ),
              icon2,
            ],
          )),
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ))
      },
    );
  }
}
