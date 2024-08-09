import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? _user;
  void submitForm(
    String email,
    String userName,
    String password,
    bool isLogin,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        _user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.user!.uid)
            .set(
          {
            'username': userName,
            'email': email,
          },
        );
      }
      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred. Please try again later.';
      if (err.message != null) {
        message = err.message.toString();
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange, body: AuthForm(submitForm, isLoading));
  }
}
