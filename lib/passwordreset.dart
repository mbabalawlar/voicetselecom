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
      String url = 'https://www.voicestelecom.com.ng/rest-auth/password/reset/';

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
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.shade200,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(
                        'images/img2.png',
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.green.withOpacity(0.1),
                              Colors.green.withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SafeArea(
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.navigate_before,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            // Align(
                            //   alignment: Alignment.bottomRight,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(
                            //         bottom: 32, right: 32),
                            //     child: Text(
                            //       'Welcome Chief',
                            //       style: TextStyle(
                            //           color: Colors.white, fontSize: 18),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 62, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text("Password Reset",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5, top: 10, bottom: 5, right: 0),
                          child: Text(
                            "Email Address",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Colors.grey[700]),
                          ),
                        ),
                        TextFormField(
                          controller: _emailController,
                          obscureText: false,
                          decoration: InputDecoration(
                            // hintText: 'Enter Username',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0x00000000)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.green),
                            ),

                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.green),
                            ),

                            filled: true,
                            contentPadding: EdgeInsets.all(18),
                            fillColor: Colors.white,
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                          ),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Email cannot be blank';
                            }

                            return null;
                          },
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
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
