// Imports
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;

  // Constructor
  UserRepository(
      {auth.FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignIn,
      FacebookLogin facebookLogin})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookLogin = facebookLogin ?? FacebookLogin();

  auth.User get user {
    return _firebaseAuth.currentUser;
  }

  Future<void> signInWithFacebook() async {
    try {
      signOut(); //cerrar sesión de todos los servicios
      final result = await _facebookLogin.logIn(['email']);

      //checkear el correo

      if (result.status == FacebookLoginStatus.loggedIn) {
        final facebookAuthCred =
            auth.FacebookAuthProvider.credential(result.accessToken.token);

        //final graphResponse = await http.get(
        //    'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');

        //final profile = json.decode(graphResponse.body);
        //debugPrint(profile['email'].toString());
        final auth.UserCredential user =
            (await _firebaseAuth.signInWithCredential(facebookAuthCred));
        return user;
      }
    } catch (e) {
      print('error caught: $e');
      debugPrint('error caught: $e');
    }
  }

  // SignInWithGoogle
  Future<auth.UserCredential> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final auth.UserCredential authResult =
          (await _firebaseAuth.signInWithCredential(credential));
      debugPrint("authResult : " + authResult.user.displayName);
      print("authResult : " + authResult.user.displayName);

      return authResult;
    } catch (e) {
      print('EXCEPTION : ' + 'error caught: $e');
    }

    /*
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
    */
  }
  /*
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await account.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);

    final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final User user = authResult.user;

    return user;
  }
  */
  /*
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    UserCredential s = await _firebaseAuth.signInWithCredential(credential);
    return s;
  }*/

  // SignInWithCredentials
  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // SignUp - Registro
  Future<void> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // SignOut
  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _facebookLogin.logOut()
    ]);
  }

  // Esta logueado?
  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  // Obtener usuario
  Future<String> getUser() async {
    return (_firebaseAuth.currentUser.email);

    //return "test";
  }

  Future<auth.User> gettUser() async {
    return _firebaseAuth.currentUser;
  }

  /*
  bool _checkEmail(String email) {
    var result;
    var doc = FirebaseFirestore.instance.collection('users').doc(email);
    doc.get().then((docData) => {
          if (docData.exists) {result = true} else {result = false}
        });
    return result;
  }*/
}
