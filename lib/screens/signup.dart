import 'package:flutter/material.dart';
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

  TextEditingController _fnameController = TextEditingController();

  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _referalController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  bool _obscureText = true;

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String usernameV;
  String fnameV;
  String addressV;
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

  Future<dynamic> _signupUser(String username, String email, String password,
      referal, phone, address, fname) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print({
      "username": username,
      "email": email,
      "password": password,
      "referer_username": referal,
      "Phone": phone,
      "Platform": "app",
      'FullName': fname,
      "Address": address
    });
    try {
      String url = 'https://www.voicestelecom.com.ng/api/registration/';

      Response response = await post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": username,
            "email": email,
            "password": password,
            "referer_username": referal,
            "Phone": phone,
            "Platform": "app",
            'FullName': fname,
            "Address": address
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
            desc:
                'Registrations Successful please verify your email address ,verification link has been sent to your email',
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
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Toast.show('$error', context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var phonesize = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
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
                                Navigator.of(context).pop();
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
                        height: phonesize.height * 0.65,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: ListView(
                          children: [
                            SizedBox(
                              height: phonesize.height * 0.035,
                            ),
                            Center(
                              child: Text(
                                'Create Account',
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
                                              "Full Name",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _fnameController,
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
                                              if (val.length == 0) {
                                                return "Full Name is required";
                                              } else if (val.length < 6) {
                                                return "Enter valid Full Name";
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
                                              if (val.length == 0) {
                                                return "username required";
                                              } else if (val.length < 3) {
                                                return "minimum of 3 characters ";
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
                                                return 'Email cannot be blank';
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
                                              "Phone Number",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _phoneController,
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
                                              if (val.length == 0) {
                                                return 'Phone required';
                                              } else if (val.length < 11) {
                                                return "Invalid phone number";
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
                                              "House Address",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _addressController,
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
                                                return 'Address cannot be blank';
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
                                              "Referal username [Optional]",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _referalController,
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
                                                  await _signupUser(
                                                    _usernameController.text,
                                                    _emailController.text,
                                                    _passwordController.text,
                                                    _referalController.text,
                                                    _phoneController.text,
                                                    _addressController.text,
                                                    _fnameController.text,
                                                  );
                                                }
                                              },
                                              child: Text('Sign Up',
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
                                            height: phonesize.height * 0.01,
                                          ),
                                          Container(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'i\'m already a member.',
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
                                                        .pushNamed("/login");
                                                  },
                                                  child: Text(
                                                    'Sign In',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Poppins',
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
