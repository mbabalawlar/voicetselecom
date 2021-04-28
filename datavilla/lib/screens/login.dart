import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'home_screen.dart';
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
          localizedReason: 'Scan your fingerprint to access elecastlesubng',
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
            backgroundColor: Colors.green,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.BOTTOM);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
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
      String url = 'https://www.elecastlesubng.com/rest-auth/login/';

      Response response = await post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"username": username, "password": password}));
   

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);

        String url = 'https://www.elecastlesubng.com/api/user/';

        Response res = await get(
          url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${responseJson['key']}'
          },
        );
       
        

        if (res.statusCode == 200 || res.statusCode == 201) {
          Map resJson = json.decode(res.body);
          List network =
              resJson["percentage"].map((net) => net["percent"]).toList();
          List topnetwork = resJson["topuppercentage"].map((net) => net["percent"]).toList();
          List topnetwork2 = resJson["topuppercentage"].map((net) => net["percent_s"]).toList();


          List adminNum = resJson["Admin_number"]
              .map((net) => net["phone_number"])
              .toList();

          List exam = resJson["Exam"].map((net) => net["amount"]).toList();

  sharedPreferences.setString("banks", json.encode(resJson["banks"]));

          sharedPreferences.setDouble("WAEC", exam[0]);
          sharedPreferences.setDouble("NECO", exam[1]);
             sharedPreferences.setString("pin", resJson["user"]["pin"]);

          sharedPreferences.setString("password", password);
          sharedPreferences.setString("fullname", resJson["user"]["FullName"]);
          sharedPreferences.setString("img", resJson["user"]["img"]);
          sharedPreferences.setString("token", responseJson['key']);
          sharedPreferences.setString("tok", responseJson['key']);
          sharedPreferences.setString("username", resJson["user"]["username"]);
          sharedPreferences.setString(
              "user_type", resJson["user"]["user_type"]);
          sharedPreferences.setString(
              "walletb", resJson["user"]["wallet_balance"]);
          sharedPreferences.setString(
              "bonusb", resJson["user"]["bonus_balance"]);
          sharedPreferences.setString("email", resJson["user"]["email"]);
          sharedPreferences.setString(
              "notification", resJson["notification"]["message"]);

          sharedPreferences.setString(
              "account", resJson["user"]["reservedaccountNumber"]);
          sharedPreferences.setString(
              "bank", resJson["user"]["reservedbankName"]);
          sharedPreferences.setString("phone", resJson["user"]["Phone"]);

          sharedPreferences.setInt("PercentageMTN", network[0]);
          sharedPreferences.setInt("PercentageGLO", network[1]);
          sharedPreferences.setInt("PercentageAIRTEL", network[2]);
          sharedPreferences.setInt("Percentage9MOBILE", network[3]);
         sharedPreferences.setString("recharge", json.encode(resJson["recharge"]));

          sharedPreferences.setInt("TopupPercentageMTN", topnetwork[0]);
          sharedPreferences.setInt("TopupPercentageGLO", topnetwork[1]);
          sharedPreferences.setInt("TopupPercentageAIRTEL", topnetwork[2]);
          sharedPreferences.setInt("TopupPercentage9MOBILE", topnetwork[3]);


           sharedPreferences.setInt("TopupPercentageMTN2", topnetwork2[0]);
          sharedPreferences.setInt("TopupPercentageGLO2", topnetwork2[1]);
          sharedPreferences.setInt("TopupPercentageAIRTEL2", topnetwork2[2]);
          sharedPreferences.setInt("TopupPercentage9MOBILE2", topnetwork2[3]);


          sharedPreferences.setString("AdminNumberMTN", adminNum[0]);
          sharedPreferences.setString("AdminNumberGLO", adminNum[1]);
          sharedPreferences.setString("AdminNumberAIRTEL", adminNum[2]);
          sharedPreferences.setString("AdminNumber9MOBILE", adminNum[3]);

          setState(() {
            Toast.show("Welcome back ", context,
                backgroundColor: Colors.green,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.BOTTOM);

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()),
                (Route<dynamic> route) => false);
            _isLoading = false;
          });
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
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(
                        'images/hero.png',
                        fit: BoxFit.cover,
                        color: Colors.indigo.withOpacity(1.0),
                        colorBlendMode: BlendMode.softLight,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.indigo.withOpacity(0.6),
                              Colors.indigo.withOpacity(1.0),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 70),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Image.asset(
                                  "images/logo.png",
                                  width: 200,
                                  height: 100,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 32, right: 32),
                                child: Text(
                                  'Welcome Chief',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            obscureText: false,
                            controller: _usernameController,
                            onSaved: (String val) {
                              usernameV = val;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.verified_user,
                                color: Colors.grey,
                              ),
                              hintText: 'Username',
                            ),
                          ),
                        ),
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
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/ResetPassword");
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, right: 32),
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              setState(() => _isLoading = true);
                              await _loginUser(_usernameController.text,
                                  _passwordController.text);
                            }
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.indigo[900],
                                    Colors.indigo[900],
                                    Colors.indigo[900],
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                'Login'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(children: <Widget>[
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Not yet a member ?',
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed("/signup");
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
