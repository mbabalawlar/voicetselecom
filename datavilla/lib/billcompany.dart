import 'package:flutter/material.dart';
import 'billpayment.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillCompany extends StatefulWidget {
  @override
  _BillCompanyState createState() => _BillCompanyState();
}

class _BillCompanyState extends State<BillCompany> {
  List<dynamic> mtn;
  List<dynamic> glo;
  List<dynamic> mobile;
  List<dynamic> airtel;
  List<dynamic> cable;
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
        title: Text("Select Disko ",
            style: TextStyle(color: Colors.white, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.indigo[900],
        elevation: 0.0,
      ),
      body: ModalProgressHUD(
        child:
            SingleChildScrollView(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
          SizedBox(height: 20.0),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ElectPayment(
                            image: "assets/abuja.jpg", id: 3)));
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
                        backgroundImage: AssetImage("assets/abuja.jpg"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "ABUJA ELECTRICITY",
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
                        builder: (context) =>
                            ElectPayment(image: "assets/eko.jpg", id: 2)));
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
                        backgroundImage: AssetImage("assets/eko.jpg"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "EKO ELECTRICITY",
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
                        builder: (context) => ElectPayment(
                            image: "assets/ikeja.jpg", id: 1)));
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
                        backgroundImage: AssetImage("assets/ikeja.jpg"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "IKEJA ELECTRICITY",
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
                        builder: (context) => ElectPayment(
                            image: "assets/enugu.jpeg", id: 5)));
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
                        backgroundImage: AssetImage("assets/enugu.jpeg"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "ENUGU ELECTRICITY",
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
                        builder: (context) =>
                            ElectPayment(image: "assets/jos.jpeg", id: 9)));
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
                        backgroundImage: AssetImage("assets/jos.jpeg"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "JOS ELECTRICITY",
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
                        builder: (context) =>
                            ElectPayment(image: "assets/kano.png", id: 4)));
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
                        backgroundImage: AssetImage("assets/kano.png"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "KANO ELECTRICITY",
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
                        builder: (context) => ElectPayment(
                            image: "assets/kaduna.jpg", id: 8)));
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
                        backgroundImage: AssetImage("assets/kaduna.jpg"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "KADUNA ELECTRICITY",
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
                        builder: (context) => ElectPayment(
                            image: "assets/ibadan.png", id: 7)));
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
                        backgroundImage: AssetImage("assets/ibadan.png"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "IBADAN ELECTRICITY",
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
                        builder: (context) => ElectPayment(
                            image: "assets/benin.jpeg", id: 10)));
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
                        backgroundImage: AssetImage("assets/benin.jpeg"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "BENIN ELECTRICITY",
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
                        builder: (context) => ElectPayment(
                            image: "assets/yola.jpg", id: 11)));
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
                        backgroundImage: AssetImage("assets/yola.jpg"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "YOLA ELECTRICITY",
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
                        builder: (context) => ElectPayment(
                            image: "assets/porthacout.jpg", id: 6)));
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
                        backgroundImage: AssetImage("assets/porthacout.jpg"),
                        radius: 20.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "PORTHACOUT ELECTRICITY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ]),
              ),
          ),
          ),
        ]),
            ),
        inAsyncCall: _isLoading,
      ),
    );
  }
}
