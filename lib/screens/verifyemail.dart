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
import 'package:open_mail_app/open_mail_app.dart';

class VerifyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VerifyPageState();
  }
}

class _VerifyPageState extends State<VerifyPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  Timer timer;
  String email = "";
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => checkmail());
    filldetails();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("email");
    });
  }

  Future<dynamic> checkmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = 'https://www.voicestelecom.com.ng/api/user/';

    Response res = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token ${pref.getString("token")}'
      },
    );
    Map resJson = json.decode(res.body);
    print("checking if user has been verify");

    if (resJson["user"]["email_verify"] == true) {
      Toast.show("Email successfully verified", context,
          backgroundColor: Colors.green,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM);
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
    }
  }

  Future<dynamic> _sendmail() async {
    try {
      setState(() {
        _isLoading = true;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String url = 'https://www.voicestelecom.com.ng/api/verification';
      print(url);
      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Token ${sharedPreferences.getString("token")}'
        },
      );

      print('Token ${sharedPreferences.getString("token")}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        Toast.show("Email verification resent", context,
            backgroundColor: Colors.green,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      } else if (response.statusCode == 500) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print(response.body);

        Toast.show("Unable to connect to server currently", context,
            backgroundColor: Colors.green[700],
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      } else if (response.statusCode == 400) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        var responseJson = json.decode(response.body);
        Toast.show("somthing went wrong", context,
            backgroundColor: Colors.green[700],
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("unexpected error occured", context,
            backgroundColor: Colors.green[700],
            duration: Toast.LENGTH_LONG,
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          child: SafeArea(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: phonesize.height * 0.04,
                        ),
                        Container(
                          child: Image.asset(
                            "images/verification-icon-8.jpeg",
                            height: phonesize.height * 0.3,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'Please Verify your Email Address',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              'Please confirm your email address to complete the registration,activation link has been sent to your email($email), also check your email spam folder',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: phonesize.height * 0.1,
                        ),
                        InkWell(
                          onTap: () async {
                            _sendmail();
                          },
                          child: Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Center(
                              child: Text(
                                'Resend'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            // Android: Will open mail app or show native picker.
                            // iOS: Will open mail app if single mail app found.
                            var result = await OpenMailApp.openMailApp();

                            // If no mail apps found, show error
                            if (!result.didOpen && !result.canOpen) {
                              showNoMailAppsDialog(context);

                              // iOS: if multiple mail apps found, show dialog to select.
                              // There is no native intent/default app system in iOS so
                              // you have to do it yourself.
                            } else if (!result.didOpen && result.canOpen) {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return MailAppPickerDialog(
                                    mailApps: result.options,
                                  );
                                },
                              );
                            }
                            ;
                          },
                          child: Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                                color: Colors.green[700],
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Center(
                              child: Text(
                                'OPEN MAIL APP'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
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
          inAsyncCall: _isLoading,
        ));
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
