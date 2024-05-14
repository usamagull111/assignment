import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupModel with ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  bool validate() {
    return _name.isNotEmpty && _email.isNotEmpty && _password.isNotEmpty && _email.contains('@');
  }

  Future<void> signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Error signing up: $e");
    }
  }
}
