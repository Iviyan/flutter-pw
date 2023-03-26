import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebaseapp/views/main_page.dart';
import 'package:firebaseapp/views/signin_page.dart';
import 'package:firebaseapp/views/signup_page.dart';

const String pageSignIn = "signin";
const String pageSignUp = "signup";
const String pageMain = "main";

class AppRouter {
  Route<dynamic>? generateRouter(RouteSettings settings) {
    switch (settings.name) {
      case pageSignIn: return MaterialPageRoute(builder: (_) => const SignInPage());
      case pageSignUp: return MaterialPageRoute(builder: (_) => const SignUpPage());
      case pageMain: return MaterialPageRoute(builder: (_)
        => MainPage(userCredential: (settings.arguments as MainRouteArguments).userCredential));
    }
    return null;
  }
}

class MainRouteArguments {
  MainRouteArguments({ required this.userCredential });
  final UserCredential userCredential;
}