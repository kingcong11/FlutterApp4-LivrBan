import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/* Provider */
import '../models/http_exception.dart';
import '../providers/authentication_service.dart';

enum AuthMode { SignIn, SignUp }

class AuthScreen extends StatefulWidget {
  /* Properties */
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  /* Properties */
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.SignIn;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _passwordController = TextEditingController();

  var _isLoading = false;

  /* Methods */
  void _switchAuthMode() {
    if (_authMode == AuthMode.SignIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.SignIn;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // invalid
      return;
    }
    _formKey.currentState.save();
    // print(_authData);

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.SignIn) {
        // Sign in
        await Provider.of<AuthenticationService>(context, listen: false)
            .signIn(email: _authData['email'], password: _authData['password']);
      } else {
        // Sign up
        await Provider.of<AuthenticationService>(context, listen: false)
            .signUp(email: _authData['email'], password: _authData['password']);
      }
    } on HttpException catch (e) {
      var errorMessage = 'Authentication Failed.';
      switch (e.toString()) {
        case 'EMAIL_EXISTS':
          errorMessage = 'Email already exists.';
          break;
        case 'OPERATION_NOT_ALLOWED':
          errorMessage = 'Invalid request.';
          break;
        case 'TOO_MANY_ATTEMPTS_TRY_LATER':
          errorMessage = 'Too many failed attempts, please try again later.';
          break;
        case 'EMAIL_NOT_FOUND':
          errorMessage = 'Email Adress doesn\'t exist.';
          break;
        case 'INVALID_PASSWORD':
          errorMessage = 'Email or Password is incorrect.';
          break;
        case 'USER_DISABLED':
          errorMessage = 'User disabled.';
          break;
      }

      await _showErrorDialog(errorMessage);
    } catch (e) {
      // general error
      var errorMessage = 'Something went wrong, please try again later.';
      await _showErrorDialog(errorMessage);

    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showErrorDialog(String message) {
    return showDialog<Null>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('An error Occured!'),
            content: Text(message),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var deviceSize = mediaQuery.size;

    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        color: Colors.grey[400],
        progressIndicator: SpinKitFadingCircle(
          color: Color(0xFF091a2f),
          size: 50.0,
        ),
        child: Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: (deviceSize.height - mediaQuery.padding.top) * .9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 0, color: Colors.white),
                            ),
                            child: (_authMode == AuthMode.SignIn)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Please sign in to continue.',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Create an Account',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          fit: FlexFit.tight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 0, color: Colors.white),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Container(
                                child: Card(
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'E-Mail',
                                            prefixIcon: Icon(Icons.email),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                !value.contains('@')) {
                                              return 'Invalid email!';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _authData['email'] = value;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            prefixIcon:
                                                Icon(Icons.lock_outline),
                                          ),
                                          obscureText: true,
                                          controller: _passwordController,
                                          textInputAction: TextInputAction.next,
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                value.length < 5) {
                                              return 'Password is too short!';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _authData['password'] = value;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        if (_authMode == AuthMode.SignUp)
                                          TextFormField(
                                            enabled:
                                                _authMode == AuthMode.SignUp,
                                            decoration: InputDecoration(
                                              labelText: 'Confirm Password',
                                              prefixIcon:
                                                  Icon(Icons.lock_outline),
                                            ),
                                            obscureText: true,
                                            textInputAction:
                                                TextInputAction.done,
                                            validator:
                                                _authMode == AuthMode.SignUp
                                                    ? (value) {
                                                        if (value !=
                                                            _passwordController
                                                                .text) {
                                                          return 'Passwords do not match!';
                                                        }
                                                        return null;
                                                      }
                                                    : null,
                                          ),
                                        SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: _submit,
                                          child: Container(
                                            height: 40,
                                            width: 120,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      19, 56, 102, 1),
                                                  Color.fromRGBO(9, 26, 47, 1),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 10),
                                                Text(
                                                  (_authMode == AuthMode.SignUp)
                                                      ? 'Sign up'
                                                      : 'Login',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.chevron_right,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    height: (deviceSize.height - mediaQuery.padding.top) * .1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.grey[700]),
                            children: [
                              (_authMode == AuthMode.SignIn)
                                  ? TextSpan(text: 'Don\'t have an account?')
                                  : TextSpan(text: 'Already have an account?'),
                            ],
                          ),
                        ),
                        FlatButton(
                          onPressed: _switchAuthMode,
                          minWidth: 55,
                          padding: const EdgeInsets.all(0),
                          splashColor: Colors.transparent,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          highlightColor: Colors.transparent,
                          child: Text(
                            (_authMode == AuthMode.SignIn)
                                ? 'Sign up'
                                : 'Sign in',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
