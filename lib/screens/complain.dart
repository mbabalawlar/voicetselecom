import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complain extends StatefulWidget {
  @override
  _ComplainState createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  @override
  void initState() {
    _launchURL();
    super.initState();
  }

  _launchURL() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString("username");
    var url =
        'https://api.whatsapp.com/send/?phone=+2347069923546&text=Hello+I+have+a+complaint.+My+username+is+$username&app_absent=0';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
          child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/home", (route) => false);
        },
        child: Text("Dashboard"),
      )),
    );
  }
}
