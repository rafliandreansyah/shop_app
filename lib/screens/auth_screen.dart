import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../models/http_exception.dart';

enum AuthMode { Login, Signup }

class AuthScreen extends StatelessWidget {
  static const routeName = 'auth-screen';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [
                  0,
                  1,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 90.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context)
                              .accentTextTheme
                              .headline6!
                              .color,
                          fontSize: 25,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: screenSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authForm = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showDialogError(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('An Accoured Error!'),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Okay'))
            ],
          );
        });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Signup) {
      setState(() {
        _authMode = AuthMode.Login;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    }
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authForm['email']!, _authForm['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authForm['email']!, _authForm['password']!);
      }
    } on HttpException catch (error) {
      String errorFlag = error.message;
      String errorMessage = 'Something missing';
      if (errorFlag.contains('EMAIL_EXISTS')) {
        errorMessage = 'The email address is already in use by another account';
      } else if (errorFlag.contains('OPERATION_NOT_ALLOWED')) {
        errorMessage = 'Login disable, please contact the admin!';
      } else if (errorFlag.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage = 'Request account blocked!';
      } else if (errorFlag.contains('EMAIL_NOT_FOUND')) {
        errorMessage =
            'There is no user record corresponding to this identifier email!';
      } else if (errorFlag.contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password, please try again';
      } else if (errorFlag.contains('USER_DISABLED')) {
        errorMessage = 'User is disabled, please contact the admin!';
      }

      _showDialogError(errorMessage);
    } catch (error) {
      _showDialogError('Not authenticated, please try again!');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8,
      child: Container(
        width: screenSize.width * 0.75,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 320 : 260,
        ),
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!!!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authForm['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password too short!!!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authForm['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Password doesn\'t match';
                            }
                            return null;
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20.0,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () async => _submit(),
                    child: Text(
                      _authMode == AuthMode.Login ? 'Login' : 'Sign Up',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                    ),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'SignUp' : 'Login'} Instead',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
