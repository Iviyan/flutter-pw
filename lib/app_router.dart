import 'package:flutter/material.dart';
import 'package:pw/views/signin_page.dart';
import 'package:pw/views/signup_page.dart';

const String pageSignIn = "signin";
const String pageSignUp = "signup";

class AppRouter {
  Route<dynamic>? generateRouter(RouteSettings settings) {
    switch (settings.name) {
      case pageSignIn: return MaterialPageRoute(builder: (_) => const SignInPage());
      case pageSignUp: return MaterialPageRoute(builder: (_) => const SignUpPage());
    }
    return null;
  }
}