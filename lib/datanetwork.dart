import 'package:flutter/material.dart';
import 'buydata.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataNet extends StatefulWidget {
  @override
  _DataNetState createState() => _DataNetState();
}

class _DataNetState extends State<DataNet> {
  Map<dynamic, dynamic> mtn;
  Map<dynamic, dynamic> glo;
  Map<dynamic, dynamic> mobile;
  Map<dynamic, dynamic> airtel;
  List<dynamic> network;
  SharedPreferences sharedPreferences;
  bool _isLoading = false;

  void initState() {
    loadplan();
    super.initState();
  }

  loadplan() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Map resJson = json.decode(sharedPreferences.getString("Dataplans"));
    print(sharedPreferences.getString("Dataplans"));

    if (this.mounted) {
      setState(() {
        mtn = resJson["MTN_PLAN"];
        glo = resJson["GLO_PLAN"];
        mobile = resJson["9MOBILE_PLAN"];
        airtel = resJson["AIRTEL_PLAN"];

        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Select Data Network",
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
                          builder: (context) => BuyData(
                              image: "assets/mtn.jpg", id: 1, plan: mtn)));
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
                            "MTN DATA BUNDLE",
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
                          builder: (context) => BuyData(
                              image: "assets/glo.jpg", id: 2, plan: glo)));
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
                            "GLO DATA BUNDLE",
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
                          builder: (context) => BuyData(
                              image: "assets/airtel.jpg",
                              id: 4,
                              plan: airtel)));
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
                            "AIRTEL DATA BUNDLE",
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
                          builder: (context) => BuyData(
                              image: "assets/9mobile.jpg",
                              id: 3,
                              plan: mobile)));
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
                            "9MOBILE DATA BUNDLE",
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
