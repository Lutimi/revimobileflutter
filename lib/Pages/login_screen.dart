//imports:
import 'package:TS_AppsMovil/Utils/utils.dart';
import 'package:TS_AppsMovil/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:TS_AppsMovil/src/bloc/authentication_bloc/authentication_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TS_AppsMovil/src/bloc/login_bloc/bloc.dart';
import 'package:TS_AppsMovil/src/repository/user_repository.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff1565c0),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      // tres casos, tres if:
      if (state.isFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Login Failure'), Icon(Icons.error)],
              ),
              backgroundColor: Colors.red,
            ),
          );
      }
      if (state.isSubmitting) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Logging in... '),
                CircularProgressIndicator(),
              ],
            ),
          ));
      }
      if (state.isSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 140, 10, 140),
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
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email), labelText: 'Correo'),
                      keyboardType: TextInputType.emailAddress,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_) {
                        return !state.isEmailValid ? 'Correo inválido' : null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock), labelText: 'Contraseña'),
                      obscureText: true,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_) {
                        return !state.isPasswordValid
                            ? 'Contraseña incorrecta'
                            : null;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // Tres botones:
                          // LoginButton

                          LoginButton(
                            onPressed: isLoginButtonEnabled(state)
                                ? _onFormSubmitted
                                : null,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // GoogleLoginButton
                          GoogleLoginButton(),
                          // FacebookLoginButton
                          FacebookLoginButton(),
                          SizedBox(
                            height: 10,
                          ),
                          // CreateAccountButton
                          CreateAccountButton(
                            userRepository: _userRepository,
                          ),
                        ],
                      ),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    var doc = FirebaseFirestore.instance
        .collection("users")
        .doc(_emailController.text);
    doc.get().then((docData) => {
          if (docData.exists)
            {
              _loginBloc.add(LoginWithCredentialsPressed(
                  email: _emailController.text,
                  password: _passwordController.text))
            }
          else
            {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Usuario no registrado'),
                        Icon(Icons.error)
                      ],
                    ),
                    backgroundColor: Colors.red,
                  ),
                )
            }
        });
  }
  /*
  bool EmailPasswordValidator(state) {
    if (!state.isEmailValid || !state.isPasswordValid)
      return true;
    else
      return false;
  }
 
  bool _checkEmail(String email) {
    var result;
    var doc = FirebaseFirestore.instance.collection('users').doc(email);
    doc.get().then((docData) => {
          if (docData.exists) {result = true} else {result = false}
        });
    return result;
  }
  */
}
