import 'dart:io';
import 'package:TS_AppsMovil/Model/SignUp.dart';
import 'package:TS_AppsMovil/Pages/dashboard.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:TS_AppsMovil/Utils/utils.dart';
import 'package:TS_AppsMovil/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:TS_AppsMovil/src/bloc/authentication_bloc/authentication_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TS_AppsMovil/src/bloc/register_bloc/bloc.dart';
import 'package:TS_AppsMovil/src/repository/user_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreenFixed extends StatelessWidget {
  final UserRepository userRepository;

  RegisterScreenFixed({Key key, @required this.userRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff1565c0),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: userRepository),
          child: RegisterFormFixed(userRepository),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RegisterFormFixed extends StatefulWidget {
  UserRepository userRepository;

  RegisterFormFixed(this.userRepository);

  @override
  _RegisterFormStateFixed createState() =>
      _RegisterFormStateFixed(this.userRepository);
}

class _RegisterFormStateFixed extends State<RegisterFormFixed> {
  final TextEditingController _phoneController = TextEditingController();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  auth.User _currentUser;
  final imagePicker = ImagePicker();
  final HttpService httpService = HttpService();
  Signup signup = Signup();
  int _choosen = 1;
  File profileImage;
  bool touchDropDown = false;
  UserRepository userRepository;

  _RegisterFormStateFixed(this.userRepository);

  RegisterBloc _registerBloc;

  bool get isPopulated => _phoneController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
      // Si estado es submitting
      if (state.isSubmitting) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Registrando'),
                CircularProgressIndicator()
              ],
            ),
          ));
      }
      // Si estado es success
      if (state.isSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        Navigator.of(context).pop();
      }
      // Si estado es failure
      if (state.isFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Registration Failure'),
                Icon(Icons.error)
              ],
            ),
            backgroundColor: Colors.red,
          ));
      }
    }, child: BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 180, 10, 180),
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30.0, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
                offset: Offset(
                  5.0, // Move to right 10  horizontally
                  5.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: Card(
            margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Completa tu registro ingresando los siguientes datos",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Imagen

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
                              height: 150.0,
                              width: 150.0,
                            ),
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

                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 44.0),
                          child: DropdownButton(
                              isExpanded: true,
                              value: _choosen,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Cliente"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("Conductor"),
                                  value: 2,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _choosen = value;
                                });
                              }),
                        ),
                        // Un button
                        Container(
                          margin: EdgeInsets.only(top: 10.0, left: 0.0),
                          child: FaIcon(FontAwesomeIcons.users),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RegisterButton(
                      onPressed: isRegisterButtonEnabled(state)
                          ? _onFormSubmitted
                          : null,
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
  }

  void _onFormSubmitted() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    signup.firstName = _currentUser.displayName;
    signup.lastName = _currentUser.displayName;
    signup.email = _currentUser.email;
    signup.password = _currentUser.email;
    signup.phone = _currentUser.email;
    signup.discriminator = _choosen;

    //regitro del usuario al restful API
    final response = await httpService.signUp(signup);

    String docName = response['resource']['email'].toString();

    //Agregando correo a Firestore
    DocumentReference currentDoc =
        FirebaseFirestore.instance.collection('users').doc(docName);

    currentDoc.get().then((data) => {
          if (data.exists)
            {
              debugPrint("account exists"),
              _showSnackbar(
                  context, "La cuenta asociada a ese correo ya está creada")
            }
          else
            {
              //Agregando credenciales a Firestore
              currentDoc.set(response['resource']),

              //Agregando correo y contraseña a shared prefrences
              sharedPreferences.setString("email", signup.email),
              sharedPreferences.setString("password", signup.password),
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Dashboard(userRepository: widget.userRepository)),
              )
            }
        });

    //inicia el patron bloc
    //_registerBloc.add(SubmittedAuth(
    //    email: _currentUser.email, password: _currentUser.displayName));
  }

  Future getImage() async {
    var tempImage = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      profileImage = File(tempImage.path);
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    final scaff = Scaffold.of(context);
    scaff.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Color.fromARGB(255, 255, 0, 0),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: "X",
        onPressed: scaff.hideCurrentSnackBar,
      ),
    ));
  }
}
