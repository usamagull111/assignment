import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInModel with ChangeNotifier {
  String _email = '';
  String _password = '';

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  bool validate() {
    return _email.isNotEmpty && _password.isNotEmpty && _email.contains('@');
  }

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message.toString());
    }
  }
}