import 'package:voicestelecom/screens/verifyemail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'newdashboard.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io' show Platform;
import 'login.dart';

class WelcomeP extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelcomePState();
  }
}

class _WelcomePState extends State<WelcomeP> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _usernameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();

  bool _canCheckBiometrics;
  //List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  String mykey;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String usernameV;
  String passwordV;
  String img = "assets/avatar.jpeg";
  String fname;
  bool _obscureText = true;

  @override
  void initState() {
    _checkBiometrics();
    super.initState();

    filldetails();
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("email_verify") != true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => VerifyPage()),
          (Route<dynamic> route) => false);
    }
    if (this.mounted) {
      setState(() {
        img = pref.getString("img");
        usernameV = pref.getString("username");
        passwordV = pref.getString("password");
        fname = pref.getString("fullname");
      });
    }
  }

  setlogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");

    Toast.show("Account logout successfully", context,
        backgroundColor: Colors.green[700],
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  // Toggles the password show status

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });

    print("can  _canCheckBiometrics $_canCheckBiometrics");
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to access  voicestelecomecom',
          useErrorDialogs: true,
          stickyAuth: true);

      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    if (authenticated == true) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      mykey = sharedPreferences.getString("tok");
      print(mykey);
      if (mykey != null) {
        setState(() {
          _isLoading = true;
          sharedPreferences.setString("token", mykey);
        });
        _loginUser(usernameV, passwordV);
      } else {
        Toast.show(
            "Required to login with username and password first", context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }

      print(mykey);
      print("yea welcome");
    }

    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  Future<dynamic> _loginUser(String username, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://www.voicestelecom.com.ng/rest-auth/login/';

      Response response = await post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"username": username, "password": password}));
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);

        String url = 'https://www.voicestelecom.com.ng/api/user/';

        Response res = await get(
          url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${responseJson['key']}'
          },
        );

        if (res.statusCode == 200 || res.statusCode == 201) {
          setState(() {
            _isLoading = false;
          });
          Toast.show("Welcome back ", context,
              backgroundColor: Colors.green[700],
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
              (Route<dynamic> route) => false);
        } else {
          setState(() {
            _isLoading = false;
          });
          Toast.show('Something went wrong, pls try again.', context,
              backgroundColor: Colors.red,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        }
      } else if (response.statusCode == 500) {
        setState(() {
          _isLoading = false;
        });
        print(response.body);
        Toast.show(
            "something went wrong please ,report to admin before try another transaction",
            context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else {
        setState(() {
          _isLoading = false;
        });
        Toast.show('Unable to log in with provided credentials.', context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    } finally {
      Client().close();
    }
  }

  String bio_icon() {
    if (Platform.isAndroid) {
      return "assets/fingerprint.png";
    } else if (Platform.isIOS) {
      return "assets/face_id.png";
    }
  }

  String bio_text() {
    if (Platform.isAndroid) {
      return "Fingerprint";
    } else if (Platform.isIOS) {
      return "Face ID";
    }
  }

  @override
  Widget build(BuildContext context) {
    var ponesize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(
                        ponesize.width * 0.01,
                        ponesize.height * 0.05,
                        ponesize.width * 0.01,
                        ponesize.height * 0.01),
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green[700],
                    child: Column(children: [
                      SizedBox(height: ponesize.height * 0.1),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/avatar.jpeg"),
                              fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Welcome Back",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white)),
                      fname != null
                          ? Text("$fname",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white))
                          : Text("$usernameV",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white))
                    ])),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 62),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 32),
                          padding: EdgeInsets.only(
                              top: 4, left: 16, right: 16, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            obscureText: _obscureText,
                            controller: _passwordController,
                            onSaved: (String val) {
                              passwordV = val;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.vpn_key,
                                color: Colors.grey,
                              ),
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon

                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,

                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            if (_canCheckBiometrics == true) {
                              _isAuthenticating
                                  ? _cancelAuthentication()
                                  : _authenticate();
                            }
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  bio_icon(),
                                  height: 30,
                                ),
                                SizedBox(width: 8),
                                Text(bio_text(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 19))
                              ]),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              setState(() => _isLoading = true);
                              await _loginUser(
                                  usernameV, _passwordController.text);
                            }
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                                color: Colors.green[700],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                'Sign in'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/ResetPassword");
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, right: 32),
                              child: Text(
                                'Forgot your Password or this is not you?',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Column(children: <Widget>[
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: <Widget>[
                          //     Text(
                          //       'or login with',
                          //       style: TextStyle(
                          //           color: Colors.grey[800],
                          //           fontWeight: FontWeight.w400),
                          //     ),
                          //     InkWell(
                          //         onTap: () {
                          //           if (_canCheckBiometrics == true) {
                          //             _isAuthenticating
                          //                 ? _cancelAuthentication()
                          //                 : _authenticate();
                          //           }
                          //         },
                          //         child: Icon(
                          //           bio_icon(),
                          //           size: 50.0,
                          //         )),
                          //   ],
                          // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  setlogout();
                                },
                                child: Text(
                                  'Signout',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),

                          SizedBox(height: 100),
                        ]),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        inAsyncCall: _isLoading,
      ),
    );
  }
}
