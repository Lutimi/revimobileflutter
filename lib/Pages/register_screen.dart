import 'dart:io';
import 'package:TS_AppsMovil/Model/SignUp.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff1565c0),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final imagePicker = ImagePicker();
  final HttpService httpService = HttpService();
  Signup signup = Signup();

  int _choosen = 1;
  File profileImage;

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return true;
    //return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          margin: const EdgeInsets.fromLTRB(10, 80, 10, 80),
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
                    SizedBox(
                      height: 10,
                    ),
                    // Nombre
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
                      validator: (_) {
                        return !state.isEmailValid ? 'Invalid Email' : null;
                      },
                    ),
                    // Un textForm para password
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock), labelText: 'Password'),
                      obscureText: true,
                      autocorrect: false,
                      autovalidate: true,
                      validator: (_) {
                        return !state.isPasswordValid
                            ? 'Invalid Password'
                            : null;
                      },
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

  void _onEmailChanged() {
    _registerBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _registerBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() async {
    //regitro del usuario al restful API
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    signup.firstName = _firstNameController.text;
    signup.lastName = _lastNameController.text;
    signup.email = _emailController.text;
    signup.password = _passwordController.text;
    signup.phone = _phoneController.text;
    signup.discriminator = _choosen;

    var response = await httpService.signUp(signup);

    String docName = response['resource']['email'].toString();

    debugPrint("email : " + docName);

    //Guardando datos en firestore
    DocumentReference currentDoc =
        FirebaseFirestore.instance.collection('users').doc(signup.email);

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

              //enviando el evento submitted
              _registerBloc.add(Submitted(
                  email: _emailController.text,
                  password: _passwordController.text))
            }
        });
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

  /*
  void signUp(Signup signup) async {
    var response = await httpService.SignUp(signup);
    //print(json.encode(response));
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (response['success'] == true) {
      debugPrint('Enabled');
      //SHARED PREFERENCES
      /*setState(() {
        sharedPreferences.setString("token", response['resource']['token']);
      });*/
      //SharedPreferences.setString("token", response.id);
      debugPrint("Success");

      //Navigator.of(context).pushAndRemoveUntil(
      //    MaterialPageRoute(builder: (context) => Dashboard()),
      //    (Route<dynamic> route) => false);
      return response;
    } else {
      debugPrint("Failed");
    }
  }*/
}
