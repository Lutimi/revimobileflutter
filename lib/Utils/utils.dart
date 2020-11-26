import 'package:TS_AppsMovil/Pages/register_screen.dart';
import 'package:TS_AppsMovil/src/bloc/login_bloc/login_bloc.dart';
import 'package:TS_AppsMovil/src/bloc/login_bloc/login_event.dart';
import 'package:TS_AppsMovil/src/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

ListTile customRowDataIcon(IconData iconData, String rowVal) {
  return ListTile(
    leading: Container(
      child: Icon(
        iconData,
        color: Colors.white,
        size: 20,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff303f9f),
      ),
    ),
    title: Text(rowVal, style: TextStyle(color: Colors.black)),
  );
}

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  Text col1;
  Text col2;
  Text col3;

  CustomListTile(col1, col2, col3) {
    this.col1 = col1;
    this.col2 = col2;
    this.col3 = col3;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        hoverColor: Colors.lightBlue[200],
        child: Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[col1, col2, col3],
            )));
  }
}

//==========AuthButtons====================================

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        '¿No tienes una cuenta?\nCrea una',
        textAlign: TextAlign.center,
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RegisterScreen(
            userRepository: _userRepository,
          );
        }));
      },
    );
  }
}

//=====================================================================

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Color(0xff007bff),
      textColor: Colors.white,
      child: Text('Entrar'),
    );
  }
}

//==============================================================

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleSignInButton(
      onPressed: () {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Iniciando sesión...'),
            CircularProgressIndicator(),
          ],
        )));

      },
    );
  }
}

//==============================================================================
// ignore: must_be_immutable
class FacebookLoginButton extends StatelessWidget {
  String email;

  @override
  Widget build(BuildContext context) {
    return FacebookSignInButton(onPressed: () {

    });
  }
}

//==============================================================================

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegisterButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Text('Registrar'),
      onPressed: _onPressed,
    );
  }
}

//===========================================================================
