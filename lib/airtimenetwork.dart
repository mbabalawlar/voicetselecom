import 'package:flutter/material.dart';
import 'buyairtime.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AirtimeNet extends StatefulWidget {
  @override
  _AirtimeNetState createState() => _AirtimeNetState();
}

class _AirtimeNetState extends State<AirtimeNet> {
  List<dynamic> mtn;
  List<dynamic> glo;
  List<dynamic> mobile;
  List<dynamic> airtel;
  List<dynamic> network;
  SharedPreferences sharedPreferences;
  bool _isLoading = false;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Select Airtime Network",
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
                          builder: (context) => BuyAirtime(
                                image: "assets/mtn.jpg",
                                id: 1,
                              )));
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
                            "MTN AIRTIME TOPUP",
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
                          builder: (context) => BuyAirtime(
                                image: "assets/glo.jpg",
                                id: 2,
                              )));
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
                            "GLO AIRTIME TOPUP",
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
                          builder: (context) => BuyAirtime(
                                image: "assets/airtel.jpg",
                                id: 4,
                              )));
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
                            "AIRTEL AIRTIME TOPUP",
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
                          builder: (context) => BuyAirtime(
                                image: "assets/9mobile.jpg",
                                id: 3,
                              )));
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
                            "9MOBILE AIRTIME TOPUP",
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
