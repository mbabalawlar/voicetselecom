import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondAtm extends StatefulWidget {
  @override
  _SecondAtmState createState() => _SecondAtmState();
}

class _SecondAtmState extends State<SecondAtm> {
  @override
  void initState() {
    _redirect();
    super.initState();
  }

  _redirect() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString("username");
    var email = pref.getString("email");

    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => CheckoutMethodSelectable(email: email)));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
