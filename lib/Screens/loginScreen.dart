import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werd/auth.dart';
import 'package:werd/constants.dart';

class LoginScreen extends StatefulWidget {
  final Auth auth;
  final VoidCallback signedIn;

  LoginScreen({this.auth, this.signedIn});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//enums for form type and image save status..
enum FormType { signIn, signUp }

class _LoginScreenState extends State<LoginScreen> {
  bool spin = false;

  String email, password, confirmedPassword;
  FormType _formType = FormType.signIn;

//TODO handle the signing exceptions
  void validateAndSubmit() async {
    setState(() {
      spin = true;
    });

    try {
      bool result;
      if (_formType == FormType.signIn) {
        result = await Auth.signMeIn(email, password);
        if (result) {
          saveLocal(email, password);
          String uId = await Auth.getCurrentUser();
          if (uId != null) Navigator.pushNamed(context, '/Day');
        } else {
          setState(() {
            spin = false;
          });
          print('Can\'t log In');
        }
      } else {
        if (password == confirmedPassword) {
          result = await Auth.signMeUp(
            email: email,
            password: password,
          );
          if (result) {
            saveLocal(email, password);
            Navigator.pushNamed(context, '/Day');
          } else {
            setState(() {
              spin = false;
            });
            print('Can\'t log up');
          }
        }
        setState(() {
          spin = false;
        });
      }
      widget.signedIn();
    } catch (e) {
      print('logins says : $e');
    }
  }

  void moveToSignup() {
    setState(() {
      // to reload the ui..
      _formType = FormType.signUp;
    });
  }

  void moveToLogin() {
    setState(() {
      // to reload the ui..
      _formType = FormType.signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: ModalProgressHUD(
        inAsyncCall: spin,
        child: Scaffold(
          body: SafeArea(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _formType == FormType.signIn ? loginFields() : signUpFields(),
                  SizedBox(
                    height: 10,
                  ),
                  formButtons(),
                ],

                // loginFields(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginFields() {
    return Column(
      children: <Widget>[
        CustomeTextField(
          onSaved: (value) => email = value,
          labelText: 'Email Address',
          hintText: 'username or email',
        ),
        SizedBox(
          height: 10,
        ),
        CustomeTextField(
          onSaved: (value) => password = value,
          hintText: 'Password',
          labelText: 'Password',
          obscure: true,
        ),
      ],
    );
  }

  Widget signUpFields() {
    return Column(
      children: <Widget>[
        CustomeTextField(
          onSaved: (value) {
            email = value;
            print('emails is #################################$email');
          },
          labelText: 'Email Address',
          hintText: 'Email',
        ),
        CustomeTextField(
          onSaved: (value) {
            password = value;
            print('passwords is $password');
          },
          hintText: 'Password',
          labelText: 'Password',
          obscure: true,
        ),
        CustomeTextField(
          hintText: 'Password',
          labelText: 'Confirm Password',
          obscure: true,
          onSaved: (value) {
            confirmedPassword = value;
          },
        ),
      ],
    );
  }

  formButtons() {
    String sign;
    String subText;
    if (_formType == FormType.signIn) {
      sign = 'sign in';
      subText = 'Create an account';
    } else {
      sign = 'sign up';
      subText = 'have account ? sign in';
    }
    return Column(
      children: <Widget>[
        RaisedButton(
          color: KmyColors[0],
          elevation: 5.0,
          child: Text(
            sign,
            style: TextStyle(color: KmyColors[5]),
          ),
          onPressed: () => validateAndSubmit(),
        ),
        FlatButton(
          color: KmyColors[5],
          onPressed: () {
            if (_formType == FormType.signIn)
              moveToSignup();
            else
              moveToLogin();
          },
          child: Text(
            subText,
            style: TextStyle(color: KmyColors[1]),
          ),
        )
      ],
    );
  }

  Future<void> saveLocal(String mail, String pswd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', mail);
    prefs.setString('pswd', pswd);
  }
}
