import 'package:TS_AppsMovil/Pages/dashboard.dart';
import 'package:TS_AppsMovil/Pages/login_screen.dart';
import 'package:TS_AppsMovil/Pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:TS_AppsMovil/src/bloc/authentication_bloc/bloc.dart';
import 'package:TS_AppsMovil/src/bloc/simple_bloc_delegate.dart';
import 'package:TS_AppsMovil/src/repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await Firebase.initializeApp();
  final UserRepository userRepository = UserRepository();
  runApp(BlocProvider(
    create: (context) =>
        AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
    child: App(userRepository: userRepository),
  ));
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          }
          if (state is Authenticated) {
            return Dashboard(
              userRepository: _userRepository,
            );
          }
          if (state is Unauthenticated) {
            return LoginScreen(
              userRepository: _userRepository,
            );
          }
          return Container();
        },
      ),
    );
  }
}
