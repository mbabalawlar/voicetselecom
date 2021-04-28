import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _usernameController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _referalController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  bool _obscureText = true;

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String usernameV;
  String emailV;
  String passwordV;
  String referalV;
  String phoneV;

  //bool _obscureText = true;

  /*
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  
  */

  Future<dynamic> _signupUser(
      String username, String email, String password, referal, phone) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://www.elecastlesubng.com/api/registration/';

      Response response = await post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": username,
            "email": email,
            "password": password,
            "referer_username": referal,
            "Phone": phone,
            "Platform": "app"
          }));

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);

        setState(() {
          _isLoading = false;

          print(responseJson["key"]);

          sharedPreferences.setString("token", responseJson['key']);

          AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            title: 'Succes',
            desc: 'Registrations Successful please verify your email address ,verification link has been sent to your email',
            btnOkOnPress: () {
              Navigator.of(context).pushNamed("/login");
            },
            btnOkIcon: Icons.check_circle,
          ).show();
        });
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
        Map responseJson = json.decode(response.body);

        if (responseJson.containsKey("username")) {
          print(responseJson["username"][0]);

          Toast.show(responseJson["username"][0], context,
              backgroundColor: Colors.red,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        } else if (responseJson.containsKey("email")) {
          Toast.show(responseJson["email"][0], context,
              backgroundColor: Colors.red,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        } else if (responseJson.containsKey("password")) {
          Toast.show(responseJson["password"][0], context,
              backgroundColor: Colors.red,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        } else if (responseJson.containsKey("Phone")) {
          Toast.show(responseJson["Phone"][0], context,
              backgroundColor: Colors.red,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        } else if (responseJson.containsKey("error")) {
          Toast.show(responseJson["error"][0], context,
              backgroundColor: Colors.red,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        }
      }
    } finally {
      Client().close();
    }
  }

  @override
  void initState() {
    super.initState();
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
                Form(
                  key: _formKey,
                  autovalidate: true,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 62),
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
                          margin: EdgeInsets.only(top: 20),
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
                            controller: _emailController,
                            onSaved: (String val) {
                              emailV = val;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.email,
                                color: Colors.grey,
                              ),
                              hintText: 'Email',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
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
                            controller: _phoneController,
                            onSaved: (String val) {
                              phoneV = val;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.phone_android,
                                color: Colors.grey,
                              ),
                              hintText: 'Phone',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
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
                            controller: _referalController,
                            onSaved: (String val) {
                              referalV = val;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.supervised_user_circle,
                                color: Colors.grey,
                              ),
                              hintText: 'Referal Username[optional]',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
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
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              setState(() => _isLoading = true);
                              await _signupUser(
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text,
                                _referalController.text,
                                _phoneController.text,
                              );
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
                                'Signup'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, right: 32),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("/login");
                              },
                              child: Text(
                                'Already a member? Sign in',
                                style: TextStyle(
                                    color: Colors.indigo[900],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
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
