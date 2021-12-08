import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:convert';

String mykey;

//import "home_screen.dart";
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  bool _isLoading = false;
  void initState() {
    alert();
    loaddata();
    super.initState();
    Timer(Duration(seconds: 6), () async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Navigator.of(context).pushReplacementNamed("/onboard");
      if (sharedPreferences.getBool("first_login") == null) {
        setState(() {
          sharedPreferences.setBool("first_login", true);
        });

        Navigator.of(context).pushReplacementNamed("/onboard");
      } else if (sharedPreferences.getString("token") != null) {
        Navigator.of(context).pushReplacementNamed("/welcome");
      } else {
        Navigator.of(context).pushReplacementNamed("/landingpage");
      }
    });
  }

  Future<dynamic> loaddata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    mykey = sharedPreferences.getString("tok");
    print(mykey);
    if (mykey != null) {
      String url = 'https://www.voicestelecom.com.ng/api/user/';

      Response res = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Token $mykey'
        },
      );

      print(res.body);
      print(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        Map resJson = json.decode(res.body);
        print(resJson["banners"]);

        List adminNum =
            resJson["Admin_number"].map((net) => net["phone_number"]).toList();

        sharedPreferences.setString("banks", json.encode(resJson["banks"]));
        sharedPreferences.setString("banners", json.encode(resJson["banners"]));
        sharedPreferences.setString("Exam", json.encode(resJson["Exam"]));
        sharedPreferences.setString(
            "percentage", json.encode(resJson["percentage"]));
        sharedPreferences.setString(
            "topuppercentage", json.encode(resJson["topuppercentage"]));
        sharedPreferences.setString(
            "Dataplans", json.encode(resJson["Dataplans"]));
        sharedPreferences.setString(
            "Cableplan", json.encode(resJson["Cableplan"]));
        sharedPreferences.setString("account",
            json.encode(resJson["user"]["bank_accounts"]["accounts"]));
        sharedPreferences.setString(
            "support_phone_number", resJson["support_phone_number"]);

        sharedPreferences.setString(
            "recharge", json.encode(resJson["recharge"]));

        sharedPreferences.setString("pin", resJson["user"]["pin"]);
        sharedPreferences.setString("username", resJson["user"]["username"]);
        sharedPreferences.setString(
            "walletb", resJson["user"]["wallet_balance"]);
        sharedPreferences.setString("bonusb", resJson["user"]["bonus_balance"]);
        sharedPreferences.setString("email", resJson["user"]["email"]);
        sharedPreferences.setString(
            "notification", resJson["notification"]["message"]);
        sharedPreferences.setString("img", resJson["user"]["img"]);

        sharedPreferences.setString("user_type", resJson["user"]["user_type"]);
        sharedPreferences.setString("phone", resJson["user"]["Phone"]);
        sharedPreferences.setBool(
            "email_verify", resJson["user"]["email_verify"]);

        sharedPreferences.setString("AdminNumberMTN", adminNum[0]);
        sharedPreferences.setString("AdminNumberGLO", adminNum[1]);
        sharedPreferences.setString("AdminNumberAIRTEL", adminNum[2]);
        sharedPreferences.setString("AdminNumber9MOBILE", adminNum[3]);
      } else {
        setState(() {
          _isLoading = false;
        });
        Toast.show('Something went wrong, pls try again.', context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    }
  }

  Future<dynamic> alert() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = 'https://www.voicestelecom.com.ng/api/alert/';

    Response res = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    Map resJson = json.decode(res.body);

    if (this.mounted) {
      setState(() {
        pref.setString("alert", resJson["alert"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var phonesize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SafeArea(
                child: Image.asset(
                  "images/voicestelecom2.png",
                  height: 150,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
