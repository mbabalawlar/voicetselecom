import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _usernameController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _referalController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  bool _obscureText = true;

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String emailV;

  //bool _obscureText = true;

  /*
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  
  */

  Future<dynamic> _resetPassword(
    String email,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://www.elecastlesubng.com/rest-auth/password/reset/';

      Response response = await post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
          }));

      print(jsonEncode({
        "email": email,
      }));
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);

        setState(() {
          _isLoading = false;
          AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            title: 'Succes',
            desc: 'Registrations Successful continue to login',
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
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.indigo[800],
                          Colors.indigo[900],
                        ],
                      ),
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(90))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50.0,
                            child: SvgPicture.asset(
                              "images/top-up.svg",
                              semanticsLabel: 'Logo',
                              width: 50,
                              height: 50,
                            ),
                          ),
                          Text(
                            "elecastlesubng",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 32, right: 32),
                          child: Text(
                            'Reset Password',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
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
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
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
                              hintText: 'Email your Email',
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
                              await _resetPassword(
                                _emailController.text,
                              );
                            }
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.indigo[800],
                                    Colors.indigo[900],
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Center(
                              child: Text(
                                'Reset Password'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
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
