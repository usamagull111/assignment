
import 'package:assignment/views/auth/sign_in_screen.dart';
import 'package:assignment/views/auth/sign_up_screen.dart';
import 'package:assignment/views/home_screen.dart';
import 'package:flutter/material.dart';

class RouteNames {
  static const String home = '/dashBoard';
  static const String signin = '/signin';
  static const String signUp = '/signup';
}

class OnGenerateRoute{
  static Route<dynamic> route(RouteSettings settings){
    if(settings.name == RouteNames.home){
      return MaterialPageRoute(builder: (context) {
        return const HomeScreen();
      },);
    }else if(settings.name == RouteNames.signin){
      return MaterialPageRoute(builder: (context) {
        return const SignInScreen();
      },);
    }else {
      return MaterialPageRoute(builder: (context) {
        return const SignupScreen();
      },);
    }
  }
}