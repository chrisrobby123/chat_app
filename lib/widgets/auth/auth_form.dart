import 'package:flutter/material.dart';

import '../loading.dart';

class AuthForm extends StatefulWidget {
  //const AuthForm({super.key});

  AuthForm(this.submitFn, this.isLoading);
  final bool isLoading;

  final void Function(
      String email, String userName, String password, bool isLogin) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLogin = true;
  var _email = '';
  var _username = '';
  var _password = '';
  final _key = GlobalKey<FormState>();
  void saveForm() {
    final isValid = _key.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _key.currentState!.save();
    widget.submitFn(_email, _username, _password, _isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
                key: _key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      key: const ValueKey('email'),
                      onSaved: (newValue) {
                        _email = newValue.toString();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an email address';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email ',
                          // fillColor: Colors.amber,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 12),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        onSaved: (newValue) {
                          _username = newValue.toString();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Username',
                            // fillColor: Colors.amber,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const ValueKey('password'),
                      onSaved: (newValue) {
                        _password = newValue.toString();
                      },
                      validator: (value) {
                        if (value!.length < 7) {
                          return 'please enter a password 7+ characters long';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'password',
                          //fillColor: Colors.amber,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 12),
                    if (widget.isLoading) const Loading(),
                    if (!widget.isLoading)
                      ElevatedButton(
                          onPressed: saveForm,
                          child: Text(_isLogin ? 'Login' : 'Sign Up')),
                    if (!widget.isLoading)
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create new account'
                              : 'Already have an account?'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
