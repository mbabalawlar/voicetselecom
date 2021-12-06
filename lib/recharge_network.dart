import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'recharge_print.dart';

class RechargeNet extends StatefulWidget {
  @override
  _RechargeNetState createState() => _RechargeNetState();
}

class _RechargeNetState extends State<RechargeNet> {
  List<dynamic> mtn;
  List<dynamic> glo;
  List<dynamic> mobile;
  List<dynamic> airtel;
  List<dynamic> network;
  SharedPreferences sharedPreferences;
  bool _isLoading = false;
  Map pins;

  void initState() {
    super.initState();
    filldetails();
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pins = json.decode(pref.getString("recharge"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Select  Network",
            style: TextStyle(color: Colors.white, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0.0,
      ),
      body: ModalProgressHUD(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => RechargeCard(
                              image: "assets/mtn.jpg",
                              id: 1,
                              plan: pins['mtn_pin'])));
                },
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/mtn.jpg"),
                            radius: 20.0,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "MTN (Available Pin = ${pins['mtn']})",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ]),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => RechargeCard(
                              image: "assets/glo.jpg",
                              id: 2,
                              plan: pins['glo_pin'])));
                },
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/glo.jpg"),
                            radius: 20.0,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "GLO (Available Pin = ${pins['glo']})",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ]),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => RechargeCard(
                              image: "assets/airtel.jpg",
                              id: 4,
                              plan: pins['airtel_pin'])));
                },
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/airtel.jpg"),
                            radius: 20.0,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "AIRTEL (Available Pin = ${pins['airtel']})",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ]),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => RechargeCard(
                              image: "assets/9mobile.jpg",
                              id: 3,
                              plan: pins['9mobile_pin'])));
                },
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/9mobile.jpg"),
                            radius: 20.0,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "9MOBILE (Available Pin = ${pins['9mobile']})",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ]),
        inAsyncCall: _isLoading,
      ),
    );
  }
}
