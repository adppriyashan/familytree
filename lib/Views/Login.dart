import 'package:flutter/services.dart';
import 'package:familytree/Controllers/AuthController.dart';
import 'package:familytree/Controllers/AuthValidator.dart';
import 'package:familytree/Models/Colors.dart';
import 'package:familytree/Models/Utils.dart';
import 'package:flutter/material.dart';
import 'package:familytree/Views/Home.dart';
import 'package:familytree/Views/Register.dart';

import '../Models/Colors.dart';
import '../Models/Colors.dart';
import '../Models/Colors.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  var _loginFormKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  AuthController _authController;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(Utils.lightNavbar);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double spaceAround = 10.0;
    double fieldspaces = 15.0;
    double fieldspacesmid = 20.0;
    double fieldspacesmax = 30.0;
    double fontsize = 12;

    _authController = AuthController();

    return SafeArea(
        child: Scaffold(
      backgroundColor: UtilColors.greyColor,
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Container(
                  width: Utils.displaySize.width,
                  height: Utils.displaySize.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      UtilColors.primaryColor,
                      UtilColors.secondaryColor,
                    ],
                  )),
                ),
                Container(
                  width: Utils.displaySize.width,
                  height: Utils.displaySize.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: spaceAround),
                        width: Utils.displaySize.width * 0.25,
                        child: Image.asset('assets/images/logowhite.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: spaceAround, vertical: spaceAround),
                        child: Card(
                          color: UtilColors.whiteColor,
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                                key: _loginFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: fieldspaces,
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Text('Unlock Access'.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: UtilColors.primaryColor)),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: fieldspacesmid,
                                    ),
                                    TextFormField(
                                      controller: _email,
                                      decoration:
                                          Utils.getDefaultTextInputDecoration(
                                              'Email',
                                              Icon(
                                                Icons.email,
                                                color: UtilColors.whiteColor
                                                    .withOpacity(0.6),
                                              )),
                                      cursorColor: UtilColors.primaryColor,
                                      keyboardType: TextInputType.emailAddress,
                                      style: Utils.getprimaryFieldTextStyle(
                                          UtilColors.greyColor),
                                      validator: (value) {
                                        return AuthValidator.validateUsername(
                                            value);
                                      },
                                    ),
                                    SizedBox(
                                      height: fieldspacesmid,
                                    ),
                                    TextFormField(
                                      controller: _password,
                                      decoration:
                                          Utils.getDefaultTextInputDecoration(
                                              'Password',
                                              Icon(Icons.lock,
                                                  color: UtilColors.whiteColor
                                                      .withOpacity(0.6))),
                                      cursorColor: UtilColors.primaryColor,
                                      obscureText: _obscurePassword,
                                      keyboardType: TextInputType.emailAddress,
                                      style: Utils.getprimaryFieldTextStyle(
                                          UtilColors.blackColor),
                                      validator: (value) {
                                        return AuthValidator.validatePassword(
                                            value);
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _obscurePassword = true;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: fieldspaces,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 24.0,
                                          width: 24.0,
                                          child: Checkbox(
                                            value: _rememberMe,
                                            onChanged: (val) {
                                              setState(() {
                                                this._rememberMe = val;
                                              });
                                            },
                                            activeColor:
                                                UtilColors.primaryColor,
                                            focusColor: Colors.red,
                                            checkColor: UtilColors.whiteColor,
                                            hoverColor: Colors.red,
                                            tristate: false,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                this._rememberMe =
                                                    !this._rememberMe;
                                              });
                                            },
                                            child: Text(
                                              'Remember my credentials',
                                              style: TextStyle(
                                                  fontSize: fontsize,
                                                  color:
                                                      UtilColors.primaryColor),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: fieldspaces,
                                    ),
                                    SizedBox(
                                      child: FlatButton(
                                        onPressed: () async {
                                          if (_loginFormKey.currentState
                                              .validate()) {
                                            FocusScope.of(context).unfocus();
                                            Utils.showLoader(context);

                                            try {
                                              await _authController.doLogin({
                                                'email': _email.text,
                                                'password': _password.text
                                              }).then((value) {
                                                if (value == true) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              Home()));
                                                }
                                              });
                                            } catch (e) {
                                              Utils.hideLoaderCurrrent(context);
                                            }
                                          }
                                        },
                                        child: Text(
                                          "LET'S START",
                                        ),
                                        color: UtilColors.primaryColor,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Utils.buttonBorderRadius),
                                            side: BorderSide(
                                                color:
                                                    UtilColors.secondaryColor)),
                                        height: 42.0,
                                      ),
                                      width: Utils.displaySize.width,
                                    ),
                                    SizedBox(
                                      height: spaceAround,
                                    ),
                                    SizedBox(
                                      child: TextButton(
                                          onPressed: () async {
                                            await _authController
                                                .signInWithGoogle()
                                                .then((value) => (value == null)
                                                    ? Utils.showToast(
                                                        'Invalid credentials.')
                                                    : Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                Home())));
                                          },
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                                  UtilColors.orangeColor,
                                              side: BorderSide(
                                                  color: UtilColors.orangeColor,
                                                  width: 1),
                                              shape:
                                                  const BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                              primary: UtilColors.orangeColor),
                                          child: Text(
                                            "GOOGLE SIGNIN",
                                            style: TextStyle(
                                                color: UtilColors.whiteColor),
                                          )),
                                      width: Utils.displaySize.width,
                                    ),
                                    SizedBox(
                                      height: fieldspaces,
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => Register()));
                                        },
                                        child: Text(
                                          'No account yet, register today !',
                                          style: TextStyle(
                                              fontSize: fontsize,
                                              color: UtilColors.primaryColor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: fieldspaces,
                                    ),
                                  ],
                                )),
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
    ));
  }
}
