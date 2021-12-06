import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../flutterwavepay.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Atm extends StatefulWidget {
  @override
  _AtmState createState() => _AtmState();
}

class _AtmState extends State<Atm> {
    @override
  void initState() {
   _redirect();
    super.initState();
   

  }


  _redirect() async {
     SharedPreferences pref = await SharedPreferences.getInstance();
     var username = pref.getString("username");
      var email = pref.getString("email");

     Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context) => FlutterwavePay(email: email, username: username)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}