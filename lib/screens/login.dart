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

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
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
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
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
          sharedPreferences.setString("token", mykey);
        });
        Toast.show("Welcome back ", context,
            backgroundColor: Colors.green[700],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.BOTTOM);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
            (Route<dynamic> route) => false);
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

      Response response = await post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"username": username, "password": password}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);

        String url = 'https://www.voicestelecom.com.ng/api/user/';

        Response res = await get(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${responseJson['key']}'
          },
        );

        print(res.body);

        if (res.statusCode == 200 || res.statusCode == 201) {
          Map resJson = json.decode(res.body);

          List adminNum = resJson["Admin_number"]
              .map((net) => net["phone_number"])
              .toList();

          sharedPreferences.setString("Exam", json.encode(resJson["Exam"]));
          sharedPreferences.setString(
              "topuppercentage", json.encode(resJson["topuppercentage"]));
          sharedPreferences.setString(
              "percentage", json.encode(resJson["percentage"]));
          sharedPreferences.setString(
              "banners", json.encode(resJson["banners"]));
          sharedPreferences.setString("banks", json.encode(resJson["banks"]));
          sharedPreferences.setString(
              "Dataplans", json.encode(resJson["Dataplans"]));
          sharedPreferences.setString(
              "Cableplan", json.encode(resJson["Cableplan"]));
          sharedPreferences.setString("account",
              json.encode(resJson["user"]["bank_accounts"]["accounts"]));
          sharedPreferences.setString(
              "support_phone_number", resJson["support_phone_number"]);

          sharedPreferences.setString("pin", resJson["user"]["pin"]);

          sharedPreferences.setString("password", password);
          sharedPreferences.setString("fullname", resJson["user"]["FullName"]);
          sharedPreferences.setString("img", resJson["user"]["img"]);
          sharedPreferences.setString("token", responseJson['key']);
          sharedPreferences.setString("tok", responseJson['key']);
          sharedPreferences.setString("username", resJson["user"]["username"]);
          sharedPreferences.setBool(
              "email_verify", resJson["user"]["email_verify"]);
          sharedPreferences.setString(
              "user_type", resJson["user"]["user_type"]);
          sharedPreferences.setString(
              "walletb", resJson["user"]["wallet_balance"]);
          sharedPreferences.setString(
              "bonusb", resJson["user"]["bonus_balance"]);
          sharedPreferences.setString("email", resJson["user"]["email"]);
          sharedPreferences.setString(
              "notification", resJson["notification"]["message"]);

          // sharedPreferences.setString(
          //     "account", resJson["user"]["reservedaccountNumber"]);
          // sharedPreferences.setString(
          //     "bank", resJson["user"]["reservedbankName"]);

          sharedPreferences.setString("phone", resJson["user"]["Phone"]);

          sharedPreferences.setString(
              "recharge", json.encode(resJson["recharge"]));

          sharedPreferences.setString("AdminNumberMTN", adminNum[0]);
          sharedPreferences.setString("AdminNumberGLO", adminNum[1]);
          sharedPreferences.setString("AdminNumberAIRTEL", adminNum[2]);
          sharedPreferences.setString("AdminNumber9MOBILE", adminNum[3]);

          if (resJson["user"]["email_verify"] == true) {
            setState(() {
              Toast.show("Welcome back ", context,
                  backgroundColor: Colors.green,
                  duration: Toast.LENGTH_SHORT,
                  gravity: Toast.BOTTOM);
            });

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => Dashboard()),
                (Route<dynamic> route) => false);
            _isLoading = false;
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => VerifyPage()),
                (Route<dynamic> route) => false);
            _isLoading = false;
          }
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

  @override
  Widget build(BuildContext context) {
    var phonesize = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey.shade200,
        body: ModalProgressHUD(
          child: SafeArea(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back),
                              iconSize: 30,
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "/landingpage", (route) => false);
                              }),
                        ],
                      ),
                      Container(
                        child: Image.asset("images/img2.png"),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: phonesize.height * 0.04,
                            ),
                            Center(
                              child: Text(
                                'Sign In ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  phonesize.width * 0.08,
                                  phonesize.height * 0.02,
                                  phonesize.width * 0.08,
                                  phonesize.height * 0.02,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5,
                                                top: 10,
                                                bottom: 5,
                                                right: 0),
                                            child: Text(
                                              "Username",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _usernameController,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              // hintText: 'Enter Username',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                              ),

                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Color(0x00000000)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.green[700]),
                                              ),

                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.green[700]),
                                              ),

                                              filled: true,
                                              contentPadding:
                                                  EdgeInsets.all(18),
                                              fillColor: Colors.white,
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                            ),
                                            validator: (val) {
                                              if (val.isEmpty) {
                                                return 'username cannot be blank';
                                              }

                                              return null;
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5,
                                                top: 10,
                                                bottom: 5,
                                                right: 0),
                                            child: Text(
                                              "Password",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _passwordController,
                                            obscureText: _obscureText,
                                            decoration: InputDecoration(
                                              // hintText: 'Enter Username',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                              ),

                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Color(0x00000000)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.green[700]),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.green[700]),
                                              ),

                                              filled: true,
                                              contentPadding:
                                                  EdgeInsets.all(18),
                                              fillColor: Colors.white,

                                              suffixIcon: InkWell(
                                                onTap: () => setState(
                                                  () => _obscureText =
                                                      !_obscureText,
                                                ),
                                                child: Icon(
                                                  _obscureText
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: Color(0xFF757575),
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                            ),
                                            validator: (val) {
                                              if (val.isEmpty) {
                                                return 'password  cannot be blank';
                                              }

                                              return null;
                                            },
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushNamed("/ResetPassword");
                                            },
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16, right: 2),
                                                child: Text(
                                                  'Forgot Password ?',
                                                  style: TextStyle(
                                                      color: Colors.grey[900]),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _formKey.currentState.save();
                                                  setState(
                                                      () => _isLoading = true);
                                                  await _loginUser(
                                                      _usernameController.text,
                                                      _passwordController.text);
                                                }
                                              },
                                              child: Text('SIGN IN',
                                                  style:
                                                      TextStyle(fontSize: 17)),
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.green[700],
                                                textStyle: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.all(17),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: phonesize.height * 0.05,
                                          ),
                                          Container(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'i\'m a new user.',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed("/signup");
                                                  },
                                                  child: Text(
                                                    'Sign Up',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          inAsyncCall: _isLoading,
        ));
  }
}
